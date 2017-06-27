//
//  ListHomeVC.m
//  trafficPolice
//
//  Created by Binrong Liu on 2017/5/9.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "ListHomeVC.h"

#import "ShareFun.h"
#import "AccidentListVC.h"
#import "IllegalListVC.h"
#import "VideoListVC.h"
#import "SearchListVC.h"


@interface ListHomeVC ()

@property (weak, nonatomic) IBOutlet UIView *v_search;

@property (weak, nonatomic) IBOutlet UIView *v_permission;

@property (nonatomic,strong) NSArray *arr_menus;

@end

@implementation ListHomeVC

- (instancetype)init{
    
    if (self = [super init]) {
        
        [self initPageMenu];
    }
    
    return self;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"列表", nil);
    
    if (self.arr_menus.count == 0) {
        self.v_permission.hidden = NO;
        self.v_search.hidden = YES;

    }else{
        self.v_permission.hidden = YES;
        self.v_search.hidden = NO;
    }
    
    
}

#pragma mark - initPageMenu


- (void)initPageMenu{
    
    NSMutableArray *t_arr = [NSMutableArray array];
    
    if ([ShareFun isPermissionForAccidentList]) {
        AccidentListVC *vc_first = [AccidentListVC new];
        vc_first.accidentType = AccidentTypeAccident;
        vc_first.title = @"事故";
        AccidentListVC *vc_second = [AccidentListVC new];
        vc_second.accidentType = AccidentTypeFastAccident;
        vc_second.title = @"快处";
        [t_arr addObject:vc_first];
        [t_arr addObject:vc_second];
    }
    
    if ([ShareFun isPermissionForIllegalList]) {
        
        IllegalListVC *vc_third = [IllegalListVC new];
        vc_third.illegalType = IllegalTypePark;
        vc_third.title = @"违停";
        IllegalListVC *vc_foured = [IllegalListVC new];
        vc_foured.illegalType = IllegalTypeThrough;
        vc_foured.title = @"闯禁令";
        [t_arr addObject:vc_third];
        [t_arr addObject:vc_foured];
    }

    if ([ShareFun isPermissionForVideoCollectList]) {
        
        VideoListVC *vc_firved = [VideoListVC new];
        vc_firved.title = @"视频";
        [t_arr addObject:vc_firved];
    }
    
    self.arr_menus = t_arr;
    
    if (t_arr.count == 0) {

        return;
    }
   
    NSArray *arr_controllers = [NSArray arrayWithArray:t_arr];
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

#pragma mark - buttonActions


- (IBAction)handleBtnSearchClicked:(id)sender {
    
    SearchListVC *t_vc = [SearchListVC new];
    [self.navigationController pushViewController:t_vc animated:YES];
    
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
