//
//  VideoDetailVC.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/6/7.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "VideoDetailVC.h"

@interface VideoDetailVC ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation VideoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"视频详情";
    
    NSURL* url = [NSURL URLWithString:_path];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [_webView loadRequest:request];//加载
    _webView.backgroundColor = [UIColor clearColor];
    [_webView setOpaque:NO];
}


#pragma mark -dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    LxPrintf(@"VideoDetailVC dealloc");

}

@end
