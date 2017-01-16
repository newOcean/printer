//
//  PrinterListViewController.h
//  PrinterSDK
//
//  Created by doulai on 9/16/15.
//  Copyright (c) 2015 doulai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormatSettingTableViewController.h"
@interface PrinterListViewController : UIViewController
@property BOOL hasTask;

//@property NSString*printeruid;
@property printModel *taskmodel;
//用来区分打印机
@property NSInteger printerTag;
@end
