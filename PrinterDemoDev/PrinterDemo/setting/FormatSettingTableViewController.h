//
//  FormatSettingTableViewController.h
//  PrinterDemo
//
//  Created by doulai on 9/30/15.
//  Copyright © 2015 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <PrinterSDK/PrinterSDK.h>

#define  ITEMS_PRODUCT_KEY  @[@"styenum",@"name",@"code",@"extra1",@"extra2",@"spec",@"count",@"unit",@"price",@"xiaoji"]


#define  ITEMS_PRODUCT_VALUE  @[NSLocalizedString(@"款号", @""),NSLocalizedString(@"名称", @""),NSLocalizedString(@"条码", @""),@"xx",@"yy",NSLocalizedString(@"规格", @""),NSLocalizedString(@"数量", @""),NSLocalizedString(@"单位", @""),NSLocalizedString(@"价格", @""),NSLocalizedString(@"小计", @"")]


@interface FormatSettingTableViewController : UITableViewController

@end
