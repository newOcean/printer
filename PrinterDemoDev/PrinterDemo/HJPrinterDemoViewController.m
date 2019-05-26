//
//  HJPrinterDemoViewController.m
//  PrinterDemo
//
//  Created by doulai on 9/15/15.
//  Copyright (c) 2015 com.cmcc. All rights reserved.
//

#import "HJPrinterDemoViewController.h"
//#import "PrinterListViewController.h"
#import "PrinterSDK.h"
#import "SVProgressHUD.h"
#import "FormatSettingTableViewController.h"
#import "PrinterListViewController.h"
#import "PrintPreviewViewController.h"
//github下载地址 https://github.com/newOcean/printer
@interface HJPrinterDemoViewController ()

@end

@implementation HJPrinterDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(printThead:) name:@"kNewLabelPrinterConnected" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishPrint) name:kNotify_print_finish object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)print:(id)sender {
#warning 请用真机 否则会有编译错误
    [PrinterSDK SetBlutoothDelegate:self];

    
    //初始化打印机，部分打印机需要
    [PrinterSDK setInitformat];
    //    自己设置格式

     [PrinterSDK addPrintText:@"\n"];
    [PrinterSDK setPrintFormat:1 LineSpace:0 alinment:1 rotation:0];// 3 大字体  ，28默认行间距,1局中对齐
    
    
    NSString*photopath=[[NSBundle mainBundle] pathForResource:@"ico180" ofType:@"png"];
    
    //    打印logo
    [PrinterSDK addPrintImage:[UIImage imageWithContentsOfFile:photopath]];
    [PrinterSDK addPrintText:@"\n"];
    //    设置格式 大字体 行间距28 局中
    [PrinterSDK setPrintFormat:3 LineSpace:28 alinment:1 rotation:0];// 3 大字体  ，28默认行间距,1局中对齐
    
    //打印标题

    [PrinterSDK addPrintText:@"掌上科技有限公司"];//打印文字
     [PrinterSDK addPrintText:@"\n"];
    [PrinterSDK setPrintFormat:1 LineSpace:28 alinment:0 rotation:0];// 1 小字体  ，28默认行间距,0左对齐
    
    [PrinterSDK addPrintText:@"打印机批发零售"];//打印文字
    [PrinterSDK addPrintText:@"\n"];
    [PrinterSDK addPrintText:@"提供全球最强SDK，傻瓜式集成"];//打印文字
    [PrinterSDK addPrintText:@"\n"];
    //   中途换格式  设置主体内容 小字体
    [PrinterSDK setPrintFormat:1 LineSpace:28 alinment:0 rotation:0];// 1 小字体  ，28默认行间距,0左对齐
    

    //打印商品列表，会自动排版，要求数组长度一致，空白地方用@""
//    [PrinterSDK addItemLines:body type:@0];
    //打印商品列表，自动添加表格线
    //第一行为每一列最大宽度

    NSArray*body=@[
           @[@"6",@"4",@"2",@"2"],
           @[@"名称",@"规格",@"数量",@"价格"],
           @[@"土豆炖牛肉",@"小份",@"2",@"50"],
           @[@"裤子",@"白色",@"1",@"500",kNextLineFalseFlag],//下一行不需要分割线
           @[@"",@"红色",@"1",@"500",kNextLineFalseFlag],
           @[@"",@"咖啡色",@"1",@"500"],
           @[@"合计",@"",@"5",@"1600"],
           ];
    [PrinterSDK addTableList:body needFrame:YES];
    [PrinterSDK addPrintText:@"\n"];
    
    //打印二维码
    [PrinterSDK addPrintBarcode:@"http://www.baidu.com" isTwoDimensionalCode:1];//二维码必须是英文和数字
    [PrinterSDK addPrintText:@"        "];
    [PrinterSDK addPrintBarcode:@"http://www.taobao.com" isTwoDimensionalCode:1];//二维码必须是英文和数字
  
    
//     [PrinterSDK addPrintText:@"\n"];
    //    打印一维码 必须是12-13位数字
//    NSString *formedUPC =[PrinterSDK addVerifyNumberForBarcode:@"123456789101"];
//    [PrinterSDK addPrintBarcode:formedUPC isTwoDimensionalCode:0];//1维码 upc 必须按upc规则生成 最后一位是校验位
//     [PrinterSDK addPrintText:@"\n"];
    //打印code128 任意位数字母和数字
//    [PrinterSDK addPrintBarcode:@"12345678901235678" isTwoDimensionalCode:-1];//1维码 code128
    [PrinterSDK addPrintText:@"\n"];
    [PrinterSDK addPrintText:@"\n"];
     [PrinterSDK addPrintText:@"\n"];
    //自动定位到下一页的开始位置
    [PrinterSDK nextPage];
    // 开始启动打印
    if ([PrinterSDK isPrinterAvailableEX:nil]) {
        
        [self performSelector:@selector(startPrint:) withObject:sender afterDelay:0.];
        
    } else
    {
        [SVProgressHUD showWithStatus:@"正在搜索打印机，请打开打印机电源..."];
        [PrinterSDK autoConnectPrinter:nil delegate:self];
        
    }

    
}




