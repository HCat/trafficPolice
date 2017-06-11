//
//  SearchListVC.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/6/11.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "SearchListVC.h"
#import "TTGTextTagCollectionView.h"
#import <PureLayout.h>
#import <IQKeyboardManager.h>
#import "SearchTagHelper.h"
#import "UIButton+Block.h"

@interface SearchListVC ()

@property (weak, nonatomic) IBOutlet UIButton *btn_search;
@property (weak, nonatomic) IBOutlet UITextField *tf_search;

@property (weak, nonatomic) IBOutlet UIView *v_history;

@property (weak, nonatomic) IBOutlet UIButton *btn_delHistory;

@property (weak, nonatomic) IBOutlet UILabel *lb_historyTip;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_historyHeight;

@property (nonatomic, strong) TTGTextTagCollectionView *tagView;

@property (nonatomic,strong) NSArray *arr_tags;


@end

@implementation SearchListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索";
    _tf_search.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 0)];
    //设置显示模式为永远显示(默认不显示)
    _tf_search.leftViewMode = UITextFieldViewModeAlways;
    [_tf_search setReturnKeyType:UIReturnKeySearch];
    [_tf_search becomeFirstResponder];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    
    [_btn_search setEnlargeEdgeWithTop:20.f right:20.f bottom:20.f left:20.f];
   
    [self initTagView];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
    [super viewWillDisappear:animated];

}

#pragma mark - set && get 

- (void)setArr_tags:(NSArray *)arr_tags{

    _arr_tags = arr_tags;
    
    if (_arr_tags && _arr_tags.count > 0) {
        _lb_historyTip.hidden  = YES;
    }else{
        _lb_historyTip.hidden = NO;
    }

}

#pragma mark - initTagView

- (void)initTagView{

    _tagView = [TTGTextTagCollectionView new];
    //_tagView.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
    
    TTGTextTagConfig *config = [TTGTextTagConfig new];
    config.tagTextFont = [UIFont systemFontOfSize:14];
    
    config.tagTextColor = UIColorFromRGB(0x787878);
    config.tagBackgroundColor = UIColorFromRGB(0xe6e6e6);
    config.tagSelectedTextColor = UIColorFromRGB(0x787878);
    config.tagSelectedBackgroundColor = UIColorFromRGB(0xe6e6e6);
    config.tagCornerRadius = 5.f;
    config.tagSelectedCornerRadius = 5.f;
    config.tagBorderWidth = 0.f;
    config.tagBorderColor = [UIColor clearColor];
    config.tagSelectedBorderWidth = 0.f;
     config.tagSelectedBorderColor = [UIColor clearColor];
    
    config.tagShadowColor = [UIColor clearColor];
   
    
    _tagView.defaultConfig = config;

    [_tagView configureForAutoLayout];
    [_v_history addSubview:_tagView];

    [_tagView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(50, 10, 10, 10)];
    
    [_tagView setDelegate:(id<TTGTextTagCollectionViewDelegate>)self];
    
    _tagView.showsVerticalScrollIndicator = NO;
   
    [self.view layoutIfNeeded];
    
    self.arr_tags = [SearchTagHelper readTagArray] ;
    if (self.arr_tags == nil) {
        self.arr_tags = [NSArray array];
    }
    
    if (_arr_tags && _arr_tags.count > 0) {
        [_tagView addTags:_arr_tags];
    }

    [_tagView reload];
    
}


#pragma mark - buttonMethods

- (IBAction)handleBtnDelHistoryClicked:(id)sender {
    
    [SearchTagHelper removeAllArray];
    self.arr_tags = [SearchTagHelper readTagArray];
    if (self.arr_tags == nil) {
        self.arr_tags = [NSArray array];
    }
    [_tagView removeAllTags];
    [_tagView reload];
    
    
}

- (IBAction)handleBtnSearchClicked:(id)sender {
    
    _v_history.hidden = YES;
    [_tf_search resignFirstResponder];
    
    
    
    
    //这里插入搜索缓存
    
    NSArray *t_arr = [SearchTagHelper readTagArray];
    if (t_arr && t_arr.count > 0) {
        for (NSString *t_str in t_arr) {
            if ([_tf_search.text isEqualToString:t_str]) {
                return;
            }
        }
    }
    
    [SearchTagHelper SaveSearchText:_tf_search.text];
    
    self.arr_tags = [SearchTagHelper readTagArray];
    if (self.arr_tags == nil) {
        self.arr_tags = [NSArray array];
    }
   
    [_tagView removeAllTags];
    [_tagView addTags:self.arr_tags];
    [_tagView reload];

}

#pragma mark - UITextFieldViewDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
   
    _v_history.hidden = NO;
    

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    _v_history.hidden = YES;
    [textField resignFirstResponder];
    
    
    

    NSArray *t_arr = [SearchTagHelper readTagArray];
    if (t_arr && t_arr.count > 0) {
        for (NSString *t_str in t_arr) {
            if ([textField.text isEqualToString:t_str]) {
                return YES;
            }
        }
    }
    
    [SearchTagHelper SaveSearchText:textField.text];
    
    self.arr_tags = [[SearchTagHelper readTagArray] mutableCopy];
    if (self.arr_tags == nil) {
        self.arr_tags = [NSMutableArray array];
    }
    
    [_tagView removeAllTags];
    [_tagView addTags:self.arr_tags];
    [_tagView reload];

    
    return YES;
}

#pragma mark - TTGTextTagCollectionViewDelegate

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(NSString *)tagText atIndex:(NSUInteger)index selected:(BOOL)selected {
    
    LxPrintf(@"Tap tag: %@, at: %ld, selected: %d", tagText, (long) index, selected);
    
    [_tf_search resignFirstResponder];
    _tf_search.text = tagText;
    
    
}

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView updateContentSize:(CGSize)contentSize {
    LxPrintf(@"text tag collection: %@ new content size: %@", textTagCollectionView, NSStringFromCGSize(contentSize));
    if (_arr_tags && _arr_tags.count > 0) {
        _layout_historyHeight.constant = contentSize.height + 50 + 10;
        
        if (contentSize.height > 235) {
            _layout_historyHeight.constant = 235 + 50 + 10;
        }else{
            _layout_historyHeight.constant = contentSize.height + 50 + 10;
        }
        
    }else{
        
        _layout_historyHeight.constant = contentSize.height + 100 + 10;
    }
    
    [self.view layoutIfNeeded];
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc{

    LxPrintf(@"SearchListVC dealloc");
}


@end
