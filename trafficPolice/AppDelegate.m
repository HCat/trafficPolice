//
//  AppDelegate.m
//  trafficPolice
//
//  Created by Binrong Liu on 2017/5/9.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginHomeVC.h"

#import "MainHomeVC.h"
#import "ListHomeVC.h"
#import "UserHomeVC.h"


@interface AppDelegate ()

@property(nonatomic,strong) LoginHomeVC *vc_login;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.vc_login = [LoginHomeVC new];
    
    UINavigationController *t_nav = [[UINavigationController alloc] initWithRootViewController:_vc_login];
    self.window.rootViewController = t_nav;
    [self.window makeKeyAndVisible];
    
    return YES;
    
}

#pragma mark - Methods

-(void)initAKTabBarController{

    if (_vc_tabBar == nil) {
        
        self.vc_tabBar = [[AKTabBarController alloc]initWithTabBarHeight:50];
        [_vc_tabBar setTabTitleIsHidden:NO];
        [_vc_tabBar setIconGlossyIsHidden:YES];
        [_vc_tabBar setTabEdgeColor:[UIColor clearColor]];
        [_vc_tabBar setTabColors:@[[UIColor clearColor],[UIColor clearColor]]];
        
        MainHomeVC *t_vc_main = [MainHomeVC new];
        UINavigationController *t_nav_main = [[UINavigationController alloc] initWithRootViewController:t_vc_main];
        
        ListHomeVC *t_vc_list = [ListHomeVC new];
        UINavigationController *t_nav_list = [[UINavigationController alloc] initWithRootViewController:t_vc_list];
        
        UserHomeVC *t_vc_user = [UserHomeVC new];
         UINavigationController *t_nav_user = [[UINavigationController alloc] initWithRootViewController:t_vc_user];
        
        [_vc_tabBar setViewControllers:[@[t_nav_main,t_nav_list,t_nav_user]mutableCopy]];
        
    }

}

-(void)showTabView;{
    [_vc_tabBar showTabBarAnimated:NO];
}

-(void)hideTabView;{
    [_vc_tabBar hideTabBarAnimated:NO];
}





- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
