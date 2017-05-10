//
//  AppDelegate.h
//  trafficPolice
//
//  Created by Binrong Liu on 2017/5/9.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKTabBarController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) AKTabBarController *vc_tabBar;


-(void)initAKTabBarController;

-(void)showTabView;
-(void)hideTabView;


@end

