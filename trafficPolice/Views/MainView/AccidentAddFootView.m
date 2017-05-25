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
#import "FSTextView.h"
#import "ShareFun.h"
#import "CommonAPI.h"
#import "LRCameraVC.h"
#import "AccidentVC.h"


@interface AccidentAddFootView()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet YUSegmentedControl *segmentedControl;


@property (weak, nonatomic) IBOutlet UIButton *btn_moreAccidentInfo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_accidentInfo;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lb_moreAccidentInfos;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *v_moreAccidentInfos;

@property (weak, nonatomic) IBOutlet UIButton *btn_moreInfo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_moreinfo;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lb_moreInfos;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btn_moreInfos;

//事故信息里面用到的textField
@property (weak, nonatomic) IBOutlet UITextField *tf_accidentCauses;    //事故成因
@property (weak, nonatomic) IBOutlet UITextField *tf_accidentTime;      //事故时间(必填)
@property (weak, nonatomic) IBOutlet UITextField *tf_location;          //所在位置(必填)
@property (weak, nonatomic) IBOutlet UITextField *tf_accidentAddress;   //事故地址(必填)
@property (weak, nonatomic) IBOutlet UITextField *tf_weather;           //天气情况
@property (weak, nonatomic) IBOutlet UITextField *tf_injuriesNumber;    //受伤人数
@property (weak, nonatomic) IBOutlet UITextField *tf_roadType;          //道路类型



//当事人信息里面用到的textField
@property (weak, nonatomic) IBOutlet UITextField *tf_name;              //姓名(甲方必填)
@property (weak, nonatomic) IBOutlet UITextField *tf_identityCard;      //身份证号(甲方必填)
@property (weak, nonatomic) IBOutlet UITextField *tf_carType;           //汽车类型(甲方必填)
@property (weak, nonatomic) IBOutlet UITextField *tf_carNumber;         //车牌号码(甲方必填)
@property (weak, nonatomic) IBOutlet UITextField *tf_phone;             //电话号码(甲方必填)
@property (weak, nonatomic) IBOutlet UITextField *tf_drivingState;      //行驶状态
@property (weak, nonatomic) IBOutlet UITextField *tf_illegalBehavior;   //违法行为
@property (weak, nonatomic) IBOutlet UITextField *tf_insuranceCompany;  //保险公司
@property (weak, nonatomic) IBOutlet UITextField *tf_responsibility;    //责任

@property (weak, nonatomic) IBOutlet UIButton *btn_temporaryCar;
@property (weak, nonatomic) IBOutlet UIButton *btn_temporaryDrivelib;
@property (weak, nonatomic) IBOutlet UIButton *btn_temporarylib;
@property (weak, nonatomic) IBOutlet UIButton *btn_temporaryIdentityCard;

@property (weak, nonatomic) IBOutlet FSTextView *tv_describe;
@property (weak, nonatomic) IBOutlet UILabel *lb_textCount;


@end

@implementation AccidentAddFootView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
    self.param = [[AccidentSaveParam alloc] init];
    self.isShowMoreInfo = YES;
    self.isShowMoreAccidentInfo = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChange) name:NOTIFICATION_CHANGELOCATION_SUCCESS object:nil];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getServerData];
    });
    
    
    [[LocationHelper sharedDefault] startLocation];
    _tf_accidentTime.text = [ShareFun getCurrentTime];
}

#pragma mark - setUp

