//
//  LRCameraVC.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/25.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "LRCameraVC.h"
#import <TOCropViewController.h>
#import <LLSimpleCamera.h>
#import "ZLPhotoActionSheet.h"
#import "ImageFileInfo.h"
#import "AppDelegate.h"
#import "PureLayout.h"
#import "maskingView.h"
#import "UIButton+Block.h"

@interface LRCameraVC ()<TOCropViewControllerDelegate>

//LLSimpleCamera是运用AVFoundation自定义的相机对象
@property (strong, nonatomic) LLSimpleCamera *camera;

//闪光灯按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_flash;

//相册按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_photoAlbum;

//关闭按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_close;

//拍照按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_snap;

@property (weak, nonatomic) IBOutlet maskingView *v_masking;

@property (weak, nonatomic) IBOutlet UILabel *lb_tip;


@end

@implementation LRCameraVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_btn_photoAlbum setEnlargeEdgeWithTop:20.f right:20.f bottom:20.f left:20.f];
    [_btn_flash setEnlargeEdgeWithTop:20.f right:20.f bottom:20.f left:20.f];
    [_btn_close setEnlargeEdgeWithTop:20.f right:20.f bottom:20.f left:20.f];

    
    if(_type == 1) {
        
        _v_masking.type = 1;
        _btn_photoAlbum.hidden = YES;
        _lb_tip.text = @"请扫描车牌号";
    
    }else if(_type == 5) {
        
        _v_masking.hidden = YES;
        [_v_masking removeFromSuperview];
        
        _btn_photoAlbum.hidden = YES;
        
    }else{
        _v_masking.type = 2;
        
        if (_type == 2) {
            _lb_tip.text = @"请扫描身份证";
        }else if (_type == 3){
            _lb_tip.text = @"请扫描驾驶证";
        }else if (_type == 4){
            _lb_tip.text = @"请扫描行驶证";
        }
        
    }

    //初始化照相机，通过AVFoundation自定义的相机
    [self initializeCamera];
    
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    _lb_tip.hidden = NO;
    WS(weakSelf);
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        weakSelf.lb_tip.hidden = YES;
    });
    

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    //允许单个页面可以横竖屏操作
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotate = 1;
    //调用Start开始拍照功能
    [self.camera start];

}

- (void)viewWillDisappear:(BOOL)animated{
    
    //退出这个页面禁止横竖屏操作，有个Bug,就是当横屏的时候退出，上一个页面也是横屏的，修复下面if方法有用，但是会延迟横屏，并没有马上退出就横屏
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotate = 0;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    
    [super viewWillDisappear:animated];

}

- (void)viewDidDisappear:(BOOL)animated{
    
    //停止拍照
    [self.camera stop];
    [super viewDidDisappear:animated];
}

#pragma mark - set && get 


#pragma mark - 请求数据

//拍照完之后请求服务端获取证件信息
- (void)getIdentifyRequest{

    WS(weakSelf);
    
    CommonIdentifyManger *manger = [[CommonIdentifyManger alloc] init];
    manger.successMessage = @"";
    manger.failMessage = @"识别失败";
    
    manger.imageInfo = self.imageInfo;
    manger.type = self.type;
    
    ShowHUD *hud = [ShowHUD showWhiteLoadingWithText:@"识别中.." inView:self.view config:nil];
    
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        [hud hide];
        if (manger.responseModel.code == CODE_SUCCESS) {
            if (manger.commonIdentifyResponse) {
                
                [ShowHUD showSuccess:@"识别成功！" duration:1.5f inView:weakSelf.view config:nil];
                strongSelf.commonIdentifyResponse = manger.commonIdentifyResponse;
                //这里待优化，需要判断服务端返回来的IdNo,name为""的情况，现阶段不做
                if (strongSelf.fininshCaptureBlock) {
                    strongSelf.fininshCaptureBlock(strongSelf);
                }
                [strongSelf dismissViewControllerAnimated:YES completion:^{
                }];
                
            }
        }else{
            [ShowHUD showError:@"识别失败,请重试!" duration:1.5f inView:weakSelf.view config:nil];
        }
        
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [hud hide];

    }];
    

}

#pragma mark - 初始化相机对象

-(void)initializeCamera{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    // 创建一个相机
    self.camera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPresetHigh  position:LLCameraPositionRear
                                             videoEnabled:YES];
    
    
    // 关联到具体的VC中
    [self.camera attachToViewController:self withFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    [self.camera.view configureForAutoLayout];
    [self.camera.view autoPinEdgesToSuperviewEdges];
    self.camera.fixOrientationAfterCapture = YES;
    self.camera.useDeviceOrientation = YES;
    
    
    __weak typeof(self) weakSelf = self;
    [self.camera setOnDeviceChange:^(LLSimpleCamera *camera, AVCaptureDevice * device) {
        
        // 检查闪关灯状态
        if([camera isFlashAvailable]) {
            weakSelf.btn_flash.hidden = NO;
            
            if(camera.flash == LLCameraFlashOff) {
                [weakSelf.btn_flash setTitle:@"关闭" forState:UIControlStateNormal];
                [weakSelf.btn_flash setImage:[UIImage imageNamed:@"camera_flash_close"] forState:UIControlStateNormal];
                
            }else if(camera.flash == LLCameraFlashOn){
                [weakSelf.btn_flash setTitle:@"开启" forState:UIControlStateNormal];
                [weakSelf.btn_flash setImage:[UIImage imageNamed:@"camera_flash_open"] forState:UIControlStateNormal];
            }else{
                [weakSelf.btn_flash setTitle:@"自动" forState:UIControlStateNormal];
                 [weakSelf.btn_flash setImage:[UIImage imageNamed:@"camera_flash_open"] forState:UIControlStateNormal];
            }
        }
        else {
            weakSelf.btn_flash.hidden = YES;
        }
    }];
    
    [self.camera setOnError:^(LLSimpleCamera *camera, NSError *error) {
        
        LxPrintf(@"Camera error: %@", error);
        if([error.domain isEqualToString:LLSimpleCameraErrorDomain]) {
            if(error.code == LLSimpleCameraErrorCodeCameraPermission) {
                [ShowHUD showError:@"未获取相机权限" duration:1.5f inView:weakSelf.view config:nil];
            }
        }
    }];
    [self.view sendSubviewToBack:self.camera.view];
    
}


