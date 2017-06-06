//
//  LRVideoVC.h
//  trafficPolice
//
//  Created by hcat on 2017/6/6.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LRVideoVC : BaseViewController

@property (nonatomic, assign) BOOL savePhotoAlbum;

@property (nonatomic, copy) void(^recordComplete)(NSString * aVideoUrl,NSString *aThumUrl);

@end
