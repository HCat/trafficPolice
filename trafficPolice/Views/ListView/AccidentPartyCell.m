//
//  AccidentPartyCell.m
//  trafficPolice
//
//  Created by hcat on 2017/6/8.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "AccidentPartyCell.h"
#import "YUSegmentedControl.h"
#import <PureLayout.h>


@interface AccidentPartyCell ()

//分段控件，分别为甲方，乙方，丙方
@property (weak, nonatomic) IBOutlet YUSegmentedControl *segmentedControl;

@property (nonatomic,strong) UIView * v_a;
@property (nonatomic,strong) UIView * v_b;
@property (nonatomic,strong) UIView * v_c;


@property (nonatomic,strong) NSMutableArray * arr_lables_a;
@property (nonatomic,strong) NSMutableArray * arr_lables_b;
@property (nonatomic,strong) NSMutableArray * arr_lables_c;

@property(nonatomic,strong) AccidentGetCodesResponse *codes;

@property(nonatomic,assign) NSUInteger indexSelected;

@end


@implementation AccidentPartyCell

- (id)initWithCoder:(NSCoder *)aDecoder{

    if (self = [super initWithCoder:aDecoder]) {
        self.indexSelected = 0;
    }

    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    //配置SegmentedControl分段
    
    self.arr_lables_a = [NSMutableArray array];
    self.arr_lables_b = [NSMutableArray array];
    self.arr_lables_c = [NSMutableArray array];
    
    self.v_a = [UIView newAutoLayoutView];
    self.v_b = [UIView newAutoLayoutView];
    self.v_c = [UIView newAutoLayoutView];
    
    [self setUpSegmentedControl];
    
    
}

- (AccidentGetCodesResponse *)codes{
    
    _codes = [ShareValue sharedDefault].accidentCodes;
    
    return _codes;
    
}



#pragma mark - 配置分段选择控件

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
    
    NSUInteger selectedIndex = _segmentedControl.selectedSegmentIndex;
 
    _indexSelected = selectedIndex;
    
    if (_indexSelected == 0) {
        [self.contentView addSubview:_v_a];
        [_v_a autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTop];
        [_v_a autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_segmentedControl withOffset:15.f];
        
    }else if (_indexSelected == 1){
        [self.contentView addSubview:_v_b];
        [_v_b autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTop];
        [_v_b autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_segmentedControl withOffset:15.f];
    }else if (_indexSelected == 2){
        [self.contentView addSubview:_v_c];
        [_v_c autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTop];
        [_v_c autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_segmentedControl withOffset:15.f];
    }
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}


#pragma mark - set && get 

- (void)setAccident:(AccidentModel *)accident{
    
    if (_accident) {
        return;
    }else{
        _accident = accident;
        if (_accident) {
            
            [self buildPartyA:_accident];
            [self buildPartyB:_accident];
            [self buildPartyC:_accident];
            
        }
    }
}

- (void)buildPartyA:(AccidentModel *)accident{

    if (accident.ptaName) {
        [self buildLableWithTitle:@"姓 名:" AndText:accident.ptaName WithArr:_arr_lables_a inView:_v_a];
    }
    
    if (accident.ptaIdNo) {
        [self buildLableWithTitle:@"身份证号:" AndText:accident.ptaIdNo WithArr:_arr_lables_a inView:_v_a];
    }
    
    if (accident.ptaVehicleId) {
        if (self.codes) {
            NSString * t_str = [self.codes searchNameWithModelId:[accident.ptaVehicleId integerValue] WithArray:self.codes.vehicle];
            [self buildLableWithTitle:@"车辆类型:" AndText:t_str WithArr:_arr_lables_a inView:_v_a];
        }
    }
    
    if (accident.ptaCarNo) {
        [self buildLableWithTitle:@"车牌号码:" AndText:accident.ptaCarNo WithArr:_arr_lables_a inView:_v_a];
    }
    
    if (accident.ptaPhone) {
        [self buildLableWithTitle:@"联系电话:" AndText:accident.ptaPhone WithArr:_arr_lables_a inView:_v_a];
    }
    
    if (accident.ptaDirect) {
        if (self.codes) {
            NSString * t_str = [self.codes searchNameWithModelId:[accident.ptaDirect integerValue] WithArray:self.codes.driverDirect];
            [self buildLableWithTitle:@"行驶状态:" AndText:t_str WithArr:_arr_lables_a inView:_v_a];
        }
    }
    
    if (accident.ptaBehaviourId) {
        if (self.codes) {
            NSString * t_str = [self.codes searchNameWithModelId:[accident.ptaBehaviourId integerValue] WithArray:self.codes.behaviour];
            [self buildLableWithTitle:@"违法行为:" AndText:t_str WithArr:_arr_lables_a inView:_v_a];
        }
    }
    
    if (accident.ptaInsuranceCompanyId) {
        if (self.codes) {
            NSString * t_str = [self.codes searchNameWithModelId:[accident.ptaInsuranceCompanyId integerValue] WithArray:self.codes.insuranceCompany];
            [self buildLableWithTitle:@"保险公司:" AndText:t_str WithArr:_arr_lables_a inView:_v_a];
        }
    }
    
    if (accident.ptaResponsibilityId) {
        if (self.codes) {
            NSString * t_str = [self.codes searchNameWithModelId:[accident.ptaResponsibilityId integerValue] WithArray:self.codes.responsibility];
            [self buildLableWithTitle:@"责 任:" AndText:t_str WithArr:_arr_lables_a inView:_v_a];
        }
    }
    
    [[_arr_lables_a firstObject] autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:13.f];
    [[_arr_lables_a firstObject] autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:13.f];
    UILabel *previousView = nil;
    for (UILabel *view in _arr_lables_a) {
        if (previousView) {
            [view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:previousView withOffset:18.f];
            [view autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:previousView];
        }
        previousView = view;
    }
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    
}


