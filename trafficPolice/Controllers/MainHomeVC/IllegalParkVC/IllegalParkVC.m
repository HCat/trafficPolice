//
//  IllegalParkVC.m
//  trafficPolice
//
//  Created by hcat on 2017/5/31.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "IllegalParkVC.h"
#import "IllegalParkCell.h"
#import "IllegalParkAddHeadView.h"
#import "IllegalParkAddFootView.h"
#import "LRCameraVC.h"

#import "ShareFun.h"

@interface IllegalParkVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<UIImage *> *arr_photos; //更多照片
@property (nonatomic, strong) UIImage *img_carNumber; //车牌近照
@property (nonatomic, strong) UIImage *img_illegalPark; //违停照片

@property (nonatomic, strong) IllegalParkAddHeadView *headView;
@property (nonatomic, strong) IllegalParkAddFootView *footView;

@end

@implementation IllegalParkVC

static NSString *const cellId = @"IllegalParkCell";
static NSString *const footId = @"IllegalParkAddFootViewID";
static NSString *const headId = @"IllegalParkAddHeadViewID";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"违停采集";
   
    [_collectionView registerNib:[UINib nibWithNibName:@"IllegalParkCell" bundle:nil] forCellWithReuseIdentifier:cellId];
    [_collectionView registerNib:[UINib nibWithNibName:@"IllegalParkAddFootView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footId];
    [_collectionView registerNib:[UINib nibWithNibName:@"IllegalParkAddHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headId];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [ShareFun getCommonRoad];
        
    });
    
    //断网之后重新连接网络该做的事情
    self.networkChangeBlock = ^{
        if ([ShareValue sharedDefault].roadModels == nil) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [ShareFun getCommonRoad];
            });
        }
    };
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    return [self.arr_photos count] + 3;
}
//返回视图的具体事例，我们的数据关联就是放在这里
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IllegalParkCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IllegalParkCell" forIndexPath:indexPath];
   
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 0.0f;
    if (indexPath.row == self.arr_photos.count+2) {
        cell.lb_title.text = @"更多照片";
        cell.imageView.image = [UIImage imageNamed:@"updataPhoto.png"];
    }else if(indexPath.row == 0){
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.lb_title.text = @"车牌近照";
        if (!_img_carNumber) {
            cell.imageView.image = [UIImage imageNamed:@"updataPhoto.png"];
        }else{
            cell.imageView.image = _img_carNumber;
        }
    }else if(indexPath.row == 1){
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.lb_title.text = @"违停照片";
        if (!_img_illegalPark) {
            cell.imageView.image = [UIImage imageNamed:@"updataPhoto.png"];
        }else{
            cell.imageView.image = _img_illegalPark;
        }
    
    }else {
        cell.imageView.image = _arr_photos[indexPath.row];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return cell;
}

// 和UITableView类似，UICollectionView也可设置段头段尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        
        self.headView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headId forIndexPath:indexPath];
    
        return _headView;
        
    }else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
        
        self.footView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footId forIndexPath:indexPath];
        
        return _footView;
        
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
    WS(weakSelf);
    LRCameraVC *home = [[LRCameraVC alloc] init];
    home.type = 1;
    home.fininshCaptureBlock = ^(LRCameraVC *camera) {
        if (camera) {
            SW(strongSelf, weakSelf);
            if (camera.type == 1) {
                
                strongSelf.headView.tf_carNumber.text = camera.commonIdentifyResponse.carNo;
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    ImageFileInfo *imageFileInfo = camera.imageInfo;
                    imageFileInfo.name = key_files;
                    
                });
                
            }
        }
    };
    [self presentViewController:home
                       animated:NO
                     completion:^{
                     }];
    
}

#pragma mark - UICollectionView Delegate FlowLayout

// cell 尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width=(self.view.bounds.size.width - 13.1f*2 - 13.0f*2)/3.f;
    return CGSizeMake(width, width+27);
}

// 装载内容 cell 的内边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(13, 13, 13, 13);
}

//最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 13.0f;
}

//item最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 13.0f;
}

//header头部大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return (CGSize){ScreenWidth,230};
}


//footer底部大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return (CGSize){ScreenWidth,75};
    
}

#pragma mark - scrollViewDelegate
//用于滚动到顶部的时候使得tableView不能再继续下拉
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == _collectionView){
        if (scrollView.contentOffset.y < 0) {
            CGPoint position = CGPointMake(0, 0);
            [scrollView setContentOffset:position animated:NO];
            return;
        }
    }
}



#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    LxPrintf(@"IllegalParkVC dealloc");

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
