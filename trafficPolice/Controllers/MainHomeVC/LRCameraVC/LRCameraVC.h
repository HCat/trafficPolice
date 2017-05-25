//
//  LRCameraVC.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/25.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^fininshcapture)(UIImage
*image);
@interface LRCameraVC : UIViewController

@property (nonatomic,copy) fininshcapture fininshcapture;//拍照完之后获取的image


@end
