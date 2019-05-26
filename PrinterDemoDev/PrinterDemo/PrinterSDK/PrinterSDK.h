
// ---------------使用必读--------------
#warning 使用必读
/*  ---------------使用必读--------------
 1.已经支持58mm 80mm 110mm 蓝牙打印机，针式打印机适配器，以及airprint苹果台式打印机。如果发现适配问题（乱码，二维码不能打印等），
 请联系QQ153887715
 2.使用此sdk表示同意只使用我们代理的打印机（物美价廉^-^），淘宝搜索店铺，手机进销存掌上开单
 3.实现功能，订单打印，二维码打印（部分打印机），多手机同时打印（部分打印机），打印速度快，自动重连
 4.无法打印的打印机，多半是因为打印机品牌太小，没有适配，请到我们淘宝购买正品。
 */

#import <UIKit/UIKit.h>
//打印完成通知
#define kNotify_print_finish @"kNotify_print_finish"
//打印机断开通知
#define kNotify_print_disconnect @"kNotify_print_disconnect"

//绑定的小票打印机
#define keydefaultprintername @"keydefaultprintername"
#define keydefaultprinteruid @"keydefaultprinteruid"
//绑定的标签打印机
#define keydefaultlabelprintername @"keydefaultlabelprintername"

#define kNextLineFalseFlag @"kNextLineFalseFlag"
#define kNoDefaultPrinter @"kNoDefaultPrinter"

//打印机delegate
@protocol BluetoothDelegate <NSObject>
@optional
-(void)BlueToothOpen:(BOOL)isopen;
-(void)updateBluetoothDevice:(NSMutableArray*)devices;
-(void)didConnected:(NSString*)deviceUid Result:(BOOL)success;
-(void)finishPrint;
-(void)printResult:(NSInteger)code message:(NSString*)msg;
@end

//自带的一个商品销售模版，只需要填入订单内容，就会自动排版打印，适合小白开发者
@interface printModel : NSObject
//订单头部
@property (nonatomic,copy) UIImage *logo;//图标 最好是长方形 比如 320x80
@property (nonatomic,copy) NSString *title;//标题 四季青精品店(销售单)
@property (nonatomic,copy) NSString *subtitle;//副标题
@property (nonatomic,copy) NSString *headText;//页眉

//订单里购买的商品列表
//@property (nonatomic,strong) NSNumber *headerMultiValuesType;//主体内容的类型，0 order,1sumary
@property (nonatomic,strong) NSArray *headerMultiValues;//购买的商品列表
@property (nonatomic,copy) NSString *bodyText;//自定义的商品列表内容
@property (nonatomic,copy) NSString *sumaryText;//总计 大字体打印

//核销内容
@property (nonatomic,copy) NSString *bodyText2;//其他内容，比如核销的内容
@property (nonatomic,copy) NSString *sumaryText2;//核销的总计 大字体打印

//页脚
@property (nonatomic,copy) NSString *footText;//页脚
@property (nonatomic,copy) NSString *advise;//广告 foottext的下方
@property (nonatomic,copy) NSString *barcode;//二维码地址，多个二维码，用逗号分隔

//打印机配置
@property (nonatomic,copy) NSString *cloudPrinterSN;//云打印机sn，多个打印机用逗号分隔
@end


//标签打印模型
@interface LabelModel : NSObject
//坐标，以左上角为顶点
@property (nonatomic,copy) NSNumber *x; //x坐标，所有尺度都以mm为单位
@property (nonatomic,copy) NSNumber *y;//x坐标
@property (nonatomic,copy) NSNumber *Rotation;//Rotation
//尺寸
@property (nonatomic,copy) NSNumber *height;//条码的高度，宽度无需指定
@property (nonatomic,copy) NSNumber *width;//二维码的宽度，高度和宽度一致
@property (nonatomic,copy) NSNumber *xscale;//x方向拉伸字体，barcode模式下为白条宽,line 宽
@property (nonatomic,copy) NSNumber *yscale;//y方向拉伸字体，barcode模式下为黑条宽，line 高

//内容和类型
@property (nonatomic,copy) NSString *text;//文字或者条码或者二维码
@property (nonatomic,copy) NSNumber *type;//0 text,1 barcode,2qrcode,3 line


@end

@interface PrinterSDK : NSObject
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
 @"keepAlive":@1 //0打印后断开以让其他手机连接，1自动决定，2打印后继续连接（下次打印速度快）
 @"pagecut":@0//210mm针打，全等分，2等分，3等分
 };
 */
+(NSDictionary*)getPrinterSetting;
+(void)setPrinterSetting:(NSDictionary*)dic;
#pragma mark 连接打印机
//扫描打印机
+(void)SetBlutoothDelegate:(id)delegate;
+(void)StartScan;
+(void)StopScan;
//清空打印机缓存，重新登录app后调用
+(void)cleanPrintList;

