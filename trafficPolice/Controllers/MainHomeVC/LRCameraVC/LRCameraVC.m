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

@interface LRCameraVC ()<TOCropViewControllerDelegate>

@property (strong, nonatomic) LLSimpleCamera *camera;
@property (weak, nonatomic) IBOutlet UIButton *btn_flash;
@property (weak, nonatomic) IBOutlet UIButton *btn_photoAlbum;
@property (weak, nonatomic) IBOutlet UIButton *btn_close;
@property (weak, nonatomic) IBOutlet UIButton *btn_snap;


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
                
            }else if(camera.flash == LLCameraFlashOn){
                [weakSelf.btn_flash setTitle:@"开启" forState:UIControlStateNormal];
            }else{
                [weakSelf.btn_flash setTitle:@"自动" forState:UIControlStateNormal];
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


#pragma mark -button Methods

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
        }
    }else if(self.camera.flash == LLCameraFlashOn){
        BOOL done = [self.camera updateFlashMode:LLCameraFlashAuto];
        if(done) {
            [self.btn_flash setTitle:@"自动" forState:UIControlStateNormal];
        }
    }else{
        BOOL done = [self.camera updateFlashMode:LLCameraFlashOff];
        if(done) {
            [self.btn_flash setTitle:@"关闭" forState:UIControlStateNormal];
        }
    
    }
    
}

//相册按钮点击
- (IBAction)handlebtnPhotoAlbumClicked:(id)sender {
    
    
}

#pragma mark - TOCropViewControllerDelegate

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle{
    

    if (self.fininshcapture) {
        self.fininshcapture(image);
    }
    
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
