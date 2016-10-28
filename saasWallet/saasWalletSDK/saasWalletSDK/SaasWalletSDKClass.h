#import <UIKit/UIKit.h>
#import "VFPayObjects.h"
#import "VFPayConstant.h"

#pragma mark - SaasWalletSDK
@interface SaasWalletSDK : NSObject

/**
 *  SharedInstance
 *
 *  @return SharedInstance
 */
+ (instancetype)sharedInstance;

/**
 *  全局初始化
 *
 *  @param appId     VFinance平台APPID
 *  @param appSecret VFinance平台密钥APPSECRET(生产密钥)/TESTSECRET(测试密钥)
 *
 *  @return 初始化成功返回YES; 若appId或者appSecret不合法，初始化失败返回NO
 */
+ (BOOL)initWithAppID:(NSString *)appId andAppSecret:(NSString *)appSecret;

/**
 *  全局初始化
 *
 *  @param appId     VFinance平台AppID
 *  @param appSecret VFinance平台密钥APPSECRET(生产密钥)/TESTSECRET(测试密钥)
 *  @param isSandbox 是否是沙箱测试模式
 *
 *  @return 初始化成功返回YES；失败返回NO
 */
+ (BOOL)initWithAppID:(NSString *)appId andAppSecret:(NSString *)appSecret sandbox:(BOOL)isSandbox;

/**
 *  需要在每次启动第三方应用程序时调用。第一次调用后，会在微信的可用应用列表中出现。
 *  iOS7及以上系统需要调起一次微信才会出现在微信的可用应用列表中。
 *
 *  @param wxAppID 微信开放平台创建APP的APPID
 *
 *  @return 成功返回YES，失败返回NO。只有YES的情况下，才能正常执行微信支付。
 */
+ (BOOL)initWeChatPay:(NSString *)wxAppID;

/**
 *  init PayPal
 *
 *  @param clientID paypal clientId
 *  @param secret   paypal secret
 *  @param isSandbox 是否是sandbox环境
 *
 *  @return  初始化成功返回YES; 若clientID或者secret不合法，初始化失败返回NO
 */
+ (BOOL)initPayPal:(NSString *)clientID secret:(NSString *)secret sandbox:(BOOL)isSandbox;

/**
 * 处理通过URL启动App时传递的数据。需要在application:openURL:sourceApplication:annotation:中调用。
 *
 * @param url 启动第三方应用时传递过来的URL
 *
 * @return 成功返回YES，失败返回NO。
 */
+ (BOOL)handleOpenUrl:(NSURL *)url;

/**
 *  设置接收消息的对象
 *
 *  @param delegate SaasWalletSDKDelegate对象，用来接收SaasWalletSDK触发的消息。
 */
+ (void)setSaasWalletSDKDelegate:(id<SaasWalletSDKDelegate>)delegate;

/**
 *  获取接收消息的对象
 *
 *  @return SaasWalletSDKDelegate对象，用来接收SaasWalletSDK触发的消息。
 */
+ (id<SaasWalletSDKDelegate>)getSaasWalletSDKDelegate;

/**
 *  设置开启或关闭沙箱测试环境
 *
 *  @param sandbox YES表示开启沙箱、关闭生产环境，并请确保已经初始化沙箱环境；NO表示关闭沙箱环境、开启生产环境，并确保已经初始化生产环境
 */
+ (void)setSandboxMode:(BOOL)sandbox;

/**
 *  如果是sandbox环境，返回YES；
 *  如果是live环境，返回NO；
 *
 *  @return YES表示当前是沙箱测试环境
 */
+ (BOOL)getCurrentMode;

/**
 *  判断手机是否支持Apple Pay；商户可以根据此方法返回的值来决定是否显示Apple Pay的支付图标
 *
 *  @param cardType  0 表示不区分卡类型；1 表示只支持借记卡；2 表示支持信用卡；
 *  @return YES表示支持
 */
+ (BOOL)canMakeApplePayments:(NSUInteger)cardType;

/**
 *  获取API版本号
 *
 *  @return 版本号
 */
+ (NSString *)getVFApiVersion;

/**
 *  设置是否打印log
 *
 *  @param flag YES打印
 */
+ (void)setWillPrintLog:(BOOL)flag;

/**
 *  设置网络请求超时时间
 *
 *  @param time 超时时间, 5.0代表5秒。
 */
+ (void)setNetworkTimeout:(NSTimeInterval)time;

/**
 *  配置VF_WX_APP支付环境
 *
 *  @param wxAppId 微信开放平台创建的应用appid。
 */
+ (void)initVFWXPay:(NSString *)wxAppId;

#pragma mark - Send SaasWalletSDK Request

/**
 *  发送SaasWalletSDK Request请求
 *
 *  @param req 请求体
 *
 *  @return 发送请求是否成功
 */
+ (BOOL)sendVFReq:(VFBaseReq *)req;

#pragma mark - Query Supported Pay Channel Request

/**
 *  获取后台支持的支付渠道
 */
+ (void)queryPayChannel;

@end
