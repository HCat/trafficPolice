//
//  LRRippleButton.h
//  trafficPolice
//
//  Created by HCat on 2017/5/10.
//  Copyright © 2017年 Degal. All rights reserved.
//  点击按钮产生涟漪效果视图

#import <UIKit/UIKit.h>

typedef void (^LRRippleButtonBlock)(void);

@interface LRRippleButton : UIView

@property (nonatomic, strong) UIColor *rippleColor;                 //涟漪颜色
@property (nonatomic, assign) NSUInteger rippleLineWidth;           //涟漪线宽
@property (nonatomic, assign) BOOL isIgnoreRipple;                  //是否关闭涟漪


@property (nonatomic, copy)LRRippleButtonBlock rippleBlock;

@end
