//
//  ViewController.m
//  QrCode
//
//  Created by 徐振 on 2017/6/26.
//  Copyright © 2017年 徐振. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong)AVCaptureSession *captureSession;

@property (nonatomic, strong)AVCaptureVideoPreviewLayer *reviewLayer;

@property (nonatomic,strong)UIView *backgroudView;

@property (nonatomic, strong)UIImageView *animationImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建设备
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //判断设备是否自动聚焦
    if (captureDevice.autoFocusRangeRestrictionSupported) {
        //判断摄像头是否加锁成功
        if ([captureDevice lockForConfiguration:nil]) {
            captureDevice.autoFocusRangeRestriction = AVCaptureAutoFocusRangeRestrictionNear;
            [captureDevice unlockForConfiguration];
        }
        
    }
    //设置设备输入流
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    
    //设置设备输出流
    AVCaptureMetadataOutput *metadateOutput = [[AVCaptureMetadataOutput alloc]init];
    //设置代理回调输出值
    [metadateOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    metadateOutput.rectOfInterest = CGRectMake(0.27, 0.2, 0.35, 0.6);

    NSLog(@"%@",NSStringFromCGRect(metadateOutput.rectOfInterest));
    //设置扫码类型
    if ([self.captureSession canAddInput:deviceInput]) {
        [self.captureSession addInput:deviceInput];
    }
    if ([self.captureSession canAddOutput:metadateOutput]) {
        [self.captureSession addOutput:metadateOutput];
    }
    //必须在添加之后才能设置扫描类型。
    metadateOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeAztecCode];

    self.reviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.reviewLayer.frame = self.view.frame;
    [self.view.layer insertSublayer:self.reviewLayer atIndex:0];
    [self.view addSubview:self.backgroudView];

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![self.captureSession isRunning]) {
        [self.captureSession startRunning];
    }
    
    [self starAnimation];
}



#pragma mark-----AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if (metadataObjects.count > 0 ) {
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects.firstObject;
        NSLog(@"%@",obj.stringValue);
//        [self.captureSession stopRunning];
//        self.animationImage.hidden = YES;
        }
}

- (AVCaptureSession *)captureSession{
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc]init];
    }
    return _captureSession;
}

- (AVCaptureVideoPreviewLayer *)reviewLayer {
    if (!_reviewLayer) {
        _reviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    }
    return _reviewLayer;
}

- (UIView *)backgroudView {
    if (!_backgroudView) {
        _backgroudView = [[UIView alloc]init];
        _backgroudView.frame = self.view.frame;
        UIView *top = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height * 0.27)];
        top.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.35];
        [_backgroudView addSubview:top];
        
        UIView *left =[[UIView alloc]initWithFrame:CGRectMake(0, [[UIScreen mainScreen]bounds].size.height * 0.27, [[UIScreen mainScreen]bounds].size.width * 0.2, [[UIScreen mainScreen]bounds].size.width * 0.6)];
        left.backgroundColor = [[UIColor blackColor ]colorWithAlphaComponent:0.35];
        [_backgroudView addSubview:left];
        
        UIView *rigth = [[UIView alloc]initWithFrame:CGRectMake([[UIScreen mainScreen]bounds].size.width * 0.8, [[UIScreen mainScreen]bounds].size.height * 0.27, [[UIScreen mainScreen]bounds].size.width * 0.2 , [[UIScreen mainScreen]bounds].size.width * 0.6)];
        rigth.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.35];
        
        [_backgroudView addSubview:rigth];
        
        UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(0, [[UIScreen mainScreen]bounds].size.width * 0.6 + ([[UIScreen mainScreen]bounds].size.height * 0.27), [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height - ([[UIScreen mainScreen]bounds].size.width * 0.6 + ([[UIScreen mainScreen]bounds].size.height * 0.27)))];
        bottom.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
        [_backgroudView addSubview:bottom];
        
        UIImageView *backgroudImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Qrbackgroud"]];

        backgroudImage.frame =CGRectMake([[UIScreen mainScreen]bounds].size.width * 0.2, [[UIScreen mainScreen]bounds].size.height * 0.27, [[UIScreen mainScreen]bounds].size.width * 0.6, [[UIScreen mainScreen]bounds].size.width * 0.6);
        [_backgroudView addSubview:backgroudImage];
        
        self.animationImage  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line"]];
        self.animationImage.frame = CGRectMake(backgroudImage.frame.origin.x, backgroudImage.frame.origin.y, backgroudImage.frame.size.width, 2);
        self.animationImage.hidden = YES;
        [_backgroudView addSubview:self.animationImage];
        
        UIButton *torchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        torchBtn.frame = CGRectMake(([[UIScreen mainScreen]bounds].size.width - 43)/2, [[UIScreen mainScreen]bounds].size.height - 70 - 43, 43, 43);
        [torchBtn setImage:[UIImage imageNamed:@"star"] forState:UIControlStateSelected];
        [torchBtn setImage:[UIImage imageNamed:@"end"] forState:UIControlStateNormal];
        [torchBtn addTarget:self action:@selector(onTorchClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backgroudView addSubview:torchBtn];
        
    }
    return _backgroudView;
}

- (void)starAnimation {
    self.animationImage.hidden = NO;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationRepeatCount:MAXFLOAT];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:1.0];
    self.animationImage.frame = CGRectMake([[UIScreen mainScreen]bounds].size.width * 0.2, [[UIScreen mainScreen]bounds].size.height * 0.27 + ([[UIScreen mainScreen]bounds].size.width * 0.6), [[UIScreen mainScreen]bounds].size.width * 0.6, 2);
    [UIView commitAnimations];
}

- (void)onTorchClick:(UIButton *)sender{
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch] && [device hasFlash]){
        [device lockForConfiguration:nil];
        if (!sender.selected) {
            [device setTorchMode:AVCaptureTorchModeOn];
            [device setFlashMode:AVCaptureFlashModeOn];
        } else {
            [device setTorchMode:AVCaptureTorchModeOff];
            [device setFlashMode:AVCaptureFlashModeOff];
        }
        [device unlockForConfiguration];
    }
    
    
    sender.selected = !sender.selected;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
