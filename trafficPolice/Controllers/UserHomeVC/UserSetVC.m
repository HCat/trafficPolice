//
//  UserSetVC.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/15.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "UserSetVC.h"
#import "XBConst.h"
#import "XBSettingCell.h"
#import "XBSettingItemModel.h"
#import "XBSettingSectionModel.h"
#import "UserModel.h"
#import "ShareFun.h"
#import "FeedbackVC.h"
#import "AboutAppVC.h"
#import "LRBaseRequest.h"
#import "AppDelegate.h"
#import "LoginHomeVC.h"

@interface UserSetVC ()

@property (nonatomic,copy) NSString * userName;
@property (nonatomic,copy) NSString * phoneNummer;

@property (nonatomic,strong) NSArray  *sectionArray; /**< section模型数组*/
@property (weak, nonatomic) IBOutlet UITableView *tb_content;

@end

@implementation UserSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.userName = [UserModel getUserModel].realName;
    self.phoneNummer = [UserModel getUserModel].phone;
    [self setupSections];
}

#pragma - mark setup
- (void)setupSections
{
    //************************************section1
    WS(weakSelf);
    XBSettingItemModel *item1 = [[XBSettingItemModel alloc]init];
    item1.funcName = @"用户名";
    item1.executeCode = ^{
        NSLog(@"用户名");
        
    };
    item1.detailText = self.userName;
    item1.accessoryType = XBSettingAccessoryTypeNone;
    
    XBSettingItemModel *item2 = [[XBSettingItemModel alloc]init];
    item2.funcName = @"手机号码";
    item2.detailText = self.phoneNummer;
    item2.accessoryType = XBSettingAccessoryTypeNone;
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    float folderSize = [ShareFun folderSizeAtPath:documentPath];
    
    XBSettingItemModel *item3 = [[XBSettingItemModel alloc]init];
    item3.funcName = @"清除缓存";
    item3.detailText = [NSString stringWithFormat:@"%.2fM", folderSize];
    
    item3.executeCode = ^{
        LxPrintf(@"清除缓存");
        SW(strongSelf, weakSelf);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSLog(@"%@", cachPath);
                       
            NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
            NSLog(@"files :%lu",(unsigned long)[files count]);
            for (NSString *p in files) {
                NSError *error;
                NSString *path = [cachPath stringByAppendingPathComponent:p];
                if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                }
            }
            
            [strongSelf performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
        });
        
    };
    
    item3.accessoryType = XBSettingAccessoryTypeNone;
    
    XBSettingItemModel *item4 = [[XBSettingItemModel alloc]init];
    item4.funcName = @"意见反馈";
    item4.executeCode = ^{
        LxPrintf(@"意见反馈");
        SW(strongSelf, weakSelf);
        FeedbackVC *t_vc = [[FeedbackVC alloc] init];
        [strongSelf.navigationController pushViewController:t_vc animated:YES];
    };
    item4.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingItemModel *item5 = [[XBSettingItemModel alloc]init];
    item5.funcName = @"关于";
    item5.executeCode = ^{
        LxPrintf(@"关于");
        SW(strongSelf, weakSelf);
        AboutAppVC *t_vc = [[AboutAppVC alloc] init];
        [strongSelf.navigationController pushViewController:t_vc animated:YES];
        
    };
    item5.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingSectionModel *section1 = [[XBSettingSectionModel alloc]init];
    section1.sectionHeaderHeight = 18;
    section1.sectionHeaderBgColor = [UIColor clearColor];
    section1.itemArray = @[item1,item2,item3,item4,item5];

    self.sectionArray = @[section1];
}

-(void)clearCacheSuccess
{
    LxPrintf(@"清理成功");
    XBSettingSectionModel *sectionModel = self.sectionArray[0];
    XBSettingItemModel *itemModel = sectionModel.itemArray[2];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    float t_folderSize = [ShareFun folderSizeAtPath:documentPath];
    itemModel.detailText = [NSString stringWithFormat:@"%.2fM", t_folderSize];
    [_tb_content reloadData];
    
    [ShowHUD showSuccess:@"缓存清理成功" duration:1.5f inView:self.view config:nil];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    XBSettingSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    static NSString *identifier = @"setting";

    XBSettingSectionModel *sectionModel = self.sectionArray[indexPath.section];
    XBSettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    
    XBSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[XBSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.item = itemModel;
    return cell;
    
}

#pragma - mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    XBSettingSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.sectionHeaderHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XBSettingSectionModel *sectionModel = self.sectionArray[indexPath.section];
    XBSettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    if (itemModel.executeCode) {
        itemModel.executeCode();
    }
}

#pragma mark - 注销按钮事件

- (IBAction)UserLoginOutAction:(id)sender {
    
    [LRBaseRequest clearRequestFilters];
    [ShareValue sharedDefault].token = nil;
    [ShareValue sharedDefault].phone = nil;
    [UserModel setUserModel:nil];
    
    ApplicationDelegate.vc_tabBar = nil;
    LoginHomeVC *t_vc = [LoginHomeVC new];
    UINavigationController *t_nav = [[UINavigationController alloc] initWithRootViewController:t_vc];
    ApplicationDelegate.window.rootViewController = t_nav;
    
}



#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    LxPrintf(@"UserSetVC dealloc");
    
}

@end
