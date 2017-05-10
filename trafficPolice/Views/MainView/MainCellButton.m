//
//  MainCellButton.m
//  trafficPolice
//
//  Created by Binrong Liu on 2017/5/10.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "MainCellButton.h"
#import <Masonry.h>

@interface MainCellButton()

@property(nonatomic,strong)UIImageView *imgV_content;
@property(nonatomic,strong)UILabel *lb_title;

@end


@implementation MainCellButton


- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super initWithCoder:aDecoder]){
        
        self.imgV_content = [[UIImageView alloc] init];
        [self addSubview:_imgV_content];
        
        self.lb_title = [[UILabel alloc] init];
        self.lb_title.font = [UIFont systemFontOfSize:14];
        self.lb_title.textColor = UIColorFromRGB(0x444444);
        [self addSubview:_lb_title];
        
        [_imgV_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.top.equalTo(self.mas_top).offset(10);
            make.width.equalTo(make.height);
        }];
        
        [_lb_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_imgV_content);
            make.top.equalTo(_imgV_content.mas_bottom).offset(8);
            make.bottom.equalTo(self.mas_bottom).offset(13);
        }];
        
    }
    return self;
}

- (void)setImg_content:(UIImage *)img_content{
    
    _img_content = img_content;
    _imgV_content.image = _img_content;
    
}

- (void)setStr_title:(NSString *)str_title{
    
    _str_title = str_title;
    _lb_title.text = _str_title;

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
