//
//  AccidentAPI.m
//  trafficPolice
//
//  Created by hcat on 2017/5/19.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "AccidentAPI.h"


#pragma mark - 获取交通事故通用值API

@implementation AccidentGetCodesModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"modelId" : @"id",
             @"modelName" : @"name",
             @"modelType" : @"type"};
}

@end

@implementation AccidentGetCodesResponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"road" : [AccidentGetCodesModel class],
             @"behaviour" : [AccidentGetCodesModel class],
             @"vehicle" : [AccidentGetCodesModel class],
             @"insuranceCompany" : [AccidentGetCodesModel class],
             @"responsibility" : [AccidentGetCodesModel class],
             @"roadType" : [AccidentGetCodesModel class],
             @"driverDirect" : [AccidentGetCodesModel class],
             };
}

- (NSString *)searchNameWithModelId:(NSInteger)modelId WithArray:(NSArray <AccidentGetCodesModel *>*)items{

    if (items && items.count > 0) {
        for(AccidentGetCodesModel *model in items){
            if (model.modelId == modelId) {
                return model.modelName;
            }
        }
    }
    
    return nil;
    
}

- (NSString *)searchNameWithModelType:(NSInteger)modelType WithArray:(NSArray <AccidentGetCodesModel *>*)items{

    if (items && items.count > 0) {
        for(AccidentGetCodesModel *model in items){
            if (model.modelId == modelType) {
                return model.modelName;
            }
        }
    }
    return nil;
}

@end

@implementation AccidentGetCodesManger

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
- (AccidentGetCodesResponse *)accidentGetCodesResponse{
    
    if (self.responseModel.data) {
        return [AccidentGetCodesResponse modelWithDictionary:self.responseModel.data];
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
    return URL_ACCIDENT_DETAIL;
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


#pragma mark - 通过车牌号统计事故数量API


@implementation AccidentCountByCarNoManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ACCIDENT_COUNTBYCARNO;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"carNo":_carNo};
}

//返回参数
- (AccidentCountModel *)accidentCountModel{
    
    if (self.responseModel.data) {
        return [AccidentCountModel modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end

#pragma mark - 通过手机号统计事故数量API


@implementation AccidentCountByTelNumManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ACCIDENT_COUNTBYTELNUM;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"telNum":_telNum};
}

//返回参数
- (AccidentCountModel *)accidentCountModel{
    
    if (self.responseModel.data) {
        return [AccidentCountModel modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end

#pragma mark - 通过身份证号统计事故数量API


@implementation AccidentCountByidNoManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ACCIDENT_COUNTBYIDNO;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"idNo":_idNo};
}

//返回参数
- (AccidentCountModel *)accidentCountModel{
    
    if (self.responseModel.data) {
        return [AccidentCountModel modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end



