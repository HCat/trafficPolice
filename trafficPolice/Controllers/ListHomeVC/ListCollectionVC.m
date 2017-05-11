//
//  ListCollectionVC.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/11.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "ListCollectionVC.h"
#import "ListCollectionCell.h"

@interface ListCollectionVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionFlowLayer;

@end

@implementation ListCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [_collectionView registerNib:[UINib nibWithNibName:@"ListCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ListCollectionCellID"];
    
    // Do any additional setup after loading the view from its nib.
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
    
    return 40;
}
//返回视图的具体事例，我们的数据关联就是放在这里
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ListCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ListCollectionCellID" forIndexPath:indexPath];
    
    return cell;
}



#pragma mark - UICollectionView Delegate method

//选中某个 item 触发
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选中 : %ld--%ld",indexPath.section,indexPath.item);
}

//取消某个 item 触发
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"取消选中 : %ld--%ld",indexPath.section,indexPath.item);
}


#pragma mark - UICollectionView Delegate FlowLayout

// cell 尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width=(self.view.bounds.size.width-30)/2;
    return CGSizeMake(width, 135);
}

// 装载内容 cell 的内边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(13, 8, 8, 10);
}

//最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}

//item最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
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
