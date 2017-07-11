//
//  MainHomeVC.m
//  trafficPolice
//
//  Created by Binrong Liu on 2017/5/9.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "MainHomeVC.h"
#import "ImagePlayerView.h"
#import "MainHomeCell.h"
#import "CommonAPI.h"
#import "UserModel.h"
#import <UIImageView+WebCache.h>

#import "AccidentVC.h"
#import "IllegalParkVC.h"
#import "VideoColectVC.h"

#import "HSUpdateApp.h"
#import "SRAlertView.h"

@interface MainHomeVC ()<ImagePlayerViewDelegate,MainHomeCellDelegate>

@property(nonatomic,strong) ImagePlayerView *cycleView;
@property (weak, nonatomic) IBOutlet UITableView *tb_content;
@property (nonatomic,strong) NSMutableArray *arr_data;
@property (nonatomic,copy) NSArray *arr_imageSource;

@end

@implementation MainHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"首页", nil);
    
    LxDBAnyVar([UserModel getUserModel].menus);
    [self initCycleView];
    [self getImgPlay];
    
    //这里获取事故通用值
    [[ShareValue sharedDefault] accidentCodes];
    //这里获取道路通用值通用值
    [[ShareValue sharedDefault] roadModels];
    
    WS(weakSelf);
    
    //断网之后重新连接网络该做的事情
    self.networkChangeBlock = ^{
        SW(strongSelf, weakSelf);
        [strongSelf getImgPlay];
        
    };
    
    [[LocationHelper sharedDefault] startLocation];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //查询是否需要更新
    __weak __typeof(&*self)weakSelf = self;
    [HSUpdateApp hs_updateWithAPPID:ITUNESAPPID block:^(NSString *currentVersion, NSString *storeVersion, NSString *openUrl, BOOL isUpdate) {
        if (isUpdate == YES) {
            [weakSelf showStoreVersion:storeVersion openUrl:openUrl];
        }
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

#pragma mark - 轮播请求数据

- (void)getImgPlay{
    //当没有数据的时候再请求
    if (self.arr_imageSource == nil) {
        WS(weakSelf);
        CommonGetImgPlayManger *manger = [CommonGetImgPlayManger new];
        manger.isNeedShowHud = NO;
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            SW(strongSelf, weakSelf);
            if (manger.responseModel.code == CODE_SUCCESS) {
                strongSelf.arr_imageSource = manger.commonGetImgPlayModel;
                [strongSelf.cycleView reloadData];
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            
        }];
    }

}

#pragma mark - set

-(NSMutableArray *)arr_data{

    if (!_arr_data) {
        
        NSMutableDictionary *t_dic_first =  [NSMutableDictionary dictionary];
        NSMutableDictionary *t_dic_second = [NSMutableDictionary dictionary];
        NSMutableDictionary *t_dic_third =  [NSMutableDictionary dictionary];
        
        NSMutableArray *t_arr_first = [NSMutableArray array];
        NSMutableArray *t_arr_second = [NSMutableArray array];
        NSMutableArray *t_arr_third = [NSMutableArray array];
        
//        [t_arr_first addObject:@{@"image":@"事故快处.png",@"title":@"事故快处"}];
//        [t_arr_first addObject:@{@"image":@"事故.png",@"title":@"事故"}];
//        [t_arr_second addObject:@{@"image":@"违停采集.png",@"title":@"违停采集"}];
//        [t_arr_second addObject:@{@"image":@"闯禁令采集.png",@"title":@"闯禁令采集"}];
//        [t_arr_third addObject:@{@"image":@"视频录入.png",@"title":@"视频录入"}];
        
        if ([UserModel getUserModel]) {
            
            [[UserModel getUserModel].menus enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj isEqualToString:@"FAST_ACCIDENT_ADD"]) {
                    //拥有快处事故添加权限
                    [t_arr_first addObject:@{@"image":@"事故快处.png",@"title":@"事故快处"}];
                    
                }else if([obj isEqualToString:@"NORMAL_ACCIDENT_ADD"]){
                    //拥有事故添加权限
                    [t_arr_first addObject:@{@"image":@"事故.png",@"title":@"事故"}];
                    
                }else if([obj isEqualToString:@"ILLEGAL_PARKING"]){
                    //拥有违停采集权限
                    [t_arr_second addObject:@{@"image":@"违停采集.png",@"title":@"违停采集"}];
                    
                }else if([obj isEqualToString:@"ILLEGAL_THROUGH"]){
                    //拥有闯禁令采集权限
                    [t_arr_second addObject:@{@"image":@"闯禁令采集.png",@"title":@"闯禁令采集"}];
                    
                }else if([obj isEqualToString:@"VIDEO_COLLECT"]){
                    //警情采集权限
                    [t_arr_third addObject:@{@"image":@"视频录入.png",@"title":@"视频录入"}];
                    
                }
            }];
  
        }
        
        self.arr_data = [NSMutableArray array];
        
        if (t_arr_first && t_arr_first.count > 0) {
            [t_dic_first setObject:t_arr_first forKey:@"items"];
            [t_dic_first setObject:@"事故管理" forKey:@"title"];
            [_arr_data addObject:t_dic_first];
        }
        
        if (t_arr_second && t_arr_second.count > 0) {
            [t_dic_second setObject:t_arr_second forKey:@"items"];
            [t_dic_second setObject:@"违法管理" forKey:@"title"];
            [_arr_data addObject:t_dic_second];
        }

        if (t_arr_third && t_arr_third.count > 0) {
            [t_dic_third setObject:t_arr_third forKey:@"items"];
            [t_dic_third setObject:@"警情采集" forKey:@"title"];
            [_arr_data addObject:t_dic_third];
        }

    }
    
    return _arr_data;
}

