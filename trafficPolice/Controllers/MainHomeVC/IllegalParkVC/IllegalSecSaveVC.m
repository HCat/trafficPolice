//
//  IllegalSecSaveVC.m
//  trafficPolice
//
//  Created by hcat on 2017/6/5.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "IllegalSecSaveVC.h"

#import "AccidentAddHeadView.h"
#import "ZLCollectionCell.h"
#import "IllegalParkAddFootView.h"
#import "IllegalThroughSecAddView.h"
#import "LRCameraVC.h"
#import "LLPhotoBrowser.h"
#import "ShareFun.h"
#import "IllegalThroughAPI.h"
#import <UIImageView+WebCache.h>


@interface IllegalSecSaveVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IllegalParkAddFootView *footView;

@property (nonatomic,strong) NSMutableArray *arr_upImages; //用于存储即将上传的图片

@property (nonatomic,strong) IllegalThroughSecSaveParam *param; //请求参数
@property (nonatomic,strong) IllegalThroughSecDetailModel * secDetailModel;//加载之后的第一次数据


@property(nonatomic,assign) BOOL isCanCommit; //是否可以上传

@end

@implementation IllegalSecSaveVC


static NSString *const headId = @"IllegalThroughSecAddViewID";
static NSString *const cellId = @"ZLCollectionCell";
static NSString *const headTitleId = @"IllegalSecSavHeadTitleID";
static NSString *const footId = @"IllegalSecSavFootViewID";



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"闯禁令二次采集";
    
    self.arr_upImages = [NSMutableArray array];
    self.param = [[IllegalThroughSecSaveParam alloc] init];
    self.param.illegalThroughId = _illegalThroughId;
    self.isCanCommit = NO;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"IllegalThroughSecAddView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headId];
    [_collectionView registerNib:[UINib nibWithNibName:@"ZLCollectionCell" bundle:nil] forCellWithReuseIdentifier:cellId];
    [_collectionView registerNib:[UINib nibWithNibName:@"IllegalParkAddFootView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footId];
    [_collectionView registerNib:[UINib nibWithNibName:@"AccidentAddHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headTitleId];
    
    
    [self loadSecIllegalThroughData:_illegalThroughId];
    
    WS(weakSelf);
    //网络断开之后重新连接之后的处理
    self.networkChangeBlock = ^{
        
        SW(strongSelf, weakSelf);
        if (!strongSelf.secDetailModel) {
            [strongSelf loadSecIllegalThroughData:strongSelf.illegalThroughId];
        }
        
    };

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

#pragma mark - 数据请求

- (void)loadSecIllegalThroughData:(NSNumber *)throughId{
    WS(weakSelf);
    
    IllegalThroughSecAddManger *manger = [[IllegalThroughSecAddManger alloc] init];
    manger.illegalThroughId = throughId;
    manger.successMessage = @"加载成功";
    manger.failMessage = @"加载失败";
    SW(strongSelf,weakSelf);
    
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        if (manger.responseModel.code == CODE_SUCCESS) {
            strongSelf.secDetailModel = manger.illegalThroughSecDetailModel;
            [strongSelf.collectionView reloadData];
            
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
}


#pragma mark - UICollectionView Data Source

//返回多少个组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView   *)collectionView
{
    return 2;
}

//返回每组多少个视图
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        if (_secDetailModel && _secDetailModel.pictures && _secDetailModel.pictures.count > 0) {
            return _secDetailModel.pictures.count;
        }

        return 0;
        
    }else{
        
        return [self.arr_upImages count] + 1;
    }
    
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
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    if (indexPath.section == 0) {
        
        AccidentPicListModel *t_model = self.secDetailModel.pictures[indexPath.row];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:t_model.imgUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
        }];
    
    }else{
    
        if (indexPath.row == self.arr_upImages.count) {
            
            cell.imageView.image = [UIImage imageNamed:@"updataPhoto.png"];
        }else{
            
            if (_arr_upImages){
                
                NSMutableDictionary *t_dic = _arr_upImages[indexPath.row];
                ImageFileInfo *imageInfo = [t_dic objectForKey:@"files"];
                cell.imageView.image = imageInfo.image;
                
            }
        
        }
        
    }
    
    
    return cell;
}

// 和UITableView类似，UICollectionView也可设置段头段尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if([kind isEqualToString:UICollectionElementKindSectionHeader])
        {
        
            IllegalThroughSecAddView *headerView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headId forIndexPath:indexPath];
            if (_secDetailModel) {
                headerView.carNumber = _secDetailModel.illegalCollect.carNo;
                headerView.roadName = _secDetailModel.roadName;
            }
            
            return headerView;
            
                      
        }else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
            
        
            
        }
        
    } else {
        
        if([kind isEqualToString:UICollectionElementKindSectionHeader])
        {
            AccidentAddHeadView *headerView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headTitleId forIndexPath:indexPath];
            headerView.lb_title.text = @"二次采集照片";
            
            return headerView;
            
        }else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
            
            self.footView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footId forIndexPath:indexPath];
            
            [_footView setDelegate:(id<IllegalParkAddFootViewDelegate>)self];
            
            return _footView;
            
        }
        
    }
    
    
    return nil;
}

