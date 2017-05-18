//
//  LRBaseRequest.m
//  trafficPolice
//
//  Created by hcat on 2017/5/18.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "LRBaseRequest.h"

@implementation LRBaseRequest

//可选，当使用缓存的时候，根据argument来过滤想要的缓存数据
- (id)cacheFileNameFilterForRequestArgument:(id)argument
{
    return argument;
}

//请求方式，默认为GET请求
- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGET;
}


//请求寄存器，默认为http
- (YTKRequestSerializerType)requestSerializerType
{
    return YTKRequestSerializerTypeHTTP;
}


//响应寄存器，默认JSON响应数据 详见 `responseObject`.
- (YTKResponseSerializerType)responseSerializerType
{
    return YTKResponseSerializerTypeJSON;
}


//缓存时间<使用默认的start，在缓存周期内并没有真正发起请求>
- (NSInteger)cacheTimeInSeconds
{
    return 0;
}

//请求超时时间
- (NSTimeInterval)requestTimeoutInterval
{
    return 60;
}

- (void)requestCompleteFilter{
    [super requestCompleteFilter];
    
    self.responseModel = [LRBaseResponse modelWithDictionary:self.responseJSONObject];
    if (_isLog) {
        LxDBAnyVar(self.responseJSONObject);
    }
    
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
    if (_isLog) {
        LxDBAnyVar(self.responseStatusCode);
        LxDBAnyVar(self.error.localizedDescription);
    }
    
}


@end
