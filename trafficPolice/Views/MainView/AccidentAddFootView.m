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
#import "BottomView.h"
#import "BottomPickerView.h"

@interface AccidentAddFootView()

@property (weak, nonatomic) IBOutlet YUSegmentedControl *segmentedControl;


@property (weak, nonatomic) IBOutlet UIButton *btn_moreAccidentInfo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_accidentInfo;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lb_moreAccidentInfos;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *v_moreAccidentInfos;

@property (weak, nonatomic) IBOutlet UIButton *btn_moreInfo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_moreinfo;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lb_moreInfos;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btn_moreInfos;



//当事人信息里面用到的textField
@property (weak, nonatomic) IBOutlet UITextField *tf_name;
@property (weak, nonatomic) IBOutlet UITextField *tf_identityCard;
@property (weak, nonatomic) IBOutlet UITextField *tf_carType;
@property (weak, nonatomic) IBOutlet UITextField *tf_carNumber;
@property (weak, nonatomic) IBOutlet UITextField *tf_phone;
@property (weak, nonatomic) IBOutlet UITextField *tf_drivingState;
@property (weak, nonatomic) IBOutlet UITextField *tf_illegalBehavior;
@property (weak, nonatomic) IBOutlet UITextField *tf_insuranceCompany;
@property (weak, nonatomic) IBOutlet UITextField *tf_responsibility;

@property (weak, nonatomic) IBOutlet UIButton *btn_temporaryCar;
@property (weak, nonatomic) IBOutlet UIButton *btn_temporaryDrivelib;
@property (weak, nonatomic) IBOutlet UIButton *btn_temporarylib;
@property (weak, nonatomic) IBOutlet UIButton *btn_temporaryIdentityCard;

@property (weak, nonatomic) IBOutlet UITextView *tv_describe;



@end

@implementation AccidentAddFootView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
    self.param = [[AccidentSaveParam alloc] init];
    self.isShowMoreInfo = YES;
    self.isShowMoreAccidentInfo = YES;
    
}

#pragma mark - setUp

- (void)setUp{
    
    self.btn_moreInfo.isIgnore = YES;
    self.btn_moreAccidentInfo.isIgnore = YES;

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"更多信息"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFF8B33) range:strRange];  //设置颜色
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [self.btn_moreAccidentInfo setAttributedTitle:str forState:UIControlStateNormal];
    [self.btn_moreInfo setAttributedTitle:str forState:UIControlStateNormal];

    [self setUpSegmentedControl];
}


#pragma mark - set && get 

