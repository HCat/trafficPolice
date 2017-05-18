//
//  CommonAPI.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/18.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "CommonAPI.h"

#pragma mark - 获取交通事故通用值API

@implementation GetCodesResponseModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"modelId" : @"id",
             @"modelName" : @"name",
             };
}

@end

@implementation GetCodesResponse

@end

@implementation GetCodesManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_COMMON_GETCODES;
}

//请求参数
- (nullable id)requestArgument
{
    return nil;
}

//返回参数
- (GetCodesResponse *)userModel{
    
    if (self.responseModel.data) {
        return [GetCodesResponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end

#pragma mark - 获取当前天气API

@implementation GetWeatherManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_COMMON_GETWEATHER;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"location":_location};
}

//返回参数
- (NSString *)weather{
    
    if (self.responseModel.data) {
        return self.responseModel.data[@"weather"];
    }
    
    return nil;
}

@end


