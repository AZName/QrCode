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
    metadateOutput.rectOfInterest = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
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
//    [self.view.layer addSublayer:self.reviewLayer];
    
    if (![self.captureSession isRunning]) {
        [self.captureSession startRunning];
    }
    
}

#pragma mark-----AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if (metadataObjects.count > 0 ) {
        for (AVMetadataMachineReadableCodeObject *obj in metadataObjects) {
            NSLog(@"%@",obj.stringValue);
        }
        
        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
