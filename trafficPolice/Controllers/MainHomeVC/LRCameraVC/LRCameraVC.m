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
#import "UIImage+JKRImage.h"
#import "ShareFun.h"

#import "ImageFileInfo.h"

@interface LRCameraVC ()<TOCropViewControllerDelegate>

@property (strong, nonatomic) LLSimpleCamera *camera;
@property (weak, nonatomic) IBOutlet UIButton *btn_flash;
@property (weak, nonatomic) IBOutlet UIButton *btn_photoAlbum;
@property (weak, nonatomic) IBOutlet UIButton *btn_close;
@property (weak, nonatomic) IBOutlet UIButton *btn_snap;
@property (nonatomic,strong) ImageFileInfo *imageInfo;


@end

@implementation LRCameraVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeCamera];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.view.backgroundColor = [UIColor blackColor];
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
    [self.camera start];

}

#pragma mark - 请求数据

//获取证件号码
- (void)getIdentifyRequest{

    WS(weakSelf);
    CommonIdentifyManger *manger = [[CommonIdentifyManger alloc] init];
    manger.isLog = YES;
    manger.isNeedShowHud = YES;
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
                if (strongSelf.fininshcapture) {
                    strongSelf.fininshcapture(strongSelf);
                }
                [strongSelf dismissViewControllerAnimated:NO completion:^{
                }];
            }
        }else{
            [ShowHUD showError:@"识别失败,请重试!" duration:1.5f inView:weakSelf.view config:nil];
        }
        
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [hud hide];

    }];
    

}




#pragma mark - initializeCamera(初始化相机)

-(void)initializeCamera{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    // 创建一个相机
    self.camera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPresetHigh  position:LLCameraPositionRear
                                             videoEnabled:YES];
    
    // attach to a view controller
    [self.camera attachToViewController:self withFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    
    self.camera.fixOrientationAfterCapture = NO;
    
    // take the required actions on a device change
    __weak typeof(self) weakSelf = self;
    [self.camera setOnDeviceChange:^(LLSimpleCamera *camera, AVCaptureDevice * device) {
        
        NSLog(@"Device changed.");
        
        // device changed, check if flash is available
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
        NSLog(@"Camera error: %@", error);
        
        if([error.domain isEqualToString:LLSimpleCameraErrorDomain]) {
            if(error.code == LLSimpleCameraErrorCodeCameraPermission) {
                
                [ShowHUD showError:@"未获取相机权限" duration:1.5f inView:weakSelf.view config:nil];
                
            }
        }
    }];
    [self.view sendSubviewToBack:self.camera.view];
    
}


#pragma mark - button Methods

//拍照按钮点击
- (IBAction)handlebtnSnapClicked:(id)sender {
    WS(weakSelf);
    [self.camera capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
        NSLog(@"拍照结束");
        if(!error) {
            TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:image];
            cropController.delegate = weakSelf;
            [weakSelf presentViewController:cropController animated:YES completion:nil];
        }
        else {
            NSLog(@"An error has occured: %@", error);
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
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    actionSheet.sortAscending = NO;
    actionSheet.allowSelectImage = YES;
    actionSheet.allowSelectGif = NO;
    actionSheet.allowSelectVideo = NO;
    actionSheet.allowTakePhotoInLibrary = NO;
    //设置照片最大预览数
    actionSheet.maxPreviewCount = 1;
    //设置照片最大选择数
    actionSheet.maxSelectCount = 1;
    actionSheet.sender = self;
    WS(weakSelf);
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        SW(strongSelf,weakSelf);
        strongSelf.imageInfo = [[ImageFileInfo alloc] initWithImage:images[0] withName:@"file"];
        strongSelf.image = strongSelf.imageInfo.image;
        [strongSelf getIdentifyRequest];
        
    }];
    [actionSheet showPhotoLibrary];
    
}

#pragma mark - TOCropViewControllerDelegate

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle{
    
    self.imageInfo = [[ImageFileInfo alloc] initWithImage:image withName:@"file"];
    self.image = self.imageInfo.image;
    
    [self getIdentifyRequest];
    
    if (cropViewController.navigationController) {
        [cropViewController.navigationController popViewControllerAnimated:YES];
    }
    else {
        cropViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [cropViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{



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