- (IBAction)printWithModel:(id)sender {
   NSArray *headers =@[@"编号",@"名称",@"价格",@"数量",@"小计金额"];
    NSArray *values0 =@[@"0",@"白菜",@"10",@"1",@"10.0"];
    NSArray *values1 =@[@"1",@"杜蕾斯丝袜",@"100",@"1",@"100.0"];
    
    NSArray* body =@[headers,values0,values1];
        printModel *model =[[printModel alloc] init];
        model.logo=[UIImage imageNamed:@"ico144"];
        model.title =@"掌上科技有限公司";
        model.subtitle=@"提供进销存专业打印机";
        model.headText =@"日期：2016-1-2   开单员：小三";
        model.headerMultiValues =body;
    
        model.footText =@"总计  xxx元";
        model.barcode =@"www.weixin.com,www.alipay.com";
        model.advise =@"联系QQ40255986 手机15988879319";
    
//    if (preview)
    {
        PrintPreviewViewController *detail =[[PrintPreviewViewController alloc] init];
        
        detail.printmode = model;
        detail.choosePrinter =nil;
        [self.navigationController pushViewController:detail animated:YES];
     
    }

    
}
#pragma mark 打印



-(void)didConnected:(NSString*)deviceUid Result:(BOOL)success;
{
    [SVProgressHUD dismiss];
    if (success) {
        [self performSelector:@selector(startPrint:) withObject:nil afterDelay:0.];
    }else{
        PrinterListViewController *detail=[[PrinterListViewController alloc] init];
        //如果没有默认打印机，最好是加上这个，否则可能第一张打印格式不对
        if ([deviceUid isEqualToString:kNoDefaultPrinter]) {
            [PrinterSDK cleanPrinterBuffer];
        }
            
        detail.hasTask =YES;
        [self.navigationController pushViewController:detail animated:YES];
    }
 
    
}
-(void)startPrint:(id)sender
{
     [SVProgressHUD showSuccessWithStatus:@"正在打印..."];
    BOOL res=   [PrinterSDK startPrint:self.navigationController deviceTag:0];
    if (!res) {
       
        PrinterListViewController *detail=[[PrinterListViewController alloc] init];
        detail.hasTask =YES;
        [self.navigationController pushViewController:detail animated:YES];
    }
    
}
-(void)finishPrint;
{
    //    [PrinterSDK disconnectPrinter:nil];
    [SVProgressHUD dismiss];
}

- (IBAction)choosePrinter:(id)sender {
    
    PrinterListViewController *detail=[[PrinterListViewController alloc] init];
    
    [self.navigationController pushViewController:detail animated:YES];
}


- (IBAction)cloudprinter:(id)sender {
    //     
    printModel *model =[[printModel alloc] init];
    model.title =@"掌上科技有限公司";
    model.headText =@"日期：2016-1-2   开单员：小三";

    model.footText =@"总计  xxx元";
    model.barcode =@"www.baidu.com";
    model.advise =@"联系QQ40255986 手机15988879319";
    
    //sn需要购买打印机后才会有，需要先注册，如有需要请联系qq153887715
    [PrinterSDK cloudPrintModel:model printerSN:@"xxxxx" sender:self];
}
//-(void)printThead:(id)sender
//{
//    [self performSelector:@selector(LabelPrinter:) withObject:sender afterDelay:0.5];
//}
- (IBAction)LabelPrinter:(id)sender {
    
    NSMutableDictionary *info =[NSMutableDictionary new];
    
    [info setObject:@80 forKey:@"labelwidth"];
    [info setObject:@100 forKey:@"labelheight"];
    [info setObject:@NO forKey:@"endcut"];
    NSMutableArray *contentlist =[[NSMutableArray alloc] init];
    LabelModel *nameLabel = [[LabelModel alloc] init];
    nameLabel.x =@30;
    nameLabel.y =@10;
    nameLabel.xscale=@1;
    nameLabel.yscale=@2;
    nameLabel.Rotation =@90;
    nameLabel.text =@"掌上科技打印机";
    [contentlist addObject:nameLabel];
    
    
    
    LabelModel *barcode = [[LabelModel alloc] init];
    barcode.x =@8;
    barcode.y =@110;
    barcode.xscale=@1;
    barcode.yscale=@2;
    barcode.height =@60;
    barcode.type =@1;
    barcode.text =[PrinterSDK addVerifyNumberForBarcode: @"123456789012"];
    [contentlist addObject:barcode];
    
    LabelModel *qrcode = [[LabelModel alloc] init];
    qrcode.x =@30;
    qrcode.y =@200;
    qrcode.Rotation=@0;
    
    qrcode.type=@2;
    qrcode.width=@60;
    qrcode.text =@"www.baidu.com";
    [contentlist addObject:qrcode];
    
    [info setObject:contentlist forKey:@"contentlist"];
    
    
    
    [PrinterSDK startPrintLabel:self.navigationController content:info];
}

@end
