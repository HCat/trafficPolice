//
//  LRCountDownButton.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/17.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BeginBlock)();

@interface LRCountDownButton : UIButton


// 验证码倒计时时长
@property (nonatomic,assign) NSInteger durationOfCountDown;

//开始倒计时触发事件

@property (nonatomic,copy) BeginBlock beginBlock;

//原始 字体颜色
@property (nonatomic,strong) UIColor *originalColor;

//倒计时 字体颜色
@property (nonatomic,strong) UIColor *processColor;

//原始 按钮背景
@property (nonatomic,strong) UIColor *originalBGColor;

//倒计时 按钮背景
@property (nonatomic,strong) UIColor *processBGColor;

//开始倒计时
- (void)startCountDown;

@end
