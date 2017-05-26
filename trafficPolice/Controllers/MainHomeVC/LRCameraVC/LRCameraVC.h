//
//  LRCameraVC.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/25.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonAPI.h"

@class LRCameraVC;

typedef void (^fininshCaptureBlock)(LRCameraVC
*camera);

@interface LRCameraVC : UIViewController

//文件类型1：车牌号 2：身份证 3：驾驶证 4：行驶证
@property (nonatomic,assign) NSInteger type;

//获取得到压缩的图片
@property (nonatomic,strong) UIImage *image;

//获取得到的照片转换成需要的imageInfo信息，具体可以查看这个类中拥有的属性
@property (nonatomic,strong) ImageFileInfo *imageInfo;

//请求服务端口得到的数据
@property (nonatomic,strong) CommonIdentifyResponse *commonIdentifyResponse;

//拍照完之后调用的block
@property (nonatomic,copy) fininshCaptureBlock fininshCaptureBlock;


@end
