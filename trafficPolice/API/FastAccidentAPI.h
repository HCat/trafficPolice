//
//  FastAccident.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/19.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRBaseRequest.h"
#import "AccidentListModel.h"
#import "FastAccidentDetailModel.h"

#pragma mark - 获取快处事故通用值API

@interface FastAccidentGetCodesModel:NSObject

@property (nonatomic,copy) NSString * modelId;
@property (nonatomic,copy) NSString * modelName;
@property (nonatomic,copy) NSString * modelType;
@end

@interface FastAccidentGetCodesResponse : NSObject

@property (nonatomic,strong) FastAccidentGetCodesModel *road;               //道路
@property (nonatomic,strong) FastAccidentGetCodesModel *behaviour;          //事故成因
@property (nonatomic,strong) FastAccidentGetCodesModel *vehicle;            //车辆类型
@property (nonatomic,strong) FastAccidentGetCodesModel *insuranceCompany;   //保险公司
@property (nonatomic,strong) FastAccidentGetCodesModel *responsibility;     //事故责任

@end

@interface FastAccidentGetCodesManger:LRBaseRequest

/****** 请求数据 ******/
/***请求参数中有token值，运用统一添加参数的办法添加到后面所有需要token参数的请求中,具体调用LRBaseRequest中的+ (void)setupRequestFilters:(NSDictionary *)arguments 方法***/

/****** 返回数据 ******/
@property (nonatomic, strong) FastAccidentGetCodesResponse *fastAccidentGetCodesResponse;

@end

#pragma mark - 快处事故增加API

@interface FastAccidentSaveParam : NSObject

@property (nonatomic,copy) NSString * happenTimeStr;    //事故时间 必填，格式：yyyy-MM-dd HH:mm:ss
@property (nonatomic,copy) NSString * roadId;           //道路ID 必填，从通用值【道路】获取ID
@property (nonatomic,copy) NSString * address;          //事故地点
@property (nonatomic,copy) NSString * causesType;       //事故成因ID 从通用值【事故成因】获取ID
@property (nonatomic,copy) NSString * weather;          //天气 默认值从天气接口获取，可编辑
@property (nonatomic,copy) NSString * ptaName;          //甲方姓名 必填，可用身份证、驾驶证识别
@property (nonatomic,copy) NSString * ptaIdNo;          //甲方身份证号码 必填，可用身份证、驾驶证识别
@property (nonatomic,copy) NSString * ptaVehicleId;     //甲方车辆类型 必填，从通用值【车辆类型】获取ID，可用行驶证识别
@property (nonatomic,copy) NSString * ptaCarNo;         //甲方车牌号 必填，可用行驶证识别
@property (nonatomic,copy) NSString * ptaPhone;         //甲方联系电话
@property (nonatomic,copy) NSString * ptaInsuranceCompanyId;        //甲方保险公司 从通用值【保险公司】获取ID
@property (nonatomic,copy) NSString * ptaResponsibilityId;          //甲方责任 从通用值【责任】获取ID
@property (nonatomic,copy) NSString * ptaDirect;                    //甲方行驶状态 从通用值【行驶状态】获取ID
@property (nonatomic,copy) NSString * ptaDescribe;      //甲方简述
@property (nonatomic,copy) NSString * ptbName;          //乙方姓名 可用身份证、驾驶证识别
@property (nonatomic,copy) NSString * ptbIdNo;          //乙方身份证号码 可用身份证、驾驶证识别
@property (nonatomic,copy) NSString * ptbVehicleId;     //乙方车辆类型 从通用值【车辆类型】获取ID，可用行驶证识别
@property (nonatomic,copy) NSString * ptbCarNo;         //乙方车牌号 可用驾驶证识别
@property (nonatomic,copy) NSString * ptbPhone;         //乙方联系电话
@property (nonatomic,copy) NSString * ptbInsuranceCompanyId;    //乙方保险公司 从通用值【保险公司】获取ID
@property (nonatomic,copy) NSString * ptbResponsibilityId;      //乙方责任 从通用值【责任】获取ID
@property (nonatomic,copy) NSString * ptbDirect;                //乙方行驶状态 从通用值【行驶状态】获取ID
@property (nonatomic,copy) NSString * ptbDescribe;              //乙方简述
@property (nonatomic,copy) NSString * ptcName;                  //丙方姓名 可用身份证、驾驶证识别
@property (nonatomic,copy) NSString * ptcIdNo;                  //丙方身份证号码 可用身份证、驾驶证识别
@property (nonatomic,copy) NSString * ptcVehicleId;             //丙方车辆类型 从通用值【车辆类型】获取ID，可用行驶证识别
@property (nonatomic,copy) NSString * ptcCarNo;                 //丙方车牌号 可用驾驶证识别
@property (nonatomic,copy) NSString * ptcPhone;                 //丙方联系电话
@property (nonatomic,copy) NSString * ptcInsuranceCompanyId;    //丙方保险公司 从通用值【保险公司】获取ID
@property (nonatomic,copy) NSString * ptcResponsibilityId;      //丙方责任 从通用值【责任】获取ID
@property (nonatomic,copy) NSString * ptcDirect;                //丙方行驶状态 从通用值【行驶状态】获取ID
@property (nonatomic,copy) NSString * ptcDescribe;              //丙方简述
@property (nonatomic,copy) NSArray  * files;                    //事故图片 列表，最多可上传30张
@property (nonatomic,copy) NSArray  * certFiles;                //证件图片 识别的图片，文件格式列表。识别后图片不需要显示出来
@property (nonatomic,copy) NSArray * certRemarks;              //证件图片名称 识别的图片名称，字符串列表。和证件图片一对一，名称统一命名，命名规则如下
/*
 证件图片名称：
 甲方身份证 甲方驾驶证 甲方行驶证
 乙方身份证 乙方驾驶证 乙方行驶证
 丙方身份证 丙方驾驶证 丙方行驶证
 */

@end

@interface FastAccidentSaveManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) FastAccidentSaveParam *param;

/****** 返回数据 ******/
//无返回参数

@end

#pragma mark - 快处事故列表API

@interface FastAccidentListPagingParam : NSObject

@property (nonatomic,assign) NSInteger start;   //开始的索引号 从0开始
@property (nonatomic,assign) NSInteger length;  //显示的记录数 默认为10
@property (nonatomic,copy)   NSString * search; //搜索的关键字

@end


@interface FastAccidentListPagingReponse : NSObject

@property (nonatomic,copy) NSArray <AccidentListModel *>*list;       //包含AccidentListModel对象
@property (nonatomic,assign) NSInteger total;   //总数


@end


@interface FastAccidentListPagingManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) FastAccidentListPagingParam *param;

/****** 返回数据 ******/
@property (nonatomic, strong) FastAccidentListPagingReponse *fastAccidentListPagingReponse;

@end


#pragma mark - 快处事件详情API


@interface FastAccidentDetailManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) NSString *fastaccidentId;

/****** 返回数据 ******/
@property (nonatomic, strong) FastAccidentDetailModel *accidentDetailModel;


@end


