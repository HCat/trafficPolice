//
//  LLPhotoBrowser.m
//  LLPhotoBrowser
//
//  Created by zhaomengWang on 17/2/6.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLPhotoBrowser.h"
#import "LLCollectionViewCell.h"
#import "UIButton+Block.h"
#import "ImageFileInfo.h"

@interface LLPhotoBrowser ()<UICollectionViewDelegate,UICollectionViewDataSource,LLPhotoDelegate,UICollectionViewDelegateFlowLayout>{
    
    NSMutableArray *_images;
    NSInteger _currentIndex;
    UICollectionView *_collectionView;
    UIView *_navigationBar;
    UILabel *_titleLabel;
    BOOL _navIsHidden;
    UIView *_tabBar;
}

@property(nonatomic,strong) NSMutableDictionary *dic_delete;

@end

@implementation LLPhotoBrowser

- (instancetype)initWithupImages:(NSMutableArray<NSMutableDictionary *> *)arr_upImages currentIndex:(NSInteger)currentIndex{
    self = [super init];
    if (self) {
        self.arr_upImages = arr_upImages;
        _currentIndex = currentIndex;
    }
    return self;

}


- (instancetype)initWithImages:(NSMutableArray<UIImage *> *)images currentIndex:(NSInteger)currentIndex {
    self = [super init];
    if (self) {
        _images = images;
        _currentIndex = currentIndex;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createViews];
}

- (void)createViews {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[LLCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
    
    if (_arr_upImages) {
        if (_currentIndex < _arr_upImages.count) {
            [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionLeft];
        }
    }
    
    
    if (_images) {
        if (_currentIndex < _images.count) {
            [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionLeft];
        }

    }
    
    /******自定义界面******/
    _navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    _navigationBar.backgroundColor = [UIColor clearColor];
    _navigationBar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_navigationBar];
    
    UIView *t_backgroudView = [[UIImageView alloc] initWithFrame:_navigationBar.bounds];
    t_backgroudView.backgroundColor = UIColorFromRGB(0x4281E8);
    t_backgroudView.alpha = 0.7f;
    [_navigationBar addSubview:t_backgroudView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15, CGRectGetMidY(_navigationBar.frame)-8.5, 9, 17);
    [backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setEnlargeEdgeWithTop:10.f right:10.f bottom:10.f left:10.f];
    [_navigationBar addSubview:backBtn];
    
    UIButton *trachBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    trachBtn.frame = CGRectMake(CGRectGetMaxX(_navigationBar.frame)-30, CGRectGetMidY(_navigationBar.frame)-8, 16, 16);
    [trachBtn setImage:[UIImage imageNamed:@"icon_trash_alt"] forState:UIControlStateNormal];
    [trachBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [trachBtn addTarget:self action:@selector(trachBtn) forControlEvents:UIControlEventTouchUpInside];
    [trachBtn setEnlargeEdgeWithTop:10.f right:10.f bottom:10.f left:10.f];
    [_navigationBar addSubview:trachBtn];
    
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 17, self.view.bounds.size.width-160, 30)];
    
    if (_arr_upImages) {
         _titleLabel.text = [NSString stringWithFormat:@"%ld/%ld",_currentIndex+1,_arr_upImages.count];
    }
    
    if (_images) {
         _titleLabel.text = [NSString stringWithFormat:@"%ld/%ld",_currentIndex+1,_images.count];
    }
   
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:18];
    [_navigationBar addSubview:_titleLabel];
    
}

#pragma mark - UICollectionViewDataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.bounds.size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_arr_upImages) {
        return _arr_upImages.count;
    }
    
    if (_images) {
        return _images.count;
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell.photo.ll_delegate) {
        cell.photo.ll_delegate = self;
    }
    
    if (_arr_upImages && _arr_upImages.count > 0) {
        NSMutableDictionary *t_dic = _arr_upImages[indexPath.item];
        ImageFileInfo *imageInfo = [t_dic objectForKey:@"files"];
        cell.photo.ll_image = imageInfo.image;
    }
    
    if (_images&&_images.count > 0) {
        cell.photo.ll_image = _images[indexPath.item];
    }
    cell.photo.zoomScale = 1.0;
    
    return cell;
}

