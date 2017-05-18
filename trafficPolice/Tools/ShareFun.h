//
//  ShareFun.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/16.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareFun : NSObject

//退出程序
+ (void)exitApplication;

//验证手机验证码格式
+ (BOOL)validatePhoneNumber:(NSString *)phoneNumber;

//高亮一段NSSting中的数字部分

+ (NSMutableAttributedString *)highlightNummerInString:(NSString *)originString;

//获取唯一标识符

+ (NSString *)getUniqueDeviceIdentifierAsString;

@end
