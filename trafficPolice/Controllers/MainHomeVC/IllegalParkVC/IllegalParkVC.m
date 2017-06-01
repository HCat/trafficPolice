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
#import "ZLPhotoActionSheet.h"
#import <Photos/Photos.h>

#import "ShareFun.h"
#import "IllegalParkAPI.h"
#import "LLPhotoBrowser.h"

@interface IllegalParkVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property (nonatomic, strong) NSMutableArray<NSMutableDictionary *> *arr_photos; //更多照片

@property (nonatomic, strong) NSMutableDictionary *img_carNumber; //车牌近照
@property (nonatomic, strong) NSMutableDictionary *img_illegalPark; //违停照片
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property (nonatomic, strong) IllegalParkAddHeadView *headView;
@property (nonatomic, strong) IllegalParkAddFootView *footView;

@property (nonatomic,strong) IllegalParkSaveParam *param; //请求参数

@property (nonatomic,assign) BOOL isObserver;

@property (nonatomic,strong) NSMutableArray *arr_upimages; //用于存储即将上传的图片

@property (nonatomic, strong) NSMutableArray<UIImage *> *lastSelectPhotos;



@end

@implementation IllegalParkVC

static NSString *const cellId = @"IllegalParkCell";
static NSString *const footId = @"IllegalParkAddFootViewID";
static NSString *const headId = @"IllegalParkAddHeadViewID";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"违停采集";
    
    self.isObserver = NO;
    self.param = [[IllegalParkSaveParam alloc] init];
    self.arr_photos = [NSMutableArray array];
    
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
    
    WS(weakSelf);
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        SW(strongSelf, weakSelf);
        NSLog(@"image:%@", images);
    }];

    return actionSheet;
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
   
    cell.imageView.layer.cornerRadius = 5.0f;
    cell.imageView.layer.masksToBounds = YES;
    
    if (indexPath.row == self.arr_photos.count+2) {
        
        cell.lb_title.text = @"更多照片";
        cell.imageView.image = [UIImage imageNamed:@"updataPhoto.png"];
        
    }else if(indexPath.row == 0){
        
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.lb_title.text = @"车牌近照";
        if (!_img_carNumber) {
            cell.imageView.image = [UIImage imageNamed:@"updataPhoto.png"];
        }else{
            ImageFileInfo *imageInfo = [_img_carNumber objectForKey:@"files"];
            cell.imageView.image = imageInfo.image;
        }
        
    }else if(indexPath.row == 1){
        
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.lb_title.text = @"违停照片";
        if (!_img_illegalPark) {
            cell.imageView.image = [UIImage imageNamed:@"updataPhoto.png"];
        }else{
            ImageFileInfo *imageInfo = [_img_illegalPark objectForKey:@"files"];
            cell.imageView.image = imageInfo.image;
        }
    
    }else {
        cell.lb_title.text = @"更多照片";
        NSMutableDictionary *t_dic = _arr_photos[indexPath.row-2];
        ImageFileInfo *imageInfo = [t_dic objectForKey:@"files"];
        cell.imageView.image = imageInfo.image;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    
    return cell;
}

// 和UITableView类似，UICollectionView也可设置段头段尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        if (!self.headView) {
            self.headView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headId forIndexPath:indexPath];
             [_headView setDelegate:(id<IllegalParkAddHeadViewDelegate>)self];
            _headView.param = _param;
            _headView.isCanCommit = NO;
            if (!_isObserver) {
                [_headView addObserver:self forKeyPath:@"isCanCommit" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
                self.isObserver = YES;
            }
        }
    
        return _headView;
        
    }else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
        
        self.footView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footId forIndexPath:indexPath];
        
        [_footView setDelegate:(id<IllegalParkAddFootViewDelegate>)self];
        
        return _footView;
        
    }
    
    return nil;
}

#pragma mark - UICollectionView Delegate method

