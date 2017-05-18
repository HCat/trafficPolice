//
//  LoginAPI.m
//  trafficPolice
//
//  Created by hcat on 2017/5/18.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "LoginAPI.h"

#pragma mark - 登录API
@implementation LoginManger


//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_USER_LOGIN;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"openId":_openId};
}

//返回参数
- (NSString *)phone{
    
    if (self.responseModel.data) {
        return self.responseModel.data[@"phone"];
    }
    return nil;
}

@end

#pragma mark - 登录发送验证码API

@implementation LoginTakeCodeManger


//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_USER_LOGINTAKECODE;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"openId":_openId};
}

//返回参数
- (NSString *)phone{
    
    if (self.responseModel.data) {
        return self.responseModel.data[@"acId"];
    }
    return nil;
}

@end

#pragma mark - 验证码登录API

@implementation LoginCheckManger


//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_USER_LOGINTAKECODE;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"openId":_openId};
}

//返回参数
- (NSString *)phone{
    
    if (self.responseModel.data) {
        return self.responseModel.data[@"acId"];
    }
    return nil;
}

@end