#pragma mark - 按钮事件

//拍照按钮点击
- (IBAction)handlebtnSnapClicked:(id)sender {
    
    WS(weakSelf);
    [self.camera capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
        if(!error) {
            
            //拍照成功之后，如果成功调用TOCropViewController 对照片进行裁剪
            
            TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:image];
            cropController.delegate = weakSelf;
            [weakSelf presentViewController:cropController animated:YES completion:nil];
            
        }else {
            
            LxPrintf(@"An error has occured: %@", error);
            
        }
    } exactSeenImage:YES];
    
}

//关闭按钮点击
- (IBAction)handlebtnCloseClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//闪光灯按钮点击
- (IBAction)handlebtnFlashClicked:(id)sender {
    
    if(self.camera.flash == LLCameraFlashOff) {
        BOOL done = [self.camera updateFlashMode:LLCameraFlashOn];
        if(done) {
            [self.btn_flash setTitle:@"开启" forState:UIControlStateNormal];
            [self.btn_flash setImage:[UIImage imageNamed:@"camera_flash_open"] forState:UIControlStateNormal];
        }
    }else if(self.camera.flash == LLCameraFlashOn){
        BOOL done = [self.camera updateFlashMode:LLCameraFlashAuto];
        if(done) {
            [self.btn_flash setTitle:@"自动" forState:UIControlStateNormal];
            [self.btn_flash setImage:[UIImage imageNamed:@"camera_flash_open"] forState:UIControlStateNormal];
        }
    }else{
        BOOL done = [self.camera updateFlashMode:LLCameraFlashOff];
        if(done) {
            [self.btn_flash setTitle:@"关闭" forState:UIControlStateNormal];
            [self.btn_flash setImage:[UIImage imageNamed:@"camera_flash_close"] forState:UIControlStateNormal];
        }
        
    }
    
}

//相册按钮点击
- (IBAction)handlebtnPhotoAlbumClicked:(id)sender {
    
    //调用从相册中选择照片
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    actionSheet.sortAscending = NO;
    actionSheet.allowSelectImage = YES;
    actionSheet.allowSelectGif = NO;
    actionSheet.allowSelectVideo = NO;
    actionSheet.allowTakePhotoInLibrary = NO;
    actionSheet.maxPreviewCount = 1;
    actionSheet.maxSelectCount = 1;
    actionSheet.sender = self;
    
    WS(weakSelf);
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        
        //选中照片之后的处理
        SW(strongSelf,weakSelf);
        //获取的照片转换成ImageFileInfo对象来得到图片信息，并且赋值name用于服务端需要的key中
        strongSelf.imageInfo = [[ImageFileInfo alloc] initWithImage:images[0] withName:key_file];
        strongSelf.image = strongSelf.imageInfo.image;
        //请求数据获取证件信息
        [strongSelf getIdentifyRequest];
        
    }];
    [actionSheet showPhotoLibrary];
    
}

#pragma mark - TOCropViewControllerDelegate

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle{
    
    if (cropViewController.navigationController) {
        [cropViewController.navigationController popViewControllerAnimated:YES];
    }
    else {
        cropViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [cropViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
    if (_type != 5) {
        WS(weakSelf);
        //获取的照片转换成ImageFileInfo对象来得到图片信息，并且赋值name用于服务端需要的key中
        ShowHUD *hud = [ShowHUD showWhiteLoadingWithText:@"图片压缩中..." inView:self.view config:nil];
        dispatch_async(dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            SW(strongSelf, weakSelf);
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.imageInfo = [[ImageFileInfo alloc] initWithImage:image withName:key_file];
                strongSelf.image = self.imageInfo.image;
                //请求数据获取证件信息
                [hud hide];
                [strongSelf getIdentifyRequest];
            
            });
        });

    }else{
        TICK
        
        WS(weakSelf);
        //获取的照片转换成ImageFileInfo对象来得到图片信息，并且赋值name用于服务端需要的key中
        ShowHUD *hud = [ShowHUD showWhiteLoadingWithText:@"图片压缩中..." inView:self.view config:nil];
        dispatch_async(dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            SW(strongSelf, weakSelf);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                strongSelf.imageInfo = [[ImageFileInfo alloc] initWithImage:image withName:key_files];
                strongSelf.image = strongSelf.imageInfo.image;
                
                TOCK
                
                if (strongSelf.fininshCaptureBlock) {
                    strongSelf.fininshCaptureBlock(strongSelf);
                }
                
                [self dismissViewControllerAnimated:YES completion:^{
                    [hud hide];
                }];
                
            });
        });

    }

}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    LxPrintf(@"LRCameraVC dealloc");

    [_camera stop];
    _camera = nil;

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
