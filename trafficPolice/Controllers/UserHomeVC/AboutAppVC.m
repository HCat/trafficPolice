//
//  AboutAppVC.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/6/7.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "AboutAppVC.h"

@interface AboutAppVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV_icon;

@property (weak, nonatomic) IBOutlet UILabel *lb_appName;

@property (weak, nonatomic) IBOutlet UILabel *lb_appVersion;


@end

@implementation AboutAppVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于";
    
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

#pragma mark - buttonMethods

#pragma mark - 检测更新按钮事件
- (IBAction)handleBtnUpAppClicked:(id)sender {
    
    
    
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
