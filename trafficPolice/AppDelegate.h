//
//  AppDelegate.h
//  trafficPolice
//
//  Created by Binrong Liu on 2017/5/9.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKTabBarController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif



@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate,JPUSHRegisterDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) AKTabBarController *vc_tabBar;

@property (nonatomic,assign)NSInteger allowRotate; //进行横竖屏的切换用的

-(void)initAKTabBarController;

-(void)showTabView;
-(void)hideTabView;


@end

