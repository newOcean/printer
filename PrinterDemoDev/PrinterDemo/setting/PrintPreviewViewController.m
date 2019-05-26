//
//  PrintPreviewViewController.m
//  PrinterDemo
//
//  Created by doulai on 10/1/15.
//  Copyright © 2015 com.cmcc. All rights reserved.
//

#import "PrintPreviewViewController.h"
//
//  AirViewController.m
//  MasterOfSale
//
//  Created by doulai on 15-3-12.
//  Copyright (c) 2015年 com.doulai. All rights reserved.
//
#define DefaultFontSize 17
#define PaddingFactor 0.1f


#import "PrinterSDK.h"

#import "SVProgressHUD.h"

#import "PrinterListViewController.h"
@interface PrintPreviewViewController ()<UIPrintInteractionControllerDelegate,UIDocumentInteractionControllerDelegate,UIWebViewDelegate>
{
    NSMutableString*printText;
    NSString*filepath;
     NSString*pngpath;
    UIDocumentInteractionController *documentController ;
    
    UIWebView *mywebview;
    UIButton *btnsend;
    UIButton *btnpngshare;
    UIButton *btnclound;
//    BOOL isPrintFinished;
}


@end

@implementation PrintPreviewViewController
//-(HJAppDelegate *)appDelegate
//{
//    return (HJAppDelegate *)[[UIApplication sharedApplication] delegate];
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem*rightbaritem=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"打印小票", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(rightbarPress:)];
    
     UIBarButtonItem*rightbaritem1=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"打印设置", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(rightbarPress1:)];
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    [dic setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightbaritem setTitleTextAttributes:dic forState:UIControlStateNormal ];
    [rightbaritem1 setTitleTextAttributes:dic forState:UIControlStateNormal ];
    NSMutableDictionary *hightlineDic=[NSMutableDictionary dictionary];
    [hightlineDic setValue:[UIColor redColor] forKey:NSForegroundColorAttributeName];
    [rightbaritem setTitleTextAttributes:hightlineDic forState:UIControlStateHighlighted];
    [rightbaritem1 setTitleTextAttributes:hightlineDic forState:UIControlStateHighlighted];
    

    
    self.navigationItem.rightBarButtonItems = @[rightbaritem,rightbaritem1] ;
//    isPrintFinished =YES;

    NSMutableString*viewhtml=[PrinterSDK creatHtml:self.printmode];


    mywebview = [[UIWebView alloc] initWithFrame:self.view.frame];
    CGRect frame =self.view.frame;
//    frame.size.width *=2;
    mywebview.frame=frame;

    
    mywebview.delegate =self;
    [mywebview setBackgroundColor:[UIColor whiteColor]];

//    mywebview.scalesPageToFit = YES;
    [self.view addSubview:mywebview];
    //    [self.webview setFrame:self.view.bounds];
    //    CGRect frame=self.view.bounds;
    [mywebview loadHTMLString:viewhtml baseURL:nil];
    
    
    btnsend = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height -44, self.view.frame.size.width/3, 44)];
    [btnsend setBackgroundColor:[UIColor orangeColor]];
    [btnsend addTarget:self action:@selector(pressSend:) forControlEvents:UIControlEventTouchUpInside];
    [btnsend setTitle:NSLocalizedString(@"发给电脑", @"") forState:UIControlStateNormal];
    [self.view addSubview:btnsend];
    
    btnpngshare = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3, self.view.frame.size.height -44, self.view.frame.size.width/3, 44)];
    [btnpngshare setBackgroundColor:[UIColor greenColor]];
    [btnpngshare addTarget:self action:@selector(pressshareSend:) forControlEvents:UIControlEventTouchUpInside];
    [btnpngshare setTitle:NSLocalizedString(@"微信分享", @"") forState:UIControlStateNormal];
    btnpngshare.hidden =NO;
    [self.view addSubview:btnpngshare];
    
    
    btnclound = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width*2/3, self.view.frame.size.height -44, self.view.frame.size.width/3, 44)];
    [btnclound setBackgroundColor:[UIColor blueColor]];
    [btnclound addTarget:self action:@selector(pressSendcloud:) forControlEvents:UIControlEventTouchUpInside];
    [btnclound setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnclound setTitle:NSLocalizedString(@"远程云发送", @"") forState:UIControlStateNormal];
    [self.view addSubview:btnclound];
    
    [self writetofile:viewhtml];
    
 
}

