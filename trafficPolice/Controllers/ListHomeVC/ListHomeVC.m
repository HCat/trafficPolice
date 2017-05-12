//
//  ListHomeVC.m
//  trafficPolice
//
//  Created by Binrong Liu on 2017/5/9.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "ListHomeVC.h"
#import "LRPageMenu.h"
#import "ListBaseVC.h"
#import "ListCollectionVC.h"



@interface ListHomeVC ()

@property (nonatomic,strong) LRPageMenu *pageMenu;


@end

@implementation ListHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"列表", nil);
    [self initPageMenu];
    
}

#pragma mark - initPageMenu


- (void)initPageMenu{

    ListBaseVC *vc_first = [ListBaseVC new];
    vc_first.title = @"违停";
    ListBaseVC *vc_second = [ListBaseVC new];
    vc_second.title = @"闯禁令";
    ListBaseVC *vc_third = [ListBaseVC new];
    vc_third.title = @"事故";
    ListCollectionVC *vc_foured = [ListCollectionVC new];
    vc_foured.title = @"快处";
    ListCollectionVC *vc_firved = [ListCollectionVC new];
    vc_firved.title = @"视频";
    
    NSArray *arr_controllers = @[vc_first,vc_second,vc_third,vc_foured,vc_firved];
    NSDictionary *dic_options = @{LRPageMenuOptionUseMenuLikeSegmentedControl:@(YES),
                                  LRPageMenuOptionSelectedTitleColor:UIColorFromRGB(0x4281e8),
                                  LRPageMenuOptionUnselectedTitleColor:UIColorFromRGB(0x444444),
                                  LRPageMenuOptionSelectionIndicatorColor:UIColorFromRGB(0x4281e8),
                                  LRPageMenuOptionScrollMenuBackgroundColor:[UIColor whiteColor],
                                  LRPageMenuOptionSelectionIndicatorWidth:@(80),
                                  LRPageMenuOptionBottomMenuHairlineColor:[UIColor clearColor],
                                  LRPageMenuOptionSelectedTitleFont:[UIFont systemFontOfSize:15.f],
                                  LRPageMenuOptionUnselectedTitleFont:[UIFont systemFontOfSize:14.f],
                                  };
    _pageMenu = [[LRPageMenu alloc] initWithViewControllers:arr_controllers frame:CGRectMake(0.0, 44.0, ScreenWidth, self.view.frame.size.height-44) options:dic_options];
    
    [self.view addSubview:_pageMenu.view];


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
