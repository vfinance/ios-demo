#ifndef SaasWalletSDK_SaasWalletSDKAdapterProtocol_h
#define SaasWalletSDK_SaasWalletSDKAdapterProtocol_h

#import <Foundation/Foundation.h>
#import "saasWalletSDKClass.h"

@protocol SaasWalletSDKAdapterDelegate <NSObject>

@optional
- (BOOL)registerWeChat:(NSString *)appid;
- (BOOL)isWXAppInstalled;
- (void)registerPayPal:(NSString *)clientID secret:(NSString *)secret sandbox:(BOOL)isSandbox;
- (BOOL)handleOpenUrl:(NSURL *)url;

- (BOOL)wxPay:(NSMutableDictionary *)dic;
- (BOOL)aliPay:(NSMutableDictionary *)dic;
- (BOOL)unionPay:(NSMutableDictionary *)dic;
- (BOOL)applePay:(NSMutableDictionary *)dic;
- (NSString *)baiduPay:(NSMutableDictionary *)dic;
- (BOOL)sandboxPay;
- (BOOL)canMakeApplePayments:(NSUInteger)cardType;

- (void)payPal:(NSMutableDictionary *)dic;
- (void)payPalVerify:(NSMutableDictionary *)dic;

- (void)offlinePay:(NSMutableDictionary *)dic;
- (void)offlineStatus:(NSMutableDictionary *)dic;
- (void)offlineRevert:(NSMutableDictionary *)dic;
//VF_WX_APP
- (void)initVFWXPay:(NSString *)wxAppId;
- (void)vfWXPay:(NSMutableDictionary *)dic;

@end

#endif
