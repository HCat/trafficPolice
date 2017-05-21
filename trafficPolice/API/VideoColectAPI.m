//
//  VideoColectAPI.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/21.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "VideoColectAPI.h"

#pragma mark - 警情反馈采集增加API

@implementation VideoColectSaveParam

@end

@implementation VideoColectSaveManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_VIDEOCOLECT_SAVE;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数

@end

#pragma mark - 警情反馈采集列表API

@implementation VideoColectListPagingParam

@end

@implementation VideoColectListPagingReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [VideoColectListModel class]
             };
}

@end

@implementation VideoColectListPagingManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_VIDEOCOLECT_LISTPAGING;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数
- (VideoColectListPagingReponse *)videoColectListPagingReponse{
    
    if (self.responseModel.data) {
        return [VideoColectListPagingReponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end

#pragma mark - 警情反馈采集详情API

@implementation VideoColectDetailManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_VIDEOCOLECT_DETAIL;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"start":_start};
}

//返回参数
//无返回数据

@end

