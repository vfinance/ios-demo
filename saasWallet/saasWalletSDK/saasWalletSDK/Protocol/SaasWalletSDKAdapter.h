#import <Foundation/Foundation.h>
#import "saasWalletSDKClass.h"

@interface SaasWalletSDKAdapter : NSObject

+ (BOOL)saasWalletRegisterWeChat:(NSString *)appid;
+ (BOOL)saasWalletIsWXAppInstalled;
+ (void)saasWalletRegisterPayPal:(NSString *)clientID secret:(NSString *)secret sandbox:(BOOL)isSandbox;
+ (BOOL)saasWallet:(NSString *)object handleOpenUrl:(NSURL *)url;

+ (BOOL)saasWalletWXPay:(NSMutableDictionary *)dic;
+ (BOOL)saasWalletAliPay:(NSMutableDictionary *)dic;
+ (BOOL)saasWalletUnionPay:(NSMutableDictionary *)dic;
+ (BOOL)saasWalletApplePay:(NSMutableDictionary *)dic;
+ (NSString *)saasWalletBaiduPay:(NSMutableDictionary *)dic;
+ (BOOL)saasWalletSandboxPay;
+ (BOOL)saasWalletCanMakeApplePayments:(NSUInteger)cardType;

+ (void)saasWalletPayPal:(NSMutableDictionary *)dic;
+ (void)saasWalletPayPalVerify:(NSMutableDictionary *)dic;
+ (void)saasWalletOfflinePay:(NSMutableDictionary *)dic;
+ (void)saasWalletOfflineStatus:(NSMutableDictionary *)dic;
+ (void)saasWalletOfflineRevert:(NSMutableDictionary *)dic;

+ (void)saasWalletInitVFWXPay:(NSString *)wxAppId;
+ (void)saasWalletVFWXPay:(NSMutableDictionary *)dic;


@end
