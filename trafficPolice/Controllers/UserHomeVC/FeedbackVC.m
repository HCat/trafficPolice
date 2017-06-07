//
//  FeedbackVC.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/6/7.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "FeedbackVC.h"
#import "FSTextView.h"
#import "CommonAPI.h"

@interface FeedbackVC ()

@property (weak, nonatomic) IBOutlet UIButton *btn_commit;

@property (weak, nonatomic) IBOutlet FSTextView *tv_feedback;

@property (weak, nonatomic) IBOutlet UILabel *lb_count;

@property (nonatomic,assign) BOOL isCanCommit;

@end

@implementation FeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    
    //配置FSTextView
    [_tv_feedback setDelegate:(id<UITextViewDelegate> _Nullable)self];
    _tv_feedback.placeholder = @"请输入反馈或建议";
    _tv_feedback.maxLength = 30;   //最大输入字数
    WS(weakSelf);
    [_tv_feedback addTextDidChangeHandler:^(FSTextView *textView) {
        // 文本改变后的相应操作.
        weakSelf.lb_count.text =
        [NSString stringWithFormat:@"%d/%d",textView.text.length,textView.maxLength];
        
    }];
    // 添加到达最大限制Block回调.
    [_tv_feedback addTextLengthDidMaxHandler:^(FSTextView *textView) {
        // 达到最大限制数后的相应操作.
    }];
    
    self.isCanCommit = NO;

    
}
#pragma mark - set && get 

-(void)setIsCanCommit:(BOOL)isCanCommit{
    _isCanCommit = isCanCommit;
    if (_isCanCommit == NO) {
        _btn_commit.enabled = NO;
        [_btn_commit setBackgroundColor:UIColorFromRGB(0xe6e6e6)];
    }else{
        _btn_commit.enabled = YES;
        [_btn_commit setBackgroundColor:UIColorFromRGB(0x4281E8)];
    }
}


#pragma mark - buttonMethods

- (IBAction)hanldeBtnCommitClicked:(id)sender {
    
    CommonAdviceManger *manger = [[CommonAdviceManger alloc] init];
    manger.msg = _tv_feedback.formatText;
    manger.successMessage = @"提交成功";
    manger.failMessage = @"提交失败";
    
    ShowHUD *hud = [ShowHUD showWhiteLoadingWithText:@"提交中..." inView:self.view config:nil];
    WS(weakSelf);
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [hud hide];
        if (manger.responseModel.code == CODE_SUCCESS) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [hud hide];

    }];
    
}


#pragma mark - 实时监听UITextView内容的变化
//只能监听键盘输入时的变化(setText: 方式无法监听),如果想修复可以参考http://www.jianshu.com/p/75355acdd058
- (void)textViewDidChange:(FSTextView *)textView{
    
    if(textView.formatText.length == 0){
        self.isCanCommit = NO;
    }else{
    
        self.isCanCommit = YES;
    }
    
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    LxPrintf(@"FeedbackVC dealloc");

}

@end
