//
//  ValueEditViewController.m
//  PrinterDemo
//
//  Created by doulai on 10/1/15.
//  Copyright © 2015 com.cmcc. All rights reserved.
//

#import "ValueEditViewController.h"
#import "FormatSettingTableViewController.h"
//#import "HJIOS7ScannerViewController.h"
//#import <WHC_KeyboardManager.h>
@interface ValueEditViewController ()
{
    NSMutableDictionary *settingDictionary;
    UITextView *textview ;
    UISegmentedControl *labelseg;
}
@end

@implementation ValueEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    if (IOS7) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
//    }
//      [[WHC_KeyboardManager share] addMonitorViewController:self];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]];
    textview =[[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    textview.editable =YES;
    if (self.isnumber) {
        textview.keyboardType =UIKeyboardTypeNumberPad;
    }
    [self.view addSubview:textview];
    
    NSDictionary *saved=[PrinterSDK getPrinterSetting];;
    settingDictionary =[NSMutableDictionary dictionaryWithDictionary:saved];
    
    UILabel *tips = [[UILabel alloc] initWithFrame:CGRectMake(12, 212, self.view.frame.size.width-12, 21)];
     tips.text = @"";
    
    if ([self.keyword isEqualToString:@"spacelength"]) {
         tips.text = @"非专业人士请不要修改，或者设置为0";
    }
    if ([self.keyword isEqualToString:@"barcode"]) {
        tips.text = NSLocalizedString(@"最多添加3个二维码的链接，每行1个", @"");
        UIButton *camerabtn =[[UIButton alloc] initWithFrame:CGRectMake(12, 240, self.view.frame.size.width-24, 30)];
        [camerabtn addTarget:self action:@selector(openScanner) forControlEvents:UIControlEventTouchUpInside];
        [camerabtn setTitle:NSLocalizedString(@"扫描二维码添加", @"") forState:UIControlStateNormal];
        [camerabtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.view addSubview:camerabtn];
    }
    [self.view addSubview:tips];
    if ([self.keyword isEqualToString:@"company" ]) {
        labelseg =[[UISegmentedControl alloc] initWithItems:@[@"商品标签不打印公司名",@"商品标签打印公司名"]];
        labelseg.frame =CGRectMake(12, 212, self.view.frame.size.width-12, 30) ;
        NSNumber *productcompany = [settingDictionary objectForKey:@"productcompany"];
        [labelseg setSelectedSegmentIndex:[productcompany integerValue]];
        [self.view addSubview:labelseg];
    }
    UIBarButtonItem*leftbutton=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"<返回", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(rightbarPress)];
    self.navigationItem.leftBarButtonItem = leftbutton;
    

    
    NSString *valuetext=[settingDictionary objectForKey:self.keyword];
    if(valuetext)
        textview.text =[NSString stringWithFormat:@"%@", valuetext];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)openScanner{
//    HJIOS7ScannerViewController *detail =[[HJIOS7ScannerViewController alloc] init];
//    detail.onScanResult =^(NSString*code){
//        if (textview.text.length>0) {
//            textview.text =[NSString stringWithFormat:@"%@\n%@",textview.text,code];
//        }else
//            textview.text=code;
//    };
//    [self presentViewController:detail animated:YES completion:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
//    [self rightbarPress];
}
-(void)rightbarPress{
    NSString *value =textview.text;
    if (value && self.keyword) {
        [settingDictionary setObject:textview.text forKey:self.keyword];
        if ([self.keyword isEqualToString:@"company"]) {
            
            [settingDictionary setObject:[NSNumber numberWithInteger:[labelseg selectedSegmentIndex]] forKey:@"productcompany"];
        }
        [PrinterSDK setPrinterSetting:settingDictionary];
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
