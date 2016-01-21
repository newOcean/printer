//
//  HJPrinterDemoViewController.m
//  PrinterDemo
//
//  Created by doulai on 9/15/15.
//  Copyright (c) 2015 com.cmcc. All rights reserved.
//

#import "HJPrinterDemoViewController.h"
//#import "PrinterListViewController.h"
#import <PrinterSDK/PrinterSDK.h>
//#import "PrinterSDK.h"
@interface HJPrinterDemoViewController ()

@end

@implementation HJPrinterDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //读取打印机设置内容
    NSDictionary *setting = [PrinterWraper getPrinterSetting];

    NSMutableDictionary *newsetting=[NSMutableDictionary dictionaryWithDictionary:setting];
    [newsetting setObject:@1 forKey:@"showconfigure"];//sdk自带打印机配置

    [PrinterWraper setPrinterSetting:newsetting];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)print:(id)sender {
  
    
//    NSDictionary *setting = [PrinterWraper getPrinterSetting];

#warning 请确保本身的navigationController是有效的
#warning 工程的General->Embedded Binaries  + PrinterSdk.framework
#warning 请试用真机 否则会有编译错误

    [PrinterWraper setPrintFormat:3 LineSpace:28 alinment:1];// 3 大字体  ，28默认行间距,1局中对齐
     [PrinterWraper addPrintText:@"掌上科技有限公司"];//打印文字
    
    [PrinterWraper setPrintFormat:1 LineSpace:28 alinment:0];// 1 小字体  ，28默认行间距,0左对齐

    [PrinterWraper addPrintText:@"掌上开单打印机高质量稳定速度快\n联系QQ40255986 手机15988879319\n"];//打印文字
    
    
    //打印商品列表
    NSMutableArray * list = [[NSMutableArray alloc] init];
    for (int i=0;i<3;i++) {
        productModel *body =[[ productModel alloc] init];
  
        body.barcode_1 =@"123456789012";
        body.styeNum = @"m1234";
        body.name = @"比基尼";
        body.brand =@"杜蕾斯";
        body.extra1 =@"粉红色";
        body.extra2 =@"M";
        body.spec =@"真丝";
        body.unit=@"件";
        body.count =@"100";//设置数量
        body.price =@"99.99";//设置价格
        body.sum = @"9999";
        [list addObject:body];
    }
    
    [PrinterWraper addItemList:list];
    [PrinterWraper addPrintBarcode:@"http://www.baidu.com" isTwoDimensionalCode:1];//二维码
    [PrinterWraper addPrintBarcode:@"123456789012" isTwoDimensionalCode:0];//1维码
    
     NSString*photopath=[[NSBundle mainBundle] pathForResource:@"ico180" ofType:@"png"];
    [PrinterWraper addPrintImage:[UIImage imageWithContentsOfFile:photopath]];
    [PrinterWraper addPrintText:@"\n\n"];//打印文字
    [PrinterWraper startPrint:self.navigationController];
    
    
}


- (IBAction)choosePrinter:(id)sender {
    
    //    主动打开打印机配置界面
        [PrinterWraper chooseNewPrinter:self];
    

}


@end
