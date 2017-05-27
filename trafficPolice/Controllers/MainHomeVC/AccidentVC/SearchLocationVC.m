//
//  SearchLocationVC.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/27.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "SearchLocationVC.h"
#import <RealReachability.h>
#import "UITableView+Lr_Placeholder.h"

@interface SearchLocationVC ()

@property (weak, nonatomic) IBOutlet UITextField *tf_search;
@property (weak, nonatomic) IBOutlet UITableView *tb_content;
@property (nonatomic,copy) NSArray *arr_content;
@property (nonatomic,copy) NSArray *arr_temp; //用于临时存储总数据
@end

@implementation SearchLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"所在位置";
    
    self.tb_content.isNeedPlaceholderView = YES;
    self.tb_content.firstReload = YES;
    
    //隐藏多余行的分割线
    self.tb_content.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    [self.tb_content setSeparatorInset:UIEdgeInsetsZero];
//    [self.tb_content setLayoutMargins:UIEdgeInsetsZero];
    _tf_search.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 0)];
    //设置显示模式为永远显示(默认不显示)
    _tf_search.leftViewMode = UITextFieldViewModeAlways;
    
    [self getAccidentCodes];
    WS(weakSelf);
    
    //网络断开之后重新连接之后的处理
    self.networkChangeBlock = ^{
        SW(strongSelf, weakSelf);
        if (strongSelf.arr_content) {
            strongSelf.arr_content = nil;
        }
        strongSelf.tb_content.isNetAvailable = NO;
        [strongSelf getAccidentCodes];
    };
    
    self.tb_content.reloadBlock = ^{
        SW(strongSelf, weakSelf);
        if (strongSelf.arr_content) {
            strongSelf.arr_content = nil;
        }
        strongSelf.tb_content.isNetAvailable = NO;
        [strongSelf getAccidentCodes];
    };
    
     [_tf_search addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - 数据请求部分

- (void)getAccidentCodes{

    WS(weakSelf);
    AccidentGetCodesManger *manger = [AccidentGetCodesManger new];
    manger.isNeedShowHud = YES;
    manger.isLog = YES;
    
    ShowHUD *hud = [ShowHUD showWhiteLoadingWithText:@"请求中..." inView:self.view config:nil];
    
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [hud hide];
        SW(strongSelf,weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {
            [ShareValue sharedDefault].accidentCodes = manger.accidentGetCodesResponse;
            strongSelf.arr_content = [ShareValue sharedDefault].accidentCodes.road;
            strongSelf.arr_temp = [ShareValue sharedDefault].accidentCodes.road;
            [strongSelf.tb_content reloadData];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [hud hide];
        SW(strongSelf,weakSelf);
         ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
        if (status == RealStatusNotReachable) {
            strongSelf.tb_content.isNetAvailable = YES;
            [strongSelf.tb_content reloadData];
        }

    }];

}


#pragma mark - buttonMethods

- (IBAction)handleBtnCancalClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.arr_content) {
        return self.arr_content.count;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchLocationID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:@"SearchLocationID"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    AccidentGetCodesModel *model = _arr_content[indexPath.row];
    cell.textLabel.text = model.modelName;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    [cell setSeparatorInset:UIEdgeInsetsZero];
//    [cell setLayoutMargins:UIEdgeInsetsZero];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     AccidentGetCodesModel *model = _arr_content[indexPath.row];
    if (self.searchLocationBlock) {
        self.searchLocationBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 实时监听UITextField内容的变化

-(void)passConTextChange:(id)sender{
    UITextField* textField = (UITextField*)sender;
    if (!self.arr_temp || self.arr_temp.count == 0) {
        return;
    }
    
    if (textField.text.length == 0) {
        self.arr_content = self.arr_temp;
        [self.tb_content reloadData];
        return;
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    [self.arr_temp enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AccidentGetCodesModel *model = (AccidentGetCodesModel *)obj;
        if ([model.modelName containsString:textField.text]) {
            [arr addObject:model];
        }
    }];
    self.arr_content = [NSArray arrayWithArray:arr];
    [self.tb_content reloadData];
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

    LxPrintf(@"SearchLocationVC dealloc");
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
