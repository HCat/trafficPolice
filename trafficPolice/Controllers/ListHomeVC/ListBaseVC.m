//
//  ListBaseVC.m
//  trafficPolice
//
//  Created by Binrong Liu on 2017/5/11.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "ListBaseVC.h"
#import "ListTableCell.h"
#import <MJRefresh.h>
#import "UITableView+Lr_Placeholder.h"


@interface ListBaseVC ()

@end

@implementation ListBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initRefresh];
    _tb_content.isNetAvailable = YES;
//    [self.tb_content reloadData];
    [_tb_content setReloadBlock:^{
        [_tb_content.mj_header beginRefreshing];
    }];
    
   
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
   

}

#pragma mark - 创建下拉刷新，以及上拉加载更多

- (void)initRefresh{

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [header setTitle:@"下拉查询" forState:MJRefreshStateIdle];
    [header setTitle:@"松手开始查询" forState:MJRefreshStatePulling];
    [header setTitle:@"查询中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tb_content.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载更多..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"— 没有更多内容了 —" forState:MJRefreshStateNoMoreData];
    
    footer.stateLabel.font = [UIFont systemFontOfSize:15];
    self.tb_content.mj_footer = footer;
    self.tb_content.mj_footer.automaticallyHidden = YES;

}

#pragma mark - 加载新数据

- (void)loadNewData{

    [self.tb_content.mj_header endRefreshing];


}

#pragma mark - 加载更多数据

- (void)loadMoreData{
    
    [self.tb_content.mj_footer endRefreshing];
    // [self.tb_content.mj_footer endRefreshingWithNoMoreData];
    

}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListTableCellID"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ListTableCell" bundle:nil] forCellReuseIdentifier:@"ListTableCellID"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"ListTableCellID"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
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
