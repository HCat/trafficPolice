//
//  PhoneLoginVC.m
//  trafficPolice
//
//  Created by Binrong Liu on 2017/5/9.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "PhoneLoginVC.h"
#import "UINavigationBar+BarItem.h"
#import "ShareFun.h"
#import "LRCountDownButton.h"

@interface PhoneLoginVC ()

@property (weak, nonatomic) IBOutlet LRCountDownButton *btn_countDown;
@property (weak, nonatomic) IBOutlet UITextField *tf_phone;
@property (weak, nonatomic) IBOutlet UITextField *tf_code;

@end

@implementation PhoneLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"短信验证";
    [self showLeftBarButtonItemWithImage:@"icon_back" target:self action:@selector(handleBtnBackClicked)];
    
    
    _btn_countDown.durationOfCountDown = 10;
    _btn_countDown.originalBGColor = UIColorFromRGB(0x467AE3);
    _btn_countDown.processBGColor = UIColorFromRGB(0xe2e2e2);
    WS(weakSelf);

    _btn_countDown.beginBlock = ^{
        SW(strongSelf, weakSelf);
        if (strongSelf.tf_phone.text.length < 11) {
            
        }else{
            [strongSelf.btn_countDown startCountDown];
        
        }
        
        
    };
    
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    
}

#pragma mark -

-(void)handleBtnBackClicked{
     [ShareFun exitApplication];
    
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
