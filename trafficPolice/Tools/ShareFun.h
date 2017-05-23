//
//  ShareFun.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/16.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface ShareFun : NSObject

//退出程序
+ (void)exitApplication;

//验证手机验证码格式
+ (BOOL)validatePhoneNumber:(NSString *)phoneNumber;

//高亮一段NSSting中的数字部分

+ (NSMutableAttributedString *)highlightNummerInString:(NSString *)originString;

//获取唯一标识符

+ (NSString *)getUniqueDeviceIdentifierAsString;

//获取列表权限

+ (BOOL)isPermissionForAccidentList;        //事故和快处权限
+ (BOOL)isPermissionForIllegalList;         //违章和违停权限
+ (BOOL)isPermissionForVideoCollectList;    //视频录入权限

@end
