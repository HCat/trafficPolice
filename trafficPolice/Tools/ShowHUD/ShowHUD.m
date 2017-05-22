//
//  ShowHUD.m
//  HelloToy
//
//  Created by Hcat on 15/4/23.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "ShowHUD.h"

#define DEFAULTMARGIN 10.0f

@interface ShowHUD ()<MBProgressHUDDelegate>{
    MBProgressHUD   *_hud;
}

@end

@implementation ShowHUD

- (instancetype)initWithView:(UIView *)view
{
    if (view == nil) {
        return nil;
    }
    self = [super init];
    if (self) {
        _hud = [[MBProgressHUD alloc] initWithView:view];
        _hud.animationType             = MBProgressHUDAnimationZoom; // 默认动画样式
        _hud.removeFromSuperViewOnHide = YES;                        // 该视图隐藏后则自动从父视图移除掉
        [view addSubview:_hud];
    }
    return self;
}

- (void)show:(BOOL)show
{
    // 根据属性判断是否要显示文本
    if (_text != nil && _text.length != 0 && _text.length) {
        if (_text.length > 10) {
            _hud.detailsLabel.text = _text;
        }else{
            _hud.label.text = _text;
        }
        
    }
    
    // 设置文本字体
    if (_textFont) {
        if (_text.length > 10) {
            _hud.detailsLabel.font = _textFont;
        }else{
            _hud.label.font = _textFont;
        }
        
    }
    
    // 如果设置这个属性,则只显示文本
    if (_showTextOnly == YES && _text != nil && _text.length != 0) {
        _hud.mode = MBProgressHUDModeText;
    }
    
    //设置蒙版效果
    
    _hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    _hud.backgroundView.color = _dimBackground ? [UIColor colorWithWhite:0.f alpha:.2f] : [UIColor clearColor];
    
    
    // 设置背景色
    if (_backgroundColor) {
        _hud.bezelView.color = _backgroundColor;
    }
    
    // 文本颜色
    if (_labelColor) {
        _hud.label.textColor = _labelColor;
    }
    
    // 设置圆角
    if (_cornerRadius) {
        _hud.bezelView.layer.cornerRadius = _cornerRadius;
    }
    
    // 设置透明度
    if (_opacity) {
        _hud.bezelView.alpha = _opacity;
    }
    
    // 自定义view
    if (_customView) {
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = _customView;
    }
    
    // 边缘留白
    if (_margin > 0) {
        _hud.margin = _margin;
    }
    
    [_hud showAnimated:show];
}

- (void)hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay
{
    [_hud hideAnimated:animated afterDelay:delay];
}

- (void)hide
{
    [_hud hideAnimated:YES];
}

#pragma mark - setter && getter

@synthesize animationStyle = _animationStyle;

- (void)setAnimationStyle:(HUDAnimationType)animationStyle{
    _animationStyle    = animationStyle;
    _hud.animationType = (MBProgressHUDAnimation)_animationStyle;
}

- (HUDAnimationType)animationStyle{
    return _animationStyle;
}

#pragma mark - Methods

+ (void)showTextOnly:(NSString *)text
            duration:(NSTimeInterval)duration
              inView:(UIView *)view
              config:(ConfigShowHUDBlock)config
{
    ShowHUD *hud     = [[ShowHUD alloc] initWithView:view];
    hud.text         = text;
    hud.showTextOnly = YES;
    hud.margin       = DEFAULTMARGIN;
    hud.dimBackground = NO;
    hud.textFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:14];
    hud.animationStyle  = Zoom;   // 设定动画方式
    hud.cornerRadius    = 3.f;    // 边缘圆角
    hud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    
    
    // 配置额外的参数
    if (config) {
        config(hud);
    }
    
    // 显示
    [hud show:YES];
    
    // 延迟duration后消失
    [hud hideAnimated:YES afterDelay:duration];
}



