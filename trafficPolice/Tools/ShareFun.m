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

#pragma mark - 退出程序

+ (void)exitApplication{
    
    UIWindow *window = ApplicationDelegate.window;
    
    [UIView animateWithDuration:0.3f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(window.bounds.size.width/2, window.bounds.size.height/2, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
    
}

#pragma mark - 验证手机号格式是否正确

+ (BOOL)validatePhoneNumber:(NSString *)phoneNumber{
    
    NSString  *phoneNum=@"^((13[0-9])|(15[^4,\\D])|(18[0-9])|(17[0-9]))\\d{8}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneNum];
    return [numberPre evaluateWithObject:phoneNumber substitutionVariables:nil];
    
}

#pragma mark - 高亮文字中部分文字

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

#pragma mark - 获取机器唯一标识符

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

#pragma mark - 获取当前时间：格式为yyyy-MM-dd HH:mm:ss

+ (NSString *)getCurrentTime{
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *current = [formatter stringFromDate:now];
    return current;
}

#pragma mark - 通过UIView获取UIViewController

+ (UIViewController *)findViewController:(UIView *)sourceView
{
    id target=sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}

#pragma mark - 根据UIImageData获取UIImage是什么格式的

+ (NSString *)typeForImageData:(NSData *)data {

    uint8_t c;
    
    [data getBytes:&c length:1];

    switch (c) {
            
        case 0xFF:
            
            return @"image/jpeg";
            
        case 0x89:
            
            return @"image/png";
            
        case 0x47:
            
            return @"image/gif";
            
        case 0x49:
            
        case 0x4D:
            
            return @"image/tiff";
    }
    
    return nil;
    
}

#pragma mark - 压缩图片
+ (UIImage *)scaleFromImage:(UIImage *)image{
    
    if (!image){
        return nil;
    }
    NSData *data =UIImagePNGRepresentation(image);
    CGFloat dataSize = data.length/1024;
    CGFloat width  = image.size.width;
    CGFloat height = image.size.height;
    CGSize size;
    
    if (dataSize<=50)//小于50k
    {
        return image;
    }else if (dataSize<=100)//小于100k
    {
        size = CGSizeMake(width/1.f, height/1.f);
    }
    else if (dataSize<=200)//小于200k
    {
        size = CGSizeMake(width/2.f, height/2.f);
    }
    else if (dataSize<=500)//小于500k
    {
        size = CGSizeMake(width/2.f, height/2.f);
    }
    else if (dataSize<=1000)//小于1M
    {
        size = CGSizeMake(width/2.f, height/2.f);
    }
    else if (dataSize<=2000)//小于2M
    {
        size = CGSizeMake(width/2.f, height/2.f);
    }
    else//大于2M
    {
        size = CGSizeMake(width/2.f, height/2.f);
    }
    NSLog(@"%f,%f",size.width,size.height);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage *newImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (!newImage){
        return image;
    }
    return newImage;
}




#pragma mark - 获取事故权限

+ (BOOL)isPermissionForAccidentList{

    NSString *match = @"ACCIDENT_LIST";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
}

#pragma mark - 获取违停权限

+ (BOOL)isPermissionForIllegalList{

    NSString *match = @"ILLEGAL_LIST";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;

}

#pragma mark - 获取警情权限

+ (BOOL)isPermissionForVideoCollectList{

    NSString *match = @"VIDEO_COLLECT_LIST";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;

}

#pragma mark - 获取事故通用值

+ (void)getAccidentCodes{

    AccidentGetCodesManger *manger = [AccidentGetCodesManger new];
    manger.isNeedShowHud = NO;
    manger.isLog = NO;
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
       
        if (manger.responseModel.code == CODE_SUCCESS) {
            [ShareValue sharedDefault].accidentCodes = manger.accidentGetCodesResponse;
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];

}



@end