- (void)setUp{
    
    //设置btn可以连续点击，这里这样写是因为有method+swizzing的分类中定义了不可重复点击btn,设置isIgnore忽略点击
    //详情请查看UIButton+NoRepeatClick
    
    self.btn_moreInfo.isIgnore = YES;
    self.btn_moreAccidentInfo.isIgnore = YES;
    
    //设置更多设置下划线，直接设置不想用别人的子类，可以说我懒，觉得没有必要
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"更多信息"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFF8B33) range:strRange];  //设置颜色
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [self.btn_moreAccidentInfo setAttributedTitle:str forState:UIControlStateNormal];
    [self.btn_moreInfo setAttributedTitle:str forState:UIControlStateNormal];
    
    //配置SegmentedControl分段
    [self setUpSegmentedControl];
    
    //事故信息里面用到的textField
    [self addChangeForEventEditingChanged:self.tf_accidentTime];
    [self addChangeForEventEditingChanged:self.tf_accidentAddress];
    [self addChangeForEventEditingChanged:self.tf_weather];
    
    //当事人信息里面用到的textField
    [self addChangeForEventEditingChanged:self.tf_name];
    [self addChangeForEventEditingChanged:self.tf_identityCard];
    [self addChangeForEventEditingChanged:self.tf_carNumber];
    [self addChangeForEventEditingChanged:self.tf_phone];
    
    [self.tv_describe setDelegate:(id<UITextViewDelegate> _Nullable)self];
    self.tv_describe.placeholder = @"请输入简述";
    // 限制输入最大字符数.
    self.tv_describe.maxLength = 150;
    // 添加输入改变Block回调.
    WS(weakSelf);
    
    [self.tv_describe addTextDidChangeHandler:^(FSTextView *textView) {
        // 文本改变后的相应操作.
        weakSelf.lb_textCount.text =
        [NSString stringWithFormat:@"%d/%d",textView.text.length,textView.maxLength];
        
    }];
    // 添加到达最大限制Block回调.
    [self.tv_describe addTextLengthDidMaxHandler:^(FSTextView *textView) {
        // 达到最大限制数后的相应操作.
    }];
    
}

#pragma mark - 数据请求部分

