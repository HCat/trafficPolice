//
//  IllegalParkAPI.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/21.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "IllegalParkAPI.h"

#pragma mark - 违停采集增加API

@implementation IllegalParkSaveParam


@end

@implementation IllegalParkSaveManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ILLEGALPARK_SAVE;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数


@end

#pragma mark - 违停采集列表API

@implementation IllegalParkListPagingParam

@end

@implementation IllegalParkListPagingReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [IllegalParkListModel class]
             };
}

@end

@implementation IllegalParkListPagingManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ILLEGALPARK_LISTPAGING;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数
- (IllegalParkListPagingReponse *)illegalParkListPagingReponse{
    
    if (self.responseModel.data) {
        return [IllegalParkListPagingReponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end

#pragma mark - 违停采集详情API


@implementation IllegalParkDetailManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ILLEGALPARK_DETAIL;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"id":_illegalParkId};
}

//返回参数
- (IllegalParkDetailModel *)accidentDetailModel{
    
    if (self.responseModel.data) {
        return [IllegalParkDetailModel modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end

#pragma mark - 违停、违法禁令上报异常API

@implementation IllegalParkReportAbnormalManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ILLEGALPARK_REPORTABNORMAL;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"id":_illegalParkId};
}

//返回参数
//无返回数据

@end

