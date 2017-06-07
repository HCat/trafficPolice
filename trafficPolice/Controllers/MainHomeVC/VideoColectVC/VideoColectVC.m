//
//  VideoColectVC.m
//  trafficPolice
//
//  Created by hcat on 2017/6/5.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "VideoColectVC.h"
#import "FSTextView.h"
#import "VideoColectAPI.h"
#import "AppDelegate.h"
#import "LRVideoVC.h"
#import "LRPlayVC.h"

#import "ArtVideoModel.h"
#import "ArtVideoUtil.h"

@interface VideoColectVC ()

@property (weak, nonatomic) IBOutlet UIButton *btn_InputVideo;
@property (weak, nonatomic) IBOutlet UITextField *tf_address;
@property (weak, nonatomic) IBOutlet FSTextView *tv_memo;
@property (weak, nonatomic) IBOutlet UIButton *btn_commit;
@property (weak, nonatomic) IBOutlet UILabel *lb_tvCount;

@property (strong,nonatomic) VideoColectSaveParam *param;
@property (nonatomic,assign) BOOL isCanCommit;

@property (weak, nonatomic) IBOutlet UIView *v_video;
@property (weak, nonatomic) IBOutlet UIButton *btn_video;


@property (nonatomic,strong) ArtVideoModel *currentRecord;


@end

@implementation VideoColectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"视频录入";
    
    self.v_video.hidden = YES;
    self.param = [[VideoColectSaveParam alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChange) name:NOTIFICATION_CHANGELOCATION_SUCCESS object:nil];
    
    //重新定位下
    [[LocationHelper sharedDefault] startLocation];
    self.isCanCommit = NO;
    
    //配置FSTextView
    [self.tv_memo setDelegate:(id<UITextViewDelegate> _Nullable)self];
    self.tv_memo.placeholder = @"请输入备注";
    self.tv_memo.maxLength = 150;   //最大输入字数
    WS(weakSelf);
    [self.tv_memo addTextDidChangeHandler:^(FSTextView *textView) {
        // 文本改变后的相应操作.
        weakSelf.lb_tvCount.text =
        [NSString stringWithFormat:@"%d/%d",textView.text.length,textView.maxLength];
        
    }];
    // 添加到达最大限制Block回调.
    [self.tv_memo addTextLengthDidMaxHandler:^(FSTextView *textView) {
        // 达到最大限制数后的相应操作.
    }];
    
    CGRect frame = [_tf_address frame];
    frame.size.width = 7.0f;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    _tf_address.leftViewMode = UITextFieldViewModeAlways;
    _tf_address.leftView = leftview;
    
}

#pragma mark - set && get 

- (void)setIsCanCommit:(BOOL)isCanCommit{

    _isCanCommit = isCanCommit;

    if (_isCanCommit) {
        _btn_commit.enabled = YES;
        [_btn_commit setBackgroundColor:UIColorFromRGB(0x4281E8)];
    } else {
        _btn_commit.enabled = NO;
        [_btn_commit setBackgroundColor:UIColorFromRGB(0xe6e6e6)];
    }
}

#pragma mark - buttonAction

#pragma mark - 视频点击播放事件
- (IBAction)handleBtnVideoPlayClicked:(id)sender {
    
    LRPlayVC *t_vc = [[LRPlayVC alloc] init];
    t_vc.videoUrl = self.currentRecord.videoAbsolutePath;
    WS(weakSelf);
    t_vc.deleteBlock = ^{
        SW(strongSelf, weakSelf);
        strongSelf.v_video.hidden =YES;
        strongSelf.currentRecord = nil;
        strongSelf.isCanCommit = NO;
    };
    [self.navigationController pushViewController:t_vc animated:YES];
    
}


#pragma mark - 视频点击录入事件
- (IBAction)handlebtnInputVideoClicked:(id)sender {
    
    WS(weakSelf);
    LRVideoVC *t_videoVC = [[LRVideoVC alloc] init];
    t_videoVC.recordComplete = ^(ArtVideoModel *currentRecord) {
        SW(strongSelf, weakSelf);
        strongSelf.currentRecord = currentRecord;
        strongSelf.v_video.hidden = NO;
        [strongSelf.btn_video setImage:[UIImage imageWithContentsOfFile:strongSelf.currentRecord.thumAbsolutePath] forState:UIControlStateNormal];
        strongSelf.isCanCommit = YES;
    };
    [self presentViewController:t_videoVC
                       animated:YES
                     completion:^{
                     }];
}

#pragma mark -重新定位点击事件
- (IBAction)handlebtnLocationClicked:(id)sender {
    [[LocationHelper sharedDefault] startLocation];
    
}



#pragma mark - 提交按钮事件点击
- (IBAction)handleBtnCommitClicked:(id)sender {
    
    VideoColectSaveManger *manger = [[VideoColectSaveManger alloc] init];
    
    if (self.currentRecord && self.currentRecord.videoAbsolutePath.length > 0) {
        if ([ArtVideoUtil existVideo]) {
            self.currentRecord.fileData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:self.currentRecord.videoAbsolutePath]];
            self.currentRecord.fileName = self.currentRecord.videoRelativePath;
            self.currentRecord.name  = @"file";
            self.currentRecord.mimeType = @"video/mpeg";
            self.param.file = self.currentRecord;
            ImageFileInfo *imageInfo = [[ImageFileInfo alloc] initWithImage:[UIImage imageWithContentsOfFile:self.currentRecord.thumAbsolutePath] withName:@"preview"];
            self.param.preview = imageInfo;
            self.param.videoLength = @([ArtVideoUtil getVideoLength:[NSURL fileURLWithPath:self.currentRecord.videoAbsolutePath]]);
        }
    }else{
        return;
    }
    
    manger.param = _param;
    manger.successMessage = @"提交成功";
    manger.failMessage = @"提交失败";

    ShowHUD *hud = [ShowHUD showWhiteLoadingWithText:@"提交中..." inView:ApplicationDelegate.window config:nil];
    
    WS(weakSelf);
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [hud hide];
        SW(strongSelf, weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {
            
            [ArtVideoUtil deleteVideo:strongSelf.currentRecord.videoAbsolutePath];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }
    
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [hud hide];
    }];
    
    
    
}

#pragma mark - 重新定位之后的通知

-(void)locationChange{
    _tf_address.text = [LocationHelper sharedDefault].address;
    _param.latitude = @([LocationHelper sharedDefault].latitude);
    _param.longitude = @([LocationHelper sharedDefault].longitude);
    _param.address = [LocationHelper sharedDefault].address;
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    LxPrintf(@"VideoColectVC dealloc");

}


@end
