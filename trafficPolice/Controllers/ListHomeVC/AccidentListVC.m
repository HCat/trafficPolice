//
//  AccidentListVC.m
//  trafficPolice
//
//  Created by hcat on 2017/6/7.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "AccidentListVC.h"
#import <MJRefresh.h>
#import <RealReachability.h>
#import "UITableView+Lr_Placeholder.h"
#import "AccidentCell.h"

#import "AccidentAPI.h"
#import "FastAccidentAPI.h"
#import "AccidentDetailVC.h"
#import "ListHomeVC.h"
#import "ShareFun.h"

@interface AccidentListVC ()

@property (weak, nonatomic) IBOutlet UITableView *tb_content;

@property (nonatomic,strong) NSMutableArray *arr_content;

@property (nonatomic,assign) NSInteger index; //加载更多数据索引

@end

@implementation AccidentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tb_content.isNeedPlaceholderView = YES;
    _tb_content.firstReload = YES;
    //隐藏多余行的分割线
    _tb_content.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tb_content setSeparatorInset:UIEdgeInsetsZero];
    [_tb_content setLayoutMargins:UIEdgeInsetsZero];

    self.arr_content = [NSMutableArray array];
    
    [self initRefresh];
    
    self.index = 0;
    [_tb_content.mj_header beginRefreshing];
    
    WS(weakSelf);
    
    //点击重新加载之后的处理
    [_tb_content setReloadBlock:^{
        SW(strongSelf, weakSelf);
        strongSelf.tb_content.isNetAvailable = NO;
        strongSelf.index = 0;
        [strongSelf.tb_content.mj_header beginRefreshing];
    }];
    
    //网络断开之后重新连接之后的处理
    self.networkChangeBlock = ^{
        SW(strongSelf, weakSelf);
        strongSelf.tb_content.isNetAvailable = NO;
        strongSelf.index = 0;
        [strongSelf.tb_content.mj_header beginRefreshing];
    };
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

}

#pragma mark - 创建下拉刷新，以及上拉加载更多

- (void)initRefresh{
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [header setTitle:@"下拉查询" forState:MJRefreshStateIdle];
    [header setTitle:@"松手开始查询" forState:MJRefreshStatePulling];
    [header setTitle:@"查询中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    _tb_content.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载更多..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"— 没有更多内容了 —" forState:MJRefreshStateNoMoreData];
    
    
    footer.stateLabel.font = [UIFont systemFontOfSize:15];
    footer.stateLabel.textColor = UIColorFromRGB(0xa6a6a6);
    _tb_content.mj_footer = footer;
    _tb_content.mj_footer.automaticallyHidden = YES;
    
}

#pragma mark - 加载新数据

- (void)loadData{
    
    WS(weakSelf);
    if (_index == 0) {
        if (_arr_content && _arr_content.count > 0) {
            [_arr_content removeAllObjects];
        }
    }

    if (_accidentType == AccidentTypeAccident) {
        
        AccidentListPagingParam *param = [[AccidentListPagingParam alloc] init];
        param.start = _index;
        param.length = 10;
        AccidentListPagingManger *manger = [[AccidentListPagingManger alloc] init];
        manger.param = param;
        manger.isNeedShowHud = NO;
        
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            SW(strongSelf, weakSelf);
            [strongSelf.tb_content.mj_header endRefreshing];
            [strongSelf.tb_content.mj_footer endRefreshing];
            
            if (manger.responseModel.code == CODE_SUCCESS) {
                
                [strongSelf.arr_content addObjectsFromArray:manger.accidentListPagingReponse.list];
                if (strongSelf.arr_content.count == manger.accidentListPagingReponse.total) {
                    [strongSelf.tb_content.mj_footer endRefreshingWithNoMoreData];
                }else{
                    strongSelf.index += 1;
                }
                [strongSelf.tb_content reloadData];
            }else{
                NSString *t_errString = [NSString stringWithFormat:@"网络错误:code:%d msg:%@",manger.responseModel.code,manger.responseModel.msg];
                [ShowHUD showError:t_errString duration:1.5 inView:strongSelf.view config:nil];
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            SW(strongSelf,weakSelf);
            [strongSelf.tb_content.mj_header endRefreshing];
            [strongSelf.tb_content.mj_footer endRefreshing];
            
            ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
            if (status == RealStatusNotReachable) {
                strongSelf.tb_content.isNetAvailable = YES;
                [strongSelf.tb_content reloadData];
            }
        }];
        
    }else if (_accidentType == AccidentTypeFastAccident){
    
        FastAccidentListPagingParam *param = [[FastAccidentListPagingParam alloc] init];
        param.start = _index;
        param.length = 10;
        FastAccidentListPagingManger *manger = [[FastAccidentListPagingManger alloc] init];
        manger.param = param;
        manger.isNeedShowHud = NO;
        
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            SW(strongSelf, weakSelf);
            [strongSelf.tb_content.mj_header endRefreshing];
            [strongSelf.tb_content.mj_footer endRefreshing];
            
            if (manger.responseModel.code == CODE_SUCCESS) {
                
                [strongSelf.arr_content addObjectsFromArray:manger.fastAccidentListPagingReponse.list];
                if (strongSelf.arr_content.count == manger.fastAccidentListPagingReponse.total) {
                    [strongSelf.tb_content.mj_footer endRefreshingWithNoMoreData];
                }else{
                    strongSelf.index += 1;
                }
                [strongSelf.tb_content reloadData];
            }else{
                NSString *t_errString = [NSString stringWithFormat:@"网络错误:code:%d msg:%@",manger.responseModel.code,manger.responseModel.msg];
                [ShowHUD showError:t_errString duration:1.5 inView:strongSelf.view config:nil];
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            SW(strongSelf,weakSelf);
            [strongSelf.tb_content.mj_header endRefreshing];
            [strongSelf.tb_content.mj_footer endRefreshing];
            
            ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
            if (status == RealStatusNotReachable) {
                strongSelf.tb_content.isNetAvailable = YES;
                [strongSelf.tb_content reloadData];
            }
        }];
    
    }
    

}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_content.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AccidentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccidentCellID"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"AccidentCell" bundle:nil] forCellReuseIdentifier:@"AccidentCellID"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"AccidentCellID"];
    }
    
    if (_arr_content && _arr_content.count > 0) {
        AccidentListModel *t_model = _arr_content[indexPath.row];
        cell.model = t_model;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_arr_content && _arr_content.count > 0) {
        
        ListHomeVC *vc_target = (ListHomeVC *)[ShareFun findViewController:self.view withClass:[ListHomeVC class]];
        
        AccidentListModel *t_model = _arr_content[indexPath.row];
        AccidentDetailVC *t_vc = [[AccidentDetailVC alloc] init];
        t_vc.accidentId = t_model.accidentId;
        [vc_target.navigationController pushViewController:t_vc animated:YES];
    }
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    LxPrintf(@"AccidentListVC dealloc");
    
}

@end