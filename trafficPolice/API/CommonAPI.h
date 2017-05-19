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

@interface GetWeatherManger:LRBaseRequest

/****** 请求数据 ******/

@property (nonatomic, copy) NSString *location; //经度+“,”+纬度,示例（118.184872,24.497949）

/****** 返回数据 ******/
@property (nonatomic, copy) NSString *weather; //天气

@end


#pragma mark - 证件识别API

@interface IdentifyResponse : NSObject

@property (nonatomic, copy) NSString *carNo;        //车牌号
@property (nonatomic, copy) NSString *vehicleType;  //车辆类型
@property (nonatomic, copy) NSString *name;         //姓名，或者车辆所有人
@property (nonatomic, copy) NSString *idNo;         //证件号码

@end

@interface IdentifyManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) NSString *file; //文件
@property (nonatomic, copy) NSString *type; //文件类型1：车牌号 2：身份证 3：驾驶证 4：行驶证

/****** 返回数据 ******/
@property (nonatomic, copy) IdentifyResponse *identifyResponse; //证件信息

@end






