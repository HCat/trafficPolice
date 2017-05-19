//
//  FastAccident.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/19.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "FastAccidentAPI.h"


#pragma mark - 获取交通事故通用值API

@implementation FastAccidentGetCodesModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"modelId" : @"id",
             @"modelName" : @"name",
             @"modelType" : @"type"};
}

@end

@implementation FastAccidentGetCodesResponse

@end

@implementation FastAccidentGetCodesManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_FASTACCIDENT_GETCODES;
}

//请求参数
- (nullable id)requestArgument
{
    return nil;
}

//返回参数
- (FastAccidentGetCodesResponse *)fastAccidentGetCodesResponse{
    
    if (self.responseModel.data) {
        return [FastAccidentGetCodesResponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end

#pragma mark - 快处事故增加API

@implementation FastAccidentSaveParam

@end

@implementation FastAccidentSaveManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_FASTACCIDENT_SAVE;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数


@end

#pragma mark - 快处事件列表API

@implementation FastAccidentListPagingParam

@end

@implementation FastAccidentListPagingReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [AccidentListModel class]
             };
}

@end

@implementation FastAccidentListPagingManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_FASTACCIDENT_LISTPAGING;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数
- (FastAccidentListPagingReponse *)fastAccidentListPagingReponse{
    
    if (self.responseModel.data) {
        return [FastAccidentListPagingReponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end


#pragma mark - 快处事件详情API


@implementation FastAccidentDetailManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_FASTACCIDENT_DETAIL;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"id":_accidentId};
}

//返回参数
- (FastAccidentDetailModel *)fastAccidentDetailModel{
    
    if (self.responseModel.data) {
        return [FastAccidentDetailModel modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}


@end