+ (void)showText:(NSString *)text
        duration:(NSTimeInterval)duration
          inView:(UIView *)view
          config:(ConfigShowHUDBlock)config
{
    ShowHUD *hud     = [[ShowHUD alloc] initWithView:view];
    hud.text         = text;
    hud.margin       = DEFAULTMARGIN;
    hud.dimBackground = NO;
    hud.textFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:14];
    hud.animationStyle  = Zoom;   // 设定动画方式
    hud.cornerRadius    = 3.f;    // 边缘圆角
    hud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];

    // 配置额外的参数
    if (config) {
        config(hud);
    }

    
    // 显示
    [hud show:YES];
    
    // 延迟duration后消失
    [hud hideAnimated:YES afterDelay:duration];
}


+ (void)showCustomView:(ConfigShowHUDCustomViewBlock)viewBlock
              duration:(NSTimeInterval)duration
                inView:(UIView *)view
                config:(ConfigShowHUDBlock)config
{
    ShowHUD *hud     = [[ShowHUD alloc] initWithView:view];
    hud.margin       = DEFAULTMARGIN;
    hud.dimBackground = NO;
    hud.textFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:14];
    hud.animationStyle  = Zoom;   // 设定动画方式
    hud.cornerRadius    = 3.f;    // 边缘圆角
    hud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];

    // 配置额外的参数
    if (config) {
        config(hud);
    }

    
    // 自定义View
    hud.customView   = viewBlock();
    
    // 显示
    [hud show:YES];
    
    [hud hideAnimated:YES afterDelay:duration];
}



// 显示警告

+ (void)showWarning:(NSString *)text
           duration:(NSTimeInterval)duration
             inView:(UIView *)view
             config:(ConfigShowHUDBlock)config
{

    ShowHUD *hud = [ShowHUD showCustomView:^UIView *{
        return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ShowHUDUntil.bundle/hud-warning"]];
    }inView:view config:^(ShowHUD *confighud) {
        confighud.text = text;
        confighud.textFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:14];
        confighud.animationStyle  = Zoom;   // 设定动画方式
        confighud.cornerRadius    = 3.f;    // 边缘圆角
        confighud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        config(confighud);
    }];
    
    hud.text = text;
    [hud hideAnimated:YES afterDelay:duration];
    
}





// 显示失败

+ (void)showError:(NSString *)text
         duration:(NSTimeInterval)duration
           inView:(UIView *)view
           config:(ConfigShowHUDBlock)config
{

    ShowHUD *hud = [ShowHUD showCustomView:^UIView *{
        return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ShowHUDUntil.bundle/hud-fail"]];
    } inView:view config:^(ShowHUD *confighud) {
        confighud.text = text;
        confighud.textFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:14];
        confighud.animationStyle  = Zoom;   // 设定动画方式
        confighud.cornerRadius    = 3.f;    // 边缘圆角
        confighud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        if (config) {
            config(confighud);
        }
    }];
    
    hud.text = text;
    [hud hideAnimated:YES afterDelay:duration];
    
}





// 显示成功

+ (void)showSuccess:(NSString *)text
           duration:(NSTimeInterval)duration
             inView:(UIView *)view
             config:(ConfigShowHUDBlock)config
{

    ShowHUD *hud = [ShowHUD showCustomView:^UIView *{
        return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ShowHUDUntil.bundle/hud-success"]];
    } inView:view  config:^(ShowHUD *confighud) {
        confighud.text = text;
        confighud.textFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:14];
        confighud.animationStyle  = Zoom;   // 设定动画方式
        confighud.cornerRadius    = 3.f;    // 边缘圆角
        confighud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        if (config) {
            config(confighud);
        }
    }];
    
    hud.text = text;
    [hud hideAnimated:YES afterDelay:duration];

}

#pragma mark - instancetype

// 初始化只有文本视图的HUD

