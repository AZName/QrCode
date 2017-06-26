//
//  AZPreviewLayer.m
//  QrCode
//
//  Created by 徐振 on 2017/6/26.
//  Copyright © 2017年 徐振. All rights reserved.
//

#import "AZPreviewLayer.h"
#import <AVFoundation/AVFoundation.h>
/**
 调取摄像机扫描
 */
@interface AZCaptureController : NSObject

@property (nonatomic, strong)AVCaptureSession *captureSession;



@end

@implementation AZCaptureController


- (AVCaptureSession *)captureSession {
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc]init];
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if (device) {
            //判断是否可以自动对焦
            if (device.autoFocusRangeRestrictionSupported) {
                
                if ([device lockForConfiguration:nil]) {
                    device.autoFocusRangeRestriction = AVCaptureAutoFocusRangeRestrictionNear;
                    [device unlockForConfiguration];
                }
            }
        }
        AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        
        
        
    }
    return _captureSession;
}

@end

/**
 扫描图层
 */
@interface AZPreviewLayer ()



@end

@implementation AZPreviewLayer



@end
