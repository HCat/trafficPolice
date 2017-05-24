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

#import "ShareValue.h"

#import <WXApi.h>
#import <YTKNetwork.h>
#import "LRBaseRequest.h"



@interface AppDelegate ()<WXApiDelegate>

@property(nonatomic,strong) LoginHomeVC *vc_login;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //******** 导航栏的设置 ********//
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x4281e8)];
    [UINavigationBar appearance].titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    if([[UIDevice currentDevice].systemVersion floatValue] >= 8 && [UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)]) {
        [UINavigationBar appearance].translucent = NO;
    }
    //******** 注册第三方：微信，百度地图等 ********//
    [self addThirthPart:launchOptions];
    
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = Base_URL;
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
//    if ([ShareValue sharedDefault].token) {
//        /*********** 切换到首页界面 ************/
//        [LRBaseRequest setupRequestFilters:@{@"token": [ShareValue sharedDefault].token}];
//        
//        [self initAKTabBarController];
//        self.window.rootViewController = self.vc_tabBar;
//        
//    }else{
//        self.vc_login = [LoginHomeVC new];
//        UINavigationController *t_nav = [[UINavigationController alloc] initWithRootViewController:_vc_login];
//        self.window.rootViewController = t_nav;
//    }
    
    [self initAKTabBarController];
    self.window.rootViewController = self.vc_tabBar;

    
    [self.window makeKeyAndVisible];
    
    return YES;
    
}

#pragma mark - Methods

-(void)initAKTabBarController{

    if (_vc_tabBar == nil) {
        
        self.vc_tabBar = [[AKTabBarController alloc]initWithTabBarHeight:50];
        [_vc_tabBar setTabTitleIsHidden:NO];
        [_vc_tabBar setTabEdgeColor:[UIColor clearColor]];
        [_vc_tabBar setIconGlossyIsHidden:YES];
        [_vc_tabBar setIconShadowOffset:CGSizeZero];
        [_vc_tabBar setTabColors:@[[UIColor clearColor],[UIColor clearColor]]];
        [_vc_tabBar setSelectedTabColors:@[[UIColor clearColor],[UIColor clearColor]]];
        [_vc_tabBar setBackgroundImageName:@"tab_white_bg"];
        [_vc_tabBar setSelectedBackgroundImageName:@"tab_white_bg"];
        [_vc_tabBar setTextColor:UIColorFromRGB(0xbbbbbb)];
        [_vc_tabBar setSelectedTextColor:UIColorFromRGB(0x4281e8)];
        [_vc_tabBar setTabStrokeColor:[UIColor clearColor]];
        [_vc_tabBar setTabInnerStrokeColor:[UIColor clearColor]];
        [_vc_tabBar setMinimumHeightToDisplayTitle:50];
        [_vc_tabBar setTextFont:[UIFont systemFontOfSize:11.f]];
        [_vc_tabBar setTopEdgeColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]];
   
        
        MainHomeVC *t_vc_main = [MainHomeVC new];
        UINavigationController *t_nav_main = [[UINavigationController alloc] initWithRootViewController:t_vc_main];
        
        ListHomeVC *t_vc_list = [ListHomeVC new];
        UINavigationController *t_nav_list = [[UINavigationController alloc] initWithRootViewController:t_vc_list];
        
        UserHomeVC *t_vc_user = [UserHomeVC new];
         UINavigationController *t_nav_user = [[UINavigationController alloc] initWithRootViewController:t_vc_user];
        
        [_vc_tabBar setViewControllers:[@[t_nav_main,t_nav_list,t_nav_user]mutableCopy]];
        
    }

}

-(void)addThirthPart:(NSDictionary *)launchOptions{


    [WXApi registerApp:WEIXIN_APP_ID];

}

#pragma mark - public Methods

-(void)showTabView;{
    [_vc_tabBar showTabBarAnimated:NO];
}

-(void)hideTabView;{
    [_vc_tabBar hideTabBarAnimated:NO];
}


#pragma mark - 微信相关

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    
    /*! @brief 处理微信通过URL启动App时传递的数据
     *
     * 需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。
     * @param url 微信启动第三方应用时传递过来的URL
     * @param delegate  WXApiDelegate对象，用来接收微信触发的消息。
     * @return 成功返回YES，失败返回NO。
     */
    
    return [WXApi handleOpenURL:url delegate:self];
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation{
    return [WXApi handleOpenURL:url delegate:self];
}

/*! 微信回调，不管是登录还是分享成功与否，都是走这个方法 @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp{
    
    /*
     enum  WXErrCode {
     WXSuccess           = 0,    成功
     WXErrCodeCommon     = -1,  普通错误类型
     WXErrCodeUserCancel = -2,    用户点击取消并返回
     WXErrCodeSentFail   = -3,   发送失败
     WXErrCodeAuthDeny   = -4,    授权失败
     WXErrCodeUnsupport  = -5,   微信不支持
     };
     */
    if ([resp isKindOfClass:[SendAuthResp class]]) {   //授权登录的类。
        
        SendAuthResp* SendRsp = (SendAuthResp*)resp;
        int nErrCode = SendRsp.errCode;
        NSString* strState = SendRsp.state;
        LxDBAnyVar(nErrCode);

        if (0 == nErrCode) {  //成功。
            if ([@"wxlogin" isEqualToString:strState]) {
                NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:SendRsp.code, @"code", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_WX_LOGIN_SUCCESS object:nil userInfo:dict];
            }
        }else{ //失败
            NSLog(@"error %@",resp.errStr);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败" message:[NSString stringWithFormat:@"reason : %@",resp.errStr] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
    

}


#pragma mark -

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