//选中某个 item 触发
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WS(weakSelf);
    
    if (indexPath.row == self.arr_photos.count+2) {
       
        [self showCameraWithType:5 withFinishBlock:^(LRCameraVC *camera) {
            if (camera) {
                SW(strongSelf, weakSelf);
                if (camera.type == 5) {
                    
                    ImageFileInfo *imageFileInfo = camera.imageInfo;
                    imageFileInfo.name = key_files;
                    
                    NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
                    [t_dic setObject:imageFileInfo forKey:@"files"];
                    [t_dic setObject:[NSString stringWithFormat:@"违停照片_%d",strongSelf.arr_photos.count+1] forKey:@"remarks"];
                    [t_dic setObject:[ShareFun getCurrentTime] forKey:@"taketimes"];
                    [strongSelf.arr_photos addObject:t_dic];
                    [strongSelf.collectionView reloadData];
                    
                }
            }
        }];
        
       
    }else if(indexPath.row == 0){
        
        if (_img_carNumber == nil) {
            
            [self showCameraWithType:1 withFinishBlock:^(LRCameraVC *camera) {
                if (camera) {
                    
                    SW(strongSelf, weakSelf);
                    
                    if (camera.type == 1) {
                        
                        strongSelf.headView.tf_carNumber.text = camera.commonIdentifyResponse.carNo;
                        
                        ImageFileInfo *imageFileInfo = camera.imageInfo;
                        imageFileInfo.name = key_files;
                        NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
                        [t_dic setObject:imageFileInfo forKey:@"files"];
                        [t_dic setObject:@"车牌近照" forKey:@"remarks"];
                        [t_dic setObject:[ShareFun getCurrentTime] forKey:@"taketimes"];
                        
                        strongSelf.img_carNumber = t_dic;
                        [strongSelf.collectionView reloadData];
                
                    }
                }
            }];
        
        }else{
            //当存在车牌近照的时候
            
            NSMutableArray *t_arr = [NSMutableArray array];
            if (_img_carNumber) {
                ImageFileInfo *imageFileInfo = [_img_carNumber objectForKey:@"files"];
                [t_arr addObject:imageFileInfo.image];
            }
            
            if (_img_illegalPark) {
                ImageFileInfo *imageFileInfo = [_img_illegalPark objectForKey:@"files"];
                [t_arr addObject:imageFileInfo.image];
            }
            
            if (_arr_photos) {
                for (NSMutableDictionary *t_dic in _arr_photos) {
                    ImageFileInfo *imageFileInfo = [t_dic objectForKey:@"files"];
                    [t_arr addObject:imageFileInfo.image];
                }
            }
            
            
            LLPhotoBrowser *photoBrowser = [[LLPhotoBrowser alloc] initWithImages:t_arr currentIndex:0];
            [self presentViewController:photoBrowser animated:YES completion:nil];
            
            
        }
        
    }else if(indexPath.row == 1){
        if (_img_carNumber == nil) {
            
            [self showCameraWithType:5 withFinishBlock:^(LRCameraVC *camera) {
                
                if (camera) {
                    
                    SW(strongSelf, weakSelf);
                    if (camera.type == 5) {
                        
                        ImageFileInfo *imageFileInfo = camera.imageInfo;
                        imageFileInfo.name = key_files;
                        NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
                        [t_dic setObject:imageFileInfo forKey:@"files"];
                        [t_dic setObject:@"违停照片_0" forKey:@"remarks"];
                        [t_dic setObject:[ShareFun getCurrentTime] forKey:@"taketimes"];
                        
                        strongSelf.img_illegalPark = t_dic;
                        [strongSelf.collectionView reloadData];


                    }
                }
            }];
            
        }else{
            //当违停照片存在的情况下
           

            
            
        }
    
    }else {
       
        
        
        
    }
    
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

#pragma mark - 模块化弹出照相机

