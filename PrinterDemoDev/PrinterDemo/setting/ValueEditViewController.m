//
//  ValueEditViewController.m
//  PrinterDemo
//
//  Created by doulai on 10/1/15.
//  Copyright © 2015 com.cmcc. All rights reserved.
//

#import "ValueEditViewController.h"
#import <PrinterSDK/PrinterSDK.h>
@interface ValueEditViewController ()
{
    NSMutableDictionary *settingDictionary;
    UITextView *textview ;
}
@end

@implementation ValueEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    if (IOS7) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
//    }
    [self.view setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]];
    textview =[[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    textview.editable =YES;
    [self.view addSubview:textview];
    UILabel *tips = [[UILabel alloc] initWithFrame:CGRectMake(12, 212, self.view.frame.size.width-12, 21)];
     tips.text = @"";
    if ([self.keyword isEqualToString:@"barcode"]) {
        tips.text = NSLocalizedString(@"请输入二维码链接地址，可以使用扫码功能获取", @"");
    }
    [self.view addSubview:tips];
    UIBarButtonItem*rightbaritem=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"保存", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(rightbarPress)];
    self.navigationItem.rightBarButtonItem = rightbaritem;
    
    NSDictionary *saved=[PrinterWraper getPrinterSetting];;
    settingDictionary =[NSMutableDictionary dictionaryWithDictionary:saved];
    
    NSString *valuetext=[settingDictionary objectForKey:self.keyword];
    textview.text =valuetext;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)rightbarPress{
    NSString *value =textview.text;
    if (value && self.keyword) {
        [settingDictionary setObject:textview.text forKey:self.keyword];
        [PrinterWraper setPrinterSetting:settingDictionary];
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
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
