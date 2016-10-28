#import "saasWalletSDKClass.h"

#import "VFPayCache.h"
#import "SaasWalletSDKAdapter.h"
#import "SaasWalletSDK+Utils.h"

@interface SaasWalletSDK ()
@property (nonatomic, weak) id<SaasWalletSDKDelegate> delegate;
@end


@implementation SaasWalletSDK

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static SaasWalletSDK *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[SaasWalletSDK alloc] init];
    });
    return instance;
}

+ (BOOL)initWithAppID:(NSString *)appId andAppSecret:(NSString *)appSecret {
    VFPayCache *instance = [VFPayCache sharedInstance];
    if (appId.isValid && appSecret.isValid) {
        instance.appId = appId;
        instance.appSecret = appSecret;
        return YES;
    }
    return NO;
}

+ (BOOL)initWithAppID:(NSString *)appId andAppSecret:(NSString *)appSecret sandbox:(BOOL)isSandbox {
    BOOL flag = [SaasWalletSDK initWithAppID:appId andAppSecret:appSecret];
    if (flag) {
        [SaasWalletSDK setSandboxMode:isSandbox];
    }
    return flag;
}

+ (void)setSandboxMode:(BOOL)sandbox {
    [VFPayCache sharedInstance].sandbox = sandbox;
}

+ (BOOL)getCurrentMode {
    return [VFPayCache sharedInstance].sandbox;
}

+ (BOOL)initWeChatPay:(NSString *)wxAppID {
    if (!wxAppID.isValid) {
        return NO;
    }
    return [SaasWalletSDKAdapter saasWalletRegisterWeChat:wxAppID];
}

+ (BOOL)initPayPal:(NSString *)clientID secret:(NSString *)secret sandbox:(BOOL)isSandbox {
    
    if(clientID.isValid && secret.isValid) {
        VFPayCache *instance = [VFPayCache sharedInstance];
        instance.payPalClientID = clientID;
        instance.payPalSecret = secret;
        instance.isPayPalSandbox = isSandbox;
        
        [SaasWalletSDKAdapter saasWalletRegisterPayPal:clientID secret:secret sandbox:isSandbox];
        return YES;
    }
    return NO;
}

+ (void)setSaasWalletSDKDelegate:(id<SaasWalletSDKDelegate>)delegate {
    [SaasWalletSDK sharedInstance].delegate = delegate;
}

+ (id<SaasWalletSDKDelegate>)getSaasWalletSDKDelegate {
    return [SaasWalletSDK sharedInstance].delegate;
}

+ (BOOL)handleOpenUrl:(NSURL *)url {
    if (VFPayUrlWeChat == [VFPayUtil getUrlType:url]) {
        return [SaasWalletSDKAdapter saasWallet:kAdapterWXPay handleOpenUrl:url];
    } else if (VFPayUrlAlipay == [VFPayUtil getUrlType:url]) {
        return [SaasWalletSDKAdapter saasWallet:kAdapterAliPay handleOpenUrl:url];
    }
    return NO;
}

+ (BOOL)canMakeApplePayments:(NSUInteger)cardType {
    return [SaasWalletSDKAdapter saasWalletCanMakeApplePayments:cardType];
}

+ (NSString *)getVFApiVersion {
    return kApiVersion;
}

+ (void)setWillPrintLog:(BOOL)flag {
    [VFPayCache sharedInstance].willPrintLogMsg = flag;
}

+ (void)setNetworkTimeout:(NSTimeInterval)time {
    [VFPayCache sharedInstance].networkTimeout = time;
}

+ (void)initVFWXPay:(NSString *)wxAppId {
    [SaasWalletSDKAdapter saasWalletRegisterWeChat:wxAppId];
    [SaasWalletSDKAdapter saasWalletInitVFWXPay:wxAppId];
}

+ (BOOL)sendVFReq:(VFBaseReq *)req {
    SaasWalletSDK *instance = [SaasWalletSDK sharedInstance];
    BOOL bSend = YES;
    switch (req.type) {
        case VFObjsTypePayReq: //支付(微信、支付宝、银联、百度钱包)
            [instance reqPay:(VFPayReq *)req];
            break;
        case VFObjsTypePreRefundReq: //预退款
            [instance reqPreRefund:(VFPreRefundReq *)req];
            break;
        case VFObjsTypeQueryBillsReq://条件查询支付订单
            [instance reqQueryBills:(VFQueryBillsReq *)req];
            break;
        case VFObjsTypeQueryBillsCountReq:
            [instance reqBillsCount:(VFQueryBillsCountReq *)req];
            break;
        case VFObjsTypeQueryBillByIdReq://根据id查询支付订单
            [instance reqQueryBillById:(VFQueryBillByIdReq *)req];
            break;
        case VFObjsTypeQueryRefundsReq://条件查询退款订单
            [instance reqQueryRefunds:(VFQueryRefundsReq *)req];
            break;
        case VFObjsTypeQueryRefundsCountReq:
            [instance reqRefundsCount:(VFQueryRefundsCountReq *)req];
            break;
        case VFObjsTypeQueryRefundByIdReq://根据id查询退款订单
            [instance reqQueryRefundById:(VFQueryRefundByIdReq *)req];
            break;
        case VFObjsTypeRefundStatusReq://查询退款状态，目前只支持微信、百度
            [instance reqRefundStatus:(VFRefundStatusReq *)req];
            break;
        case VFObjsTypePayPal:
            [instance  reqPayPal:(VFPayPalReq *)req];
            break;
        case VFObjsTypePayPalVerify:
            [instance reqPayPalVerify:(VFPayPalVerifyReq *)req];
            break;
        case VFObjsTypeOfflinePayReq:
            [instance reqOfflinePay:req];
            break;
        case VFObjsTypeOfflineBillStatusReq:
            [instance reqOfflineBillStatus:req];
            break;
        case VFObjsTypeOfflineRevertReq:
            [instance reqOfflineBillRevert:req];
            break;
        default:
            bSend = NO;
            break;
    }
    return bSend;
}

+ (void)queryPayChannel {
    SaasWalletSDK *instance = [SaasWalletSDK sharedInstance];
    [instance queryPayChannel];
}

+ (void)notifyTradeResult:(NSString *)orderNumber andChannelCode:(NSString *)channelCode {
    SaasWalletSDK *instance = [SaasWalletSDK sharedInstance];
    [instance notifyTradeResult:orderNumber andChannelCode:channelCode];
}

@end