+ (instancetype)showTextOnly:(NSString *)text
                      inView:(UIView *)view
                      config:(ConfigShowHUDBlock)config
{
    ShowHUD *hud     = [[ShowHUD alloc] initWithView:view];
    hud.text         = text;
    hud.showTextOnly = YES;
    hud.margin       = DEFAULTMARGIN;
    hud.dimBackground = NO;
    hud.textFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:14];
    hud.animationStyle  = Zoom;   // 设定动画方式
    hud.cornerRadius    = 3.f;    // 边缘圆角
    hud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];

    
    // 配置额外的参数
    if (config) {
        config(hud);
    }
    // 显示
    [hud show:YES];
    
    return hud;
}


//初始化菊花视图的HUD

+ (instancetype)showText:(NSString *)text
                  inView:(UIView *)view
                  config:(ConfigShowHUDBlock)config
{
    ShowHUD *hud     = [[ShowHUD alloc] initWithView:view];
    hud.text         = text;
    hud.margin       = DEFAULTMARGIN;
    hud.textFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:14];
    hud.animationStyle  = Zoom;   // 设定动画方式
    hud.cornerRadius    = 3.f;    // 边缘圆角
    hud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];

    
    // 配置额外的参数
    if (config) {
        config(hud);
    }

    // 显示
    [hud show:YES];
    
    return hud;
}


//初始化外部导入视图的HUD

+ (instancetype)showCustomView:(ConfigShowHUDCustomViewBlock)viewBlock
                        inView:(UIView *)view
                        config:(ConfigShowHUDBlock)config
{
    ShowHUD *hud     = [[ShowHUD alloc] initWithView:view];
    hud.margin       = DEFAULTMARGIN;
    hud.textFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:14];
    hud.animationStyle  = Zoom;   // 设定动画方式
    hud.cornerRadius    = 3.f;    // 边缘圆角
    hud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];

    
    // 配置额外的参数
    if (config) {
        config(hud);
    }

    
    // 自定义View
    hud.customView   = viewBlock();
    
    // 显示
    [hud show:YES];
    
    return hud;
}



//初始化白色转圈的HUD

+ (instancetype)showWhiteLoadingWithText:(NSString*)text inView:(UIView*)view config:(ConfigShowHUDBlock)config
{
    ShowHUD *hud = [ShowHUD showCustomView:^UIView *{
        return [ShowHUD showAnimatedWithImage:[UIImage imageNamed:@"ShowHUDUntil.bundle/loading_white"]];
    } inView:view  config:^(ShowHUD *confighud) {
        confighud.text = text;
        confighud.textFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:14];
        confighud.animationStyle  = Zoom;   // 设定动画方式
        confighud.cornerRadius    = 3.f;    // 边缘圆角
        confighud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        if (config) {
            config(confighud);
        }
    }];

    return hud;
}


//初始化灰色转圈的HUD

+ (instancetype)showGaryLoadingWithText:(NSString*)text inView:(UIView*)view config:(ConfigShowHUDBlock)config
{
    ShowHUD *hud = [ShowHUD showCustomView:^UIView *{
        return [ShowHUD showAnimatedWithImage:[UIImage imageNamed:@"ShowHUDUntil.bundle/loading_gray"]];
    } inView:view  config:^(ShowHUD *confighud) {
        confighud.text = text;
        confighud.textFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:14];
        confighud.animationStyle  = Zoom;   // 设定动画方式
        confighud.cornerRadius    = 3.f;    // 边缘圆角
        confighud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        if (config) {
            config(confighud);
        }
    }];
    
    return hud;
}

#pragma mark - 转圈圈动画

+ (UIImageView *)showAnimatedWithImage:(UIImage*)image
{
    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.removedOnCompletion = NO;//保证切换到其他页面或进入后台再回来动画继续执行
    rotationAnimation.repeatCount = CGFLOAT_MAX;
    
    [imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    return imageView;
    
}





- (void)dealloc
{
    NSLog(@"资源释放了,没有泄露^_^");
}



@end
