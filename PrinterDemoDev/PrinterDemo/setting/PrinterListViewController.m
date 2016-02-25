//
//  PrinterListViewController.m
//  PrinterSDK
//
//  Created by doulai on 9/16/15.
//  Copyright (c) 2015 doulai. All rights reserved.
//

#import "PrinterListViewController.h"
#import "FormatSettingTableViewController.h"

//#import "VirturePrinter.h"

#import <CoreBluetooth/CoreBluetooth.h>
//#import "CustomerPrintViewController.h"

@interface PrinterListViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,BluetoothDelegate>
{
    NSArray*deviceList;
//    NSDictionary*connetedDevice;
    NSInteger choosedIndex;
//    VirturePrinter*printDevice;
    NSTimer* mytimer;
    UIActivityIndicatorView *activityView;
    UITableView *mytableview;

    
}


@end
//static NSString*printertableIdentify=@"printertableIdentify";
@implementation PrinterListViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
        self.edgesForExtendedLayout=UIRectEdgeNone;
    
    self.hidesBottomBarWhenPushed=YES;
    self.title=NSLocalizedString(@"配置打印机", @"");
    [self.view setBackgroundColor:[UIColor whiteColor]];
//    NSDictionary*configure=[[NSUserDefaults standardUserDefaults] objectForKey:@"dashixiongprintersdk"];
//    NSNumber*hideConfigure=[configure objectForKey:@"hideConfigure"];
    int height =12;
//    if ([hideConfigure integerValue] !=1 )
    {
        UIButton *selfprint = [[UIButton alloc] initWithFrame:CGRectMake(8, height, 150, 44)];
        [selfprint setTitle:NSLocalizedString(@"查看配套打印机", @"") forState:UIControlStateNormal];
        [selfprint addTarget:self action:@selector(openTaobao:) forControlEvents:UIControlEventTouchUpInside];
        [selfprint setBackgroundColor:[UIColor orangeColor]];
        [selfprint setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:selfprint];
        
        UIButton *formatbtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width- 8-150, height, 150, 44)];
        [formatbtn setTitle:NSLocalizedString(@"设置打印模版", @"") forState:UIControlStateNormal];
        [formatbtn addTarget:self action:@selector(openFormat:) forControlEvents:UIControlEventTouchUpInside];
        [formatbtn setBackgroundColor:[UIColor orangeColor]];
        [formatbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:formatbtn];
        
        height +=44+12;
  
    }
    

    
    
    UILabel *chooselbl=[[UILabel alloc] initWithFrame:CGRectMake(8, height, 200, 21)];
    chooselbl.text = NSLocalizedString(@"打印机列表", @"");
    [self.view addSubview:chooselbl];
    
    height +=21+12;
    mytableview = [[UITableView alloc] initWithFrame:CGRectMake(0, height, self.view.frame.size.width, self.view.frame.size.height- height)];
    mytableview.delegate    =self;
    mytableview.dataSource  =self;
    mytableview.tag         =2;
    [self.view addSubview:mytableview];
    
  
    [PrinterWraper getPrinterSetting];
    
