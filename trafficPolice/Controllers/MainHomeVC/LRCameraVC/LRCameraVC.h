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

typedef void (^fininshcapture)(LRCameraVC
*camera);

@interface LRCameraVC : UIViewController

@property (nonatomic,assign) NSInteger type;    //文件类型1：车牌号 2：身份证 3：驾驶证 4：行驶证
@property (nonatomic,strong) UIImage *image;    //获取得到的图片
@property (nonatomic,strong) CommonIdentifyResponse *commonIdentifyResponse;//得到返回数据
@property (nonatomic,copy) fininshcapture fininshcapture;//拍照完之后获取的image


@end
