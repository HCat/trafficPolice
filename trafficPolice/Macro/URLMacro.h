//
//  URLMacro.h
//  trafficPolice
//
//  Created by hcat on 2017/5/18.
//  Copyright © 2017年 Degal. All rights reserved.
//

#ifndef URLMacro_h
#define URLMacro_h


#define DEBUG_URL @"http://162358vc96.imwork.net/police-wx"
#define RELEASE_URL @"http://jinjiang.degal.cn/police_wx_jj"

#define Base_URL DEBUG_URL



#define URL_LOGIN_LOGIN @"app/login.json"                           //登录
#define URL_LOGIN_LOGINTAKECODE @"app/loginTakeCode.json"           //登录发送验证码
#define URL_LOGIN_LOGINCHECK @"app/loginCheck.json"                 //验证码登录

#define URL_COMMON_GETWEATHER @"app/common/getWeather.json"         //获取当前天气
#define URL_COMMON_IDENTIFY @"app/common/identify.json"             //证件识别
#define URL_COMMON_GETROAD @"app/common/getRoad.json"    //获取路名


#define URL_ACCIDENT_GETCODES @"app/accident/getCodes.json"         //获取事故通用值
#define URL_ACCIDENT_SAVE @"app/accident/save.json"                //事故增加
#define URL_ACCIDENT_LISTPAGING @"app/accident/listPaging.json"    //事故列表
#define URL_ACCIDENT_DETAIL @"app/accident/detail.json"            //事故详情
#define URL_ACCIDENT_COUNTBYCARNO @"app/accident/countAccidentByCarno.json"            //通过车牌号统计事故数量
#define URL_ACCIDENT_COUNTBYTELNUM @"app/accident/countAccidentByTelNum.json"            //通过手机号统计事故数量
#define URL_ACCIDENT_COUNTBYIDNO @"app/accident/countAccidentByIdNo.json"            //通过身份证号统计事故数量




#define URL_FASTACCIDENT_GETCODES @"app/fastAccident/getCodes.json"         //获取快处事故通用值
#define URL_FASTACCIDENT_SAVE @"app/fastAccident/save.json"                //快处事故增加
#define URL_FASTACCIDENT_LISTPAGING @"app/fastAccident/listPaging.json"    //快处事故列表
#define URL_FASTACCIDENT_DETAIL @"app/fastAccident/detail.json"            //快处事故详情


#endif /* URLMacro_h */
