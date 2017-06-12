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

#import "FastAccidentAPI.h"
#import "CommonAPI.h"
#import "LoginHomeVC.h"


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


#pragma mark - 身份证验证

/**
 * 验证身份证
 **/
+ (BOOL)validateIDCardNumber:(NSString *)value {
    
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSInteger length =0;
    if (!value) {
        return NO;
    }else {
        length = value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray = @[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return NO;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch >0) {
                int S = [value substringWithRange:NSMakeRange(0,1)].intValue*7 + [value substringWithRange:NSMakeRange(10,1)].intValue *7 + [value substringWithRange:NSMakeRange(1,1)].intValue*9 + [value substringWithRange:NSMakeRange(11,1)].intValue *9 + [value substringWithRange:NSMakeRange(2,1)].intValue*10 + [value substringWithRange:NSMakeRange(12,1)].intValue *10 + [value substringWithRange:NSMakeRange(3,1)].intValue*5 + [value substringWithRange:NSMakeRange(13,1)].intValue *5 + [value substringWithRange:NSMakeRange(4,1)].intValue*8 + [value substringWithRange:NSMakeRange(14,1)].intValue *8 + [value substringWithRange:NSMakeRange(5,1)].intValue*4 + [value substringWithRange:NSMakeRange(15,1)].intValue *4 + [value substringWithRange:NSMakeRange(6,1)].intValue*2 + [value substringWithRange:NSMakeRange(16,1)].intValue *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return NO;
    }
}

#pragma mark - 车牌号验证

+ (BOOL) validateCarNumber:(NSString *) carNumber{
    NSString *CarkNum = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarkNum];
    BOOL isMatch = [pred evaluateWithObject:carNumber];
    return isMatch;
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

+ (NSMutableAttributedString *)highlightInString:(NSString *)originString withSubString:(NSString *)subString{
    
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:originString];
    
    NSRange range1=[[attribut string]rangeOfString:subString];
    [attribut addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xf05563) range:range1];
    
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

//#pragma mark - 时间戳转换成时间 
//
//+ (NSString *)timestampGetTime:(NSNumber *)time{
//
//    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:[time doubleValue] / 1000];
//    NSLog(@"date:%@",[detaildate description]);
//    //实例化一个NSDateFormatter对象
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    //设定时间格式,这里可以设置成自己需要的格式
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    
//    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
//    
//    return currentDateStr;
//
//}


#pragma mark - 获取时间挫转换成时间：格式为yyyy-MM-dd HH:mm:ss

+ (NSString *)timeWithTimeInterval:(NSNumber *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
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

+ (UIViewController *)findViewController:(UIView *)sourceView withClass:(Class)classVC{
    id target=sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:classVC]) {
            break;
        }
    }
    return target;

}


#pragma mark - 获取缓存目录
+ (NSString *)getCacheSubPath:(NSString *)dirName {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    return [documentPath stringByAppendingPathComponent:dirName];
}

#pragma mark - 单个文件的大小
+ (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

#pragma mark - 遍历文件夹获得文件夹大小，返回多少M

+ (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    LxDBAnyVar(folderSize/(1024.0*1024.0));
    return folderSize/(1024.0*1024.0);
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
//第一种方法：scaleFromImage 这种方式
+ (UIImage *)scaleFromImage:(UIImage *)image{
    
    if (!image){
        return nil;
    }
    NSData *data =UIImageJPEGRepresentation(image,1.f);
    CGFloat dataSize = data.length/1024;
    CGFloat width  = image.size.width;
    CGFloat height = image.size.height;
    CGSize size;
    
    
//    if (dataSize<=50)//小于50k
//    {
//        return image;
//    }else if (dataSize<=100)//小于100k
//    {
//        size = CGSizeMake(width/1.f, height/1.f);
//    }
//    else if (dataSize<=200)//小于200k
//    {
//        size = CGSizeMake(width/2.f, height/2.f);
//    }
//    else if (dataSize<=500)//小于500k
//    {
//        size = CGSizeMake(width/2.f, height/2.f);
//    }
    if (dataSize<=500) {
        return image;
    }
    else if (dataSize<=1000)//小于1M
    {
        size = CGSizeMake(width/1.f, height/1.f);
    }
    else if (dataSize<=1500)//小于1.5M
    {
        size = CGSizeMake(width*2/3.f, height*2/3.f);
    }
    else if (dataSize<=2000)//小于2M
    {
        size = CGSizeMake(width/2.f, height/2.f);
    }
    else//大于2M
    {
        size = CGSizeMake(width/2.f, height/2.f);
    }
    LxPrintf(@"%f,%f",size.width,size.height);
//    UIGraphicsBeginImageContext(size);
//    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
//    UIImage *newImage =UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    if (!newImage){
//        return image;
//    }
    return [self imageCompressForSize:image targetSize:CGSizeMake(size.width, size.height)];
}

//等比例压缩
+ (UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
    
}


/**
 *  压缩图片到指定文件大小
 *
 *  @param image 目标图片
 *  @param size  目标大小（最大值）
 *
 *  @return 返回的图片文件
 */
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length / 1000.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    return data;
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

#pragma mark - 获取路名通用值
+ (void)getCommonRoad{

    CommonGetRoadManger *manger = [[CommonGetRoadManger alloc] init];
    manger.isNeedShowHud = NO;
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        if (manger.responseModel.code == CODE_SUCCESS) {
            [ShareValue sharedDefault].roadModels = manger.commonGetRoadResponse;
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];

}

//注销需要执行的操作

+ (void)LoginOut{
    
    [LRBaseRequest clearRequestFilters];
    [ShareValue sharedDefault].token = nil;
    [ShareValue sharedDefault].phone = nil;
    [UserModel setUserModel:nil];
    
    ApplicationDelegate.vc_tabBar = nil;
    LoginHomeVC *t_vc = [LoginHomeVC new];
    UINavigationController *t_nav = [[UINavigationController alloc] initWithRootViewController:t_vc];
    ApplicationDelegate.window.rootViewController = t_nav;

}

@end
