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
#import "FormatSettingTableViewController.h"
#import "PrinterListViewController.h"
@interface HJPrinterDemoViewController ()

@end

@implementation HJPrinterDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //读取打印机设置内容
//    NSDictionary *setting = [PrinterWraper getPrinterSetting];

//    NSMutableDictionary *newsetting=[NSMutableDictionary dictionaryWithDictionary:setting];
//    [newsetting setObject:@1 forKey:@"showconfigure"];//sdk自带打印机配置

//    [PrinterWraper setPrinterSetting:newsetting];
    

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
  


  
#warning 请确保本身的navigationController是有效的
#warning 工程的General->Embedded Binaries  + PrinterSdk.framework
#warning 请试用真机 否则会有编译错误
    NSArray *headers =@[@"编号",@"名称",@"价格",@"数量",@"小计金额"];
    NSArray *values0 =@[@"0",@"杜蕾斯",@"10",@"1",@"10.0"];
    NSArray *values1 =@[@"0",@"杜蕾斯丝袜",@"100",@"1",@"100.0"];
    NSArray *values2 =@[@"0",@"大白菜",@"1",@"10",@"10.0"];
    NSArray* body =@[headers,values0,values1,values2];
    
#if 1
//    自己设置格式
//    if (![PrinterWraper isPrinterAvailable]) {
//        PrinterListViewController *detail=[[PrinterListViewController alloc] init];
//        
//        [self.navigationController pushViewController:detail animated:YES];
//        return;
//    }
//    设置格式 大字体 行间距28 局中
     [PrinterWraper setPrintFormat:3 LineSpace:28 alinment:1];// 3 大字体  ，28默认行间距,1局中对齐
    NSString*photopath=[[NSBundle mainBundle] pathForResource:@"ico180" ofType:@"png"];
    
    //打印logo
    [PrinterWraper addPrintImage:[UIImage imageWithContentsOfFile:photopath]];
   //打印标题
     [PrinterWraper addPrintText:@"掌上科技有限公司"];//打印文字
//    设置主体内容 小字体
    [PrinterWraper setPrintFormat:1 LineSpace:28 alinment:0];// 1 小字体  ，28默认行间距,0左对齐

    [PrinterWraper addPrintText:@"掌上开单打印机高质量稳定速度快\n联系QQ40255986 手机15988879319\n"];//打印文字
    
    
//打印商品列表，会自动排版，要求数组长度一致，空白地方用@""
    [PrinterWraper addItemLines:body];
//打印二维码
    [PrinterWraper addPrintBarcode:@"http://www.baidu.com" isTwoDimensionalCode:1];//二维码
//    打印一维码
    [PrinterWraper addPrintBarcode:@"123456789012" isTwoDimensionalCode:0];//1维码
    [PrinterWraper addPrintBarcode:@"123456789013" isTwoDimensionalCode:0];//1维码
    
   
    [PrinterWraper addPrintText:@"\n\n"];//打印文字
//    开始启动打印
//    [PrinterWraper startPrint:self.navigationController];
    BOOL res=   [PrinterWraper startPrint:self.navigationController];
    if (!res) {
        PrinterListViewController *detail=[[PrinterListViewController alloc] init];
        //        detail.taskmodel =model;
        [self.navigationController pushViewController:detail animated:YES];
        
        
    }
#endif
   
//    偷懒的做法
//    printModel *model =[[printModel alloc] init];
//    model.title =@"掌上科技有限公司";
//    model.headText =@"日期：2016-1-2   开单员：小三";
//    model.headerMultiValues =body;
//    
//    model.footText =@"总计  xxx元";
//    model.barcode =@"www.baidu.com";
//    model.advise =@"联系QQ40255986 手机15988879319";
//    
//    [PrinterWraper printModel:model fromviewc:self printeruid:nil preview:YES failed:^(BOOL res ){
//       //在打印失败的时候 利用这个block来选择打印机。
//      
//            PrinterListViewController *detail=[[PrinterListViewController alloc] init];
//            detail.taskmodel =model;
//            [self.navigationController pushViewController:detail animated:YES];
//
//        
//    
//    }];
    
}


- (IBAction)choosePrinter:(id)sender {
    
    PrinterListViewController *detail=[[PrinterListViewController alloc] init];
    
    [self.navigationController pushViewController:detail animated:YES];


}
- (IBAction)confiurePrinter:(id)sender {
    FormatSettingTableViewController *detail =[[FormatSettingTableViewController alloc] init];
    [self.navigationController pushViewController:detail animated:YES];
}


@end