#pragma mark - UICollectionView Delegate method

//选中某个 item 触发
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WS(weakSelf);
    
    if (indexPath.section == 0) {
        
        NSMutableArray *t_arr = [NSMutableArray array];
        
        if (_secDetailModel && _secDetailModel.pictures.count > 0) {
            for (int i = 0; i < self.secDetailModel.pictures.count; i++) {
                NSIndexPath *currentIndexPath = [NSIndexPath indexPathForItem:i inSection:0];
                ZLCollectionCell *currentCell = (ZLCollectionCell *)[_collectionView cellForItemAtIndexPath:currentIndexPath];
                [t_arr addObject:currentCell.imageView.image];
            }

        }
    
        LLPhotoBrowser *photoBrowser = [[LLPhotoBrowser alloc] initWithImages:t_arr currentIndex:indexPath.row];
        photoBrowser.isShowDeleteBtn = NO;
        [self presentViewController:photoBrowser animated:YES completion:nil];
        
    } else {
        if (indexPath.row == _arr_upImages.count) {
            
            [self showCameraWithType:5 withFinishBlock:^(LRCameraVC *camera) {
                if (camera) {
                    
                    SW(strongSelf, weakSelf);
                    
                    if (camera.type == 5) {
                        [strongSelf addUpImageItemToUpImagesWithImageInfo:camera.imageInfo remark:[NSString stringWithFormat:@"二次采集照%d",indexPath.row+1]];
                        [strongSelf.collectionView reloadData];
                        
                    }
                }
            }];
            
        }else {
            
            //当存在车牌近照的时候,弹出图片浏览器
            [self showPhotoBrowserWithIndex:indexPath.row];
            
        }
        
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
    
    if (section == 0) {
        return (CGSize){ScreenWidth,100};
    }else{
        return (CGSize){ScreenWidth,32};
    }
    
}


//footer底部大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        return (CGSize){0,0};
    }else{
        return (CGSize){ScreenWidth,75};
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

#pragma mark - 管理上传图片

//添加图片到arr_upImages数组中
- (void)addUpImageItemToUpImagesWithImageInfo:(ImageFileInfo *)imageFileInfo remark:(NSString *)remark{
    
    imageFileInfo.name = key_files;
    
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
    [t_dic setObject:imageFileInfo forKey:@"files"];
    [t_dic setObject:remark forKey:@"remarks"];
    [t_dic setObject:[ShareFun getCurrentTime] forKey:@"taketimes"];
    [self.arr_upImages addObject:t_dic];
    
    if (self.arr_upImages.count > 0) {
        self.isCanCommit = YES;
    }else{
        self.isCanCommit = NO;
    }
    
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

#pragma mark - FootViewDelegate 点击提交按钮事件

- (void)handleCommitClicked{

    [self configParamInFilesAndRemarksAndTimes];
    
    LxDBObjectAsJson(_param);
    WS(weakSelf);
    
    IllegalThroughSecSaveManger *manger = [[IllegalThroughSecSaveManger alloc] init];
    manger.param =_param;
    manger.successMessage = @"提交成功";
    manger.failMessage = @"提交失败";
    
    ShowHUD *hud = [ShowHUD showWhiteLoadingWithText:@"提交中..." inView:self.view config:nil];
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [hud hide];
        SW(strongSelf, weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {
            [strongSelf.navigationController popViewControllerAnimated:YES];
            if (strongSelf.saveSuccessBlock) {
                strongSelf.saveSuccessBlock();
            }
        }
    
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [hud hide];
    }];
    
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

#pragma mark - 调用图片浏览器

-(void)showPhotoBrowserWithIndex:(NSInteger)index {
    
    //将arr_upImages中有图片的赋值到t_arr中用于LLPhotoBrowser中
    
    NSMutableArray *t_arr = [_arr_upImages mutableCopy];
    
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
                    
                    [strongSelf.arr_upImages removeObject:t_dic];
                    
                    [strongSelf.collectionView reloadData];
                    
                    //替换之后做是否可以上传判断
                    if (strongSelf.arr_upImages.count > 0) {
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

    LxPrintf(@"IllegalSecSaveVC dealloc");

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
