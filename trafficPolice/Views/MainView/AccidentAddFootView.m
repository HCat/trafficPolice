//
//  AccidentAddFootView.m
//  trafficPolice
//
//  Created by hcat on 2017/5/23.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "AccidentAddFootView.h"
#import "YUSegment.h"
#import "UIButton+NoRepeatClick.h"

@interface AccidentAddFootView()

@property (weak, nonatomic) IBOutlet YUSegmentedControl *segmentedControl;


@property (weak, nonatomic) IBOutlet UIButton *btn_moreAccidentInformation;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_accidentInfo;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lb_moreAccidentInfos;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *v_moreAccidentInfos;


@property (weak, nonatomic) IBOutlet UIButton *btn_information;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_moreinfo;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lb_moreInfo;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btn_moreInfo;




@end

@implementation AccidentAddFootView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpSegmentedControl];
    self.btn_information.isIgnore = YES;
    self.btn_moreAccidentInformation.isIgnore = YES;
    self.isShowMoreInfo = YES;
    self.isShowMoreAccidentInfo = YES;
}


#pragma mark - set && get 

- (void)setIsShowMoreInfo:(BOOL)isShowMoreInfo{

    _isShowMoreInfo = isShowMoreInfo;
    
    if (_isShowMoreInfo) {
        for (UILabel *t_label in _lb_moreInfo) {
            t_label.hidden = YES;
        }
        for (UIButton *t_btn in _btn_moreInfo) {
            t_btn.hidden = YES;
        }
        _layout_moreinfo.constant = 34.f;
        [self layoutIfNeeded];
        
    }else{
        for (UILabel *t_label in _lb_moreInfo) {
            t_label.hidden = NO;
        }
        for (UIButton *t_btn in _btn_moreInfo) {
            t_btn.hidden = NO;
        }
        _layout_moreinfo.constant = 158.f;
        [self layoutIfNeeded];
    }
    
}


- (void)setIsShowMoreAccidentInfo:(BOOL)isShowMoreAccidentInfo{
    
    _isShowMoreAccidentInfo = isShowMoreAccidentInfo;
    
    if (_isShowMoreAccidentInfo) {
        for (UILabel *t_label in _lb_moreAccidentInfos) {
            t_label.hidden = YES;
        }
        for (UIView *t_v in _v_moreAccidentInfos) {
            t_v.hidden = YES;
        }
        _layout_accidentInfo.constant = 20.f;
        [self layoutIfNeeded];
        
    }else{
        for (UILabel *t_label in _lb_moreAccidentInfos) {
            t_label.hidden = NO;
        }
        for (UIView *t_v in _v_moreAccidentInfos) {
            t_v.hidden = NO;
        }
        _layout_accidentInfo.constant = 108.f;
        [self layoutIfNeeded];
    }
    
}


#pragma mark - btnActions
- (IBAction)handleBtnAccidentInformation:(id)sender {
    self.isShowMoreAccidentInfo = !_isShowMoreAccidentInfo;
    
}

- (IBAction)handleBtnInformationClick:(id)sender {
    self.isShowMoreInfo = !_isShowMoreInfo;
    
}



#pragma mark - setUpsegmentedControl

-(void)setUpSegmentedControl{

    [_segmentedControl setUpWithTitles:@[@"甲方",@"乙方",@"丙方"]];
    [_segmentedControl setTextAttributes:@{
                                           NSFontAttributeName: [UIFont systemFontOfSize:14.0 weight:UIFontWeightLight],
                                           NSForegroundColorAttributeName: UIColorFromRGB(0x444444)
                                           } forState:YUSegmentedControlStateNormal];
    [_segmentedControl setTextAttributes:@{
                                           NSFontAttributeName: [UIFont systemFontOfSize:14.0 weight:UIFontWeightLight],
                                           NSForegroundColorAttributeName: UIColorFromRGB(0x4281e8)
                                           } forState:YUSegmentedControlStateSelected];
    _segmentedControl.indicator.backgroundColor = UIColorFromRGB(0x4281e8);
    [_segmentedControl addTarget:self action:@selector(segmentedControlTapped:) forControlEvents:UIControlEventValueChanged];
    [_segmentedControl setBackgroundColor:UIColorFromRGB(0xf6f6f6)];
    _segmentedControl.showsVerticalDivider = YES;
    _segmentedControl.showsTopSeparator = NO;
    _segmentedControl.showsBottomSeparator = NO;

}


#pragma mark - segmentedControlTapped

- (void)segmentedControlTapped:(YUSegmentedControl *)sender {
    
   NSUInteger selectedIndex = _segmentedControl.selectedSegmentIndex;
    LxDBAnyVar(selectedIndex);
}

@end
