//
//  MessageCell.m
//  trafficPolice
//
//  Created by hcat on 2017/7/7.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "MessageCell.h"
#import "ShareFun.h"
#import "IdentifyAPI.h"

@interface MessageCell()

@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@property (weak, nonatomic) IBOutlet UILabel *lb_content;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_label;

@property (weak, nonatomic) IBOutlet UIButton *btn_commit;

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
        
        if ([_model.type isEqualToNumber:@2]) {
            
            if ([_model.flag isEqualToNumber:@0]) {
                _btn_commit.hidden = NO;
                _layout_label.constant = 75.f;
                [self setNeedsLayout];
                
            }else{
                _btn_commit.hidden = YES;
                _layout_label.constant = 25.f;
                [self setNeedsLayout];
            }
        }else{
            
            _btn_commit.hidden = YES;
            _layout_label.constant = 25.f;
            [self setNeedsLayout];

        }
    
    }
    
}

- (IBAction)handleBtnCommitClicked:(id)sender {
    
    if ([_model.type isEqualToNumber:@2]) {
        
        if ([_model.flag isEqualToNumber:@0]) {
            
            IdentifySetMsgReadManger *manger = [[IdentifySetMsgReadManger alloc] init];
            manger.msgId = _model.msgId;
            manger.isNeedShowHud = NO;
            ShowHUD *hud = [ShowHUD showWhiteLoadingWithText:@"确认中..." inView:[[UIApplication sharedApplication] keyWindow] config:nil];
            
            WS(weakSelf);
            [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                SW(strongSelf, weakSelf);
                [hud hide];
                if (manger.responseModel.code == CODE_SUCCESS) {
                    strongSelf.model.flag = @1;
                    [strongSelf.tableView reloadData];
                }
        
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                [hud hide];
            }];
        }
        
    }
    
}



@end
