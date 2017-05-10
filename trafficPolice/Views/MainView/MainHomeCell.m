//
//  MainHomeCell.m
//  trafficPolice
//
//  Created by Binrong Liu on 2017/5/10.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "MainHomeCell.h"
#import "MainCellButton.h"

@interface MainHomeCell()

@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet MainCellButton *btn_first;
@property (weak, nonatomic) IBOutlet MainCellButton *btn_second;


@end


@implementation MainHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _btn_first.rippleLineWidth = 1;
    _btn_first.rippleColor = [UIColor redColor];
    _btn_second.rippleLineWidth = 1;
    _btn_second.rippleColor = [UIColor redColor];
    
    // Initialization code
}

- (void)createCell:(NSString *)title withItems:(NSArray *)arr_item{

    _lb_title.text = title;
    
    if (!arr_item && arr_item.count ==0) {
        return;
    }else{
    
        if (arr_item.count == 1) {
            NSDictionary *t_dic = arr_item.lastObject;
            if (!t_dic) {
                _btn_first.img_content = [t_dic objectForKey:@"image"];
                _btn_first.str_title = [t_dic objectForKey:@"title"];
                WS(weakSelf)
                _btn_first.rippleBlock = ^(){
                    
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(itemClickInCell:withIndex:)]) {
                        [weakSelf.delegate itemClickInCell:weakSelf withIndex:0];
                    }
                
                };
                
            }
            
        }else{
        
            NSDictionary *t_dic = arr_item.firstObject;
            if (!t_dic) {
                _btn_first.img_content = [t_dic objectForKey:@"image"];
                _btn_first.str_title = [t_dic objectForKey:@"title"];
                WS(weakSelf)
                _btn_first.rippleBlock = ^(){
                    
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(itemClickInCell:withIndex:)]) {
                        [weakSelf.delegate itemClickInCell:weakSelf withIndex:0];
                    }
                    
                };
                
            }
            
            t_dic = arr_item.lastObject;
            if (!t_dic) {
                _btn_second.img_content = [t_dic objectForKey:@"image"];
                _btn_second.str_title = [t_dic objectForKey:@"title"];
                WS(weakSelf)
                _btn_second.rippleBlock = ^(){
                    
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(itemClickInCell:withIndex:)]) {
                        [weakSelf.delegate itemClickInCell:weakSelf withIndex:0];
                    }
                    
                };
                
            }
            
        }
        
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
