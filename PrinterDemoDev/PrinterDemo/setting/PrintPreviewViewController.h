//
//  PrintPreviewViewController.h
//  PrinterDemo
//
//  Created by doulai on 10/1/15.
//  Copyright © 2015 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class printModel;
@interface PrintPreviewViewController : UIViewController
//@property NSDictionary*printerDic;
@property printModel *printmode;
@property (nonatomic ,copy) void (^choosePrinter)( BOOL res );
//@property NSDictionary*oderdic;
//@property (nonatomic,strong)NSString*deviceId;
@property NSInteger printerTag;
//@property BOOL isbuy;
@end
