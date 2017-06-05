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

@interface VideoColectVC ()

@property (weak, nonatomic) IBOutlet UIButton *btn_InputVideo;
@property (weak, nonatomic) IBOutlet UITextField *tf_address;
@property (weak, nonatomic) IBOutlet FSTextView *tv_memo;
@property (weak, nonatomic) IBOutlet UIButton *btn_commit;
@property (weak, nonatomic) IBOutlet UILabel *lb_tvCount;

@property (strong,nonatomic) VideoColectSaveParam *param;
@property (nonatomic,assign) BOOL isCanCommit;

@end

@implementation VideoColectVC

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {

    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"视频录入";
    
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

#pragma mark - 视频点击录入事件
- (IBAction)handlebtnInputVideoClicked:(id)sender {
    
    
    
    
    
}



#pragma mark -重新定位点击事件
- (IBAction)handlebtnLocationClicked:(id)sender {
    [[LocationHelper sharedDefault] startLocation];
    
}



#pragma mark - 提交按钮事件点击
- (IBAction)handleBtnCommitClicked:(id)sender {
    
    VideoColectSaveManger *manger = [[VideoColectSaveManger alloc] init];
    manger.param = _param;
    
    ShowHUD *hud = [ShowHUD showWhiteLoadingWithText:@"提交中..." inView:ApplicationDelegate.window config:nil];
    
    WS(weakSelf);
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [hud hide];
        SW(strongSelf, weakSelf);
        
        
        
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [hud hide];
    }];
    
    
    
}

#pragma mark - 重新定位之后的通知

-(void)locationChange{
    //这里待优化
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
