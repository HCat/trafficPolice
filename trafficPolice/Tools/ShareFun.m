//
//  ShareFun.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/16.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "ShareFun.h"
#import "AppDelegate.h"

#import "SAMKeychain.h"
#import "SAMKeychainQuery.h"


@implementation ShareFun

+ (void)exitApplication{
    
    UIWindow *window = ApplicationDelegate.window;
    
    [UIView animateWithDuration:0.3f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(window.bounds.size.width/2, window.bounds.size.height/2, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
    
}


+ (BOOL)validatePhoneNumber:(NSString *)phoneNumber{
    
    NSString  *phoneNum=@"^((13[0-9])|(15[^4,\\D])|(18[0-9])|(17[0-9]))\\d{8}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneNum];
    return [numberPre evaluateWithObject:phoneNumber substitutionVariables:nil];
    
}

+ (NSMutableAttributedString *)highlightNummerInString:(NSString *)originString{

    //生成 NSAttributedString 子类 NSMutableAttributedString 的对象，这个NSMutableAttributedString才是可变的
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:originString];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [paragraphStyle setLineSpacing:5];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSParagraphStyleAttributeName] = paragraphStyle;
    [attribut addAttributes:dic range:NSMakeRange(0, attribut.length)];
    
    NSCharacterSet *numbers=[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray *setArr = [originString componentsSeparatedByCharactersInSet:numbers];
    NSString *temSting = originString;
    NSInteger location = 0;
    for (NSString *str_sub in setArr) {
        if (![str_sub isEqualToString:@""]) {
            NSRange numRange = [temSting rangeOfString:str_sub];
            location = location+numRange.location;
            
            /*
             * 这里要注意了，这里有两个方法，一个是改变单个属性用的，比如你只想改变字体，或者只是想改变显示的颜色用第一个方法就可以了，但是如果你同时想改变字体和颜色就应该用下面的方法
             - (void)addAttribute:(NSString *)name value:(id)value range:(NSRange)range;
             - (void)addAttributes:(NSDictionary<NSString *, id> *)attrs range:(NSRange)range;
             */
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            //改变显示的颜色，还有很多属性，大家可以自行看文档
            dic[NSForegroundColorAttributeName] = UIColorFromRGB(0xf14827);
            //改变字体的大小
            dic[NSFontAttributeName] = [UIFont systemFontOfSize:16];
            //改变背景颜色
//            dic[NSBackgroundColorAttributeName] = [UIColor grayColor];
//            dic[NSParagraphStyleAttributeName] = paragraphStyle;
            //赋值
            NSRange numRange2 = NSMakeRange(location, numRange.length);
            [attribut addAttributes:dic range:numRange2];
            location = location+numRange.length;
            temSting = [temSting substringFromIndex:numRange.location+numRange.length];
            
        }
        
    }
    
    return attribut;

}

+ (NSString *)getUniqueDeviceIdentifierAsString
{
    NSString *appName=[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    
    NSString *strApplicationUUID =  [SAMKeychain passwordForService:appName account:@"incoding"];
    
    if (strApplicationUUID == nil)
    {
        strApplicationUUID  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
        NSError *error = nil;
        SAMKeychainQuery *query = [[SAMKeychainQuery alloc] init];
        query.service = appName;
        query.account = @"incoding";
        query.password = strApplicationUUID;
        query.synchronizationMode = SAMKeychainQuerySynchronizationModeNo;
        [query save:&error];
        
    }
    
    return strApplicationUUID;
}

//获取列表权限

+ (BOOL)isPermissionForAccidentList{
    
    
    NSString *match = @"ACCIDENT_LIST";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
}


+ (BOOL)isPermissionForIllegalList{

    NSString *match = @"ILLEGAL_LIST";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;

}

+ (BOOL)isPermissionForVideoCollectList{

    NSString *match = @"VIDEO_COLLECT_LIST";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;

}

+ (void)getAccidentCodes{

    AccidentGetCodesManger *manger = [AccidentGetCodesManger new];
    manger.isLog = NO;
    manger.isNeedShowHud = NO;
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
       
        if (manger.responseModel.code == CODE_SUCCESS) {
            [ShareValue sharedDefault].accidentCodes = manger.accidentGetCodesResponse;
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];

}


+ (NSString *)getCurrentTime{

    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *current = [formatter stringFromDate:now];
    return current;
}

@end
