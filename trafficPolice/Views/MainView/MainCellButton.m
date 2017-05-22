//
//  MainCellButton.m
//  trafficPolice
//
//  Created by Binrong Liu on 2017/5/10.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "MainCellButton.h"
#import <PureLayout.h>

@interface MainCellButton()

@property(nonatomic,strong)UIImageView *imgV_content;
@property(nonatomic,strong)UILabel *lb_title;

@end


@implementation MainCellButton


- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super initWithCoder:aDecoder]){
        
        self.rippleLineWidth = 1;
        self.rippleColor = [UIColor lightGrayColor];
       
        self.imgV_content = [[UIImageView alloc] init];
        [self addSubview:_imgV_content];
        
        self.lb_title = [[UILabel alloc] init];
        self.lb_title.font = [UIFont systemFontOfSize:14];
        self.lb_title.textColor = UIColorFromRGB(0x444444);
        [self addSubview:_lb_title];
        
        [_imgV_content configureForAutoLayout];
        [_lb_title configureForAutoLayout];
        
        [_imgV_content autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [_imgV_content autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0];
        [_imgV_content autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:_imgV_content];
        
        [_lb_title autoAlignAxis:ALAxisVertical toSameAxisOfView:_imgV_content];
        [_lb_title autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_imgV_content withOffset:8.f];
        [_lb_title autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0];
        
    }
    return self;
}

- (void)setImg_content:(NSString *)img_content{
    
    _img_content = img_content;
    NSLog(@"%@",_img_content);
    _imgV_content.image = [UIImage imageNamed:_img_content];
    
}

- (void)setStr_title:(NSString *)str_title{
    
    _str_title = str_title;
    _lb_title.text = _str_title;
    if (!_str_title || _str_title.length ==0) {
        self.isIgnoreRipple = YES;
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
