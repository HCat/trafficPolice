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



#define URL_LOGIN_LOGIN @"app/login.json"                    //登录
#define URL_LOGIN_LOGINTAKECODE @"app/loginTakeCode.json"    //登录发送验证码
#define URL_LOGIN_LOGINCHECK @"app/loginCheck.json"          //验证码登录

#define URL_COMMON_GETCODES @"getCodes.json"          //获取事故通用值
#define URL_COMMON_GETWEATHER @"getWeather.json"        //获取当前天气


#endif /* URLMacro_h */
