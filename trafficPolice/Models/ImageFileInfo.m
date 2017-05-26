//
//  ImageFileInfo.m
//  trafficPolice
//
//  Created by hcat on 2017/5/26.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "ImageFileInfo.h"
#import "ShareFun.h"
#import "UserModel.h"

@implementation ImageFileInfo

-(id)initWithImage:(UIImage *)image withName:(NSString *)name{
    self = [super init];
    if (self) {
        if (image) {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *time = [formatter stringFromDate:[NSDate date]];
            if ([UserModel getUserModel].userId) {
                time = [NSString stringWithFormat:@"%@_%@",[UserModel getUserModel].userId,time];
            }
            
            _name = name; //对应网站上[upload.php中]处理文件的[字段"file"]
            _mimeType = @"image/jpeg";
            //进行压缩
            
            
            //long long time = [[NSDate date]timeIntervalSince1970] * 100000;
            
            self.image = [ShareFun scaleFromImage:image];
            _fileData = UIImageJPEGRepresentation(self.image, 0.7);
            LxPrintf(@"压缩成jpg之后的数据大小:%zd", _fileData.length/1000);
            if (_fileData == nil)
            {
                _fileData = UIImagePNGRepresentation(self.image);
                LxPrintf(@"压缩成png之后的数据大小:%zd", _fileData.length/1000);
                _fileName = [NSString stringWithFormat:@"%@.png",time];
                _mimeType = @"image/png";
            }
            else
            {
                _fileName = [NSString stringWithFormat:@"%@.jpg",time];
            }
            self.image = [UIImage imageWithData:_fileData];
            self.filesize = _fileData.length;
            self.width = self.image.size.width;
            self.height = self.image.size.height;
            LxPrintf(@"Image尺寸是(宽：%f 长：%f)",self.width,self.height);
        }
    }
    return self;
}



@end
