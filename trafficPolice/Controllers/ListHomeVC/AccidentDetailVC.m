//
//  AccidentDetailVC.m
//  trafficPolice
//
//  Created by hcat on 2017/6/8.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "AccidentDetailVC.h"
#import "AccidentCell.h"
#import <RealReachability.h>
#import "UITableView+Lr_Placeholder.h"
#import "AccidentAPI.h"
#import "AccidentImageCell.h"
#import "AccidentMessageCell.h"
#import "AccidentPartyCell.h"

@interface AccidentDetailVC ()

@property (weak, nonatomic) IBOutlet UITableView *tb_content;
@property (nonatomic,strong) AccidentDetailModel *model;

@end

@implementation AccidentDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"事故详情";
    
    _tb_content.isNeedPlaceholderView = YES;
    _tb_content.firstReload = YES;
    //隐藏多余行的分割线
    _tb_content.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tb_content setSeparatorInset:UIEdgeInsetsZero];
    [_tb_content setLayoutMargins:UIEdgeInsetsZero];
    _tb_content.allowsSelection = NO;
    
    WS(weakSelf);
    //点击重新加载之后的处理
    [_tb_content setReloadBlock:^{
        SW(strongSelf, weakSelf);
        strongSelf.tb_content.isNetAvailable = NO;
        [strongSelf loadAccidentDetail];
    }];
    
    //网络断开之后重新连接之后的处理
    self.networkChangeBlock = ^{
        SW(strongSelf, weakSelf);
        strongSelf.tb_content.isNetAvailable = NO;
        [strongSelf loadAccidentDetail];
    };

    [self loadAccidentDetail];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    
}

#pragma mark - 数据请求部分

- (void)loadAccidentDetail{

    WS(weakSelf);
    AccidentDetailManger *manger = [[AccidentDetailManger alloc] init];
    manger.accidentId = _accidentId;
    
    ShowHUD *hud = [ShowHUD showWhiteLoadingWithText:@"加载中..." inView:self.view config:nil];
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [hud hide];
        SW(strongSelf, weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {
            strongSelf.model = manger.accidentDetailModel;
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
        return 3;
    }else{
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        AccidentImageCell *cell = (AccidentImageCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }else if (indexPath.row == 1){
        AccidentMessageCell *cell = (AccidentMessageCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }else if (indexPath.row == 2){
        AccidentPartyCell *cell = (AccidentPartyCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
    return 105;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        AccidentImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccidentImageCellID"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"AccidentImageCell" bundle:nil] forCellReuseIdentifier:@"AccidentImageCellID"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"AccidentImageCellID"];
        }
        
        if (_model) {
            NSMutableArray *t_arr = [NSMutableArray array];
            if (_model.picList && _model.picList.count > 0) {
                for (AccidentPicListModel * t_model in _model.picList) {
                    [t_arr addObject:t_model.imgUrl];
                }
                cell.arr_images = t_arr;
            }
        }
        
        CGRect frame = cell.frame;
        frame.size.height = [cell heightWithimages];
        cell.frame = frame;
    
        return cell;
        
    }else if(indexPath.row == 1){
    
        AccidentMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccidentMessageCellID"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"AccidentMessageCell" bundle:nil] forCellReuseIdentifier:@"AccidentMessageCellID"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"AccidentMessageCellID"];
        }
        
        if (_model) {
            if (_model.accident ) {
                cell.accident = _model.accident;
            }
        }

        CGRect frame = cell.frame;
        frame.size.height = [cell heightWithAccident];
        cell.frame = frame;
        
        return cell;
    
    }else if(indexPath.row == 2){
        
        AccidentPartyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccidentPartyCellID"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"AccidentPartyCell" bundle:nil] forCellReuseIdentifier:@"AccidentPartyCellID"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"AccidentPartyCellID"];
        }
        
        if (_model) {
            if (_model.accident ) {
                cell.accident = _model.accident;
                WS(weakSelf);
                cell.block = ^{
                    SW(strongSelf, weakSelf);
                    [strongSelf.tb_content reloadData];
                    
                };
            }
        }
        
        
        CGRect frame = cell.frame;
        frame.size.height = [cell heightWithAccident];
        cell.frame = frame;
        
        return cell;
        
    }

    return nil;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
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

    LxPrintf(@"AccidentDetailVC dealloc");
    
}

@end
