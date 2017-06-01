//
//  IllegalParkAddHeadView.m
//  trafficPolice
//
//  Created by hcat on 2017/5/31.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "IllegalParkAddHeadView.h"
#import "IllegalParkVC.h"
#import "LRCameraVC.h"
#import "SearchLocationVC.h"
#import "CountAccidentHelper.h"

#import "ShareFun.h"

@interface IllegalParkAddHeadView()


@property (weak, nonatomic) IBOutlet UITextField *tf_roadSection; //选择路段
@property (weak, nonatomic) IBOutlet UITextField *tf_address; //所在位置
@property (weak, nonatomic) IBOutlet UITextField *tf_addressRemarks; //地址备注


@end

@implementation IllegalParkAddHeadView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        //添加对定位的监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChange) name:NOTIFICATION_CHANGELOCATION_SUCCESS object:nil];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[LocationHelper sharedDefault] startLocation];
    
    _tf_carNumber.attributedPlaceholder = [ShareFun highlightInString:@"请输入车牌号(必填)" withSubString:@"(必填)"];
    _tf_roadSection.attributedPlaceholder = [ShareFun highlightInString:@"请选择路段(必选)" withSubString:@"(必选)"];
    _tf_address.attributedPlaceholder = [ShareFun highlightInString:@"请输入所在位置(必填)" withSubString:@"(必填)"];
    
    [self addChangeForEventEditingChanged:_tf_carNumber];
    [self addChangeForEventEditingChanged:_tf_address];
    [self addChangeForEventEditingChanged:_tf_addressRemarks];
    
}


#pragma mark - buttonMethods

#pragma mark - 识别车牌号按钮事件

- (IBAction)handleBtnCarNumberClicked:(id)sender {
    
    WS(weakSelf);
    
    IllegalParkVC *t_vc = (IllegalParkVC *)[ShareFun findViewController:self];
    LRCameraVC *home = [[LRCameraVC alloc] init];
    home.type = 1;
    home.fininshCaptureBlock = ^(LRCameraVC *camera) {
        
        if (camera) {
            
            SW(strongSelf, weakSelf);
            
            if (camera.type == 1) {
                
                strongSelf.tf_carNumber.text = camera.commonIdentifyResponse.carNo;
                strongSelf.param.carNo = camera.commonIdentifyResponse.carNo;
                
                //用于判断该车牌号码是否有违规行为
                if (strongSelf.tf_carNumber.text.length > 0) {
                    [[CountAccidentHelper sharedDefault] setCarNo:strongSelf.tf_carNumber.text];
                }
                
                //判断是否可以提交，用于按钮是否可以点击
                strongSelf.isCanCommit = [strongSelf juegeCanCommit];
                
                ImageFileInfo *imageFileInfo = camera.imageInfo;
                if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(recognitionCarNumber:)]) {
                    [strongSelf.delegate recognitionCarNumber:imageFileInfo];
                }
            
            }
        }
    };
    [t_vc presentViewController:home
                       animated:NO
                     completion:^{
                     }];
    
}

#pragma mark - 重新定位按钮事件
- (IBAction)handlebtnLocationClicked:(id)sender {
    
    [[LocationHelper sharedDefault] startLocation];
    
}

#pragma mark - 选择路段按钮事件
- (IBAction)handlebtnChoiceLocationClicked:(id)sender {
    
    WS(weakSelf);
    
    IllegalParkVC *t_vc = (IllegalParkVC *)[ShareFun findViewController:self];
    SearchLocationVC *t_searchLocationvc = [SearchLocationVC new];
    t_searchLocationvc.searchType = SearchLocationTypeIllegal;
    t_searchLocationvc.arr_content = [ShareValue sharedDefault].roadModels;
    t_searchLocationvc.arr_temp = [ShareValue sharedDefault].roadModels;
    
    t_searchLocationvc.getRoadBlock = ^(CommonGetRoadModel *model) {
        SW(strongSelf, weakSelf);
        strongSelf.tf_roadSection.text = model.getRoadName;
        strongSelf.param.roadId = model.getRoadId;
        strongSelf.param.roadName = model.getRoadName;
    };
    
    [t_vc.navigationController pushViewController:t_searchLocationvc animated:YES];
    
    
}

#pragma mark - 重新定位之后的通知

-(void)locationChange{
    
    _tf_roadSection.text = [LocationHelper sharedDefault].streetName;
    
    self.param.longitude = @([LocationHelper sharedDefault].longitude);
    self.param.latitude = @([LocationHelper sharedDefault].latitude);
    
    if ([ShareValue sharedDefault].roadModels && [ShareValue sharedDefault].roadModels.count > 0) {
        for(CommonGetRoadModel *model in [ShareValue sharedDefault].roadModels){
            if ([model.getRoadName isEqualToString:[LocationHelper sharedDefault].streetName]) {
                _param.roadId = model.getRoadId;
                break;
            }
        }
    }
    if (!_param.roadId) {
        _param.roadId = @0;
    }
    
    _param.roadName = [LocationHelper sharedDefault].streetName;
    self.isCanCommit =  [self juegeCanCommit];
}

#pragma mark - 添加监听Textfield的变化，用于给参数实时赋值

- (void)addChangeForEventEditingChanged:(UITextField *)textField{
    [textField addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - 实时监听UITextField内容的变化

-(void)passConTextChange:(id)sender{
    UITextField* textField = (UITextField*)sender;
    LxDBAnyVar(textField.text);
    NSInteger length =  textField.text.length;
    
    if (textField == _tf_carNumber) {
        self.param.carNo = length > 0 ? _tf_carNumber.text : nil;
        //手动输入车牌号的时候用于判断是否有违法行为进行弹框出来
        if (length > 0 ) {
            [[CountAccidentHelper sharedDefault] setCarNo:self.param.carNo];
        }
        
    }
    
    if (textField == _tf_address) {
        self.param.address = length > 0 ? _tf_address.text : nil;
    }
    
    if (textField == _tf_addressRemarks) {
        self.param.addressRemark = length > 0 ? _tf_addressRemarks.text : nil;
        
    }
    
    self.isCanCommit = [self juegeCanCommit];
    
}



#pragma mark - 判断是否可以提交

-(BOOL)juegeCanCommit{
    LxDBObjectAsJson(self.param);
    if (self.param.address.length >0 && self.param.roadId && self.param.carNo.length > 0 && self.param.latitude && self.param.longitude ) {
        return YES;
    }else{
        return NO;
    }
}



#pragma mark - dealloc

- (void)dealloc{

    LxPrintf(@"IllegalParkAddHeadView dealloc");

}

@end
