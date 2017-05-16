//
//  ShareFun.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/16.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "ShareFun.h"
#import "AppDelegate.h"

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

@end