//自动连接打印机，nameFlag为空时去连接绑定的打印机，否则连接指定的打印机名
+(BOOL)autoConnectPrinter:(NSString*)printerName delegate:(id)sender;
+(void)connectPrinterTag:(NSInteger)tag device:(id)deviceObj;
//断开链接
+(void)disconnectPrinter:(NSString*)uid;
+(BOOL)disconnectLabelPrinter;
#pragma mark 打印机是否连接
//打印机是否处于连接状态
+(BOOL)isPrinterConnected:(NSString*)uid;
//判断打印是否可用，是否扫描到？
+(BOOL)isPrinterAvailableEX:(NSString*)uid;
//初始化打印机，针式打印机和rp410需要
+(void)setInitformat;
#pragma mark 模版打印接口
//根据订单数据model打印，SDK负责排版,
+(BOOL)printModel:(printModel*)model   printerTag:(NSInteger)pTag  failed:(void (^)( BOOL res ))onfailed
;

//云打印机
+(BOOL)cloudPrintModel:(printModel*)model printerSN:(NSString*)sn sender:(id)sender;


#pragma mark 自定义打印接口，先填充数据，再启动打印
//分行格式控制打印
//fontSize 字体大小 0小字体,1中字体,2大，
//lineSpace  :行间距 0～254 默认28  对应4毫米
//alin 对齐 0左，1居中，2右
//rotation 0竖直打印，1顺时针旋转90度打印
+(void)setPrintFormat:(int)printerfontsize LineSpace:(int)lineSpace alinment:(int)alin rotation:(int)rotation;
+(void)addPrintText:(NSString*)text;
+(void)addPrintImage:(UIImage*)img;
//+(NSString*)addItemLines:(NSArray*)lines type:(NSNumber*)type;//打印多行商品列表0,order,1 suamry
//打印表格列表，第一行为宽度，第二行开始为数据,自动对齐，自动添加表格
//@[
//@[@"6",@"4",@"2",@"2",@"1"],//每一列的最大字符长度,最后一个数字表示是否添加下划线
//@[@"名称",@"规格",@"数量",@"价格",@"1"],
//@[@"土豆炖牛肉",@"小份",@"2",@"50",@"1"]
//@[@"裤子",@"白色",@"1",@"500",@"1"]
//]
+(NSString*)addTableList:(NSArray*)lines needFrame:(BOOL)needFrame;
+(void)addPrintData:(NSData *)data;//直接发送命令
//二维码或者一维码 text必须是英文字符 ，istwo＝NO 打印一维码，text必须是12-13位数字
+(void)addPrintBarcode:(NSString*)text isTwoDimensionalCode :(int)isTwo;
//清空打印的buffer，比如之前加了很多待打印的文字图片，现在蛋疼不想打了
+(void)cleanPrinterBuffer;
//打印并清空前面添加的文字图片，如果返回NO则会缓存本次打印数据，nav用来push出打印机选择列表,
+(BOOL)startPrint:(UINavigationController*)nav deviceTag:(NSInteger)tag;
//掌上开单内部打印标签接口，其他用户请使用startPrintLabel，
+(BOOL)startPrintEX:(UINavigationController *)nav deviceTag:(NSInteger)tag info:(NSDictionary*)info;
/**
 公开的标签打印接口 需要支持不干胶打印的机器
 
 @param nav 为了方便弹出打印机界面
 @param info，打印内容和控制信息
 NSNumber* labelwidth =info[@"labelwidth"];
 NSNumber* labelheight =info[@"labelheight"];
 NSNumber *endcut =info[@"endcut"];
 NSArray *contentlist =info[@"contentlist"];
 contentlist 为LabelModel
 @return yes,  NO则需要重新打印
 */
+(BOOL)startPrintLabel:(UINavigationController *)nav content:(NSDictionary*)info;

#pragma mark utils 一些小动作
//切纸 并且进纸N个点 不能自动切的无作用
+(void)cutPage:(int)n;
+(void)nextPage;
+(void)setpageLen:(int)n;
+(NSInteger)getPrinterMaxWidth;//当前打印机和当前字体下支持的行最大字符数
+(NSString*)getSplitLine;//当前打印机的分割线，虚线
+(NSString*)getSplitLine:(int)type;//表格类型的分割线，实线
+(int)getStringByteLen:(NSString*)str;//字符串在打印机中占的长度
+(NSString*)addVerifyNumberForBarcode:(NSString*)basecode;//12位的一维码加上校验码，否则部分打印机可能打印错误
+(NSString*)creatHtml:(printModel*)model;
@end