//-(void)delayMethod{
//    isPrintFinished =   YES;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    CGRect frame =btnsend.frame;
    frame.origin.y =self.view.frame.size.height-44;
    btnsend.frame =frame;
    
    frame =btnclound.frame;
    frame.origin.y =self.view.frame.size.height-44;
    btnclound.frame =frame;
    
    frame =btnpngshare.frame;
    frame.origin.y =self.view.frame.size.height-44;
    btnpngshare.frame =frame;
    
}
-(NSString *)dataFilePath:(NSString*)file{
    
    // NSString*filename=[NSString stringWithFormat:@"%@.%@",file,type];
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingPathComponent:file];
    
}
-(void)writetofile:(NSMutableString*)viewhtml{

    NSString* timeString= [NSString stringWithFormat:@"%@.html",self.printmode.title.length>0?self.printmode.title:@"form"];
    
    filepath=[self dataFilePath:timeString];
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    [viewhtml writeToFile:filepath atomically:YES encoding:gbkEncoding error:nil];
    
    
    

//    UIImageWriteToSavedPhotosAlbum(sendImage, nil, nil, nil);//保存图片到照片库
    
    
}

-(void)savepngfile{
    NSString* timeString= [NSString stringWithFormat:@"%@.png",self.printmode.title.length>0?self.printmode.title:@"form"];
    
    pngpath=[self dataFilePath:timeString];
    UIScrollView*view=self.view.subviews.firstObject;
    
    view.frame=view.superview.frame;
    CGRect frm=view.frame;
    frm.size.height=mywebview.scrollView.contentSize.height;
    frm.size.width=mywebview.scrollView.contentSize.width;
    view.frame=frm;
    
    [view.superview layoutIfNeeded];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(frm.size.width,frm.size.height), YES, 0);     //设置截屏大小
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef imageRef = viewImage.CGImage;
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRef];
    NSData *savepng =UIImagePNGRepresentation(sendImage);
    [savepng writeToFile:pngpath atomically:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)rightbarPress1:(id)sender;
{
    PrinterListViewController *detail =[[PrinterListViewController alloc] init];
    detail.taskmodel =self.printmode;
    detail.printerTag =self.printerTag;
    [self.navigationController pushViewController:detail animated:YES];
    
}
-(void)rightbarPress:(id)sender;
{
    //    if (![[self appDelegate] isvipusershowmsg:YES]) {
    //        return;
    //    }
    NSDictionary*configure=[PrinterSDK getPrinterSetting];
    NSNumber*printertype=[configure objectForKey:@"printertype"];
//    [SVProgressHUD showInfoWithStatus:@"正在打印..."];
    switch ([printertype intValue])
    {
        case 0:
        {
        }

        case 1:
            

        case 2:
        case 3:
        case 4:

        {
//            if (!isPrintFinished) {
//                UIAlertView *alert =[[UIAlertView alloc ] initWithTitle:nil message:@"没有出票？请重启打印机，每次打印请间隔5秒" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
//                return;
//            }
            if (self.printmode) {
                
                
                [self printThead:nil];
             
//                isPrintFinished =NO;
//                [self performSelector:@selector(delayMethod) withObject:nil afterDelay:5.0f];
                

            }
                
                break;
        }
            case 5:
            [self AirPrinterPresent];
          
            
        default:
            break;
    }
}
#pragma mark 打印
-(void)printCall:(NSNumber*)sender
{
     [SVProgressHUD showSuccessWithStatus:@"正在打印..."];
     [PrinterSDK printModel:self.printmode  printerTag:self.printerTag  failed:self.choosePrinter];

}

-(void)printThead:(NSNumber*)sender
{
        if ([PrinterSDK isPrinterAvailableEX:nil]) {
            
            [self performSelector:@selector(printCall:) withObject:sender afterDelay:0.];
            
        } else
        {
            [SVProgressHUD showWithStatus:@"正在搜索打印机，请打开打印机电源..."];
            [PrinterSDK autoConnectPrinter:nil delegate:self];
            
        }
}

-(void)didConnected:(NSString*)deviceUid Result:(BOOL)success;
{
    NSLog(@"打印机连接回调 %d",success);
    [SVProgressHUD dismiss];
    if(success)
        [self performSelector:@selector(printCall:) withObject:@YES afterDelay:0.];
    else
    {
        PrinterListViewController *detail=[[PrinterListViewController alloc] init];
        detail.taskmodel =self.printmode ;
        detail.printerTag =self.printerTag;
        [self.navigationController pushViewController:detail animated:YES];
    }
    
    
}



-(void)AirPrinterPresent;
{
    /* Get the UIPrintInteractionController, which is a shared object */
    UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
    if(!controller){
        NSLog(@"Couldn't get shared UIPrintInteractionController!");
        return;
    }
    
    /* Set this object as delegate so you can  use the printInteractionController:cutLengthForPaper: delegate */
    controller.delegate = self;
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    
    /* Use landscape orientation for a banner so the text  print along the long side of the paper. */
    //    printInfo.orientation = UIPrintInfoOrientationLandscape;
    
    printInfo.jobName = @"receipt";
    controller.printInfo = printInfo;
    
    
    /* Create the UISimpleTextPrintFormatter with the text supplied by the user in the text field */
    //    UISimpleTextPrintFormatter* textFormatter = [[UISimpleTextPrintFormatter alloc] initWithText:printText];
    //
    //    /* Set the text formatter's color and font properties based on what the user chose */
    //    textFormatter.color = [UIColor blackColor];
    //    textFormatter.font = [UIFont systemFontOfSize:17];
    
    /* Set this UISimpleTextPrintFormatter on the controller */
    controller.printFormatter = [mywebview viewPrintFormatter] ;
    
    /* Set up a completion handler block.  If the print job has an error before spooling, this is where it's handled. */
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if(completed && error)
            NSLog( @"Printing failed due to error in domain %@ with error code %lu. Localized description: %@, and failure reason: %@", error.domain, (long)error.code, error.localizedDescription, error.localizedFailureReason );
    };
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [controller presentFromRect:CGRectMake(self.view.frame.size.width/2-100, self.view.frame.size.height/2-100, 200, 200) inView:self.view animated:YES completionHandler:completionHandler];
    else
        [controller presentAnimated:YES completionHandler:completionHandler];  // iPhone
}

