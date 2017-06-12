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
            
         
            self.image = image;
            LxPrintf(@"压缩成jpg之前Image尺寸是(宽：%f 长：%f)",self.image.size.width,self.image.size.height);
            _fileData = UIImageJPEGRepresentation(self.image, 1.0);
            LxPrintf(@"压缩成jpg之前的数据大小:%zd", _fileData.length/1000);
            
            //将图片进行等比例缩到指定大小
            self.image = [ShareFun scaleFromImage:image];
            
            LxPrintf(@"压缩成jpg之之后Image尺寸是(宽：%f 长：%f)",self.image.size.width,self.image.size.height);
            
            
            //横向的情况下不压缩得特别厉害
            TICK
            if (self.image.size.width > self.image.size.height) {
                _fileData = UIImagePNGRepresentation(self.image);
            }else{
                _fileData =UIImageJPEGRepresentation(self.image, 0.9);
            }
            
            LxPrintf(@"压缩成jpg之后的数据大小:%zd", _fileData.length/1000);
            _fileName = [NSString stringWithFormat:@"%@.jpg",time];
            _mimeType = @"image/jpeg";
            
            self.image = [UIImage imageWithData:_fileData];
            TOCK
            self.filesize = _fileData.length;
            self.width = self.image.size.width;
            self.height = self.image.size.height;
            
        }
    }
    return self;
}



@end
