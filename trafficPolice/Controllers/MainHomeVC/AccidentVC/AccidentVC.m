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
#import "AccidentAPI.h"
#import "ShareFun.h"


@interface AccidentVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong)  NSArray *arr_photos;
@property (nonatomic, strong) NSMutableArray<UIImage *> *lastSelectPhotos;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *lastSelectAssets;

@property (nonatomic, strong) AccidentAddFootView *footView;

@property (nonatomic,assign) BOOL isFirstLoad; //判断collectionView是不是第一次load

@property (nonatomic,assign) BOOL isObserver; //判断是否添加了kvo监听,如果添加了不需要重复添加
@end

@implementation AccidentVC

static NSString *const cellId = @"ZLCollectionCell";
static NSString *const footId = @"AccidentAddFootViewID";
static NSString *const headId = @"AccidentAddHeadViewID";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_accidentType == AccidentTypeAccident) {
        self.title = NSLocalizedString(@"事故录入", nil);
    }else{
        self.title = NSLocalizedString(@"快处事故录入", nil);
    }
    
    
    [_collectionView registerNib:[UINib nibWithNibName:@"ZLCollectionCell" bundle:nil] forCellWithReuseIdentifier:cellId];
    [_collectionView registerNib:[UINib nibWithNibName:@"AccidentAddFootView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footId];
    [_collectionView registerNib:[UINib nibWithNibName:@"AccidentAddHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headId];
    self.isFirstLoad = YES;
    self.isObserver = NO;
    
    [[ShareValue sharedDefault] accidentCodes];

    //断网之后重新连接网络该做的事情

    self.networkChangeBlock = ^{
        [[ShareValue sharedDefault] accidentCodes];

    };
    
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
        strongSelf.footView.arr_photes = images;
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
        _footView.accidentType = _accidentType;
        
        if (!_isObserver && _footView.accidentType == AccidentTypeAccident) {
            [_footView addObserver:self forKeyPath:@"isShowMoreAccidentInfo" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
            [_footView addObserver:self forKeyPath:@"isShowMoreInfo" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
            self.isObserver = YES;
        }
        
        return _footView;
        
    }
    
    return nil;
}

#pragma mark - UICollectionView Delegate method


//选中某个 item 触发
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _arr_photos.count) {
        
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
    if (_footView.isShowMoreAccidentInfo && _footView.isShowMoreInfo) {
        return (CGSize){ScreenWidth,1214-88-124};
    }else{
        if (_footView.isShowMoreAccidentInfo) {
            return (CGSize){ScreenWidth,1214-88};
        }else if(_footView.isShowMoreInfo){
            return (CGSize){ScreenWidth,1214-124};
        }
    
    }
    if (_isFirstLoad) {
        _isFirstLoad = NO;
        if (_accidentType == AccidentTypeAccident) {
            return (CGSize){ScreenWidth,1214-88-124};
        }else{
            return (CGSize){ScreenWidth,1214-88-124-24-44};
        }
        
    }else{
        if (_accidentType == AccidentTypeAccident) {
            return (CGSize){ScreenWidth,1214};
        }else{
            return (CGSize){ScreenWidth,1214-88-124-24-44};
        }
    }
    
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

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"isShowMoreAccidentInfo"] && object == _footView) {
        [_collectionView reloadData];
    }
    
    if ([keyPath isEqualToString:@"isShowMoreInfo"] && object == _footView) {
        [_collectionView reloadData];
    }

}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    LxPrintf(@"AccidentVC dealloc");
    
    @try {
        [_footView removeObserver:self forKeyPath:@"isShowMoreAccidentInfo"];
        [_footView removeObserver:self forKeyPath:@"isShowMoreInfo"];
    }
    @catch (NSException *exception) {
        NSLog(@"多次删除了");
    }

}


@end
