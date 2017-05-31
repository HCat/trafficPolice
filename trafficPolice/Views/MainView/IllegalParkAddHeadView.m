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
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    ImageFileInfo *imageFileInfo = camera.imageInfo;
                    imageFileInfo.name = key_files;
                    
                });
                t_vc.img_carNumber = camera.image;
                [t_vc.collectionView reloadData];
                
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
       
        
        
    };
    [t_vc.navigationController pushViewController:t_searchLocationvc animated:YES];
    
    
}

#pragma mark - 重新定位之后的通知

-(void)locationChange{
    _tf_roadSection.text = [LocationHelper sharedDefault].streetName;
    
}



#pragma mark - dealloc

- (void)dealloc{

    LxPrintf(@"IllegalParkAddHeadView dealloc");

}

@end
