//
//  LRRippleButton.m
//  trafficPolice
//
//  Created by Binrong Liu on 2017/5/10.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "LRRippleButton.h"



const CGFloat LRRippleInitialRaius = 20;

@interface LRRippleButton()<CAAnimationDelegate>

@end

@implementation LRRippleButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]){
        [self initLRRippleButton];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super initWithCoder:aDecoder]){
        [self initLRRippleButton];
    }
    return self;
}

#pragma mark - init
- (void)initLRRippleButton{
    //模拟按钮点击效果
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:tap];
    
    self.clipsToBounds = YES;
}

#pragma mark - tapped
- (void)tapped:(UITapGestureRecognizer *)tap{
    
    if (self.isIgnoreRipple) {
       
        if (self.rippleBlock){
            self.rippleBlock();
        }
        
    }else{
        
        //获取所点击的那个点
        CGPoint tapPoint = [tap locationInView:self];
        //创建涟漪
        CAShapeLayer *rippleLayer = nil;
        CGFloat buttonWidth = self.frame.size.width;
        CGFloat buttonHeight = self.frame.size.height;
        //  CGFloat bigBoard = buttonWidth >= buttonHeight ? buttonWidth : buttonHeight;
        CGFloat smallBoard = buttonWidth <= buttonHeight ? buttonWidth : buttonHeight;
        CGFloat rippleRadiius = smallBoard/2 <= LRRippleInitialRaius ? smallBoard/2 : LRRippleInitialRaius;
        
        //   CGFloat scale = bigBoard / rippleRadiius + 0.5;
        
        rippleLayer = [self createRippleLayerWithPosition:tapPoint rect:CGRectMake(0, 0, rippleRadiius * 2, rippleRadiius * 2) radius:rippleRadiius];
        
        [self.layer addSublayer:rippleLayer];
        
        //layer动画
        CAAnimationGroup *rippleAnimationGroup = [self createRippleAnimationWithScale:rippleRadiius duration:1.5f];
        //使用KVC消除layer动画以防止内存泄漏
        [rippleAnimationGroup setValue:rippleLayer forKey:@"rippleLayer"];
        
        [rippleLayer addAnimation:rippleAnimationGroup forKey:@"rippleLayerAnimation"];
        
    }
    
    
}

#pragma mark - createRippleLayer && CAAnimationGroup
- (CAShapeLayer *)createRippleLayerWithPosition:(CGPoint)position rect:(CGRect)rect radius:(CGFloat)radius{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = [self createPathWithRadius:rect radius:radius];
    layer.position = position;
    layer.bounds = CGRectMake(0, 0, radius * 2, radius * 2);
    layer.fillColor = self.rippleColor ? self.rippleColor.CGColor : [UIColor whiteColor].CGColor;
    layer.opacity = 0;
    layer.lineWidth = self.rippleLineWidth ? self.rippleLineWidth : 1;
    
    return layer;
}

- (CAAnimationGroup *)createRippleAnimationWithScale:(CGFloat)scale duration:(CGFloat)duration{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1)];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @0.5;
    alphaAnimation.toValue = @0;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleAnimation, alphaAnimation];
    animation.delegate = self;
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    return animation;
}

- (CGPathRef)createPathWithRadius:(CGRect)frame radius:(CGFloat)radius{
    return [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:radius].CGPath;
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim{
    if (self.rippleBlock){
        self.rippleBlock();
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    CALayer *layer = [anim valueForKey:@"rippleLayer"];
    if (layer) {
       
        [layer removeFromSuperlayer];
    }
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
