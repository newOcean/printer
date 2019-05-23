//
//  PrinterListViewController.m
//  PrinterSDK
//
//  Created by doulai on 9/16/15.
//  Copyright (c) 2015 doulai. All rights reserved.
//

#import "PrinterListViewController.h"
#import "FormatSettingTableViewController.h"


#import "SVProgressHUD.h"
#import <CoreBluetooth/CoreBluetooth.h>


@interface PrinterListViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,BluetoothDelegate>
{
    NSArray*deviceList;

    NSTimer* mytimer;
    UIActivityIndicatorView *activityView;
    UITableView *mytableview;
    CBPeripheral *clickedDevice;
    BOOL showAllPrinter;
}
@end

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
    self.title=NSLocalizedString(@"打印设置", @"");
    [self.view setBackgroundColor:[UIColor whiteColor]];
    int height =12;
    
#ifndef kHideTaobao
        UIButton *selfprint = [[UIButton alloc] initWithFrame:CGRectMake(8, height, 150, 44)];
        [selfprint setTitle:NSLocalizedString(@"购买打印机", @"") forState:UIControlStateNormal];
        [selfprint addTarget:self action:@selector(openTaobao:) forControlEvents:UIControlEventTouchUpInside];
        [selfprint setBackgroundColor:[UIColor orangeColor]];
        [selfprint setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:selfprint];
#endif

        UIButton *formatbtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width- 8-150, height, 150, 44)];
        [formatbtn setTitle:NSLocalizedString(@"打印模版", @"") forState:UIControlStateNormal];
        [formatbtn addTarget:self action:@selector(openFormat:) forControlEvents:UIControlEventTouchUpInside];
        [formatbtn setBackgroundColor:[UIColor orangeColor]];
        [formatbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:formatbtn];
        
        height +=44+12;
  
    
    
    UILabel *chooselbl=[[UILabel alloc] initWithFrame:CGRectMake(8, height, 200, 21)];
    chooselbl.text = NSLocalizedString(@"打印机列表", @"");
    [self.view addSubview:chooselbl];
    
    height +=21+12;
    mytableview = [[UITableView alloc] initWithFrame:CGRectMake(0, height, self.view.frame.size.width, self.view.frame.size.height- height)];
    mytableview.delegate    =self;
    mytableview.dataSource  =self;
    mytableview.tag         =2;
    [self.view addSubview:mytableview];

    [PrinterSDK getPrinterSetting];
    //清空打印机，重新搜索
    [PrinterSDK cleanPrintList];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [PrinterSDK disconnectLabelPrinter];

    [self scanPrinter:nil ];
    [mytableview reloadData];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [self stopScan];
    [PrinterSDK SetBlutoothDelegate:nil];

}
#pragma mark 按钮

-(void)openTaobao:(id)sender
{
    NSString *customURL=@"https://item.taobao.com/item.htm?id=568305858207";
    
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

- (void)scanPrinter:(id)sender {

  
    [PrinterSDK SetBlutoothDelegate:self];
    [PrinterSDK StartScan];
   
    mytimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(timeout) userInfo:nil repeats:NO];
    activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityView.center=self.view.center;
    
    [activityView startAnimating];
    
    [self.view addSubview:activityView];
    
    
}
-(void)stopScan{
    [PrinterSDK StopScan];
    [activityView stopAnimating];
    [mytimer invalidate];
    mytimer=nil;
}
-(void)timeout{
    [self stopScan];
    if (deviceList.count==0)
    {

        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"没有扫描到专用打印机,请确保手机蓝牙已经打开，打印机已经开机",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:nil, nil];
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

        [mytableview reloadData];

    }
}

-(void)updateBluetoothDevice:(NSMutableArray*)devices;
{
//    deviceList  =devices;
    deviceList =[NSArray arrayWithArray:devices];

    [mytableview reloadData];
}

-(void)didConnected:(NSString*)deviceUid  Result:(BOOL)success;{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        
        [mytableview reloadData];
        
        if (success)
            [self excuteTask];
        else
        {
            UIAlertView*alert =[[UIAlertView alloc] initWithTitle:@"提示" message:deviceUid delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    });
   
        
    
    
}
-(void)finishPrint{
    //    DDLog(@"完成打印");
}
#pragma mark task
-(void)excuteTask{
    NSString*info;
//    if (self.hasTask ||self.taskmodel) {
//        info=NSLocalizedString(@"连接成功，是否打印单据？",@"") ;
//    }else
        info=NSLocalizedString(@"连接成功，是否绑定为默认打印机？",@"") ;
    UIAlertView*alert=[[UIAlertView alloc] initWithTitle:nil message:info delegate:self cancelButtonTitle:NSLocalizedString(@"取消", @"") otherButtonTitles:NSLocalizedString(@"确定", @""), nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    
    if (buttonIndex==1) {
        if (clickedDevice.name.length>0) {
             //绑定打印机
            [[NSUserDefaults standardUserDefaults] setObject:clickedDevice.name.lowercaseString forKey:keydefaultprintername];
            NSString*uid =clickedDevice.identifier.UUIDString ;
            if(uid)
                [[NSUserDefaults standardUserDefaults] setObject:uid forKey:keydefaultprinteruid];
           
        }
        if (self.hasTask) {
            
            [PrinterSDK startPrint:nil deviceTag:self.printerTag];
            self.hasTask =NO;

            [self.navigationController popViewControllerAnimated:YES];
        }else if(self.taskmodel)
        {
            [PrinterSDK printModel:self.taskmodel fromviewc:nil printerTag:self.printerTag preview:NO failed:nil];
            self.taskmodel=nil;
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
//            [self printTest];
           
           
            
        }
    }else
    {

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
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"指定淘宝店<手机进销存掌上开单>";
}
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

    clickedDevice =device;
    [SVProgressHUD showWithStatus:@"..."];

    [PrinterSDK StopScan];
    [PrinterSDK connectPrinterTag:self.printerTag device:device];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