#pragma mark - UICollectionViewDelagate 当图图片滑出屏幕外时，将图片比例重置为原始比例
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    LLCollectionViewCell *LLCell = (LLCollectionViewCell *)cell;
    LLCell.photo.zoomScale = 1.0;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _currentIndex = (long)scrollView.contentOffset.x/self.view.bounds.size.width;
    
    if (_arr_upImages) {
       _titleLabel.text = [NSString stringWithFormat:@"%ld/%ld",_currentIndex+1,_arr_upImages.count];
    }
    
    if (_images) {
        _titleLabel.text = [NSString stringWithFormat:@"%ld/%ld",_currentIndex+1,_images.count];
    }
    
    
}

#pragma mark - LLPhotoDelegate 图片单击事件，显示/隐藏标题栏
- (void)singleClickWithPhoto:(LLPhoto *)photo {
    [UIView animateWithDuration:.1 animations:^{
        if (_navIsHidden) {
            _navigationBar.transform = CGAffineTransformIdentity;
        }
        else {
            _navigationBar.transform = CGAffineTransformMakeTranslation(0, -64);
        }
    } completion:^(BOOL finished) {
        _navIsHidden = !_navIsHidden;
    }];
}

#pragma mark - 返回按钮
- (void)goBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 垃圾桶按钮

- (void)trachBtn{


    // 取出可见cell
    // 判断即将显示哪一张
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForItem:_currentIndex inSection:0];
    LLCollectionViewCell *currentCell = (LLCollectionViewCell *)[_collectionView cellForItemAtIndexPath:currentIndexPath];
    
    // 移除数组中的某个元素
    NSInteger count = -1;
    if (_arr_upImages) {
        count = _arr_upImages.count;
    }
    
    if (_images) {
        count = _images.count;
    }
    
    
    
    if (_currentIndex > count - 1 ) {
        _currentIndex = count - 1;
    }
    
    
    
    if (_arr_upImages) {
        self.dic_delete = _arr_upImages[_currentIndex];
         [_arr_upImages removeObjectAtIndex:_currentIndex];
    }
    
    if (_images) {
         [_images removeObjectAtIndex:_currentIndex];
    }
    
    // 移除cell
    [currentCell removeFromSuperview];
    // 刷新cell
    [_collectionView reloadData];
    
    // 刷新标题
    if (self.deleteBlock) {
        self.deleteBlock(_dic_delete);
    }
    
    if (_arr_upImages) {
        
        if (_currentIndex == count - 1) {
            _titleLabel.text = [NSString stringWithFormat:@"%zd/%zd", _currentIndex,_arr_upImages.count];
        }else{
            _titleLabel.text = [NSString stringWithFormat:@"%zd/%zd", _currentIndex+1,_arr_upImages.count];
        }
        
        
        if (_arr_upImages.count == 0) {
            // 来到这里说明没有图片，退出预览
            [self goBack];
        };
    }
    
    if (_images) {
        
        if (_currentIndex == count - 1) {
            _titleLabel.text = [NSString stringWithFormat:@"%zd/%zd", _currentIndex,_images.count];
        }else{
            _titleLabel.text = [NSString stringWithFormat:@"%zd/%zd", _currentIndex+1,_images.count];
        }
        
        
        if (_images.count == 0) {
            // 来到这里说明没有图片，退出预览
            [self goBack];
        };
    }
    
    
    
    
}

#pragma mark - 发送按钮
- (void)sendImage:(UIButton *)btn {
    
    if ([self.delegate respondsToSelector:@selector(photoBrowser:didSelectImage:)]) {
        [self.delegate photoBrowser:self didSelectImage:_images[_currentIndex]];
    }
}

#pragma mark - 隐藏状态栏
- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _collectionView.frame = self.view.bounds;
    _collectionView.contentOffset = CGPointMake(self.view.bounds.size.width*_currentIndex, 0);
    [_collectionView reloadData];
}

- (void)dealloc {
    NSLog(@"图片浏览器释放，无内存泄漏");
}

@end