-(void)showCameraWithType:(NSInteger)type withFinishBlock:(void(^)(LRCameraVC *camera))finishBlock{
    
    LRCameraVC *home = [[LRCameraVC alloc] init];
    home.type = type;
    home.fininshCaptureBlock = finishBlock;
    [self presentViewController:home
                       animated:YES
                     completion:^{
                     }];
    
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

#pragma mark - KVO,监听看是否可以提交，用于提交按钮是否可以点击

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"isCanCommit"] && object == _headView) {
        
        if (_headView.isCanCommit == NO) {
            _footView.btn_commit.enabled = NO;
            [_footView.btn_commit setBackgroundColor:UIColorFromRGB(0xe6e6e6)];
        }else{
            _footView.btn_commit.enabled = YES;
            [_footView.btn_commit setBackgroundColor:UIColorFromRGB(0x4281E8)];
        }
    }

}


#pragma mark - 当横竖屏切换时调用

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        NSLog(@"现在是竖屏");
        [_collectionView reloadData];
    }
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        NSLog(@"现在是横屏");
        [_collectionView reloadData];
    }
}

#pragma mark - FootViewDelegate 点击提交按钮事件

- (void)handleCommitClicked{
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    if (_param.carNo) {
        
        if([ShareFun validateCarNumber:_param.carNo] == NO){
            [ShowHUD showError:@"车牌号格式错误" duration:1.f inView:window config:nil];
            return;
        }
        
    }
    
    if (_param.roadId != 0) {
        _param.roadName = nil;
    }
    
    [self configParamInFilesAndRemarksAndTimes];
    
    LxDBObjectAsJson(_param);
    WS(weakSelf);
    
    IllegalParkSaveManger *manger = [[IllegalParkSaveManger alloc] init];
    manger.param = _param;
    manger.successMessage = @"提交成功";
    manger.failMessage = @"提交失败";
    
    ShowHUD *hud = [ShowHUD showWhiteLoadingWithText:@"提交中.." inView:window config:nil];
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [hud hide];
        
        SW(strongSelf, weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {
            
            
            
            
            
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [hud hide];
        
    }];

}

#pragma mark - HeadViewDelegate 点击识别按钮返回回来的数据

- (void)recognitionCarNumber:(ImageFileInfo *)imageInfo{

    imageInfo.name = key_files;
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
    [t_dic setObject:imageInfo forKey:@"files"];
    [t_dic setObject:@"车牌近照" forKey:@"remarks"];
    [t_dic setObject:[ShareFun getCurrentTime] forKey:@"taketimes"];
    
    self.img_carNumber = t_dic;
    
    [_collectionView reloadData];
    
}

#pragma mark - 添加到证件图片到数组中用于上传用的

- (void)addUpItemsByImageInfo:(ImageFileInfo *)imageInfo withTitle:(NSString *)title withTime:(NSString *)takeTime{
    
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
    [t_dic setObject:imageInfo forKey:@"files"];
    [t_dic setObject:title forKey:@"remarks"];
    [t_dic setObject:takeTime forKey:@"taketimes"];
    
    [_arr_upimages addObject:t_dic];
    
}

- (void)configParamInFilesAndRemarksAndTimes{
    
    if (_arr_upimages && _arr_upimages.count > 0) {
        
        NSMutableArray *t_arr_files = [NSMutableArray array];
        NSMutableArray *t_arr_remarks = [NSMutableArray array];
        NSMutableArray *t_arr_taketimes = [NSMutableArray array];
        
        for (int i = 0; i < _arr_upimages.count; i++) {
            NSMutableDictionary *t_dic = _arr_upimages[i];
            ImageFileInfo *imageInfo = [t_dic objectForKey:@"files"];
            NSString *t_title = [t_dic objectForKey:@"remarks"];
            NSString *t_taketime = [t_dic objectForKey:@"taketimes"];
            [t_arr_files addObject:imageInfo];
            [t_arr_remarks addObject:t_title];
            [t_arr_taketimes addObject:t_taketime];
            
        }
        
        _param.files = t_arr_files;
        _param.remarks = t_arr_remarks;
        _param.taketimes = t_arr_taketimes;
    }
    
}

#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    @try {
        [_headView removeObserver:self forKeyPath:@"isCanCommit"];
    }
    @catch (NSException *exception) {
        NSLog(@"多次删除了");
    }
    
    LxPrintf(@"IllegalParkVC dealloc");

}

@end
