#import "SaasWalletSDKAdapter.h"
#import "SaasWalletSDKAdapterProtocol.h"
#import "VFPayCache.h"

@implementation SaasWalletSDKAdapter

+ (BOOL)saasWalletRegisterWeChat:(NSString *)appid {
    id adapter = [[NSClassFromString(kAdapterWXPay) alloc] init];
    if (adapter && [adapter respondsToSelector:@selector(registerWeChat:)]) {
        return [adapter registerWeChat:appid];
    }
    return NO;
}

+ (BOOL)saasWalletIsWXAppInstalled {
    id adapter = [[NSClassFromString(kAdapterWXPay) alloc] init];
    if (adapter && [adapter respondsToSelector:@selector(isWXAppInstalled)]) {
        return [adapter isWXAppInstalled];
    }
    return NO;
}

+ (void)saasWalletRegisterPayPal:(NSString *)clientID secret:(NSString *)secret sandbox:(BOOL)isSandbox {
    id adapter = [[NSClassFromString(kAdapterPayPal) alloc] init];
    if (adapter && [adapter respondsToSelector:@selector(registerPayPal:secret:sandbox:)]) {
        [adapter registerPayPal:clientID secret:secret sandbox:isSandbox];
    }
}

+ (BOOL)saasWallet:(NSString *)object handleOpenUrl:(NSURL *)url {
    id adapter = [[NSClassFromString(object) alloc] init];
    if (adapter && [adapter respondsToSelector:@selector(handleOpenUrl:)]) {
        return [adapter handleOpenUrl:url];
    }
    return NO;
}

+ (BOOL)saasWalletWXPay:(NSMutableDictionary *)dic {
    id adapter = [[NSClassFromString(kAdapterWXPay) alloc] init];
    if (adapter && [adapter respondsToSelector:@selector(wxPay:)]) {
         return [adapter wxPay:dic];
    }
    return NO;
}

+ (BOOL)saasWalletAliPay:(NSMutableDictionary *)dic {
    id adapter = [[NSClassFromString(kAdapterAliPay) alloc] init];
    if (adapter && [adapter respondsToSelector:@selector(aliPay:)]) {
        return [adapter aliPay:dic];
    }
    return NO;
}

+ (BOOL)saasWalletUnionPay:(NSMutableDictionary *)dic {
    id adapter = [[NSClassFromString(kAdapterUnionPay) alloc] init];
    if (adapter && [adapter respondsToSelector:@selector(unionPay:)]) {
        return [adapter unionPay:dic];
    }
    return NO;
}

+ (BOOL)saasWalletCanMakeApplePayments:(NSUInteger)cardType {
    id adapter = [[NSClassFromString(kAdapterApplePay) alloc] init];
    if (adapter && [adapter respondsToSelector:@selector(canMakeApplePayments:)]) {
        return [adapter canMakeApplePayments:cardType];
    }
    return NO;
}

+ (BOOL)saasWalletApplePay:(NSMutableDictionary *)dic {
    id adapter = [[NSClassFromString(kAdapterApplePay) alloc] init];
    if (adapter && [adapter respondsToSelector:@selector(applePay:)]) {
        return [adapter applePay:dic];
    }
    return NO;
}

+ (NSString *)saasWalletBaiduPay:(NSMutableDictionary *)dic {
    id adapter = [[NSClassFromString(kAdapterBaidu) alloc] init];
    if (adapter && [adapter respondsToSelector:@selector(baiduPay:)]) {
        return [adapter baiduPay:dic];
    }
    return nil;
}

+ (BOOL)saasWalletSandboxPay {
    id adapter = [[NSClassFromString(kAdapterSandbox) alloc] init];
    if (adapter && [adapter respondsToSelector:@selector(sandboxPay)]) {
        return [adapter sandboxPay];
    }
    return NO;
}

+ (void)saasWalletPayPal:(NSMutableDictionary *)dic {
    id adapter = [[NSClassFromString(kAdapterPayPal) alloc] init];
    if (adapter && [adapter respondsToSelector:@selector(payPal:)]) {
        [adapter payPal:dic];
    }
}

+ (void)saasWalletPayPalVerify:(NSMutableDictionary *)dic {
    id adapter = [[NSClassFromString(kAdapterPayPal) alloc] init];
    if (adapter && [adapter respondsToSelector:@selector(payPalVerify:)]) {
        [adapter payPalVerify:dic];
    }
}

+ (void)saasWalletOfflinePay:(NSMutableDictionary *)dic {
    id adapter = [[NSClassFromString(kAdapterOffline) alloc] init];
    if (adapter && [adapter respondsToSelector:@selector(offlinePay:)]) {
        [adapter offlinePay:dic];
    }
}

+ (void)saasWalletOfflineStatus:(NSMutableDictionary *)dic {
    id adapter = [[NSClassFromString(kAdapterOffline) alloc] init];
    if (adapter && [adapter respondsToSelector:@selector(offlineStatus:)]) {
        [adapter offlineStatus:dic];
    }
}

+ (void)saasWalletOfflineRevert:(NSMutableDictionary *)dic {
    id adapter = [[NSClassFromString(kAdapterOffline) alloc] init];
    if (adapter && [adapter respondsToSelector:@selector(offlineRevert:)]) {
        [adapter offlineRevert:dic];
    }
}

+ (void)saasWalletInitVFWXPay:(NSString *)wxAppId {
    id adapter = [[NSClassFromString(kAdapterVFWXPay) alloc] init];
    if (adapter && [adapter respondsToSelector:@selector(initVFWXPay:)]) {
        [adapter initVFWXPay:wxAppId];
    }
}

+ (void)saasWalletVFWXPay:(NSMutableDictionary *)dic {
    id adapter = [[NSClassFromString(kAdapterVFWXPay) alloc] init];
    if (adapter && [adapter respondsToSelector:@selector(vfWXPay:)]) {
        [adapter vfWXPay:dic];
    }
}


@end