- (void)setIsShowMoreInfo:(BOOL)isShowMoreInfo{

    _isShowMoreInfo = isShowMoreInfo;
    
    if (_isShowMoreInfo) {
        for (UILabel *t_label in _lb_moreInfos) {
            t_label.hidden = YES;
        }
        for (UIButton *t_btn in _btn_moreInfos) {
            t_btn.hidden = YES;
        }
        _layout_moreinfo.constant = 34.f;
        [self layoutIfNeeded];
        
    }else{
        for (UILabel *t_label in _lb_moreInfos) {
            t_label.hidden = NO;
        }
        for (UIButton *t_btn in _btn_moreInfos) {
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

/*************** 事故信息的更多信息按钮点击 ***************/

- (IBAction)handleBtnMoreAccidentInfoClicked:(id)sender {
    self.isShowMoreAccidentInfo = !_isShowMoreAccidentInfo;
}

/*************** 当事人信息的更多信息按钮点击 ***************/

- (IBAction)handleBtnMoreInfoClicked:(id)sender {
    self.isShowMoreInfo = !_isShowMoreInfo;
}

/*************** 姓名识别按钮点击 ***************/

- (IBAction)handleBtnNameIdentifyClicked:(id)sender {
    
    
}

/*************** 车牌号码识别按钮点击 ***************/

- (IBAction)handleBtnPlateNumberClicked:(id)sender {
    
    
}

/*************** 重新定位按钮点击 ***************/

- (IBAction)handleBtnLocationClicked:(id)sender {
    
    
}

/*************** 事故成因按钮点击 ***************/

- (IBAction)handleBtnAccidentCausesClicked:(id)sender {
    
    
}

/*************** 所在位置按钮点击 ***************/

- (IBAction)handleBtnChoiceLocationClicked:(id)sender {
    
    
}

/*************** 受伤人数按钮点击 ***************/

- (IBAction)handleBtnInjuryNumberClicked:(id)sender {
    
    
}

/*************** 道路类型按钮点击 ***************/

- (IBAction)handleBtnRoadTypeClicked:(id)sender {
    
    
}

/*************** 车辆类型按钮点击 ***************/

- (IBAction)handleBtnCarTypeClicked:(id)sender {
    BottomPickerView *t_view = [BottomPickerView initCustomView];
    [t_view setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 207)];
    t_view.pickerTitle = @"车辆类型";
    
    WS(weakSelf);
    t_view.items = [ShareValue sharedDefault].accidentCodes.vehicle;
    t_view.selectedAccidentBtnBlock = ^(NSString *title, NSInteger itemId, NSInteger itemType) {
        SW(strongSelf, weakSelf);
        strongSelf.tf_carType.text = title;
        NSUInteger selectedIndex = strongSelf.segmentedControl.selectedSegmentIndex;
        switch (selectedIndex) {
            case 0:
                strongSelf.param.ptaVehicleId = itemId;
                break;
            case 1:
                strongSelf.param.ptbVehicleId = itemId;
                break;
            case 2:
                strongSelf.param.ptbVehicleId = itemId;
                break;
                
            default:
                break;
        }
        
        
        [BottomView dismissWindow];
    };
    
    [BottomView showWindowWithBottomView:t_view];

}

/*************** 行驶状态按钮点击 ***************/

- (IBAction)handleBtnTrafficStateClicked:(id)sender {
    
    
}

/*************** 违法行为按钮点击 ***************/

- (IBAction)handleBtnIllegalBehaviorClicked:(id)sender {
    
    
}

/*************** 保险公司按钮点击 ***************/

- (IBAction)handleBtnInsuranceCompanyClicked:(id)sender {
    
    
}


/*************** 责任按钮点击 ***************/

- (IBAction)handleBtnResponsibilityClicked:(id)sender {
    
    
}

/*************** 是否暂扣车辆按钮点击 ***************/
- (IBAction)handleBtnTemporaryCarClicked:(id)sender {
    _btn_temporaryCar.selected = !_btn_temporaryCar.selected;
    
    
    
}


/*************** 是否暂扣行驶证按钮点击 ***************/

- (IBAction)handleBtnTemporaryDrivingLicenseClicked:(id)sender {
    _btn_temporaryDrivelib.selected = !_btn_temporaryDrivelib.selected;
    
    
    
}

/*************** 是否暂扣驾驶证按钮点击 ***************/

- (IBAction)handleBtnTemporaryLicenseClicked:(id)sender {
    _btn_temporarylib.selected = !_btn_temporarylib.selected;
    
    
    
}

/*************** 是否暂扣身份证按钮点击 ***************/

- (IBAction)handleBtnIdentityCardClicked:(id)sender {
    _btn_temporaryIdentityCard.selected = !_btn_temporaryIdentityCard.selected;
    
    
    
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
    //无语的接口,待优化
    if (selectedIndex == 0) {
        self.tf_name.text = self.param.ptaName;
        self.tf_identityCard.text = self.param.ptaIdNo;
        
        if (self.param.ptaVehicleId) {
            NSString*t_str = [[ShareValue sharedDefault].accidentCodes searchNameWithModelId:self.param.ptaVehicleId WithArray:[ShareValue sharedDefault].accidentCodes.vehicle];
            self.tf_carType.text = t_str;
        }else{
            self.tf_carType.text = nil;
        }
       
        self.tf_carNumber.text = self.param.ptaCarNo;
        self.tf_phone.text = self.param.ptaIdNo;
        
        if (self.param.ptaDirect) {
            NSString*t_str = [[ShareValue sharedDefault].accidentCodes searchNameWithModelType:self.param.ptaDirect WithArray:[ShareValue sharedDefault].accidentCodes.driverDirect];
            self.tf_drivingState.text = t_str;
        }else{
            self.tf_drivingState.text = nil;
        }
        if (self.param.ptaBehaviourId) {
            NSString*t_str = [[ShareValue sharedDefault].accidentCodes searchNameWithModelId:self.param.ptaBehaviourId WithArray:[ShareValue sharedDefault].accidentCodes.behaviour];
            self.tf_illegalBehavior.text = t_str;
        }else{
            self.tf_illegalBehavior.text = nil;
        }
        if (self.param.ptaInsuranceCompanyId) {
            NSString*t_str = [[ShareValue sharedDefault].accidentCodes searchNameWithModelId:self.param.ptaInsuranceCompanyId WithArray:[ShareValue sharedDefault].accidentCodes.insuranceCompany];
            self.tf_insuranceCompany.text = t_str;
        }else{
            self.tf_insuranceCompany.text = nil;
        }
        if (self.param.ptaResponsibilityId) {
            NSString*t_str = [[ShareValue sharedDefault].accidentCodes searchNameWithModelId:self.param.ptaResponsibilityId WithArray:[ShareValue sharedDefault].accidentCodes.responsibility];
            self.tf_responsibility.text = t_str;
        }else{
            self.tf_responsibility.text = nil;
        }

        self.btn_temporaryCar.selected = self.param.ptaIsZkCl;
        self.btn_temporaryDrivelib.selected = self.param.ptaIsZkXsz;
        self.btn_temporarylib.selected = self.param.ptaIsZkJsz;
        self.btn_temporarylib.selected = self.param.ptaIsZkSfz;
        self.tv_describe.text = self.param.ptaDescribe;
        
    }else if (selectedIndex == 1){
        
        self.tf_name.text = self.param.ptcName;
        self.tf_identityCard.text = self.param.ptbIdNo;
        
        if (self.param.ptbVehicleId) {
            NSString*t_str = [[ShareValue sharedDefault].accidentCodes searchNameWithModelId:self.param.ptbVehicleId WithArray:[ShareValue sharedDefault].accidentCodes.vehicle];
            self.tf_carType.text = t_str;
        }else{
            self.tf_carType.text = nil;
        }
        
        self.tf_carNumber.text = self.param.ptbCarNo;
        self.tf_phone.text = self.param.ptbIdNo;
        
        if (self.param.ptbDirect) {
            NSString*t_str = [[ShareValue sharedDefault].accidentCodes searchNameWithModelType:self.param.ptbDirect WithArray:[ShareValue sharedDefault].accidentCodes.driverDirect];
            self.tf_drivingState.text = t_str;
        }else{
            self.tf_drivingState.text = nil;
        }
        if (self.param.ptbBehaviourId) {
            NSString*t_str = [[ShareValue sharedDefault].accidentCodes searchNameWithModelId:self.param.ptbBehaviourId WithArray:[ShareValue sharedDefault].accidentCodes.behaviour];
            self.tf_illegalBehavior.text = t_str;
        }else{
            self.tf_illegalBehavior.text = nil;
        }
        if (self.param.ptbInsuranceCompanyId) {
            NSString*t_str = [[ShareValue sharedDefault].accidentCodes searchNameWithModelId:self.param.ptbInsuranceCompanyId WithArray:[ShareValue sharedDefault].accidentCodes.insuranceCompany];
            self.tf_insuranceCompany.text = t_str;
        }else{
            self.tf_insuranceCompany.text = nil;
        }
        if (self.param.ptbResponsibilityId) {
            NSString*t_str = [[ShareValue sharedDefault].accidentCodes searchNameWithModelId:self.param.ptbResponsibilityId WithArray:[ShareValue sharedDefault].accidentCodes.responsibility];
            self.tf_responsibility.text = t_str;
        }else{
            self.tf_responsibility.text = nil;
        }
        
        self.btn_temporaryCar.selected = self.param.ptbIsZkCl;
        self.btn_temporaryDrivelib.selected = self.param.ptbIsZkXsz;
        self.btn_temporarylib.selected = self.param.ptbIsZkJsz;
        self.btn_temporarylib.selected = self.param.ptbIsZkSfz;
        self.tv_describe.text = self.param.ptbDescribe;
        
    }else if (selectedIndex == 2){
    
        self.tf_name.text = self.param.ptcName;
        self.tf_identityCard.text = self.param.ptcIdNo;
        
        if (self.param.ptcVehicleId) {
            NSString*t_str = [[ShareValue sharedDefault].accidentCodes searchNameWithModelId:self.param.ptcVehicleId WithArray:[ShareValue sharedDefault].accidentCodes.vehicle];
            self.tf_carType.text = t_str;
        }else{
            self.tf_carType.text = nil;
        }
        
        self.tf_carNumber.text = self.param.ptcCarNo;
        self.tf_phone.text = self.param.ptcIdNo;
        
        if (self.param.ptcDirect) {
            NSString*t_str = [[ShareValue sharedDefault].accidentCodes searchNameWithModelType:self.param.ptcDirect WithArray:[ShareValue sharedDefault].accidentCodes.driverDirect];
            self.tf_drivingState.text = t_str;
        }else{
            self.tf_drivingState.text = nil;
        }
        if (self.param.ptcBehaviourId) {
            NSString*t_str = [[ShareValue sharedDefault].accidentCodes searchNameWithModelId:self.param.ptcBehaviourId WithArray:[ShareValue sharedDefault].accidentCodes.behaviour];
            self.tf_illegalBehavior.text = t_str;
        }else{
            self.tf_illegalBehavior.text = nil;
        }
        if (self.param.ptcInsuranceCompanyId) {
            NSString*t_str = [[ShareValue sharedDefault].accidentCodes searchNameWithModelId:self.param.ptcInsuranceCompanyId WithArray:[ShareValue sharedDefault].accidentCodes.insuranceCompany];
            self.tf_insuranceCompany.text = t_str;
        }else{
            self.tf_insuranceCompany.text = nil;
        }
        if (self.param.ptcResponsibilityId) {
            NSString*t_str = [[ShareValue sharedDefault].accidentCodes searchNameWithModelId:self.param.ptcResponsibilityId WithArray:[ShareValue sharedDefault].accidentCodes.responsibility];
            self.tf_responsibility.text = t_str;
        }else{
            self.tf_responsibility.text = nil;
        }
        
        self.btn_temporaryCar.selected = self.param.ptcIsZkCl;
        self.btn_temporaryDrivelib.selected = self.param.ptcIsZkXsz;
        self.btn_temporarylib.selected = self.param.ptcIsZkJsz;
        self.btn_temporarylib.selected = self.param.ptcIsZkSfz;
        self.tv_describe.text = self.param.ptcDescribe;

    }
    
}

@end
