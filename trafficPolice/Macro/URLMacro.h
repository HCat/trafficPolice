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
#define URL_COMMON_GETIMGPLAY @"app/common/getImgPlay.json"    //获取图片轮播图片
#define URL_COMMON_VERSIONUPDATE @"app/common/versionUpdate.json"    //版本更新
#define URL_COMMON_ADVICE @"app/common/advice.json"    //投诉建议


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



#define URL_ILLEGALPARK_SAVE @"app/illegalPark/save.json"            //违停采集增加
#define URL_ILLEGALPARK_LISTPAGING @"app/illegalPark/listPaging.json"            //违停采集列表
#define URL_ILLEGALPARK_DETAIL @"app/illegalPark/detail.json"            //违停采集详情
#define URL_ILLEGALPARK_REPORTABNORMAL @"app/illegalPark/reportAbnormal.json"            //违停、违法禁令上报异常


#define URL_ILLEGALTHROUGH_QUERYSEC @"app/illegalThrough/querySec.json"            //违反禁令查询是否需要二次采集
#define URL_ILLEGALTHROUGH_SAVE @"app/illegalThrough/save.json"            //违反禁令采集增加
#define URL_ILLEGALTHROUGH_SECADD @"app/illegalThrough/secAdd.json"            //违反禁令采集增加违反禁令二次采集加载数据
#define URL_ILLEGALTHROUGH_SECSAVE @"app/illegalThrough/secSave.json"            //违反禁令二次采集保存
#define URL_ILLEGALTHROUGH_LISTPAGING @"app/illegalThrough/listPaging.json"            //违反禁令采集列表
#define URL_ILLEGALTHROUGH_DETAIL @"app/illegalThrough/detail.json"            //违反禁令采集详情


#define URL_VIDEOCOLECT_SAVE @"app/videoColect/save.json"            //警情反馈采集增加
#define URL_VIDEOCOLECT_LISTPAGING @"app/videoColect/listPaging.json"            //警情反馈采集列表
#define URL_VIDEOCOLECT_DETAIL @"app/videoColect/detail.json"            //	警情反馈详情


#endif /* URLMacro_h */
