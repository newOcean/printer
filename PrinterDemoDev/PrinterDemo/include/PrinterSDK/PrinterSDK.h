//---------------使用必读--------------
//---------------使用必读--------------
//---------------使用必读--------------
//---------------使用必读--------------
//---------------使用必读--------------

/*  ---------------使用必读--------------
 1.已经支持58mm 80mm 110mm 蓝牙打印机，针式打印机适配器，以及airprint苹果台式打印机。如果发现适配问题（乱码，二维码不能打印等），请联系QQ40255986
 2.使用此sdk表示同意只使用我们代理的打印机（物美价廉^-^）,咨询淘宝购买网址http://shop113684150.taobao.com
 3.实现功能，订单打印，二维码打印（部分打印机），多手机同时打印（部分打印机），打印速度快，自动重连
 4.无法打印的打印机，多半是因为打印机品牌太小，没有适配，请到我们淘宝购买。
*/





#import <UIKit/UIKit.h>

//! Project version number for PrinterSDK.
//FOUNDATION_EXPORT double PrinterSDKVersionNumber;
//
////! Project version string for PrinterSDK.
//FOUNDATION_EXPORT const unsigned char PrinterSDKVersionString[];
#define kNotify_print_finish @"kNotify_print_finish"
#define kNotify_print_disconnect @"kNotify_print_disconnect"
//打印机delegate
@protocol BluetoothDelegate <NSObject>
@optional
-(void)BlueToothOpen:(BOOL)isopen;
-(void)updateBluetoothDevice:(NSMutableArray*)devices;
-(void)didConnected:(NSString*)deviceUid Result:(BOOL)success;
-(void)finishPrint;

@end

//订单头尾内容
@interface printModel : NSObject<NSCopying>
@property (nonatomic,copy) NSString *title;//标题 四季青精品店(销售单)
@property (nonatomic,copy) NSString *headText;//页眉，

//主体内容三选一
@property (nonatomic,strong) NSArray *headerMultiValues;//一行表头 多行值
@property (nonatomic,strong) NSArray *headersValues;//一行表头一行值
@property (nonatomic,copy) NSString *bodyText;//主体内容

@property (nonatomic,copy) NSString *sumaryText;//总计 大字体打印
@property (nonatomic,copy) NSString *bodyText2;//核销 小字体打印
@property (nonatomic,copy) NSString *sumaryText2;//总计 大字体打印

@property (nonatomic,copy) NSString *footText;//页脚
@property (nonatomic,copy) NSString *advise;//广告 foottext的下方
@property (nonatomic,copy) NSString *barcode;//二维码地址


//--------end

//@property int odertype;//0销售单 1采购单 2批发单 如果写了标题就不需要
@property BOOL isLabel;//打印标签，打印productList中所有商品的标签,name,color,size,barcode_1,price
//@property BOOL composedSummary;//数量 价格 小记 是否合到一起（数量/单价/小记）
@end

@interface PrinterWraper : NSObject
/* 打印设置的默认值，可以修改，或者获取此值，对应于打印模版设置的内容
 @"lineSpace"  :@28    0～254 默认28  对应4毫米
  @{@"printertype":@0,// 打印机宽度  0 58mm,1 80mm,2 110mm,3,A4 针式打印机蓝牙适配器,3 airprint A4（台式无线打印机）
@"printerfontsize":@0,//字体大小 0自动, 1小，2中，3大,
@"copycount":@0,//0 1联，1 2联 ，2 3联
@"autoprint":@0,//0 不自动打印  1自动打印
@"company":NSLocalizedString(@"公司名称", @""),//公司名称 第一行自动居中 大字体，可多行
@"operater":NSLocalizedString(@"店小二", @""),//开单员
@"welcome":NSLocalizedString(@"谢谢惠顾", @""),//页脚，可多行
@"barcode":@"",//二维码的链接地址

@"name":@YES,//名称
@"code":@NO,//商品条码编号
@"styenum":@YES,//款号 货号
@"color":@YES,//颜色
@"spec":@NO,//规格
@"count":@YES,//数量
@"unit":@YES,//单位
@"price":@YES,//价格
@"xiaoji":@YES,//小记
@"comment":@YES,//订单备注

 @"keepAlive":@1 //0打印后断开以让其他手机连接，1自动决定，2打印后继续连接（下次打印速度快）
};
 */
+(NSDictionary*)getPrinterSetting;
+(void)setPrinterSetting:(NSDictionary*)dic;
+(NSInteger)getPrinterMaxWidth;//获取打印机字符宽度，32～60个字符宽
+(NSString*)getSplitLine;//获取标准的分割线
//扫描打印机
+(void)SetBlutoothDelegate:(id)delegate;
+(void)StartScanTimeout:(int)timeout;
+(void)StopScan;

+(void)connectPrinterTag:(NSInteger)tag uid:(NSString*)peripheraluid useCache:(BOOL)cache;
+(void)disconnectPrinter:(NSString*)uid;

//选择打印机
//+(void)chooseNewPrinter:(UIViewController*)sender;
//自动连接上一次使用的打印机
+(void)autoConnectLastPrinterTimeout:(NSInteger)timeout Completion:(void(^)(NSString *))block;
+(BOOL)isPrinterConnected:(NSString*)uid;
+(BOOL)isPrinterAvailable:(NSString*)uid;
//+(BOOL)isConnected;


//根据订单数据model打印，SDK负责排版,
+(BOOL)printModel:(printModel*)model fromviewc:(UIViewController*)sender  printerTag:(NSInteger)tag preview:(BOOL)preview failed:(void (^)( BOOL res ))choose;
//分行格式控制打印
//fontSize 字体大小 0小字体,1中字体,2大，
//lineSpace  :行间距 0～254 默认28  对应4毫米
//alin 对齐 0左，1居中，2右
//rotation 0竖直打印，1顺时针旋转90度打印
+(void)setPrintFormat:(int)printerfontsize LineSpace:(int)lineSpace alinment:(int)alin rotation:(int)rotation;
+(void)addPrintText:(NSString*)text;
+(void)addPrintImage:(UIImage*)img;
+(void)addItemLines:(NSArray*)headervalue;//打印多行商品列表

//将12位的随机数字 加上最后一位校验码，返回13位的upc码，11位的输入则返回12位upc码
+(NSString*)addUPCLastVerifyCode:(NSString*)basecode;
//二维码或者一维码 text必须是英文字符 ，istwo＝NO 打印一维码，text必须是12-13位数字
+(void)addPrintBarcode:(NSString*)text isTwoDimensionalCode :(int)isTwo;

//清空打印的buffer，比如之前加了很多待打印的文字图片，现在蛋疼不想打了
+(void)cleanPrinterBuffer;
//打印并清空前面添加的文字图片，如果返回NO则会缓存本次打印数据，nav用来push出打印机选择列表,
+(BOOL)startPrint:(UINavigationController*)nav deviceTag:(NSInteger)tag;
+(void)addPrintData:(NSData *)data;//直接发送命令
//定位到下一页
+(void)moveToNextPage;

@end


