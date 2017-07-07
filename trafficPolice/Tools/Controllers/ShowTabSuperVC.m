//
//  ShowTabSuperVC.m
//  HelloToy
//
//  Created by chenzf on 15/10/9.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "ShowTabSuperVC.h"
#import "AppDelegate.h"
#import "UIButton+Block.h"
#import "MessageVC.h"


@interface ShowTabSuperVC ()

@property(nonatomic,strong) UIButton *btn_right;

@end

@implementation ShowTabSuperVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChange) name:NOTIFICATION_CHANGELOCATION_SUCCESS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification) name:NOTIFICATION_RECEIVENOTIFICATION_SUCCESS object:nil];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btn_right= [UIButton buttonWithType:UIButtonTypeCustom];
    _btn_right.backgroundColor = [UIColor clearColor];
    _btn_right.frame = CGRectMake(0, 0, 22, 19);
    
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if (badge > 0) {
        [_btn_right setImage:[UIImage imageNamed:@"icon_notification_h"] forState:UIControlStateNormal];
    }else{
        [_btn_right setImage:[UIImage imageNamed:@"icon_notification"] forState:UIControlStateNormal];
    }
    
    [_btn_right setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [_btn_right setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    
    [_btn_right addTarget:self action:@selector(pushNotificationVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_btn_right];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ApplicationDelegate showTabView];
    
}

-(void)locationChange{

    [self showLocationInfo:[LocationHelper sharedDefault].city image:@"icon_location"];
    
}

- (void)receiveNotification{
    
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if (badge > 0) {
        [_btn_right setImage:[UIImage imageNamed:@"icon_notification_h"] forState:UIControlStateNormal];
    }else{
        [_btn_right setImage:[UIImage imageNamed:@"icon_notification"] forState:UIControlStateNormal];
    }
    [_btn_right setImage:[UIImage imageNamed:@"icon_notification_h"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_btn_right];
    
}


- (void)showLocationInfo:(NSString *)title image:(NSString *)imageName{

    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    /// Set text alignment
    //paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:13],
                                  //NSForegroundColorAttributeName:_textColor ? _textColor : textColor,
                                  NSParagraphStyleAttributeName: paragraphStyle };
    
    CGSize size = [title boundingRectWithSize:CGSizeMake(100, 28) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    
    //CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(100, 28)];
    CGRect buttonFrame = CGRectMake(0, 0, size.width + 20.0f, 28);
    UIButton *button= [UIButton buttonWithType:UIButtonTypeCustom];
    button.contentMode = UIViewContentModeScaleToFill;
    button.backgroundColor = [UIColor clearColor];
    button.frame = buttonFrame;
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [button setTitle:title forState:UIControlStateNormal];
    if(imageName.length > 0)
    {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
         [button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    }
   
    
    [button addTarget:self action:@selector(reloadLocationInfo:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
}

- (void)reloadLocationInfo:(id)sender{

    [[LocationHelper sharedDefault] startLocation];
}

- (void)pushNotificationVC:(id)sender{
    
    [JPUSHService resetBadge];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [_btn_right setImage:[UIImage imageNamed:@"icon_notification"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_btn_right];

    
    MessageVC * vc = [[MessageVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_CHANGELOCATION_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_RECEIVENOTIFICATION_SUCCESS object:nil];
    
}

@end