- (void)buildPartyB:(AccidentModel *)accident{
    
    if (accident.ptbName) {
        [self buildLableWithTitle:@"姓 名:" AndText:accident.ptbName WithArr:_arr_lables_b inView:_v_b];
    }
    
    if (accident.ptbIdNo) {
        [self buildLableWithTitle:@"身份证号:" AndText:accident.ptbIdNo WithArr:_arr_lables_b inView:_v_b];
    }
    
    if (accident.ptbVehicleId) {
        if (self.codes) {
            NSString * t_str = [self.codes searchNameWithModelId:[accident.ptbVehicleId integerValue] WithArray:self.codes.vehicle];
            [self buildLableWithTitle:@"车辆类型:" AndText:t_str WithArr:_arr_lables_b inView:_v_b];
        }
    }
    
    if (accident.ptbCarNo) {
        [self buildLableWithTitle:@"车牌号码:" AndText:accident.ptbCarNo WithArr:_arr_lables_b inView:_v_b];
    }
    
    if (accident.ptbPhone) {
        [self buildLableWithTitle:@"联系电话:" AndText:accident.ptbPhone WithArr:_arr_lables_b inView:_v_b];
    }
    
    if (accident.ptbDirect) {
        if (self.codes) {
            NSString * t_str = [self.codes searchNameWithModelId:[accident.ptbDirect integerValue] WithArray:self.codes.driverDirect];
            [self buildLableWithTitle:@"行驶状态:" AndText:t_str WithArr:_arr_lables_b inView:_v_b];
        }
    }
    
    if (accident.ptbBehaviourId) {
        if (self.codes) {
            NSString * t_str = [self.codes searchNameWithModelId:[accident.ptbBehaviourId integerValue] WithArray:self.codes.behaviour];
            [self buildLableWithTitle:@"违法行为:" AndText:t_str WithArr:_arr_lables_b inView:_v_b];
        }
    }
    
    if (accident.ptbInsuranceCompanyId) {
        if (self.codes) {
            NSString * t_str = [self.codes searchNameWithModelId:[accident.ptbInsuranceCompanyId integerValue] WithArray:self.codes.insuranceCompany];
            [self buildLableWithTitle:@"保险公司:" AndText:t_str WithArr:_arr_lables_b inView:_v_b];
        }
    }
    
    if (accident.ptbResponsibilityId) {
        if (self.codes) {
            NSString * t_str = [self.codes searchNameWithModelId:[accident.ptbResponsibilityId integerValue] WithArray:self.codes.responsibility];
            [self buildLableWithTitle:@"责 任:" AndText:t_str WithArr:_arr_lables_b inView:_v_b];
        }
    }
    
    [[_arr_lables_b firstObject] autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:13.f];
    [[_arr_lables_b firstObject] autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:13.f];
    UILabel *previousView = nil;
    for (UILabel *view in _arr_lables_b) {
        if (previousView) {
            [view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:previousView withOffset:18.f];
            [view autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:previousView];
        }
        previousView = view;
    }
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    
}