//    printDevice = [VirturePrinter  createPrinterDevice:@"bluetooth"];
//    printDevice.delegate=self;
//    deviceList = [printDevice getScanedPrinterList];
    choosedIndex = -1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    


    [self scanPrinter:nil ];
    
   

    [mytableview reloadData];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [self stopScan];
    [PrinterWraper SetBlutoothDelegate:nil];

}
#pragma mark 按钮
-(void)selfprint:(id)sender
{
//    CustomerPrintViewController *detail=[[CustomerPrintViewController alloc] init];
//    detail.title = NSLocalizedString(@"打印自定义内容", @"");
//    BOOL hide=  self.hidesBottomBarWhenPushed ;
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:detail animated:YES];
//    self.hidesBottomBarWhenPushed = hide;

}
-(void)openTaobao:(id)sender
{
//    NSString *customURL = @"taobao://shop113684150.taobao.com/";
    NSString *customURL=@"http://item.taobao.com/item.htm?id=44696180568";
    
    if ([[UIApplication sharedApplication]
         canOpenURL:[NSURL URLWithString:customURL]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customURL]];
    }else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://shop113684150.taobao.com"]];
    }
}
-(void)openFormat:(id)sender
{
    FormatSettingTableViewController *detail=[[FormatSettingTableViewController alloc] init];
    detail.title = NSLocalizedString(@"设置打印模版", @"");
    BOOL hide=  self.hidesBottomBarWhenPushed ;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
    self.hidesBottomBarWhenPushed = hide;
    
}
-(void)printTypeChanged:(UISegmentedControl*)sender
{
    
}
- (void)scanPrinter:(id)sender {
    //clean
//    [self stopScan];
  
    [PrinterWraper SetBlutoothDelegate:self];
    [PrinterWraper StartScanTimeout:10];
   
    mytimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(timeout) userInfo:nil repeats:NO];
    activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityView.center=self.view.center;
    
    [activityView startAnimating];
    
    [self.view addSubview:activityView];
    
    
}
-(void)stopScan{
    [PrinterWraper StopScan];
    [activityView stopAnimating];
    [mytimer invalidate];
    mytimer=nil;
}
-(void)timeout{
    [self stopScan];
    if (deviceList.count==0)
    {

        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"没有扫描到专用打印机,只支持iphone4s或者new pad及以后的苹果设备",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark bluetooth delegate
-(void)BlueToothOpen:(BOOL)isopen;{
    if (!isopen) {
        [self stopScan];
        deviceList=nil;
        choosedIndex= -1;
        [mytableview reloadData];
//                UIAlertView*alert=[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"请在手机设置－》蓝牙 中打开蓝牙设备",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:nil, nil];
//                [alert show];
    }
}

-(void)updateBluetoothDevice:(NSMutableArray*)devices;
{
    deviceList  =devices;
    
    [mytableview reloadData];
}

-(void)didConnected:(NSString*)deviceUid  Result:(BOOL)success;{
//    [SVProgressHUD dismiss];
  
    [mytableview reloadData];
    
    if (success)
        [self excuteTask];
        
    
    
}
-(void)finishPrint{
    //    DDLog(@"完成打印");
}
#pragma mark task
-(void)excuteTask{
    NSString*info;
    if (self.hasTask ||self.taskmodel) {
        info=NSLocalizedString(@"连接成功，立即打印单据吗",@"") ;
    }else
        info=NSLocalizedString(@"恭喜您连接成功，是否检测打印效果？",@"") ;
    UIAlertView*alert=[[UIAlertView alloc] initWithTitle:nil message:info delegate:self cancelButtonTitle:NSLocalizedString(@"取消", @"") otherButtonTitles:NSLocalizedString(@"确定", @""), nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    
    if (buttonIndex==1) {
        if (self.hasTask) {
            [PrinterWraper startPrint:nil];
            self.hasTask =NO;
//            [PrinterWraper printDictionary:self.task fromviewc:nil  printeruid:nil needPreview:NO];
//            self.task=nil;
            [self.navigationController popViewControllerAnimated:YES];
        }else if(self.taskmodel)
        {
            [PrinterWraper printModel:self.taskmodel fromviewc:nil printeruid:nil preview:NO failed:nil];
            self.taskmodel=nil;
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
//            NSDictionary*oneOder=@{@"title":@"Sale",@"time": [NSDate date],@"buyer":@"customer",@"payedmoney":[NSNumber numberWithFloat:1000],@"sum":[NSNumber numberWithFloat:1000],@"historymoney":[NSNumber numberWithFloat:0]};
//            [PrinterWraper printDictionary:oneOder fromviewc:nil printeruid:nil needPreview:NO];
            [PrinterWraper addPrintText:@"掌上开单\n掌上开单\n掌上开单\n掌上开单\nSmart Invoice\nSmart Invoice\nSmart Invoice\n\n\n\n"];
             [PrinterWraper startPrint:nil];
            
        }
    }else
    {
        //dis
//        [printDevice disconnectPrinter:nil];
    }
}
#pragma  mark table
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 54;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    return deviceList.count;
    
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"tablecellindentify"];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"tablecellindentify"];
    }
    CBPeripheral *device=[deviceList objectAtIndex:indexPath.row];
   NSString*name= device.name.length>0?device.name:NSLocalizedString(@"未知设备", @"");
    cell.textLabel.text=name;
    cell.detailTextLabel.text=NSLocalizedString(@"点击连接",@"");
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{

    CBPeripheral *device=[deviceList objectAtIndex:indexPath.row];
    choosedIndex =indexPath.row;
//    [PrinterWraper disconnectPrinter:nil];
    [PrinterWraper connectPrinter:device.identifier.UUIDString shouldreset:YES];


    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

