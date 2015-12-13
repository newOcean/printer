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
//    NSString *company = setting[@"company"];
    NSMutableDictionary *newsetting=[NSMutableDictionary dictionaryWithDictionary:setting];
    [newsetting setObject:@1 forKey:@"showconfigure"];//设置为110mm打印机
      [newsetting setObject:@28 forKey:@"lineSpace"];//设置为110mm打印机
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
    NSString*textToPrint=@"大师兄打印机高质量稳定速度快\n大师兄打印机高质量稳定速度快\n大师兄打印机高质量稳定速度快\n大师兄打印机高质量稳定速度快\n大师兄打印机高质量稳定速度快\n联系QQ40255986 手机15988879319\n";
    
//    NSDictionary *setting = [PrinterWraper getPrinterSetting];
    NSString *barcode = @"http://www.baidu.com";

    
    NSDictionary*dic=@{@"textToPrint":textToPrint,@"barcode":barcode};
#warning 请确保本身的navigationController是有效的
#warning 工程的General->Embedded Binaries  + PrinterSdk.framework
    [PrinterWraper printDictionary:dic fromviewc:self  printeruid:nil needPreview:NO];
    
}

- (IBAction)printModel:(id)sender {
    
    
    //读取打印机设置内容
    NSDictionary *setting = [PrinterWraper getPrinterSetting];
    NSString *company = setting[@"company"];
    
    //设置订单内容
    printModel *model = [[printModel alloc] init];
    
    //订单标题  如果不写title 则要写明销售类型   sdk根据设置自动组合订单标题
    model.title = [NSString stringWithFormat:@"%@ 销售单",company ];
//    model.odertype =0;
    
    //订单页眉
    model.headText =@"客户:零售客户   经办人:大师兄  单号:F1011111111111\n出库日期:2015-09-10 打印日期:2015-09-20";
    
    //订单页脚 设置中的页脚会拼接在他之后
    model.footText=@"上期结余:-8777.00     本期应收:9999 下期结余:-111000.00\n";
    
//    商品列表
    NSMutableArray * list = [[NSMutableArray alloc] init];
    for (int i=0; i<1; i++) {
        productModel *body =[[ productModel alloc] init];
        body.oderType =@"订货";
        body.styeNum = @"00001";
        body.name = @"牛仔裤";
//        body.color =@"黄色";
//        body.size =@"XXXL:2 L:18 M:8";
        
        body.count =@"28";//设置数量
        body.unit =@"";
        body.price =@"150";//设置价格
        [list addObject:body];
    }
    
    model.productList =[NSArray arrayWithArray:list];
    model.composedSummary = NO;//数量 价格 小记 合并显示
    
    //预览 如果不需要则不用传
    model.time =@"2015-10-01";
    model.customer =@"张三 15988879";
    model.totalAmount=@"10000.00";
    model.payed =@"0.00";
    model.arrears =@"10000.00";
    
    //如果不需要预览 preview 设置为NO
    [PrinterWraper printModel:model fromviewc:self printeruid:nil preview:YES];

}

- (IBAction)choosePrinter:(id)sender {
    
    //    主动打开打印机配置界面
        [PrinterWraper chooseNewPrinter:self];
    

}


@end
