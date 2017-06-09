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
#import "IllegalThroughAPI.h" //违禁令
#import "LLPhotoBrowser.h"
#import "SRAlertView.h"
#import "IllegalSecSaveVC.h"

@interface IllegalParkVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property (nonatomic, strong) IllegalParkAddHeadView *headView;
@property (nonatomic, strong) IllegalParkAddFootView *footView;

@property (nonatomic,strong) IllegalParkSaveParam *param; //请求参数

@property (nonatomic,assign) BOOL isObserver;   //用于注册isCanCommit的KVC,如果注册了设置YES，防止重复注册

@property (nonatomic,strong) NSMutableArray *arr_upImages; //用于存储即将上传的图片

@property (nonatomic,assign) BOOL isCanCommit; //需要可以上传的条件有两个，一个是需要车牌近照和违停照片，还有就是headView中的必填字段



@end

@implementation IllegalParkVC

static NSString *const cellId = @"IllegalParkCell";
static NSString *const footId = @"IllegalParkAddFootViewID";
static NSString *const headId = @"IllegalParkAddHeadViewID";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_illegalType == IllegalTypePark) {
        self.title = @"违停采集";
    }else if(_illegalType == IllegalTypeThrough){
        self.title = @"闯禁令采集";
    }
    
    
    self.isObserver = NO;
   

    //初始化请求参数
    self.param = [[IllegalParkSaveParam alloc] init];
    
    //初始化图片数据，加入两个空对象，分别对应车牌近照，违停照片
    //如果有了车牌近照和违停照片则替换掉这两个空对象，如果没有则替换回来空对象
    self.arr_upImages = [NSMutableArray array];
    [self.arr_upImages addObject:[NSNull null]];
    [self.arr_upImages addObject:[NSNull null]];
    
    //注册collection格式
    [_collectionView registerNib:[UINib nibWithNibName:@"IllegalParkCell" bundle:nil] forCellWithReuseIdentifier:cellId];
    [_collectionView registerNib:[UINib nibWithNibName:@"IllegalParkAddFootView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footId];
    [_collectionView registerNib:[UINib nibWithNibName:@"IllegalParkAddHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headId];
    
    [self getCommonRoad];
    
    //断网之后重新连接网络事件
    WS(weakSelf);
    self.networkChangeBlock = ^{
        if ([ShareValue sharedDefault].roadModels == nil) {
            [weakSelf getCommonRoad];
        }
    };
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark - set && get 

- (void)setIsCanCommit:(BOOL)isCanCommit{

    _isCanCommit = isCanCommit;
    

    if (_isCanCommit) {
        _footView.btn_commit.enabled = YES;
        [_footView.btn_commit setBackgroundColor:UIColorFromRGB(0x4281E8)];
        
    }else{
        _footView.btn_commit.enabled = NO;
        [_footView.btn_commit setBackgroundColor:UIColorFromRGB(0xe6e6e6)];
    
    }
}

#pragma mark -  请求网络数据
//如果类型为闯禁令，输入或者识别车牌号的时候需要请求是否需要二次采集，如果需要二次采集则跳到二次采集页面
- (void)judgeNeedSecondCollection:(NSString *)carNumber{
    
    if (carNumber && carNumber.length > 0 && [ShareFun validateCarNumber:carNumber]) {
        
        WS(weakSelf);
        //获取roadId
        [_headView getRoadId];
        //这里待优化，如果说获取得到的roadId为0的情况的话
        IllegalThroughQuerySecManger *manger = [[IllegalThroughQuerySecManger alloc] init];
        manger.isNeedShowHud = NO;
        manger.carNo = carNumber;
        manger.roadId = _param.roadId;
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        /*code:0 超过90秒有一次采集记录，返回一次采集ID、采集时间，提示“同路段该车于yyyy-MM-dd已被拍照采集”，跳转至二次采集页面
          code:110 提示“同路段当天已有违章行为，请不要重复采集！”
          code:13 提示“同路段该车1分30秒内有采集记录，是否重新采集？”
          code:999 无采集记录,不用任何提示
         */
        SW(strongSelf, weakSelf);
        LxPrintf(@"%ld",(long)manger.responseModel.code);
        if (manger.responseModel.code == 0) {
            
            [strongSelf showAlertViewWithcontent:manger.responseModel.msg leftTitle:@"确定" rightTitle:nil block:^(AlertViewActionType actionType) {
                if (actionType == AlertViewActionTypeLeft) {
                    NSNumber * illegalThroughId = manger.responseModel.data[@"id"];
                    IllegalSecSaveVC *t_vc = [[IllegalSecSaveVC alloc] init];
                    t_vc.illegalThroughId = illegalThroughId;
                    t_vc.saveSuccessBlock = ^{
                        [strongSelf.arr_upImages removeAllObjects];
                        [strongSelf.arr_upImages addObject:[NSNull null]];
                        [strongSelf.arr_upImages addObject:[NSNull null]];
                        
                        [strongSelf.collectionView reloadData];
                        
                        strongSelf.headView.param = strongSelf.param;
                        [strongSelf.headView handleBeforeCommit];
                    };
                    [strongSelf.navigationController pushViewController:t_vc animated:YES];
                }
            }];
            
        }else if (manger.responseModel.code == 13){
            
            [strongSelf showAlertViewWithcontent:manger.responseModel.msg leftTitle:@"重新录入" rightTitle:@"取消" block:^(AlertViewActionType actionType) {
                
                if (actionType == AlertViewActionTypeLeft) {
                    
                    if (strongSelf.headView.isCanCommit == YES && ![strongSelf.arr_upImages[0] isKindOfClass:[NSNull class]] && ![strongSelf.arr_upImages[1] isKindOfClass:[NSNull class]]) {
                        strongSelf.isCanCommit = YES;
                    }else{
                        strongSelf.isCanCommit = NO;
                    }
                    
                    if (strongSelf.isCanCommit == YES) {
                        [strongSelf handleCommitClicked];
                    }
                    
                }else if (actionType == AlertViewActionTypeRight){
                
                    [strongSelf.navigationController popViewControllerAnimated:YES];
                
                }
                
            }];
            
        
        }else if (manger.responseModel.code == 110){
        
           [strongSelf showAlertViewWithcontent:manger.responseModel.msg leftTitle:@"确定" rightTitle:nil block:nil];
            
        }else if (manger.responseModel.code == 999){
            //不做处理
            //无任何记录，无需做处理
        }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
    }

}

//获取道路ID
- (void)getCommonRoad{

    WS(weakSelf);
    CommonGetRoadManger *manger = [[CommonGetRoadManger alloc] init];
    manger.isNeedShowHud = NO;
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {
            [ShareValue sharedDefault].roadModels = manger.commonGetRoadResponse;
            if (strongSelf.headView) {
                [strongSelf.headView getRoadId];
            }
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];

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
    return [self.arr_upImages count] + 1;
}

//返回视图的具体事例，我们的数据关联就是放在这里
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IllegalParkCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IllegalParkCell" forIndexPath:indexPath];
   
    cell.imageView.layer.cornerRadius = 5.0f;
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    if (indexPath.row == self.arr_upImages.count) {
        
        cell.lb_title.text = @"更多照片";
        cell.imageView.image = [UIImage imageNamed:@"updataPhoto.png"];
    }else{
        
        if(indexPath.row == 0){
            cell.lb_title.text = @"车牌近照";
        }else if(indexPath.row == 1){
            
            if (_illegalType == IllegalTypePark) {
                cell.lb_title.text = @"违停照片";
            }else if(_illegalType == IllegalTypeThrough){
                cell.lb_title.text = @"闯禁令照片";
            }
            
        }else {
            
            if (_illegalType == IllegalTypePark) {
                cell.lb_title.text = [NSString stringWithFormat:@"违停照片%d",indexPath.row];
            }else if(_illegalType == IllegalTypeThrough){
                cell.lb_title.text = [NSString stringWithFormat:@"闯禁令照片%d",indexPath.row];
            }
        
        }
    
        //判断是否拥有图片，如果拥有则显示图片，如果没有则显示@“updataPhoto.png”的图片
        //主要用于分辨车牌近照，和违停照片有没有图片
        if ([_arr_upImages[indexPath.row] isKindOfClass:[NSNull class]]) {
            
            cell.imageView.image = [UIImage imageNamed:@"updataPhoto.png"];
            
        }else{
            
            NSMutableDictionary *t_dic = _arr_upImages[indexPath.row];
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
            
            //监听headView中的isCanCommit来判断是否可以上传
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
    
    if (indexPath.row == _arr_upImages.count) {
        
        [self showCameraWithType:5 withFinishBlock:^(LRCameraVC *camera) {
            if (camera) {
                
                SW(strongSelf, weakSelf);
                
                if (camera.type == 5) {
                    if (_illegalType == IllegalTypePark) {
                        [strongSelf addUpImageItemToUpImagesWithImageInfo:camera.imageInfo remark:[NSString stringWithFormat:@"违停照片%d",indexPath.row]];
                    }else if(_illegalType == IllegalTypeThrough){
                        [strongSelf addUpImageItemToUpImagesWithImageInfo:camera.imageInfo remark:[NSString stringWithFormat:@"闯禁令照片%d",indexPath.row]];
                    }
                    
                    [strongSelf.collectionView reloadData];
                    
                }
            }
        }];
        
    }else if(indexPath.row == 0){
        
        if ([_arr_upImages[0] isKindOfClass:[NSNull class]]) {
            
            [self showCameraWithType:1 withFinishBlock:^(LRCameraVC *camera) {
                if (camera) {
                    
                    SW(strongSelf, weakSelf);
                    
                    if (camera.type == 1) {
                        
                        //替换车牌近照的图片
                        [self replaceUpImageItemToUpImagesWithImageInfo:camera.imageInfo remark:@"车牌近照" replaceIndex:0];
                        
                        //识别之后所做的操作
                        [strongSelf.headView takePhotoToDiscernmentWithCarNumber:camera.commonIdentifyResponse.carNo];
                        
                        if (_illegalType == IllegalTypeThrough) {
                            [strongSelf judgeNeedSecondCollection:strongSelf.param.carNo];
                        }
                        
                        [strongSelf.collectionView reloadData];
                
                    }
                }
            }];
        
        }else{
            //当存在车牌近照的时候,弹出图片浏览器
            [self showPhotoBrowserWithIndex:0];
        }
        
    }else if(indexPath.row == 1){
        
        if ([_arr_upImages[1] isKindOfClass:[NSNull class]]) {
            [self showCameraWithType:5 withFinishBlock:^(LRCameraVC *camera) {
                if (camera) {
                    SW(strongSelf, weakSelf);
                    if (camera.type == 5) {
                        //替换违停照片的图片
                        
                        if (_illegalType == IllegalTypePark) {
                            [self replaceUpImageItemToUpImagesWithImageInfo:camera.imageInfo remark:@"违停照片" replaceIndex:1];
                            [strongSelf.collectionView reloadData];
                        }else if(_illegalType == IllegalTypeThrough){
                            [self replaceUpImageItemToUpImagesWithImageInfo:camera.imageInfo remark:@"闯禁令照片" replaceIndex:1];
                            [strongSelf.collectionView reloadData];
                        }

                        
                        
    
                    }
                }
            }];
            
        }else{
            
            //当违停照片存在的情况下,弹出图片浏览器,如果车牌近照有的情况下图片索引为1,如果没有则图片索引变成0
            //
            if ([_arr_upImages[0] isKindOfClass:[NSNull class]]) {
                [self showPhotoBrowserWithIndex:0];
            }else {
                [self showPhotoBrowserWithIndex:1];
            }
    
        }
    
    }else {
        //当更多照片存在的情况下,弹出图片浏览器,下面判断图片索引
        if ([_arr_upImages[0] isKindOfClass:[NSNull class]] && [_arr_upImages[1] isKindOfClass:[NSNull class]]) {
            [self showPhotoBrowserWithIndex:indexPath.row-2];
        }else {
            if ([_arr_upImages[0] isKindOfClass:[NSNull class]] || [_arr_upImages[1] isKindOfClass:[NSNull class]]) {
                [self showPhotoBrowserWithIndex:indexPath.row-1];
            }else{
                [self showPhotoBrowserWithIndex:indexPath.row];
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
            self.isCanCommit = NO;
        }else{
            if ([_arr_upImages[0] isKindOfClass:[NSNull class]] || [_arr_upImages[1] isKindOfClass:[NSNull class]]) {
                self.isCanCommit = NO;
            }else{
                self.isCanCommit = YES;
            }
        
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
    
    if (_illegalType == IllegalTypePark) {
        
        //违停请求
        IllegalParkSaveManger *manger = [[IllegalParkSaveManger alloc] init];
        manger.param = _param;
        manger.successMessage = @"提交成功";
        manger.failMessage = @"提交失败";
        
        ShowHUD *hud = [ShowHUD showWhiteLoadingWithText:@"提交中.." inView:window config:nil];
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            [hud hide];
            SW(strongSelf, weakSelf);
            
            //异步请求通用路名ID,这里需要请求的原因是当传入的roadID为0的情况下，需要重新去服务器里面拉取路名来匹配
            if ([strongSelf.param.roadId isEqualToNumber:@0]) {
                [strongSelf getCommonRoad];
            }
            
            if (manger.responseModel.code == CODE_SUCCESS) {
                
                strongSelf.param = [[IllegalParkSaveParam alloc] init];
                
                [strongSelf.arr_upImages removeAllObjects];
                [strongSelf.arr_upImages addObject:[NSNull null]];
                [strongSelf.arr_upImages addObject:[NSNull null]];
                
                [strongSelf.collectionView reloadData];
                
                strongSelf.headView.param = strongSelf.param;
                [strongSelf.headView handleBeforeCommit];
                
            }else if (manger.responseModel.code == CODE_FAILED){
                
               [strongSelf showAlertViewWithcontent:manger.responseModel.msg leftTitle:@"确定" rightTitle:nil block:nil];
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            [hud hide];
            
        }];
    }else if (_illegalType == IllegalTypeThrough){
        
        //违禁令请求
        IllegalThroughSaveManger *manger = [[IllegalThroughSaveManger alloc] init];
        manger.param = _param;
        manger.successMessage = @"提交成功";
        manger.failMessage = @"提交失败";
        
        ShowHUD *hud = [ShowHUD showWhiteLoadingWithText:@"提交中.." inView:window config:nil];
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            [hud hide];
            SW(strongSelf, weakSelf);
            
            //异步请求通用路名ID,这里需要请求的原因是当传入的roadID为0的情况下，需要重新去服务器里面拉取路名来匹配
            if ([strongSelf.param.roadId isEqualToNumber:@0]) {
               [strongSelf getCommonRoad];
            }
            
            if (manger.responseModel.code == CODE_SUCCESS) {
                
                strongSelf.param = [[IllegalParkSaveParam alloc] init];
                
                [strongSelf.arr_upImages removeAllObjects];
                [strongSelf.arr_upImages addObject:[NSNull null]];
                [strongSelf.arr_upImages addObject:[NSNull null]];
                
                [strongSelf.collectionView reloadData];
                
                strongSelf.headView.param = strongSelf.param;
                [strongSelf.headView handleBeforeCommit];
                
            }else if (manger.responseModel.code == 110){
            
                [strongSelf showAlertViewWithcontent:manger.responseModel.msg leftTitle:@"确定" rightTitle:nil block:^(AlertViewActionType actionType) {
                    
                    if (actionType == AlertViewActionTypeLeft) {
                        NSNumber * illegalThroughId = manger.responseModel.data[@"id"];
                        IllegalSecSaveVC *t_vc = [[IllegalSecSaveVC alloc] init];
                        t_vc.illegalThroughId = illegalThroughId;
                        t_vc.saveSuccessBlock = ^{
                            [strongSelf.arr_upImages removeAllObjects];
                            [strongSelf.arr_upImages addObject:[NSNull null]];
                            [strongSelf.arr_upImages addObject:[NSNull null]];
                            
                            [strongSelf.collectionView reloadData];
                            
                            strongSelf.headView.param = strongSelf.param;
                            [strongSelf.headView handleBeforeCommit];
                        };
                        [strongSelf.navigationController pushViewController:t_vc animated:YES];
                    }
                }];
               
            }else if (manger.responseModel.code == 100){
            
                [strongSelf showAlertViewWithcontent:manger.responseModel.msg leftTitle:@"确定" rightTitle:nil block:nil];
               
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            [hud hide];
            
        }];
    
    
    
    }

}

#pragma mark - HeadViewDelegate 点击识别按钮返回回来的数据

- (void)recognitionCarNumber:(ImageFileInfo *)imageInfo{

    [self replaceUpImageItemToUpImagesWithImageInfo:imageInfo remark:@"车牌近照" replaceIndex:0];
    [_collectionView reloadData];
    
    if (_illegalType == IllegalTypeThrough) {
        [self judgeNeedSecondCollection:self.param.carNo];
    }
    
}

- (void)listentCarNumber{

    if (_illegalType == IllegalTypeThrough) {
        [self judgeNeedSecondCollection:self.param.carNo];
    }
    

}

#pragma mark - 管理上传图片

//替换图片到arr_upImages数组中
- (void)replaceUpImageItemToUpImagesWithImageInfo:(ImageFileInfo *)imageFileInfo remark:(NSString *)remark replaceIndex:(NSInteger)index{
    
    imageFileInfo.name = key_files;
    
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
    [t_dic setObject:imageFileInfo forKey:@"files"];
    [t_dic setObject:remark forKey:@"remarks"];
    [t_dic setObject:[ShareFun getCurrentTime] forKey:@"taketimes"];
    [self.arr_upImages  replaceObjectAtIndex:index withObject:t_dic];
    
    //替换之后做是否可以上传判断
    if (_headView.isCanCommit == YES && ![_arr_upImages[0] isKindOfClass:[NSNull class]] && ![_arr_upImages[1] isKindOfClass:[NSNull class]]) {
        self.isCanCommit = YES;
    }else{
        self.isCanCommit = NO;
    }
  
}


//添加图片到arr_upImages数组中
- (void)addUpImageItemToUpImagesWithImageInfo:(ImageFileInfo *)imageFileInfo remark:(NSString *)remark{

    imageFileInfo.name = key_files;
    
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
    [t_dic setObject:imageFileInfo forKey:@"files"];
    [t_dic setObject:remark forKey:@"remarks"];
    [t_dic setObject:[ShareFun getCurrentTime] forKey:@"taketimes"];
    [self.arr_upImages addObject:t_dic];
    
}

- (void)configParamInFilesAndRemarksAndTimes{
    
    if (_arr_upImages && _arr_upImages.count > 0) {
        
        LxDBObjectAsJson(_arr_upImages);
        
        NSMutableArray *t_arr_files = [NSMutableArray array];
        NSMutableArray *t_arr_remarks = [NSMutableArray array];
        NSMutableArray *t_arr_taketimes = [NSMutableArray array];
        
        for (int i = 0; i < _arr_upImages.count; i++) {
            if([_arr_upImages[i] isKindOfClass:[NSMutableDictionary class]]){
                NSMutableDictionary *t_dic = _arr_upImages[i];
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


#pragma mark - 弹出照相机

-(void)showCameraWithType:(NSInteger)type withFinishBlock:(void(^)(LRCameraVC *camera))finishBlock{
    
    LRCameraVC *home = [[LRCameraVC alloc] init];
    home.type = type;
    home.fininshCaptureBlock = finishBlock;
    [self presentViewController:home
                       animated:YES
                     completion:^{
                     }];
    
}

#pragma mark - 弹出提示框

-(void)showAlertViewWithcontent:(NSString *)content leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle block:(AlertViewDidSelectAction)selectAction{

    SRAlertView *alertView = [[SRAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:content
                                                leftActionTitle:leftTitle
                                               rightActionTitle:rightTitle
                                                 animationStyle:AlertViewAnimationNone
                                                   selectAction:selectAction];
    alertView.blurCurrentBackgroundView = NO;
    alertView.actionWhenHighlightedBackgroundColor = UIColorFromRGB(0x4281E8);
    [alertView show];


}


#pragma mark - 调用图片浏览器

-(void)showPhotoBrowserWithIndex:(NSInteger)index{
    
    //将arr_upImages中有图片的赋值到t_arr中用于LLPhotoBrowser中
    
    NSMutableArray *t_arr = [NSMutableArray array];
    
    for (int i = 0; i < [_arr_upImages count]; i++) {
        if ([_arr_upImages[i] isKindOfClass:[NSMutableDictionary class]]) {
            [t_arr addObject:_arr_upImages[i]];
        }
    }
    
    WS(weakSelf);
    
    LLPhotoBrowser *photoBrowser = [[LLPhotoBrowser alloc] initWithupImages:t_arr currentIndex:index];
    
    //在图片浏览器中点击删除按钮的操作
    photoBrowser.deleteBlock = ^(NSMutableDictionary *deleteImage) {
        
        SW(strongSelf, weakSelf);
        
        for (int i = 0; i < [_arr_upImages count]; i++) {
            
            if ([strongSelf.arr_upImages[i] isKindOfClass:[NSMutableDictionary class]]) {
                
                NSMutableDictionary *t_dic = strongSelf.arr_upImages[i];
                
                NSString *t_str = [t_dic objectForKey:@"remarks"];
                
                if ([t_str isEqualToString:[deleteImage objectForKey:@"remarks"]]) {
                    
                    if ([t_str isEqualToString:@"车牌近照"] || [t_str isEqualToString:@"违停照片"]) {
                        
                        [strongSelf.arr_upImages replaceObjectAtIndex:i withObject:[NSNull null]];
                        
                        [strongSelf.collectionView reloadData];
                        
                    }else{
                        
                        [strongSelf.arr_upImages removeObject:t_dic];
                        
                        [strongSelf.collectionView reloadData];
                    }
                    
                    //替换之后做是否可以上传判断
                    if (strongSelf.headView.isCanCommit == YES && ![strongSelf.arr_upImages[0] isKindOfClass:[NSNull class]] && ![strongSelf.arr_upImages[1] isKindOfClass:[NSNull class]]) {
                        strongSelf.isCanCommit = YES;
                    }else{
                        strongSelf.isCanCommit = NO;
                    }
                    
                    break;
                }
                
            }
        }
        
    };
    
    [self presentViewController:photoBrowser animated:YES completion:nil];
    
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
