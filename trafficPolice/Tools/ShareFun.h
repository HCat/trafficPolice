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

//身份证验证
+ (BOOL)validateIDCardNumber:(NSString *)value;

//车牌号验证
+ (BOOL) validateCarNumber:(NSString *) carNumber;

//高亮一段NSSting中的数字部分

+ (NSMutableAttributedString *)highlightNummerInString:(NSString *)originString;

+ (NSMutableAttributedString *)highlightInString:(NSString *)originString withSubString:(NSString *)subString;

//获取唯一标识符

+ (NSString *)getUniqueDeviceIdentifierAsString;

//通过UIView获取UIViewController
+ (UIViewController *)findViewController:(UIView *)sourceView;

//获取当前时间，格式是 yyyy-MM-dd HH:mm:ss
+ (NSString *)getCurrentTime;

+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString;


//根据UIImageData获取UIImage是什么格式的
+ (NSString *)typeForImageData:(NSData *)data;

#pragma mark - 压缩图片
+ (UIImage *)scaleFromImage:(UIImage *)image;

#pragma mark - 业务相关，待删除

//获取事故通用值
+ (void)getAccidentCodes;

//获取快处事故通用值
+ (void)getFastAccidentCodes;

//获取通用道路值

+ (void)getCommonRoad;

//获取列表权限

+ (BOOL)isPermissionForAccidentList;        //事故和快处权限
+ (BOOL)isPermissionForIllegalList;         //违章和违停权限
+ (BOOL)isPermissionForVideoCollectList;    //视频录入权限

@end
