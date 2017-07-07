//
//  MessageCell.m
//  trafficPolice
//
//  Created by hcat on 2017/7/7.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "MessageCell.h"
#import "ShareFun.h"

@interface MessageCell()

@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@property (weak, nonatomic) IBOutlet UILabel *lb_content;

@end


@implementation MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(IdentifyModel *)model{

    _model = model;
    
    if (_model) {
        _lb_time.text = [ShareFun timeWithTimeInterval:_model.createTime];
        self.lb_content.text = _model.content;
        
    }
    
}


@end
