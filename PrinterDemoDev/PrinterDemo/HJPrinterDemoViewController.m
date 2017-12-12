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
//#import "PrinterSDK.h"
#import "FormatSettingTableViewController.h"
#import "PrinterListViewController.h"
//github下载地址 https://github.com/newOcean/printer
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(printThead:) name:@"kNewLabelPrinterConnected" object:nil];

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
#warning 请用真机 否则会有编译错误
    
    [PrinterWraper SetBlutoothDelegate:self];
    NSArray *headers =@[@"编号",@"名称",@"价格",@"数量",@"小计金额"];
    NSArray *values0 =@[@"0",@"杜蕾斯",@"10",@"1",@"10.0"];
    NSArray *values1 =@[@"0",@"杜蕾斯丝袜",@"100",@"1",@"100.0"];
    NSArray *values2 =@[@"0",@"大白菜",@"1",@"10",@"10.0"];
    NSArray* body =@[headers,values0,values1,values2];
 
    
    NSArray* body2 =@[@[@"oo",@"xx"],@[@"xx",@"00"]];
    
#if 1
//    自己设置格式
    [PrinterWraper setPrintFormat:1 LineSpace:0 alinment:1 rotation:0];// 3 大字体  ，28默认行间距,1局中对齐

    
    NSString*photopath=[[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"];
    
//    打印logo
        [PrinterWraper addPrintImage:[UIImage imageWithContentsOfFile:photopath]];
//    设置格式 大字体 行间距28 局中
     [PrinterWraper setPrintFormat:3 LineSpace:28 alinment:1 rotation:0];// 3 大字体  ，28默认行间距,1局中对齐

   //打印标题
 
     [PrinterWraper addPrintText:@"掌上科技有限公司"];//打印文字
//   中途换格式  设置主体内容 小字体
    [PrinterWraper setPrintFormat:1 LineSpace:28 alinment:0 rotation:0];// 1 小字体  ，28默认行间距,0左对齐

    [PrinterWraper addPrintText:@"掌上开单打印机高质量稳定速度快\n联系QQ40255986 手机15988879319\n"];//打印文字
    
    
//打印商品列表，会自动排版，要求数组长度一致，空白地方用@""
    [PrinterWraper addItemLines:body];
//打印二维码
    [PrinterWraper addPrintBarcode:@"http://www.baidu.com" isTwoDimensionalCode:1];//二维码必须是英文和数字
//    打印一维码 必须是12-13位数字
    NSString *formedUPC =[PrinterWraper addUPCLastVerifyCode:@"123456789101"];
    [PrinterWraper addPrintBarcode:formedUPC isTwoDimensionalCode:0];//1维码 upc 必须按upc规则生成 最后一位是校验位
  
    //打印code128 任意位数字母和数字
    [PrinterWraper addPrintBarcode:@"12345678901235678" isTwoDimensionalCode:-1];//1维码 code128
    
    [PrinterWraper addPrintText:@"再添加一个表格\n"];
     [PrinterWraper addItemLines:body2];
   
    [PrinterWraper moveToNextPage];//换页
//    [PrinterWraper addPrintText:@"\n\n"];//打印文字
//    开始启动打印
//    [PrinterWraper startPrint:self.navigationController];
    BOOL res=   [PrinterWraper startPrint:self.navigationController deviceTag:0];
    if (!res) {
        PrinterListViewController *detail=[[PrinterListViewController alloc] init];
                detail.hasTask =YES;
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

-(void)didConnected:(NSString*)deviceUid Result:(BOOL)success;
{
    if (success) {
        return;
    }
    UIAlertView*alert =[[UIAlertView alloc] initWithTitle:@"断开连接" message:@"断开连接成功" delegate:self cancelButtonTitle: nil  otherButtonTitles:@"确认", nil];
    [alert show];
}

-(void)finishPrint;
{
//    [PrinterWraper disconnectPrinter:nil];

}

- (IBAction)disconnectPrinter:(id)sender {
    [PrinterWraper disconnectPrinter:nil];
}


- (IBAction)choosePrinter:(id)sender {
    
    PrinterListViewController *detail=[[PrinterListViewController alloc] init];
    
    [self.navigationController pushViewController:detail animated:YES];


}
- (IBAction)confiurePrinter:(id)sender {
    FormatSettingTableViewController *detail =[[FormatSettingTableViewController alloc] init];
    [self.navigationController pushViewController:detail animated:YES];
}

- (IBAction)cloudprinter:(id)sender {
//        偷懒的做法
        printModel *model =[[printModel alloc] init];
        model.title =@"掌上科技有限公司";
        model.headText =@"日期：2016-1-2   开单员：小三";
//        model.headerMultiValues =body;
    
        model.footText =@"总计  xxx元";
        model.barcode =@"www.baidu.com";
        model.advise =@"联系QQ40255986 手机15988879319";
    
    
    //sn需要购买打印机后才会有，需要先注册，如有需要请联系qq153887715
    [PrinterWraper cloudPrintModel:model printerSN:@"xxxxx" sender:self];
}
-(void)printThead:(id)sender
{
    [self performSelector:@selector(LabelPrinter:) withObject:sender afterDelay:0.5];
}
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
    barcode.text =[PrinterWraper addUPCLastVerifyCode: @"123456789012"];
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
    
    
    
    [PrinterWraper startPrintLabel:self.navigationController content:info];
}

@end
