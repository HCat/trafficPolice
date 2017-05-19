//
//  LoginAPI.h
//  trafficPolice
//
//  Created by hcat on 2017/5/18.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRBaseRequest.h"
#import "UserModel.h"

#pragma mark - 登录API
/****************** 登录 *****************/

@interface LoginManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) NSString *openId;  //实际是微信的unionid

/****** 返回数据 ******/
@property (nonatomic, copy) NSString *phone; //手机号码


@end

#pragma mark - 登录发送验证码API


@interface LoginTakeCodeManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) NSString *openId; //实际是微信的unionid

/****** 返回数据 ******/
@property (nonatomic, copy) NSString *acId; //短信ID


@end

#pragma mark - 验证码登录API

@interface LoginCheckParam : NSObject

@property (nonatomic,copy) NSString *openId;        //实际是微信的unionid
@property (nonatomic,copy) NSString *acId;          //短信ID
@property (nonatomic,copy) NSString *autoCode;      //验证码
@property (nonatomic,copy) NSString *equipmentId;   //设备ID


@end

@interface LoginCheckManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) LoginCheckParam *param;

/****** 返回数据 ******/
@property (nonatomic, strong) UserModel *userModel; //用户

@end