- (void)buildPartyC:(AccidentModel *)accident{
    
    
    if (accident.ptcName) {
        [self buildLableWithTitle:@"姓 名:" AndText:accident.ptcName WithArr:_arr_lables_c inView:_v_c];
    }
    
    if (accident.ptcIdNo) {
        [self buildLableWithTitle:@"身份证号:" AndText:accident.ptcIdNo WithArr:_arr_lables_c inView:_v_c];
    }
    
    if (accident.ptcVehicleId) {
        if (self.codes) {
            NSString * t_str = [self.codes searchNameWithModelId:[accident.ptcVehicleId integerValue] WithArray:self.codes.vehicle];
            [self buildLableWithTitle:@"车辆类型:" AndText:t_str WithArr:_arr_lables_c inView:_v_c];
        }
    }
    
    if (accident.ptcCarNo) {
        [self buildLableWithTitle:@"车牌号码:" AndText:accident.ptcCarNo WithArr:_arr_lables_c inView:_v_c];
    }
    
    if (accident.ptcPhone) {
        [self buildLableWithTitle:@"联系电话:" AndText:accident.ptcPhone WithArr:_arr_lables_c inView:_v_c];
    }
    
    if (accident.ptcDirect) {
        if (self.codes) {
            NSString * t_str = [self.codes searchNameWithModelId:[accident.ptcDirect integerValue] WithArray:self.codes.driverDirect];
            [self buildLableWithTitle:@"行驶状态:" AndText:t_str WithArr:_arr_lables_c inView:_v_c];
        }
    }
    
    if (accident.ptcBehaviourId) {
        if (self.codes) {
            NSString * t_str = [self.codes searchNameWithModelId:[accident.ptcBehaviourId integerValue] WithArray:self.codes.behaviour];
            [self buildLableWithTitle:@"违法行为:" AndText:t_str WithArr:_arr_lables_c inView:_v_c];
        }
    }
    
    if (accident.ptcInsuranceCompanyId) {
        if (self.codes) {
            NSString * t_str = [self.codes searchNameWithModelId:[accident.ptcInsuranceCompanyId integerValue] WithArray:self.codes.insuranceCompany];
            [self buildLableWithTitle:@"保险公司:" AndText:t_str WithArr:_arr_lables_c inView:_v_c];
        }
    }
    
    if (accident.ptcResponsibilityId) {
        if (self.codes) {
            NSString * t_str = [self.codes searchNameWithModelId:[accident.ptcResponsibilityId integerValue] WithArray:self.codes.responsibility];
            [self buildLableWithTitle:@"责 任:" AndText:t_str WithArr:_arr_lables_c inView:_v_c];
        }
    }
    
    [[_arr_lables_c firstObject] autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:13.f];
    [[_arr_lables_c firstObject] autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:13.f];
    UILabel *previousView = nil;
    for (UILabel *view in _arr_lables_c) {
        if (previousView) {
            [view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:previousView withOffset:18.f];
            [view autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:previousView];
        }
        previousView = view;
    }
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}

- (void)buildLableWithTitle:(NSString *)title AndText:(NSString *)text WithArr:(NSMutableArray *)arr inView:(UIView *)view{
    
    UILabel * t_title = [UILabel newAutoLayoutView];
    t_title.font = [UIFont systemFontOfSize:14.f];
    t_title.textColor = UIColorFromRGB(0x444444);
    t_title.text = title;
    [view addSubview:t_title];
    
    UILabel * t_content = [UILabel newAutoLayoutView];
    t_content.font = [UIFont systemFontOfSize:14.f];
    t_content.textColor = UIColorFromRGB(0x444444);
    t_content.text = text;
    [view addSubview:t_content];
    
    [t_content autoAlignAxis:ALAxisHorizontal toSameAxisOfView:t_title ];
    [t_content autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:t_title withOffset:20.f];
    
    [arr addObject:t_title];
}


#pragma mark - 分段控件选中之后的处理

- (void)segmentedControlTapped:(YUSegmentedControl *)sender {
    
    NSUInteger selectedIndex = _segmentedControl.selectedSegmentIndex;
    LxDBAnyVar(selectedIndex);
    if (_indexSelected != selectedIndex) {
        if (_indexSelected == 0) {
            [_v_a removeFromSuperview];
        }else if (_indexSelected == 1){
            [_v_b removeFromSuperview];
        }else if (_indexSelected == 2){
            [_v_c removeFromSuperview];
        }
        
        if (selectedIndex == 0) {
            [self.contentView addSubview:_v_a];
            [_v_a autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTop];
            [_v_a autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_segmentedControl withOffset:15.f];
            
        }else if (selectedIndex == 1){
            [self.contentView addSubview:_v_b];
            [_v_b autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTop];
            [_v_b autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_segmentedControl withOffset:15.f];
        }else if (selectedIndex == 2){
            [self.contentView addSubview:_v_c];
            [_v_c autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTop];
            [_v_c autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_segmentedControl withOffset:15.f];
        }
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
        
        _indexSelected = selectedIndex;
        if (self.block) {
            self.block();
        }
    }

}

#pragma mark - publicMethods

- (float)heightWithAccident{
    
    if (_indexSelected == 0) {
        
        if (_arr_lables_a && _arr_lables_a.count > 0) {
            
            UILabel *t_lb = (UILabel *)_arr_lables_a[0];
            
            return 84 + 15 + 13 + _arr_lables_a.count * (t_lb.frame.size.height + 18);
        }
        
    }else if (_indexSelected == 1){
        
        if (_arr_lables_b && _arr_lables_b.count > 0) {
            
            UILabel *t_lb = (UILabel *)_arr_lables_b[0];
            
            return 84 + 15 + 13 + _arr_lables_b.count * (t_lb.frame.size.height + 18);
        }
    }else if (_indexSelected == 2){
        
        if (_arr_lables_c && _arr_lables_c.count > 0) {
            
            UILabel *t_lb = (UILabel *)_arr_lables_c[0];
            
            return 84 + 15 + 13 + _arr_lables_c.count * (t_lb.frame.size.height + 18);
        }

    }
    return 84;
}



#pragma mark -

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
