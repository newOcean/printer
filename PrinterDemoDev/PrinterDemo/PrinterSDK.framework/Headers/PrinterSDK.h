//---------------使用必读--------------
//---------------使用必读--------------
//---------------使用必读--------------
//---------------使用必读--------------
//---------------使用必读--------------

/*  ---------------使用必读--------------
 1.已经支持58mm 80mm 110mm 蓝牙打印机，以及airprint苹果台式打印机。如果发现适配问题（乱码，二维码不能打印等），请联系QQ40255986
 2.使用此sdk表示同意只使用我们代理的打印机（物美价廉^-^）,咨询淘宝购买网址http://shop113684150.taobao.com
 3.库在使用时，加入工程，并且在工程设置 General ->Embedded Binaries 添加此库
 4.实现功能，订单打印，二维码打印（部分打印机），多手机同时打印（部分打印机），打印速度快，自动重连
*/





#import <UIKit/UIKit.h>

//! Project version number for PrinterSDK.
//FOUNDATION_EXPORT double PrinterSDKVersionNumber;
//
////! Project version string for PrinterSDK.
//FOUNDATION_EXPORT const unsigned char PrinterSDKVersionString[];
#define kNotify_print_finish @"kNotify_print_finish"
#define kNotify_print_disconnect @"kNotify_print_disconnect"
//销售商品列表
@interface productModel : NSObject<NSCopying>
@property (nonatomic,copy) NSString *oderType;//交易类型 订货，
@property (nonatomic,copy) NSString *name;//名称
@property (nonatomic,copy) NSString *styeNum;//款号 货号
@property (nonatomic,copy) NSString *barcode_1;//条码
@property (nonatomic,copy) NSString *extra1;//颜色 重量 生产日期
@property (nonatomic,copy) NSString *extra2;//尺寸 crv  保质期
@property (nonatomic,copy) NSString *spec;//规格
@property (nonatomic,copy) NSString *unit;//单位
@property (nonatomic,copy) NSString *brand;//品牌

@property (nonatomic,copy) NSString *catogry;//分类


@property (nonatomic,copy) NSString *count;//数量
@property (nonatomic,copy) NSString *price;//价格
@property (nonatomic,copy) NSString *sum;//小记
@end

//订单头尾内容
@interface printModel : NSObject<NSCopying>

@property (nonatomic,copy) NSString *headText;//页眉下面，客户 单号 日期
@property (nonatomic,copy) NSString *footText;//页脚上面 上期结余 本期应收 下棋结余 备注
@property (nonatomic,copy) NSString *barcode;//二维码地址
@property (nonatomic,strong) NSArray *productList;//productModel
@property (nonatomic,copy) NSString *title;//标题 四季青精品店(销售单)


//预览时使用
@property (nonatomic,copy) NSString *time;//订单日期
@property (nonatomic,copy) NSString *customer;//客户详情
@property (nonatomic,copy) NSString *totalAmount;//本单金额
@property (nonatomic,copy) NSString *payed;//本单付款
@property (nonatomic,copy) NSString *arrears;//累积欠款
@property (nonatomic,copy) NSString *comment;//备注
//--------end

@property int odertype;//0销售单 1采购单 2批发单 如果写了标题就不需要
@property BOOL isLabel;//打印标签，打印productList中所有商品的标签,name,color,size,barcode_1,price
@property BOOL composedSummary;//数量 价格 小记 是否合到一起（数量/单价/小记）
@end

@interface PrinterWraper : NSObject
/* 打印设置的默认值，可以修改，或者获取此值，对应于打印模版设置的内容
 @"lineSpace"  :@28    0～254 默认28  对应4毫米
  @{@"printertype":@0,// 打印机宽度  0 58mm,1 80mm,2 110mm,3 airprint A4（台式无线打印机）
@"printerfontsize":@0,//字体大小 0 小，1中，2大
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

 @"needdisconnect":@NO //YES打印后断开 支持多手机机链接，速度较慢
};
 */
+(NSDictionary*)getPrinterSetting;

+(void)setPrinterSetting:(NSDictionary*)dic;




//打印内容,需要自己排版好

/*
 dic=@{@"textToPrint":textToPrint,@"barcode":barcode};
 sender 用来打开蓝牙选择列表，如果是首次打印请确保本身的navigationController是有效的
 uid 指定打印机  nil
 */
+(BOOL)printDictionary:(NSDictionary*)dic fromviewc:(UIViewController*)sender  printeruid:(NSString*)uid needPreview:(BOOL)needPreview;

//根据订单数据model打印，SDK负责排版
+(BOOL)printModel:(printModel*)model fromviewc:(UIViewController*)sender  printeruid:(NSString*)uid preview:(BOOL)preview;
//显示预览
+(void)presentPreviewFromView:(UIViewController*)vc oderlist:(NSArray*)oderlist odertype:(BOOL)isbuy;
//选择新的打印机 配置小票模版 请确保本身的navigationController是有效的
+(void)chooseNewPrinter:(UIViewController*)sender;
//自动连接上一次使用的打印机
+(void)autoConnectLastPrinterTimeout:(NSInteger)timeout Completion:(void(^)(NSString *))block;
+(BOOL)isConnected;
@end