#pragma mark - initCycleView

-(void)initCycleView{

    if (_cycleView == nil) {
        self.cycleView = [[ImagePlayerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 140)];
        _cycleView.backgroundColor = UIColorFromRGB(0x6fbbfb);
        _cycleView.imagePlayerViewDelegate = self;
        
        _cycleView.scrollInterval = 3.0f;
        _cycleView.pageControlPosition = ICPageControlPosition_BottomCenter;
        _cycleView.hidePageControl = NO;
        _cycleView.endlessScroll = YES;
        _cycleView.pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0x4281e8);
        _cycleView.pageControl.pageIndicatorTintColor = UIColorFromRGB(0xeeeeee);
    
        _tb_content.tableHeaderView = _cycleView;
        
    }

    [_cycleView reloadData];


}


#pragma mark - ImagePlayerViewDelegate

- (NSInteger)numberOfItems
{
    return self.arr_imageSource.count;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    // recommend to use SDWebImage lib to load web image
    if (self.arr_imageSource) {
        CommonGetImgPlayModel *model = self.arr_imageSource[index];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.getImgPlayImgUrl]];
    
    }

}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    
    if (self.arr_imageSource) {
        CommonGetImgPlayModel *model = self.arr_imageSource[index];
        LxPrintf(@"did tap index = %d url:%@", (int)index, model.getImgPlayUrl);
    }
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arr_data.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MainHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainHomeCellID"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"MainHomeCell" bundle:nil] forCellReuseIdentifier:@"MainHomeCellID"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"MainHomeCellID"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NSMutableDictionary *t_dic = self.arr_data[indexPath.row];
    if (t_dic) {
        NSMutableArray *t_arr = t_dic[@"items"];
        NSString *t_title = t_dic[@"title"];
        [cell createCell:t_title withItems:t_arr];
    }
    [cell setDelegate:(id<MainHomeCellDelegate>)self];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - scrollViewDelegate
//用于滚动到顶部的时候使得tableView不能再继续下拉
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.tb_content){
        if (scrollView.contentOffset.y < 0) {
            CGPoint position = CGPointMake(0, 0);
            [scrollView setContentOffset:position animated:NO];
            return;
        }
    }
}

#pragma mark - MainHomeCellDelegate

- (void)itemClickInCell:(MainHomeCell *)cell{
    
    if (cell.str_title) {
        if ([cell.str_title isEqualToString:@"事故快处"]) {
            LxPrintf(@"点击事故快处");
            AccidentVC *t_vc = [[AccidentVC alloc] init];
            t_vc.accidentType = AccidentTypeFastAccident;
            [self.navigationController pushViewController:t_vc animated:YES];
            
        }else if ([cell.str_title isEqualToString:@"事故"]) {
            LxPrintf(@"点击事故");
            AccidentVC *t_vc = [[AccidentVC alloc] init];
            t_vc.accidentType = AccidentTypeAccident;
            [self.navigationController pushViewController:t_vc animated:YES];
            
        }else if ([cell.str_title isEqualToString:@"违停采集"]) {
            LxPrintf(@"点击违停采集");
            IllegalParkVC *t_vc = [[IllegalParkVC alloc] init];
            t_vc.illegalType = IllegalTypePark;
            [self.navigationController pushViewController:t_vc animated:YES];
            
        }else if ([cell.str_title isEqualToString:@"闯禁令采集"]) {
            LxPrintf(@"点击闯禁令采集");
            IllegalParkVC *t_vc = [[IllegalParkVC alloc] init];
            t_vc.illegalType = IllegalTypeThrough;
            [self.navigationController pushViewController:t_vc animated:YES];
            
        }else if ([cell.str_title isEqualToString:@"视频录入"]) {
            LxPrintf(@"点击视频录入");
            VideoColectVC *t_vc = [[VideoColectVC alloc] init];
            [self.navigationController pushViewController:t_vc animated:YES];
            
        }else{
            LxPrintf(@"其他");
        }
    }
    
}

#pragma mark - 判断版本更新

-(void)showStoreVersion:(NSString *)storeVersion openUrl:(NSString *)openUrl{
    
    WS(weakSelf);
    SRAlertView *alertView = [[SRAlertView alloc] initWithTitle:@"版本有更新"
                                                        message:[NSString stringWithFormat:@"检测到新版本(%@),是否更新?",storeVersion]
                                                leftActionTitle:@"取消"
                                               rightActionTitle:@"更新"
                                                 animationStyle:AlertViewAnimationNone
                                                   selectAction:^(AlertViewActionType actionType) {
                                                       if (actionType == AlertViewActionTypeLeft) {
                                                           
                                                           
                                                       } else if(actionType == AlertViewActionTypeRight) {
                                                           NSURL *url = [NSURL URLWithString:openUrl];
                                                           [[UIApplication sharedApplication] openURL:url];
                                                       }
                                                   }];
    alertView.blurCurrentBackgroundView = NO;
    alertView.actionWhenHighlightedBackgroundColor = UIColorFromRGB(0x4281E8);
    [alertView show];
    
}

#pragma mark - AKTabBar Method

- (NSString *)tabImageName{
    return @"icon_tab_main";
}

- (NSString *)tabSelectedImageName{
    return @"icon_tab_main_h";
}

- (NSString *)tabTitle{
    
    return NSLocalizedString(@"首页", nil);
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    _arr_data = nil;
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

    [self.cycleView stopTimer];
    self.cycleView.imagePlayerViewDelegate = nil;
    self.cycleView = nil;

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
