//
//  ListHomeVC.m
//  trafficPolice
//
//  Created by Binrong Liu on 2017/5/9.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "ListHomeVC.h"

@interface ListHomeVC ()

@end

@implementation ListHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"列表", nil);
    
    
    
}


#pragma mark - AKTabBar Method

- (NSString *)tabImageName{
    return @"icon_tab_list";
}

- (NSString *)tabSelectedImageName{
    return @"icon_tab_list_h";
}

- (NSString *)tabTitle{
    return NSLocalizedString(@"列表", nil);
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
