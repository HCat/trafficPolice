//
//  LoginHomeVC.m
//  trafficPolice
//
//  Created by Binrong Liu on 2017/5/9.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "LoginHomeVC.h"

#import "AppDelegate.h"


@interface LoginHomeVC ()

@end

@implementation LoginHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ApplicationDelegate initAKTabBarController];
    ApplicationDelegate.window.rootViewController = ApplicationDelegate.vc_tabBar;
    
    // Do any additional setup after loading the view from its nib.
}







#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

- (void)dealloc{



}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
