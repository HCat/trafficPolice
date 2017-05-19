//
//  CommonAPI.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/18.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRBaseRequest.h"

#pragma mark - 获取当前天气API

@interface CommonGetWeatherManger:LRBaseRequest

/****** 请求数据 ******/

@property (nonatomic, copy) NSString *location; //经度+“,”+纬度,示例（118.184872,24.497949）

/****** 返回数据 ******/
@property (nonatomic, copy) NSString *weather; //天气

@end


#pragma mark - 证件识别API

@interface CommonIdentifyResponse : NSObject

@property (nonatomic, copy) NSString *carNo;        //车牌号
@property (nonatomic, copy) NSString *vehicleType;  //车辆类型
@property (nonatomic, copy) NSString *name;         //姓名，或者车辆所有人
@property (nonatomic, copy) NSString *idNo;         //证件号码

@end

@interface CommonIdentifyManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) NSString *file; //文件
@property (nonatomic, copy) NSString *type; //文件类型1：车牌号 2：身份证 3：驾驶证 4：行驶证

/****** 返回数据 ******/
@property (nonatomic, copy) CommonIdentifyResponse *commonIdentifyResponse; //证件信息

@end

#pragma mark - 获取路名API

@interface CommonGetRoadModel : NSObject

@property (nonatomic,copy) NSString *getRoadId;     //通用值id
@property (nonatomic,copy) NSString *getRoadName;   //通用值名称


@end


@interface CommonGetRoadManger : LRBaseRequest

/****** 请求数据 ******/
/***请求参数中有token值，运用统一添加参数的办法添加到后面所有需要token参数的请求中,具体调用LRBaseRequest中的+ (void)setupRequestFilters:(NSDictionary *)arguments 方法***/

/****** 返回数据 ******/
@property (nonatomic, copy) NSArray<CommonGetRoadModel *> *commonGetRoadResponse; //证件信息


@end






