//
//  LRRippleButton.h
//  trafficPolice
//
//  Created by Binrong Liu on 2017/5/10.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LRRippleButtonBlock)(void);

@interface LRRippleButton : UIView

@property (nonatomic, strong) UIColor *rippleColor;                 //涟漪颜色
@property (nonatomic, assign) NSUInteger rippleLineWidth;           //涟漪线宽



@property (nonatomic, copy)LRRippleButtonBlock rippleBlock;

@end
