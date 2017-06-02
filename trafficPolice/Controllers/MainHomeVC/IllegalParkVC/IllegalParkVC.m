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
#import "CountAccidentHelper.h"

@interface IllegalParkVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property (nonatomic, strong) IllegalParkAddHeadView *headView;
@property (nonatomic, strong) IllegalParkAddFootView *footView;

@property (nonatomic,strong) IllegalParkSaveParam *param; //请求参数

@property (nonatomic,assign) BOOL isObserver;

@property (nonatomic,strong) NSMutableArray *arr_upimages; //用于存储即将上传的图片

@property (nonatomic, strong) LLPhotoBrowser *photoBrowser;



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
    self.arr_upimages = [NSMutableArray array];
    [self.arr_upimages addObject:[NSNull null]];
    [self.arr_upimages addObject:[NSNull null]];
    
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
    return [self.arr_upimages count] + 1;
}
//返回视图的具体事例，我们的数据关联就是放在这里
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IllegalParkCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IllegalParkCell" forIndexPath:indexPath];
   
    cell.imageView.layer.cornerRadius = 5.0f;
    cell.imageView.layer.masksToBounds = YES;
    
    if (indexPath.row == self.arr_upimages.count) {
        
        cell.lb_title.text = @"更多照片";
        cell.imageView.image = [UIImage imageNamed:@"updataPhoto.png"];
        
    }else if(indexPath.row == 0){
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.lb_title.text = @"车牌近照";
    }else if(indexPath.row == 1){
        
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.lb_title.text = @"违停照片";
    }else {
        cell.lb_title.text = @"更多照片";
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    
    if (indexPath.row != self.arr_upimages.count ) {
        if ([_arr_upimages[indexPath.row] isKindOfClass:[NSNull class]]) {
            cell.imageView.image = [UIImage imageNamed:@"updataPhoto.png"];
        }else{
            NSMutableDictionary *t_dic = _arr_upimages[indexPath.row];
            ImageFileInfo *imageInfo = [t_dic objectForKey:@"files"];
            cell.imageView.image = imageInfo.image;
        }
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
    
    if (indexPath.row == _arr_upimages.count) {
       
        [self showCameraWithType:5 withFinishBlock:^(LRCameraVC *camera) {
            if (camera) {
                SW(strongSelf, weakSelf);
                if (camera.type == 5) {
                    
                    ImageFileInfo *imageFileInfo = camera.imageInfo;
                    imageFileInfo.name = key_files;
                    
                    NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
                    [t_dic setObject:imageFileInfo forKey:@"files"];
                    [t_dic setObject:[NSString stringWithFormat:@"违停照片_%d",strongSelf.arr_upimages.count -1] forKey:@"remarks"];
                    [t_dic setObject:[ShareFun getCurrentTime] forKey:@"taketimes"];
                    [strongSelf.arr_upimages addObject:t_dic];
                    [strongSelf.collectionView reloadData];
                    
                }
            }
        }];
        
       
    }else if(indexPath.row == 0){
        
        if ([_arr_upimages[indexPath.row] isKindOfClass:[NSNull class]]) {
            
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
                        strongSelf.param.carNo = camera.commonIdentifyResponse.carNo;
                        if (camera.commonIdentifyResponse.carNo > 0 ) {
                            [[CountAccidentHelper sharedDefault] setCarNo:self.param.carNo];
                        }
                        strongSelf.headView.isCanCommit = [strongSelf.headView juegeCanCommit];
                        [strongSelf.arr_upimages  replaceObjectAtIndex:indexPath.row withObject:t_dic];
                        [strongSelf.collectionView reloadData];
                
                    }
                }
            }];
        
        }else{
            //当存在车牌近照的时候
            [self handleUpImagesWithIndex:indexPath.row];
        
        }
        
    }else if(indexPath.row == 1){
        
        if ([_arr_upimages[indexPath.row] isKindOfClass:[NSNull class]]) {
            
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
                        
                        [strongSelf.arr_upimages replaceObjectAtIndex:indexPath.row withObject:t_dic];
                        [strongSelf.collectionView reloadData];
                        

                    }
                }
            }];
            
        }else{
            //当违停照片存在的情况下
           
            if ([_arr_upimages[0] isKindOfClass:[NSNull class]]) {
                [self handleUpImagesWithIndex:indexPath.row-1];
            }else {
                [self handleUpImagesWithIndex:indexPath.row];
            }
            
            
        }
    
    }else {
        //当更多照片存在的情况下
        if ([_arr_upimages[0] isKindOfClass:[NSNull class]] && [_arr_upimages[1] isKindOfClass:[NSNull class]]) {
            [self handleUpImagesWithIndex:indexPath.row-2];
        }else {
            if ([_arr_upimages[0] isKindOfClass:[NSNull class]] || [_arr_upimages[1] isKindOfClass:[NSNull class]]) {
                [self handleUpImagesWithIndex:indexPath.row-1];
            }else{
                [self handleUpImagesWithIndex:indexPath.row];
            }
        
        }
        
        
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
    
    if ([_param.roadId integerValue] != 0) {
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
            strongSelf.param = [[IllegalParkSaveParam alloc] init];
            
            [strongSelf.arr_upimages removeAllObjects];
            [strongSelf.arr_upimages addObject:[NSNull null]];
            [strongSelf.arr_upimages addObject:[NSNull null]];
            
            [strongSelf.collectionView reloadData];
            
            [[LocationHelper sharedDefault] startLocation];
            
            strongSelf.headView.param = strongSelf.param;
            strongSelf.headView.tf_roadSection.text = nil;
            strongSelf.headView.tf_address.text = nil;
            strongSelf.headView.tf_carNumber.text = nil;
            if (strongSelf.headView.tf_addressRemarks.text.length > 0) {
                strongSelf.param.addressRemark = strongSelf.headView.tf_addressRemarks.text;
            }
            strongSelf.headView.isCanCommit = [strongSelf.headView juegeCanCommit];
            
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
    
    [_arr_upimages replaceObjectAtIndex:0 withObject:t_dic];
   
    [_collectionView reloadData];
    
}

#pragma mark - 处理arr_upImages用于上传用的

-(void)handleUpImagesWithIndex:(NSInteger)index{


    NSMutableArray *t_arr = [NSMutableArray array];
    
    for (int i = 0; i < [_arr_upimages count]; i++) {
        if ([_arr_upimages[i] isKindOfClass:[NSMutableDictionary class]]) {
            [t_arr addObject:_arr_upimages[i]];
        }
    }
    
    WS(weakSelf);
    
    self.photoBrowser = [[LLPhotoBrowser alloc] initWithupImages:t_arr currentIndex:index];
    self.photoBrowser.deleteBlock = ^(NSMutableDictionary *deleteImage) {
        SW(strongSelf, weakSelf);
        for (int i = 0; i < [_arr_upimages count]; i++) {
            if ([strongSelf.arr_upimages[i] isKindOfClass:[NSMutableDictionary class]]) {
                NSMutableDictionary *t_dic = strongSelf.arr_upimages[i];
                NSString *t_str = [t_dic objectForKey:@"remarks"];
                if ([t_str isEqualToString:[deleteImage objectForKey:@"remarks"]]) {
                    if ([t_str isEqualToString:@"车牌近照"] || [t_str isEqualToString:@"违停照片_0"]) {
                        [strongSelf.arr_upimages replaceObjectAtIndex:i withObject:[NSNull null]];
                        [strongSelf.collectionView reloadData];
                        
                    }else{
                        [strongSelf.arr_upimages removeObject:t_dic];
                        [strongSelf.collectionView reloadData];
                    }
                    break;
                }
                
            }
        }
        
    };
    [self presentViewController:_photoBrowser animated:YES completion:nil];

}

- (void)configParamInFilesAndRemarksAndTimes{
    
    if (_arr_upimages && _arr_upimages.count > 0) {
        
        
        LxDBObjectAsJson(_arr_upimages);
        
        NSMutableArray *t_arr_files = [NSMutableArray array];
        NSMutableArray *t_arr_remarks = [NSMutableArray array];
        NSMutableArray *t_arr_taketimes = [NSMutableArray array];
        
        for (int i = 0; i < _arr_upimages.count; i++) {
            if([_arr_upimages[i] isKindOfClass:[NSMutableDictionary class]]){
                NSMutableDictionary *t_dic = _arr_upimages[i];
                ImageFileInfo *imageInfo = [t_dic objectForKey:@"files"];
                NSString *t_title = [t_dic objectForKey:@"remarks"];
                NSString *t_taketime = [t_dic objectForKey:@"taketimes"];
                [t_arr_files addObject:imageInfo];
                [t_arr_remarks addObject:t_title];
                [t_arr_taketimes addObject:t_taketime];
            
            }
        
        }
        if (t_arr_files.count > 0) {
            _param.files = t_arr_files;
        }
        
        if (t_arr_remarks.count > 0) {
            
             _param.remarks = [t_arr_remarks componentsJoinedByString:@","];
        }
        
        if (t_arr_taketimes.count > 0) {
            _param.taketimes = [t_arr_taketimes componentsJoinedByString:@","];
        }

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