- (CGFloat)printInteractionController:(UIPrintInteractionController *)printInteractionController cutLengthForPaper:(UIPrintPaper *)paper {
    NSLog(@"cutLengthForPaper");
    /* Create a font with arbitrary size so that you can calculate the approximate
     font points per screen point for the height of the text. */
    UIFont *font =[UIFont systemFontOfSize:17];
    CGSize size = [printText sizeWithAttributes:@{NSFontAttributeName: font}];
    
    float approximateFontPointPerScreenPoint = font.pointSize / size.height;
    
    /* Create a new font using a size  that will fill the width of the paper */
    font = [UIFont systemFontOfSize : paper.printableRect.size.width * approximateFontPointPerScreenPoint];
    
    /* Calculate the height and width of the text with the final font size */
    CGSize finalTextSize = [printText sizeWithAttributes:@{NSFontAttributeName: font}];
    
    /* Set the UISimpleTextFormatter font to the font with the size calculated */
    //    _textFormatter.font = font;
    
    /* Calculate the margins of the roll. Roll printers may have unprintable areas
     before and after the cut.  We must add this to our cut length to ensure the
     printable area has enough room for our text. */
    CGFloat lengthOfMargins = paper.paperSize.height - paper.printableRect.size.height;
    
    /* The cut length is the width of the text, plus margins, plus some padding */
    return finalTextSize.width + lengthOfMargins + paper.printableRect.size.width * PaddingFactor;
}
-(void)pressshareSend:(id)sender
{
    UIButton*btn =sender;
     [btn setBackgroundColor:[UIColor grayColor]];
  
    
    [self savepngfile];
    
    NSString *cachePath =pngpath;
    
    
    documentController =
    
    
    [UIDocumentInteractionController
     
     interactionControllerWithURL:[NSURL fileURLWithPath:cachePath]];
    
    documentController.delegate = self;
    

    
    [documentController presentOpenInMenuFromRect:CGRectZero
     
                                           inView:self.view
     
                                         animated:YES];
}
- (IBAction)pressSend:(id)sender {
    
    UIButton*btn =sender;
    [btn setBackgroundColor:[UIColor grayColor]];
    
    NSString *cachePath =filepath;
    

    documentController =
    
    
    [UIDocumentInteractionController
     
     interactionControllerWithURL:[NSURL fileURLWithPath:cachePath]];
    
    documentController.delegate = self;
    
    //    documentController.UTI=@"public.html";
    
    [documentController presentOpenInMenuFromRect:CGRectZero
     
                                           inView:self.view
     
                                         animated:YES];
}
- (IBAction)pressSendcloud:(id)sender
{
    if (self.printmode.cloudPrinterSN.length==0) {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"请购买云打印机，并且在公司设置中登记打印机SN序号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }else{
        UIButton*btn =sender;
        [btn setBackgroundColor:[UIColor grayColor]];
        
    [PrinterSDK cloudPrintModel:self.printmode printerSN:self.printmode.cloudPrinterSN  sender:self];
    [PrinterSDK cleanPrinterBuffer];
//    [SVProgressHUD showWithStatus:@"正在远程打印，5秒后反馈结果..."];
    }
}
-(void)printResult:(NSInteger)code message:(NSString*)msg
{
    [SVProgressHUD dismiss];
    if (code >=0) {
        [SVProgressHUD showSuccessWithStatus:msg];
    }
    else
        [SVProgressHUD showErrorWithStatus:msg];
}

#pragma mark web log

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    CGFloat webViewHeight =[[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    CGFloat webViewWidth =[[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetWidth"] floatValue];
    
    // CGFloat webViewHeight= [[webViewstringByEvaluatingJavaScriptFromString:@document.body.scrollHeight]floatValue];
    CGRect newFrame = webView.frame;
    newFrame.size.height= webViewHeight;
    if (webViewWidth<350) {
        webViewWidth+=150;
    }
    newFrame.size.width=webViewWidth;

    mywebview.scrollView.contentSize =CGSizeMake(newFrame.size.width, newFrame.size.height+84+60);
}
@end
