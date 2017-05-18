//
//  CommonAPI.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/18.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRBaseRequest.h"

#pragma mark - 获取交通事故通用值API

@interface GetCodesResponseModel:NSObject

@property (nonatomic,copy) NSString * modelId;
@property (nonatomic,copy) NSString * modelName;


@end

@interface GetCodesResponse : NSObject

@property (nonatomic,strong) GetCodesResponseModel *road;               //道路
@property (nonatomic,strong) GetCodesResponseModel *behaviour;          //事故成因
@property (nonatomic,strong) GetCodesResponseModel *vehicle;            //车辆类型
@property (nonatomic,strong) GetCodesResponseModel *insuranceCompany;   //保险公司
@property (nonatomic,strong) GetCodesResponseModel *responsibility;     //事故责任
@property (nonatomic,strong) GetCodesResponseModel *roadType;           //事故地点类型
@property (nonatomic,strong) GetCodesResponseModel *driverDirect;       //行驶状态

@end

@interface GetCodesManger:LRBaseRequest

/****** 请求数据 ******/
/***请求参数中有token值，运用统一添加参数的办法添加到后面所有需要token参数的请求中,具体调用LRBaseRequest中的+ (void)setupRequestFilters:(NSDictionary *)arguments 方法***/

/****** 返回数据 ******/
@property (nonatomic, strong) GetCodesResponse *getCodes;

@end

#pragma mark - 获取当前天气API

@interface GetWeatherManger:LRBaseRequest

/****** 请求数据 ******/

@property (nonatomic, copy) NSString *location; //经度+“,”+纬度,示例（118.184872,24.497949）

/****** 返回数据 ******/
@property (nonatomic, copy) NSString *weather; //天气

@end



