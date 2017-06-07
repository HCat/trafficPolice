//
//  URLErrorMacro.h
//  trafficPolice
//
//  Created by hcat on 2017/5/22.
//  Copyright © 2017年 Degal. All rights reserved.
//

#ifndef URLErrorMacro_h
#define URLErrorMacro_h

//#define CODE_TOKENTIMEOUT   999 //token失效CODE
#define CODE_FAILED         100 //请求链接成功，但是服务器返回失败CODE
#define CODE_SUCCESS        0   //请求成功CODE
#define CODE_HAVECOLLECT    110 //90秒前有一次采集记录，返回一次采集记录的ID，跳转到二次采集页面
#define CODE_TOKENTIMEOUT   111 //token失效CODE

#endif /* URLErrorMacro_h */
