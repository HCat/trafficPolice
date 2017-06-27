//
//  AboutAppVC.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/6/7.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "AboutAppVC.h"

#import "HSUpdateApp.h"
#import "SRAlertView.h"

@interface AboutAppVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV_icon;

@property (weak, nonatomic) IBOutlet UILabel *lb_appName;

@property (weak, nonatomic) IBOutlet UILabel *lb_appVersion;

@property (weak, nonatomic) IBOutlet UIButton *btn_upApp;

@property (nonatomic,copy) NSString *storeVersion;
@property (nonatomic,copy) NSString *openUrl;


@end

@implementation AboutAppVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于";
    
    _btn_upApp.hidden = YES;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //CFShow((__bridge CFTypeRef)(infoDictionary));
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    // app appIcon
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    
    UIImage* image = [UIImage imageNamed:icon];
    
    _imageV_icon.image = image;
    _imageV_icon.layer.cornerRadius = _imageV_icon.frame.size.width/2;
    _lb_appName.text = app_Name;
    _lb_appVersion.text = app_Version;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //查询是否需要更新
    __weak __typeof(&*self)weakSelf = self;
    [HSUpdateApp hs_updateWithAPPID:ITUNESAPPID block:^(NSString *currentVersion, NSString *storeVersion, NSString *openUrl, BOOL isUpdate) {
        if (isUpdate == YES) {
            weakSelf.storeVersion = storeVersion;
            weakSelf.openUrl = openUrl;
            weakSelf.btn_upApp.hidden = NO;
        }
    }];
    
}

#pragma mark - buttonMethods

#pragma mark - 检测更新按钮事件
- (IBAction)handleBtnUpAppClicked:(id)sender {
    
    WS(weakSelf);
    SRAlertView *alertView = [[SRAlertView alloc] initWithTitle:@"检查更新"
                                                        message:[NSString stringWithFormat:@"检测到新版本(%@),是否更新?",_storeVersion]
                                                leftActionTitle:@"取消"
                                               rightActionTitle:@"更新"
                                                 animationStyle:AlertViewAnimationNone
                                                   selectAction:^(AlertViewActionType actionType) {
                                                       if (actionType == AlertViewActionTypeLeft) {
                                                           
                                                           
                                                       } else if(actionType == AlertViewActionTypeRight) {
                                                           NSURL *url = [NSURL URLWithString:weakSelf.openUrl];
                                                           [[UIApplication sharedApplication] openURL:url];
                                                       }
                                                   }];
    alertView.blurCurrentBackgroundView = NO;
    alertView.actionWhenHighlightedBackgroundColor = UIColorFromRGB(0x4281E8);
    [alertView show];

}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    LxPrintf(@"AboutAppVC dealloc");
    
}

@end
