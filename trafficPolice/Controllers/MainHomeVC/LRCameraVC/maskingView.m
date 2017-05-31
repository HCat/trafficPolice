//
//  maskingView.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/31.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "maskingView.h"

@interface maskingView()

@property (nonatomic,strong) CAShapeLayer * shapeLayer;
@property (nonatomic,strong)  UIBezierPath *circlePath;

@end


@implementation maskingView

+(Class)layerClass{
    return [CAShapeLayer class];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.shapeLayer = [CAShapeLayer layer];
        [self.layer addSublayer:self.shapeLayer];
    
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:[UIScreen mainScreen].bounds cornerRadius:0];
    
    CGRect myRect = CGRectZero;
    if (ScreenHeight > ScreenWidth) {
        //竖屏
        [self setType:_type];

    }else{
        //横屏
        if(_type == 1){
            myRect =CGRectMake(ScreenWidth/2-(ScreenWidth*3/10),ScreenHeight/2-(ScreenHeight/4),ScreenWidth*3/5, ScreenHeight/2);
        }else if (_type == 2){
            myRect =CGRectMake(ScreenWidth/2-(ScreenWidth*3/10),ScreenHeight/2-(ScreenHeight*2/6),ScreenWidth*3/5, ScreenHeight * 2/3);
        }
        
        self.circlePath = [UIBezierPath bezierPathWithRect:myRect];
       
        [self setNeedsDisplay];
        [path appendPath:_circlePath];
        [path setUsesEvenOddFillRule:YES];
        
        self.shapeLayer.path = path.CGPath;
        self.shapeLayer.fillRule = kCAFillRuleEvenOdd;
        self.shapeLayer.fillColor = [UIColor blackColor].CGColor;
        self.shapeLayer.opacity = 0.95;
    }

}

- (void) setType:(NSInteger)type{

    _type = type;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:[UIScreen mainScreen].bounds cornerRadius:0];
    CGRect myRect = CGRectZero;
    if (_type == 1) {
        myRect =CGRectMake(ScreenWidth/2-(ScreenWidth * 4/10),ScreenHeight/2-(ScreenHeight/10),ScreenWidth*4/5, ScreenHeight/5);
       
    }else if (_type == 2){
        myRect =CGRectMake(ScreenWidth/2-(ScreenWidth * 4/10),ScreenHeight/2-(ScreenHeight/6),ScreenWidth * 4/5, ScreenHeight/3);
    }
    
    self.circlePath = [UIBezierPath bezierPathWithRect:myRect];
    [self setNeedsDisplay];
    [path appendPath:_circlePath];
    [path setUsesEvenOddFillRule:YES];
    self.shapeLayer.path = path.CGPath;
    self.shapeLayer.fillRule = kCAFillRuleEvenOdd;
    self.shapeLayer.fillColor = [UIColor blackColor].CGColor;
    self.shapeLayer.opacity = 0.95;
}


- (void) drawRect:(CGRect)rect {
    _circlePath.lineWidth = 2;
    UIColor *color = [UIColor whiteColor];
    [color set];
    _circlePath.lineCapStyle = kCGLineCapRound;
    _circlePath.lineJoinStyle = kCGLineJoinRound;
    [_circlePath stroke];
    
}

@end
