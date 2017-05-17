//
//  AlertView.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/17.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "AlertView.h"
#import "ShareFun.h"

#define SPACE 40.0
#define WINDOW_WIDTH ([UIScreen mainScreen].bounds.size.width - (SPACE * 2))
#define WINDOW_HEIGHT ([UIScreen mainScreen].bounds.size.height - (SPACE * 2))

@interface AlertView()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *contentView;



@property (nonatomic, copy) NSString *title;    //提示title
@property (nonatomic, copy) NSString *content; //内容

@property (nonatomic, strong) UILabel *lb_title;
@property (nonatomic, strong) UILabel *lb_content;
@property (nonatomic, strong) UIButton *btn_quit;


@end

@implementation AlertView

#pragma mark -

+ (void)showWindowWithTitle:(NSString*)title
                   contents:(NSString *)contents{

    AlertView *window = [[AlertView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    window.title = title;
    window.content = contents;
    [[UIApplication sharedApplication].keyWindow addSubview:window];

    window.contentView.center = window.center;
    window.contentView.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                              CGAffineTransformMakeScale(1.1f, 1.1f));
    [UIView animateWithDuration:.2 animations:^{
        window.contentView.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                                  CGAffineTransformMakeScale(1.0f, 1.0f));
    }];
    
}


+ (void)showWindowWithContentView:(UIView*)contentView{


    AlertView *window = [[AlertView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:window];
    
    window.contentView = contentView;
    window.contentView.center = window.center;
    window.contentView.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                           CGAffineTransformMakeScale(1.1f, 1.1f));
    [UIView animateWithDuration:.2 animations:^{
        window.contentView.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                               CGAffineTransformMakeScale(1.0f, 1.0f));
    }];


}


#pragma mark -

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self createUI];
}

- (void)createUI {
    [self addSubview:self.maskView];
    [self addSubview:self.contentView];
}

#pragma mark - set && get 

- (UIView*)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = .5;
    }
    return _maskView;
}

- (UIView*)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 260,  150)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        _contentView.layer.borderWidth = .5;
        _contentView.layer.cornerRadius = 10.0;
        
        [_contentView addSubview:self.lb_title];
        [_contentView addSubview:self.lb_content];
        
        CGRect frame = _contentView.frame;
        frame.size.height = CGRectGetMinY(_lb_content.frame) + CGRectGetHeight(_lb_content.frame) +10;
        _contentView.frame = frame;
    }
    return _contentView;
}

- (UILabel *)lb_title{
    
    if (!_lb_title) {
        self.lb_title = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, _contentView.frame.size.width - 40, 20)];
        _lb_title.backgroundColor = [UIColor clearColor];
        _lb_title.textColor = UIColorFromRGB(0x444444);
        _lb_title.font = [UIFont systemFontOfSize:17.f];
        _lb_title.textAlignment = NSTextAlignmentCenter;
        _lb_title.text = _title;
    }
    return _lb_title;
}

- (UILabel *)lb_content{
    
    if (!_lb_content) {
        _lb_content = [[UILabel alloc] initWithFrame:CGRectMake(24, CGRectGetMaxY(_lb_title.frame)+10, CGRectGetWidth(_contentView.frame) - 48, 150)];
        _lb_content.backgroundColor = [UIColor clearColor];
        _lb_content.textColor = UIColorFromRGB(0x444444);
        _lb_content.font = [UIFont systemFontOfSize:14.f];
        _lb_content.textAlignment = NSTextAlignmentLeft;
        _lb_content.numberOfLines = 0;
        _lb_content.lineBreakMode = NSLineBreakByWordWrapping;
        _lb_content.attributedText = [ShareFun highlightNummerInString:_content];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        [paragraphStyle setLineSpacing:5];
        NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:14],NSParagraphStyleAttributeName: paragraphStyle };
        
        CGSize size = [_content boundingRectWithSize:CGSizeMake(CGRectGetWidth(_lb_content.frame), WINDOW_HEIGHT-20) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
        CGRect frame =_lb_content.frame;
        frame.size.height = size.height+10;
        _lb_content.frame = frame;
        
    }
    return _lb_content;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}

@end
