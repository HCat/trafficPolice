//
//  IllegalThroughAPI.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/21.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "IllegalThroughAPI.h"

#pragma mark - 违反禁令查询是否需要二次采集API

@implementation IllegalThroughQuerySecManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ILLEGALTHROUGH_QUERYSEC;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"carNo": _carNo,
             @"roadId":_roadId};
}

//返回参数


@end

#pragma mark - 违反禁令采集增加API

@implementation IllegalThroughSaveParam

@end


@implementation IllegalThroughSaveManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ILLEGALTHROUGH_SAVE;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数

@end

#pragma mark - 违反禁令二次采集加载数据API

@implementation IllegalThroughSecAddManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ILLEGALTHROUGH_SECADD;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"id": _illegalThroughId};
}

//返回参数
- (IllegalThroughSecDetailModel *)illegalThroughSecDetailModel{
    
    if (self.responseModel.data) {
        return [IllegalThroughSecDetailModel modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end

#pragma mark - 违反禁令二次采集保存数据API

@implementation IllegalThroughSecSaveParam

@end

@implementation IllegalThroughSecSaveManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ILLEGALTHROUGH_SECSAVE;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数

@end

#pragma mark - 违反禁令采集列表API

@implementation IllegalThroughListPagingParam

@end

@implementation IllegalThroughListPagingReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [IllegalParkListModel class]
             };
}

@end

@implementation IllegalThroughListPagingManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ILLEGALTHROUGH_LISTPAGING;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数
- (IllegalThroughListPagingReponse *)illegalThroughListPagingReponse{
    
    if (self.responseModel.data) {
        return [IllegalThroughListPagingReponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end

#pragma mark - 违反禁令采集详情API


@implementation IllegalThroughDetailManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ILLEGALTHROUGH_DETAIL;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"id":_illegalThroughId};
}

//返回参数
- (IllegalParkDetailModel *)accidentDetailModel{
    
    if (self.responseModel.data) {
        return [IllegalParkDetailModel modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end

