#import "VFPayCache.h"
#import "VFPayConstant.h"
#import "saasWalletSDKClass.h"

@implementation VFPayCache

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    __strong static VFPayCache *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[VFPayCache alloc] init];
        
        instance.appId = nil;
        instance.appSecret = nil;
        instance.sandbox = NO;
        
        instance.payPalClientID = nil;
        instance.payPalSecret = nil;
        instance.isPayPalSandbox = NO;
        
        instance.vfResp = [[VFBaseResp alloc] init];
        
        instance.networkTimeout = 5.0;
        instance.willPrintLogMsg = NO;
        
    });
    return instance;
}

+ (BOOL)vfinanceDoResponse {
    id<SaasWalletSDKDelegate> delegate = [SaasWalletSDK getSaasWalletSDKDelegate];
    if (delegate && [delegate respondsToSelector:@selector(onSaasWalletSDKResp:)]) {
        [delegate onSaasWalletSDKResp:[VFPayCache sharedInstance].vfResp];
        return YES;
    }
    return NO;
}

@end