- (void) getServerData{
    
    [ShareFun getAccidentCodes];
    
    WS(weakSelf);
    CommonGetWeatherManger *manger = [CommonGetWeatherManger new];
    manger.location = [[NSString stringWithFormat:@"%f,%f",[LocationHelper sharedDefault].longitude,[LocationHelper sharedDefault].latitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    manger.isNeedShowHud = NO;
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {
            strongSelf.tf_weather.text = manger.weather;
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];

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
    
    AccidentVC *t_vc = (AccidentVC *)[ShareFun findViewController:self];
    LRCameraVC *homec = [[LRCameraVC alloc] init];
    homec.fininshcapture = ^(UIImage *image) {
        if (image) {
            NSData * imageData = UIImageJPEGRepresentation(image,1);
            NSInteger length = [imageData length]/1000;
            LxPrintf(@"%dKB",length);
            NSLog(@"照片存在");
            
        }
    };
    [t_vc presentViewController:homec
                         animated:NO
                       completion:^{
                       }];
    
}

/*************** 车牌号码识别按钮点击 ***************/

- (IBAction)handleBtnPlateNumberClicked:(id)sender {
    
    
}

/*************** 重新定位按钮点击 ***************/

- (IBAction)handleBtnLocationClicked:(id)sender {
    
    [[LocationHelper sharedDefault] startLocation];
    
}

/*************** 事故成因按钮点击 ***************/

- (IBAction)handleBtnAccidentCausesClicked:(id)sender {
    WS(weakSelf);
    
    [self showBottomPickViewWithTitle:@"事故成因" items:[ShareValue sharedDefault].accidentCodes.behaviour block:^(NSString *title, NSInteger itemId, NSInteger itemType) {
        
        SW(strongSelf, weakSelf);
        strongSelf.tf_accidentCauses.text = title;
        strongSelf.param.causesType  = itemId;
        
        [BottomView dismissWindow];
        
    }];
    
}

/*************** 所在位置按钮点击 ***************/

- (IBAction)handleBtnChoiceLocationClicked:(id)sender {
    
    
}

/*************** 受伤人数按钮点击 ***************/

- (IBAction)handleBtnInjuryNumberClicked:(id)sender {
    WS(weakSelf);
    
    NSArray *items = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    BottomPickerView *t_view = [BottomPickerView initCustomView];
    [t_view setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 207)];
    t_view.pickerTitle = @"受伤人数";
    t_view.items = items;
    t_view.selectedBtnBlock = ^(NSArray *items, NSInteger index) {
        SW(strongSelf, weakSelf);
        NSString * number = items[index];
        strongSelf.tf_injuriesNumber.text = number;
        strongSelf.param.injuredNum  = number;
        
        [BottomView dismissWindow];
    };
    
    [BottomView showWindowWithBottomView:t_view];
    
}

/*************** 道路类型按钮点击 ***************/

- (IBAction)handleBtnRoadTypeClicked:(id)sender {
    
    WS(weakSelf);
    
    [self showBottomPickViewWithTitle:@"道路类型" items:[ShareValue sharedDefault].accidentCodes.roadType block:^(NSString *title, NSInteger itemId, NSInteger itemType) {
        
        SW(strongSelf, weakSelf);
        strongSelf.tf_roadType.text = title;
        strongSelf.param.roadType  = itemId;
    
        [BottomView dismissWindow];
        
    }];
    
    
}

/*************** 车辆类型按钮点击 ***************/

- (IBAction)handleBtnCarTypeClicked:(id)sender {
    
    WS(weakSelf);
    
    [self showBottomPickViewWithTitle:@"车辆类型" items:[ShareValue sharedDefault].accidentCodes.vehicle block:^(NSString *title, NSInteger itemId, NSInteger itemType) {
        
        SW(strongSelf, weakSelf);
        strongSelf.tf_carType.text = title;
        NSUInteger selectedIndex = strongSelf.segmentedControl.selectedSegmentIndex;
        switch (selectedIndex) {
            case 0:
                strongSelf.param.ptaVehicleId  = itemId;
                break;
            case 1:
                strongSelf.param.ptbVehicleId  = itemId;
                break;
            case 2:
                strongSelf.param.ptbVehicleId  = itemId;
                break;
                
            default:
                break;
        }
        
        
        [BottomView dismissWindow];

    }];

}

/*************** 行驶状态按钮点击 ***************/

- (IBAction)handleBtnTrafficStateClicked:(id)sender {
    
    WS(weakSelf);
    
    [self showBottomPickViewWithTitle:@"行驶状态" items:[ShareValue sharedDefault].accidentCodes.driverDirect block:^(NSString *title, NSInteger itemId, NSInteger itemType) {
        
        SW(strongSelf, weakSelf);
        strongSelf.tf_drivingState.text = title;
        NSUInteger selectedIndex = strongSelf.segmentedControl.selectedSegmentIndex;
        switch (selectedIndex) {
            case 0:
                strongSelf.param.ptaDirect  = itemId;
                break;
            case 1:
                strongSelf.param.ptbDirect  = itemId;
                break;
            case 2:
                strongSelf.param.ptcDirect  = itemId;
                break;
                
            default:
                break;
        }
        
        
        [BottomView dismissWindow];
        
    }];

}

/*************** 违法行为按钮点击 ***************/

- (IBAction)handleBtnIllegalBehaviorClicked:(id)sender {
    WS(weakSelf);
    
    [self showBottomPickViewWithTitle:@"违法行为" items:[ShareValue sharedDefault].accidentCodes.behaviour block:^(NSString *title, NSInteger itemId, NSInteger itemType) {
        
        SW(strongSelf, weakSelf);
        strongSelf.tf_illegalBehavior.text = title;
        NSUInteger selectedIndex = strongSelf.segmentedControl.selectedSegmentIndex;
        switch (selectedIndex) {
            case 0:
                strongSelf.param.ptaBehaviourId  = itemId;
                break;
            case 1:
                strongSelf.param.ptbBehaviourId  = itemId;
                break;
            case 2:
                strongSelf.param.ptcBehaviourId  = itemId;
                break;
                
            default:
                break;
        }
        
        
        [BottomView dismissWindow];
        
    }];
    
}

/*************** 保险公司按钮点击 ***************/

- (IBAction)handleBtnInsuranceCompanyClicked:(id)sender {
    WS(weakSelf);
    
    [self showBottomPickViewWithTitle:@"保险公司" items:[ShareValue sharedDefault].accidentCodes.insuranceCompany block:^(NSString *title, NSInteger itemId, NSInteger itemType) {
        
        SW(strongSelf, weakSelf);
        strongSelf.tf_insuranceCompany.text = title;
        NSUInteger selectedIndex = strongSelf.segmentedControl.selectedSegmentIndex;
        switch (selectedIndex) {
            case 0:
                strongSelf.param.ptaInsuranceCompanyId  = itemId;
                break;
            case 1:
                strongSelf.param.ptbInsuranceCompanyId  = itemId;
                break;
            case 2:
                strongSelf.param.ptcInsuranceCompanyId  = itemId;
                break;
                
            default:
                break;
        }
        
        
        [BottomView dismissWindow];
        
    }];
}


/*************** 责任按钮点击 ***************/

- (IBAction)handleBtnResponsibilityClicked:(id)sender {
    WS(weakSelf);
    
    [self showBottomPickViewWithTitle:@"事故责任" items:[ShareValue sharedDefault].accidentCodes.responsibility block:^(NSString *title, NSInteger itemId, NSInteger itemType) {
        
        SW(strongSelf, weakSelf);
        strongSelf.tf_responsibility.text = title;
        NSUInteger selectedIndex = strongSelf.segmentedControl.selectedSegmentIndex;
        switch (selectedIndex) {
            case 0:
                strongSelf.param.ptaResponsibilityId  = itemId;
                break;
            case 1:
                strongSelf.param.ptbResponsibilityId  = itemId;
                break;
            case 2:
                strongSelf.param.ptcResponsibilityId  = itemId;
                break;
                
            default:
                break;
        }
        
        
        [BottomView dismissWindow];
        
    }];

    
}

/*************** 是否暂扣车辆按钮点击 ***************/
- (IBAction)handleBtnTemporaryCarClicked:(id)sender {
    _btn_temporaryCar.selected = !_btn_temporaryCar.selected;
    
    NSUInteger selectedIndex = self.segmentedControl.selectedSegmentIndex;
    switch (selectedIndex) {
        case 0:
            self.param.ptaIsZkCl  = _btn_temporaryCar.selected;
            break;
        case 1:
            self.param.ptbIsZkCl  = _btn_temporaryCar.selected;
            break;
        case 2:
            self.param.ptcIsZkCl  = _btn_temporaryCar.selected;
            break;
            
        default:
            break;
    }
    
}


/*************** 是否暂扣行驶证按钮点击 ***************/

- (IBAction)handleBtnTemporaryDrivingLicenseClicked:(id)sender {
    _btn_temporaryDrivelib.selected = !_btn_temporaryDrivelib.selected;
    
    NSUInteger selectedIndex = self.segmentedControl.selectedSegmentIndex;
    switch (selectedIndex) {
        case 0:
            self.param.ptaIsZkXsz  = _btn_temporaryDrivelib.selected;
            break;
        case 1:
            self.param.ptbIsZkXsz  = _btn_temporaryDrivelib.selected;
            break;
        case 2:
            self.param.ptcIsZkXsz  = _btn_temporaryDrivelib.selected;
            break;
            
        default:
            break;
    }
    
}

/*************** 是否暂扣驾驶证按钮点击 ***************/

- (IBAction)handleBtnTemporaryLicenseClicked:(id)sender {
    _btn_temporarylib.selected = !_btn_temporarylib.selected;
    
    NSUInteger selectedIndex = self.segmentedControl.selectedSegmentIndex;
    switch (selectedIndex) {
        case 0:
            self.param.ptaIsZkJsz  = _btn_temporarylib.selected;
            break;
        case 1:
            self.param.ptbIsZkJsz  = _btn_temporarylib.selected;
            break;
        case 2:
            self.param.ptcIsZkJsz  = _btn_temporarylib.selected;
            break;
            
        default:
            break;
    }
    
}

/*************** 是否暂扣身份证按钮点击 ***************/

- (IBAction)handleBtnIdentityCardClicked:(id)sender {
    _btn_temporaryIdentityCard.selected = !_btn_temporaryIdentityCard.selected;
    
    NSUInteger selectedIndex = self.segmentedControl.selectedSegmentIndex;
    switch (selectedIndex) {
        case 0:
            self.param.ptaIsZkSfz  = _btn_temporaryIdentityCard.selected;
            break;
        case 1:
            self.param.ptbIsZkSfz  = _btn_temporaryIdentityCard.selected;
            break;
        case 2:
            self.param.ptcIsZkSfz  = _btn_temporaryIdentityCard.selected;
            break;
            
        default:
            break;
    }

    
}

#pragma mark - 添加监听Textfield的变化，用于给参数实时赋值

- (void)addChangeForEventEditingChanged:(UITextField *)textField{
    [textField addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - showBottomPickView

- (void)showBottomPickViewWithTitle:(NSString *)title items:(NSArray *)items block:(void(^)(NSString *title, NSInteger itemId, NSInteger itemType))block{

    BottomPickerView *t_view = [BottomPickerView initCustomView];
    [t_view setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 207)];
    t_view.pickerTitle = title;
    t_view.items = items;
    t_view.selectedAccidentBtnBlock = block;
    
    [BottomView showWindowWithBottomView:t_view];
    
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

#pragma mark - 实时监听UITextField内容的变化

-(void)passConTextChange:(id)sender{
    UITextField* textField = (UITextField*)sender;
    LxDBAnyVar(textField.text);
    if (textField == self.tf_accidentTime) {
        self.param.happenTimeStr = self.tf_accidentTime.text;
    }
    
    if (textField == self.tf_accidentAddress) {
        self.param.address = self.tf_accidentAddress.text;
    }
    
    if (textField == self.tf_weather) {
        self.param.weather = self.tf_weather.text;
    }
    
    if (textField == self.tf_name) {
        NSUInteger selectedIndex = self.segmentedControl.selectedSegmentIndex;
        switch (selectedIndex) {
            case 0:
                self.param.ptaName  = self.tf_name.text;
                break;
            case 1:
                self.param.ptbName  = self.tf_name.text;
                break;
            case 2:
                self.param.ptcName  = self.tf_name.text;
                break;
            default:
                break;
        }
        
    }
    if (textField == self.tf_identityCard) {
        
        NSUInteger selectedIndex = self.segmentedControl.selectedSegmentIndex;
        switch (selectedIndex) {
            case 0:
                self.param.ptaIdNo  = self.tf_identityCard.text;
                break;
            case 1:
                self.param.ptbIdNo  = self.tf_identityCard.text;
                break;
            case 2:
                self.param.ptcIdNo  = self.tf_identityCard.text;
                break;
            default:
                break;
        }
    }
    if (textField == self.tf_carNumber) {
        NSUInteger selectedIndex = self.segmentedControl.selectedSegmentIndex;
        switch (selectedIndex) {
            case 0:
                self.param.ptaCarNo  = self.tf_carNumber.text;
                break;
            case 1:
                self.param.ptbCarNo  = self.tf_carNumber.text;
                break;
            case 2:
                self.param.ptcCarNo  = self.tf_carNumber.text;
                break;
            default:
                break;
        }
    }
    if (textField == self.tf_phone) {
        NSUInteger selectedIndex = self.segmentedControl.selectedSegmentIndex;
        switch (selectedIndex) {
            case 0:
                self.param.ptaPhone  = self.tf_phone.text;
                break;
            case 1:
                self.param.ptbPhone  = self.tf_phone.text;
                break;
            case 2:
                self.param.ptcPhone  = self.tf_phone.text;
                break;
            default:
                break;
        }
    }
    
}

#pragma mark - 实时监听UITextView内容的变化
//只能监听键盘输入时的变化(setText: 方式无法监听),如果想修复可以参考http://www.jianshu.com/p/75355acdd058
- (void)textViewDidChange:(FSTextView *)textView{
    
    NSUInteger selectedIndex = self.segmentedControl.selectedSegmentIndex;
    switch (selectedIndex) {
        case 0:
            self.param.ptaDescribe  = textView.formatText;
            
            break;
        case 1:
            self.param.ptaDescribe  = textView.formatText;
            break;
        case 2:
            self.param.ptaDescribe  = textView.formatText;
            break;
        default:
            break;
    }


}

#pragma mark - 重新定位之后的通知

-(void)locationChange{
    
    self.tf_location.text = [LocationHelper sharedDefault].streetName;
    
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
        self.tf_phone.text = self.param.ptaPhone;
        
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
        self.btn_temporaryIdentityCard.selected = self.param.ptaIsZkSfz;
        self.tv_describe.text = self.param.ptaDescribe;
        
    }else if (selectedIndex == 1){
        
        self.tf_name.text = self.param.ptbName;
        self.tf_identityCard.text = self.param.ptbIdNo;
        
        if (self.param.ptbVehicleId) {
            NSString*t_str = [[ShareValue sharedDefault].accidentCodes searchNameWithModelId:self.param.ptbVehicleId WithArray:[ShareValue sharedDefault].accidentCodes.vehicle];
            self.tf_carType.text = t_str;
        }else{
            self.tf_carType.text = nil;
        }
        
        self.tf_carNumber.text = self.param.ptbCarNo;
        self.tf_phone.text = self.param.ptbPhone;
        
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
        self.btn_temporaryIdentityCard.selected = self.param.ptbIsZkSfz;
        
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
        self.tf_phone.text = self.param.ptcPhone;
        
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
        self.btn_temporaryIdentityCard.selected = self.param.ptcIsZkSfz;
        
        self.tv_describe.text = self.param.ptcDescribe;

    }
    
}

@end
