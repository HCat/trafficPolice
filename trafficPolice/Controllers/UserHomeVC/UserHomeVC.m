//
//  UserHomeVC.m
//  trafficPolice
//
//  Created by Binrong Liu on 2017/5/9.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "UserHomeVC.h"
#import "UserHomeCell.h"
#import "UserReusableView.h"
#import "AppDelegate.h"
#import "ListHomeVC.h"
#import "UserSetVC.h"
#import "ShareFun.h"

@interface UserHomeVC ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *arr_data;


@end

@implementation UserHomeVC

static NSString *const cellId = @"UserHomeCellID";
static NSString *const headerId = @"UserReusableViewID";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"我的", nil);
     [_collectionView registerNib:[UINib nibWithNibName:@"UserHomeCell" bundle:nil] forCellWithReuseIdentifier:cellId];
    [_collectionView registerNib:[UINib nibWithNibName:@"UserReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
    
}

-(NSArray *)arr_data{

    if (!_arr_data) {
        
        self.arr_data = [NSMutableArray array];
        
        if ([ShareFun isPermissionForAccidentList]) {
           
            [_arr_data addObject:@{@"image":@"事故列表.png",@"title":@"事故列表",@"associated":@"事故"}];
            [_arr_data addObject:@{@"image":@"快处列表",@"title":@"快处列表",@"associated":@"快处"}];
        }
        
        if ([ShareFun isPermissionForIllegalList]) {
            
            [_arr_data addObject:@{@"image":@"违停列表",@"title":@"违停列表",@"associated":@"违停"}];
            [_arr_data addObject:@{@"image":@"闯禁令列表",@"title":@"闯禁令列表",@"associated":@"闯禁令"}];
        }
        
        if ([ShareFun isPermissionForVideoCollectList]) {
            
            [_arr_data addObject:@{@"image":@"视频列表",@"title":@"视频列表",@"associated":@"视频"}];
        }
        
        [_arr_data addObject:@{@"image":@"设置",@"title":@"设置",@"associated":@"设置"}];
    
    }
    
    return _arr_data;
}

 


#pragma mark - UICollectionView Data Source

//返回多少个组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView   *)collectionView
{
    return 1;
}
//返回每组多少个视图
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.arr_data count];
}
//返回视图的具体事例，我们的数据关联就是放在这里
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UserHomeCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    [cell setUpCellInsideView:self.arr_data[indexPath.row]];
    
    return cell;
}

// 和UITableView类似，UICollectionView也可设置段头段尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        
        UICollectionReusableView *headerView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
        if(headerView == nil)
        {
            headerView = [[UICollectionReusableView alloc] init];
        }
        headerView.backgroundColor = [UIColor grayColor];
        
        return headerView;
    }
    else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
        
        
        
    }
    
    return nil;
}

#pragma mark - UICollectionView Delegate method

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 点击高亮
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

//选中某个 item 触发
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UserHomeCell *cell = (UserHomeCell *)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    if (cell.dic_source) {

        NSString *title = cell.dic_source[@"associated"];
        
        if ([title isEqualToString:@"设置"]) {
            UserSetVC *t_vc = [[UserSetVC alloc] init];
            [self.navigationController pushViewController:t_vc animated:YES];
            return;
        }
        
        ApplicationDelegate.vc_tabBar.selectedIndex = 1;
        UINavigationController *t_nav = ApplicationDelegate.vc_tabBar.viewControllers[1];
        ListHomeVC *t_vc = (ListHomeVC *)t_nav.topViewController;
        
        for (UIViewController * t_item in t_vc.pageMenu.arr_controllers) {
           
            if ([t_item.title isEqualToString:title]) {
                 NSInteger index = [t_vc.pageMenu.arr_controllers indexOfObject:t_item];
                [t_vc.pageMenu moveToPage:index withAnimation:NO];
                return;
            }
        }
    
    }
    
}

#pragma mark - UICollectionView Delegate FlowLayout

// cell 尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width=(self.view.bounds.size.width-2.1f)/3.f;
    return CGSizeMake(width, width);
}

// 装载内容 cell 的内边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 8, 0);
}

//最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}

//item最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){ScreenWidth,140};
}



#pragma mark - AKTabBar Method

- (NSString *)tabImageName{
    return @"icon_tab_user";
}

- (NSString *)tabSelectedImageName{
    return @"icon_tab_user_h";
}

- (NSString *)tabTitle{
    return NSLocalizedString(@"我的", nil);
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
