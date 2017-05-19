//
//  AccidentAPI.m
//  trafficPolice
//
//  Created by hcat on 2017/5/19.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "AccidentAPI.h"


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
    return URL_ACCIDENT_GETCODES;
}

//请求参数
- (nullable id)requestArgument
{
    return nil;
}

//返回参数
- (GetCodesResponse *)getCodesResponse{
    
    if (self.responseModel.data) {
        return [GetCodesResponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end

#pragma mark - 事故增加API

@implementation AccidentSaveParam

@end

@implementation AccidentSaveManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ACCIDENT_SAVE;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数


@end

#pragma mark - 事件列表API

@implementation AccidentListPagingParam

@end

@implementation AccidentListPagingReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [AccidentListModel class]
            };
}

@end

@implementation AccidentListPagingManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ACCIDENT_LISTPAGING;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数
- (AccidentListPagingReponse *)accidentListPagingReponse{
    
    if (self.responseModel.data) {
        return [AccidentListPagingReponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end

#pragma mark - 事件详情API


@implementation AccidentDetailManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ACCIDENT_LISTPAGING;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"id":_accidentId};
}

//返回参数
- (AccidentDetailModel *)accidentDetailModel{
    
    if (self.responseModel.data) {
        return [AccidentDetailModel modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}


@end



