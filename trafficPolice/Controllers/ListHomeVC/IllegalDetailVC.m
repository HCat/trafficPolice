//
//  IllegalDetailVC.m
//  trafficPolice
//
//  Created by hcat on 2017/6/9.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "IllegalDetailVC.h"

#import "UITableView+Lr_Placeholder.h"
#import <RealReachability.h>

#import "IllegalParkAPI.h"
#import "IllegalThroughAPI.h"

#import "IllegalImageCell.h"


@interface IllegalDetailVC ()

@property (weak, nonatomic) IBOutlet UITableView *tb_content;
@property (nonatomic,strong) IllegalParkDetailModel *model;

@end

@implementation IllegalDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_illegalType == IllegalTypePark) {
        self.title = @"违停详情";
    }else if(_illegalType == IllegalTypeThrough){
        self.title = @"闯禁令详情";
    }
    
    _tb_content.isNeedPlaceholderView = YES;
    _tb_content.firstReload = YES;
    _tb_content.allowsSelection = NO;

    [self setNetworking];
    
}

#pragma mark - 数据请求

- (void)setNetworking{

    WS(weakSelf);
    //点击重新加载之后的处理
    [_tb_content setReloadBlock:^{
        
        SW(strongSelf, weakSelf);
        strongSelf.tb_content.isNetAvailable = NO;
        if (strongSelf.illegalType == IllegalTypePark) {
            [strongSelf loadIllegalParkDetail];
        }else if (strongSelf.illegalType == IllegalTypeThrough){
            [strongSelf loadIllegalThroughDetail];
        }
        
    }];
    
    //网络断开之后重新连接之后的处理
    self.networkChangeBlock = ^{
        SW(strongSelf, weakSelf);
        strongSelf.tb_content.isNetAvailable = NO;
        if (strongSelf.illegalType == IllegalTypePark) {
            [strongSelf loadIllegalParkDetail];
        }else if (strongSelf.illegalType == IllegalTypeThrough){
            [strongSelf loadIllegalThroughDetail];
        }
    };
    
    if (_illegalType == IllegalTypePark) {
        [self loadIllegalParkDetail];
    }else if (_illegalType == IllegalTypeThrough){
        [self loadIllegalThroughDetail];
    }
    
}

- (void)loadIllegalParkDetail{

    WS(weakSelf);
    IllegalParkDetailManger *manger = [[IllegalParkDetailManger alloc] init];
    manger.illegalParkId = _illegalId;
    manger.successMessage = @"加载成功";
    manger.failMessage = @"加载失败";
    
    ShowHUD *hud = [ShowHUD showWhiteLoadingWithText:@"加载中..." inView:self.view config:nil];
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [hud hide];
        SW(strongSelf, weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {
            strongSelf.model = manger.illegalDetailModel;
            [strongSelf.tb_content reloadData];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [hud hide];
        SW(strongSelf,weakSelf);
        ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
        if (status == RealStatusNotReachable) {
            strongSelf.model = nil;
            strongSelf.tb_content.isNetAvailable = YES;
            [strongSelf.tb_content reloadData];
        }
        
    }];

}

- (void)loadIllegalThroughDetail{

    WS(weakSelf);
    IllegalThroughDetailManger *manger = [[IllegalThroughDetailManger alloc] init];
    manger.illegalThroughId = _illegalId;
    manger.successMessage = @"加载成功";
    manger.failMessage = @"加载失败";
    
    ShowHUD *hud = [ShowHUD showWhiteLoadingWithText:@"加载中..." inView:self.view config:nil];
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [hud hide];
        SW(strongSelf, weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {
            strongSelf.model = manger.illegalDetailModel;
            [strongSelf.tb_content reloadData];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [hud hide];
        SW(strongSelf,weakSelf);
        ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
        if (status == RealStatusNotReachable) {
            strongSelf.model = nil;
            strongSelf.tb_content.isNetAvailable = YES;
            [strongSelf.tb_content reloadData];
        }
        
    }];

}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_model) {
        return 1;
    }else{
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        IllegalImageCell *cell = (IllegalImageCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return [cell heightWithimages];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        IllegalImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IllegalImageCellID"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"IllegalImageCell" bundle:nil] forCellReuseIdentifier:@"IllegalImageCellID"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"IllegalImageCellID"];
        }
        
        
        if (_model) {

            if (_model.picList && _model.picList.count > 0) {
                cell.arr_images = [_model.picList mutableCopy];
            }
        }
        
        return cell;
        
    }
    
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

    LxPrintf(@"IllegalDetailVC dealloc");
    
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