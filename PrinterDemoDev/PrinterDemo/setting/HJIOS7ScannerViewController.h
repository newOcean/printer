//
//  HJIOS7ScannerViewController.h
//  MasterOfSale
//
//  Created by doulai on 14-8-30.
//  Copyright (c) 2014年 com.doulai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@protocol scanerDelegate <NSObject>

-(void)callbackCallback:(NSString*)comment;

@end

@interface HJIOS7ScannerViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
}
@property (nonatomic, copy) void (^onScanResult)(NSString*code);

@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain) UIImageView * line;
@property (nonatomic,assign) id delegate;
@end
