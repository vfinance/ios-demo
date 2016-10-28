#import "AliPayAdapter.h"
#import "SaasWalletSDKAdapterProtocol.h"
#import <AlipaySDK/AlipaySDK.h>

@interface AliPayAdapter ()<SaasWalletSDKAdapterDelegate>

@end

@implementation AliPayAdapter

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static AliPayAdapter *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[AliPayAdapter alloc] init];
    });
    return instance;
}

- (BOOL)handleOpenUrl:(NSURL *)url {
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        [[AliPayAdapter sharedInstance] processOrderForAliPay:resultDic];
    }];
    return YES;
}

- (BOOL)aliPay:(NSMutableDictionary *)dic {
    
    NSString *orderString = [dic stringValueForKey:@"url" defaultValue:@""];
    if (orderString.isValid) {
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:[dic stringValueForKey:@"scheme" defaultValue:@""]
                                    callback:^(NSDictionary *resultDic) {
                                        [[AliPayAdapter sharedInstance] processOrderForAliPay:resultDic];
                                    }];
        return YES;
    }
    return NO;
}

#pragma mark - Implementation AliPayDelegate

- (void)processOrderForAliPay:(NSDictionary *)resultDic {
    int status = [resultDic[@"resultStatus"] intValue];
    
    NSString *strMsg;
    int errcode = 0;
    switch (status) {
        case 9000:
            strMsg = @"支付成功";
            errcode = VFErrCodeSuccess;
            break;
        case 4000:
        case 6002:
            strMsg = @"支付失败";
            errcode = VFErrCodeSentFail;
            break;
        case 6001:
            strMsg = @"支付取消";
            errcode = VFErrCodeUserCancel;
            break;
        default:
            strMsg = @"未知错误";
            errcode = VFErrCodeUnsupport;
            break;
    }
    VFPayResp *resp = (VFPayResp *)[VFPayCache sharedInstance].vfResp;
    resp.resultCode = errcode;
    resp.resultMsg = strMsg;
    resp.errDetail = strMsg;
    resp.paySource = resultDic;
    [VFPayCache vfinanceDoResponse];
}

@end
