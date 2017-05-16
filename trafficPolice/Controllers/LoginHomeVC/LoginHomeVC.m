//
//  LoginHomeVC.m
//  trafficPolice
//
//  Created by Binrong Liu on 2017/5/9.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "LoginHomeVC.h"
#import "PhoneLoginVC.h"
#import <AFNetworking.h>
#import <WXApi.h>
#import "ShareFun.h"


@interface LoginHomeVC ()

@end

@implementation LoginHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [ApplicationDelegate initAKTabBarController];
//    ApplicationDelegate.window.rootViewController = ApplicationDelegate.vc_tabBar;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinLoginSuccess:) name:NOTIFICATION_WX_LOGIN_SUCCESS object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;

}

#pragma mark - buttonAction 

- (IBAction)weixinLoginAction:(id)sender {
    
//    if (![WXApi isWXAppInstalled]) {
//        
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败" message:@"请先安装微信" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
//        
//    }else{
//        
//        SendAuthReq *req =[[SendAuthReq alloc]init];
//        
//        req.scope = @"snsapi_userinfo" ;
//        req.state = @"wxlogin" ;
//        req.openID = WEIXIN_APP_ID;
//        //第三方向微信终端发送一个SendAuthReq消息结构
//        [WXApi sendReq:req];
//        
//    }
    
    
    PhoneLoginVC *t_vc = [PhoneLoginVC new];
    [self.navigationController pushViewController:t_vc animated:YES];
    
}

- (IBAction)quitAppAction:(id)sender {
    
    [ShareFun exitApplication];
    
}

#pragma mark - WeixinLoginSucessNotification

- (void)weixinLoginSuccess:(NSNotification *)notification{
    if (notification.userInfo != nil) {
        [self getOpenidAndTokenFromWxCode:[notification.userInfo objectForKey:@"code"]];
    }
}

- (void)getOpenidAndTokenFromWxCode:(NSString*)code {
    
    WS(weakSelf);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json",@"text/plain", nil];
    //通过 appid  secret 认证code . 来发送获取 access_token的请求
    [manager GET:[NSString stringWithFormat:WEIXIN_BASE_URL,WEIXIN_APP_ID,WEIXIN_APP_SECRET,code] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {  //获得access_token，然后根据access_token获取用户信息请求。
        SW(strongSelf, weakSelf);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        LxDBAnyVar(dic);
        
        /*
         access_token	接口调用凭证
         expires_in	access_token接口调用凭证超时时间，单位（秒）
         refresh_token	用户刷新access_token
         openid	授权用户唯一标识
         scope	用户授权的作用域，使用逗号（,）分隔
         unionid	 当且仅当该移动应用已获得该用户的userinfo授权时，才会出现该字段
         */
        NSString* accessToken=[dic valueForKey:@"access_token"];
        NSString* openID=[dic valueForKey:@"openid"];
        
        [strongSelf requestUserInfoByToken:accessToken andOpenid:openID];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@",error.localizedFailureReason);
    }];
    
}

-(void)requestUserInfoByToken:(NSString *)token andOpenid:(NSString *)openID{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,openID] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //开发人员拿到相关微信用户信息后， 需要与后台对接，进行登录
        LxPrintf(@"login success dic  ==== %@",dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LxPrintf(@"error %ld",(long)error.code);
    }];
}


#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_WX_LOGIN_SUCCESS object:nil];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
