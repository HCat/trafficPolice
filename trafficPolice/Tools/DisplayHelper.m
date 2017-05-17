//
//  DisplayHelper.m
//  Ordering
//
//  Created by AaronKwok on 12-4-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DisplayHelper.h"
#import "MBProgressHUD.h"
//error
//success

@implementation DisplayHelper

+ (DisplayHelper *)shareDisplayHelper
{
    static DisplayHelper *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[DisplayHelper alloc]init];
    });
    return shareInstance;
}

- (void)showLoading:(UIView *)aView
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:aView];
    [aView addSubview:HUD];
    [HUD showAnimated:NO];
}

- (void)showLoading:(UIView *)aView noteText:(NSString *)noteText
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:aView];
    HUD.label.text = noteText;
    [aView addSubview:HUD];
    [HUD showAnimated:NO];
}

- (void)hideLoading:(UIView *)aView
{
    [MBProgressHUD hideHUDForView:aView animated:NO];
}


//用于显示提示信息的浮动框
+(void)displaySuccessAlert:(NSString*)title message:(NSString*)message{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:window];
    // Add HUD to screen
    [window addSubview:HUD];
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"showhud_success"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.label.text = title;
    HUD.detailsLabel.text = message;
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:1.5];
}


+(void)displaySuccessAlert:(NSString*)message interval:(float)interval{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:HUD];
    
    HUD.mode = MBProgressHUDModeText;
    HUD.label.text = message;
    HUD.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f]; //蒙版层
    HUD.margin = 10.f; //设置字和边框之间的距离
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:interval];
    
}

//用于显示提示信息的浮动框
+(void)displayWarningAlert:(NSString*)title message:(NSString*)message{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:window];
    // Add HUD to screen
    [window addSubview:HUD];
    
    
//    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.label.text = title;
    HUD.detailsLabel.text = message;
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:1.5];
    //[HUD release];
}

+(void)displaySuccessAlert:(NSString*)message{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:window];
    // Add HUD to screen
    [window addSubview:HUD];
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"showhud_success"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.label.text = message;
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:1.5];
    //[HUD release];
}
//用于显示提示信息的浮动框
+(void)displayWarningAlert:(NSString*)message{
    
    if ([message length] > 15) {
        
        NSLog(@"%@",message);
        return;
    }
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:window];
    // Add HUD to screen
    [window addSubview:HUD];
    
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"showhud_error"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.label.text = message;
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:1.5];
    //[HUD release];
}

//用于显示提示信息的浮动框
+(void)displaySuccessAlert:(NSString*)title message:(NSString*)message onView:(UIView*)aView{
    //UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:aView];
    // Add HUD to screen
    [aView addSubview:HUD];
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"showhud_success"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.label.text = title;
    HUD.detailsLabel.text = message;
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:1.5];
    //[HUD release];
}


//用于显示提示信息的浮动框
+(void)displayWarningAlert:(NSString*)title message:(NSString*)message onView:(UIView*)aView{
    //UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:aView];
    // Add HUD to screen
    [aView addSubview:HUD];
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"showhud_error"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.label.text = title;
    HUD.detailsLabel.text = message;
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:1.5];
    //[HUD release];
}

+(void)displaySuccessAlert:(NSString*)message onView:(UIView*)aView{
    //UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:aView];
    // Add HUD to screen
    [aView addSubview:HUD];
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"showhud_success"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.label.text = message;
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:1.5];
    //[HUD release];
}


//用于显示提示信息的浮动框
+(void)displayWarningAlert:(NSString*)message onView:(UIView*)aView{
    //UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:aView];
    // Add HUD to screen
    [aView addSubview:HUD];
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"showhud_error"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.label.text = message;
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:1.5];

    //[HUD release];
}

+(void)displaySuccessAlert:(NSString *)message onHUD:(MBProgressHUD *)HUD{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (!HUD) {
        HUD = [[MBProgressHUD alloc] initWithView:window];
    }
    [window addSubview:HUD];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"showhud_success"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.label.text = message;
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:1.5];
}


+(void)displaySuccessAlert:(NSString*)message interval:(float)interval onHUD:(MBProgressHUD *)HUD{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (!HUD) {
        HUD = [[MBProgressHUD alloc] initWithView:window];
    }
    [window addSubview:HUD];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"showhud_success"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.label.text = message;
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:interval];

}


+(void)displayWarningAlert:(NSString*)message onHUD:(MBProgressHUD *)HUD{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (!HUD) {
        HUD = [[MBProgressHUD alloc] initWithView:window];
    }
    
    [window addSubview:HUD];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"showhud_error"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.label.text = message;
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:1.5];
}


+(void)displayWarningAlert:(NSString*)message interval:(float)interval onHUD:(MBProgressHUD *)HUD{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (!HUD) {
        HUD = [[MBProgressHUD alloc] initWithView:window];
    }
    [window addSubview:HUD];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"showhud_error"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.label.text = message;
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:interval];
}



@end
