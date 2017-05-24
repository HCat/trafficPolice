//
//  AccidentVC.m
//  trafficPolice
//
//  Created by hcat on 2017/5/23.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "AccidentVC.h"
#import "AccidentAddFootView.h"
#import "ZLPhotoActionSheet.h"
#import "ZLCollectionCell.h"
#import "ZLPhotoModel.h"

@interface AccidentVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)  NSArray *arr_photos;
@property (nonatomic, strong) NSMutableArray<UIImage *> *lastSelectPhotos;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *lastSelectAssets;
@property (nonatomic, strong) AccidentAddFootView *footView;
@property (nonatomic,assign) BOOL isFirstLoad; //判断collectionView是不是第一次load
@property (nonatomic,assign) BOOL isObserver; //判断是否添加了监听
@end

@implementation AccidentVC

static NSString *const cellId = @"ZLCollectionCell";
static NSString *const footId = @"AccidentAddFootViewID";
static NSString *const headId = @"AccidentAddHeadViewID";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"事故录入", nil);
    
    [_collectionView registerNib:[UINib nibWithNibName:@"ZLCollectionCell" bundle:nil] forCellWithReuseIdentifier:cellId];
    [_collectionView registerNib:[UINib nibWithNibName:@"AccidentAddFootView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footId];
    [_collectionView registerNib:[UINib nibWithNibName:@"AccidentAddHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headId];
    self.isFirstLoad = YES;
    self.isObserver = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark - initActionSheet

- (ZLPhotoActionSheet *)getPhotoActionSheet
{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    actionSheet.sortAscending = NO;
    actionSheet.allowSelectImage = YES;
    actionSheet.allowSelectGif = NO;
    actionSheet.allowSelectVideo = NO;
    actionSheet.allowTakePhotoInLibrary = YES;
    //设置照片最大预览数
    actionSheet.maxPreviewCount = kmaxPreviewCount;
    //设置照片最大选择数
    actionSheet.maxSelectCount = kmaxSelectCount;
    actionSheet.cellCornerRadio = 0;
    actionSheet.sender = self;
    
    NSMutableArray *arr = [NSMutableArray array];
    for (PHAsset *asset in self.lastSelectAssets) {
        if (asset.mediaType == PHAssetMediaTypeImage && ![[asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
            [arr addObject:asset];
        }
    }
    actionSheet.arrSelectedAssets =  arr ;
    
    WS(weakSelf);
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        SW(strongSelf, weakSelf);
        strongSelf.arr_photos = images;
        strongSelf.lastSelectAssets = assets.mutableCopy;
        strongSelf.lastSelectPhotos = images.mutableCopy;
        [strongSelf.collectionView reloadData];
        NSLog(@"image:%@", images);
    }];
    [actionSheet setSelectGifBlock:^(UIImage * _Nonnull gif, PHAsset * _Nonnull asset) {
    }];
    [actionSheet setSelectVideoBlock:^(UIImage * _Nonnull coverImage, PHAsset * _Nonnull asset) {
    }];
    
    return actionSheet;
}

#pragma mark - 

- (void)showPhotoLibrary
{
    ZLPhotoActionSheet *actionSheet = [self getPhotoActionSheet];
    [actionSheet showPhotoLibrary];
    
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
    return [self.arr_photos count] + 1;
}
//返回视图的具体事例，我们的数据关联就是放在这里
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZLCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZLCollectionCell" forIndexPath:indexPath];
    cell.btnSelect.hidden = YES;
    cell.videoImageView.hidden = YES;
    cell.videoBottomView.hidden = YES;

    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 5.0f;
    if (indexPath.row == self.arr_photos.count) {
        cell.imageView.image = [UIImage imageNamed:@"updataPhoto.png"];
    } else {
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
        
        UICollectionReusableView *headerView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headId forIndexPath:indexPath];
        if(headerView == nil)
        {
            headerView = [[UICollectionReusableView alloc] init];
        }
        
        return headerView;
        
    }else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
        
        self.footView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footId forIndexPath:indexPath];
        if (!self.isObserver) {
            [_footView addObserver:self forKeyPath:@"isShowMoreAccidentInfo" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
            [_footView addObserver:self forKeyPath:@"isShowMoreInfo" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
            self.isObserver = YES;
        }
        
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
    if (indexPath.row == self.arr_photos.count) {
        
        [self showPhotoLibrary];
        
    } else {
        //image预览
        [[self getPhotoActionSheet] previewSelectedPhotos:self.lastSelectPhotos assets:self.lastSelectAssets index:indexPath.row];
    }
    
}

#pragma mark - UICollectionView Delegate FlowLayout

// cell 尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width=(self.view.bounds.size.width - 13.1f*2 - 13.0f*2)/3.f;
    return CGSizeMake(width, width);
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
    return (CGSize){ScreenWidth,32};
}


//footer底部大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (self.footView.isShowMoreAccidentInfo && self.footView.isShowMoreInfo) {
        return (CGSize){ScreenWidth,1214-88-124};
    }else{
        if (self.footView.isShowMoreAccidentInfo) {
            return (CGSize){ScreenWidth,1214-88};
        }else if(self.footView.isShowMoreInfo){
            return (CGSize){ScreenWidth,1214-124};
        }
    
    }
    if (self.isFirstLoad) {
        self.isFirstLoad = NO;
        return (CGSize){ScreenWidth,1214-88-124};
    }else{
        return (CGSize){ScreenWidth,1214};
    }
    
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"isShowMoreAccidentInfo"] && object == self.footView) {
        [self.collectionView reloadData];
    }
    
    if ([keyPath isEqualToString:@"isShowMoreInfo"] && object == self.footView) {
        [self.collectionView reloadData];
    }

}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    @try {
        [_footView removeObserver:self forKeyPath:@"isShowMoreAccidentInfo"];
        [_footView removeObserver:self forKeyPath:@"isShowMoreInfo"];
    }
    @catch (NSException *exception) {
        NSLog(@"多次删除了");
    }

}


@end
