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



@interface MainHomeVC ()<ImagePlayerViewDelegate,MainHomeCellDelegate>

@property(nonatomic,strong) ImagePlayerView *cycleView;
@property (weak, nonatomic) IBOutlet UITableView *tb_content;
@property (nonatomic,copy) NSArray *arr_data;
@property (nonatomic,copy) NSArray *arr_title;
@property (nonatomic,copy) NSArray *arr_imageSource;

@end

@implementation MainHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"首页", nil);
    
    LxDBAnyVar([UserModel getUserModel].menus);
    [self initCycleView];
    [self getImgPlay];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

#pragma mark - 轮播请求数据

- (void)getImgPlay{

    
    WS(weakSelf);
    CommonGetImgPlayManger *manger = [CommonGetImgPlayManger new];
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        strongSelf.arr_imageSource = manger.commonGetImgPlayModel;
        [strongSelf.cycleView reloadData];
    
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];

}

#pragma mark - set

-(NSArray *)arr_data{

    if (!_arr_data) {
        
        NSMutableArray *t_arr_first = [NSMutableArray array];
        NSMutableArray *t_arr_second = [NSMutableArray array];
        NSMutableArray *t_arr_third = [NSMutableArray array];
        
        
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
        
        self.arr_data = [[NSArray alloc] initWithObjects:t_arr_first,t_arr_second,t_arr_third, nil];

    }
    
    return _arr_data;
}

-(NSArray *)arr_title{
    
    if (!_arr_title) {
        
        self.arr_title = @[@"事故管理",@"违法管理",@"警情采集"];
        
    }
    
    return _arr_title;
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
    NSLog(@"did tap index = %d", (int)index);
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
    
    NSString *title = self.arr_title[indexPath.row];
    NSArray *t_arr = self.arr_data[indexPath.row];
    if (t_arr) {
        [cell createCell:title withItems:t_arr];
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

- (void)itemClickInCell:(MainHomeCell *)cell withIndex:(NSInteger)index{
    
    switch (index) {
        case 0:
            LxDBAnyVar(index);
            break;
        case 1:
            LxDBAnyVar(index);
            break;
            
        default:
            break;
    }
    
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
    _arr_title = nil;
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
