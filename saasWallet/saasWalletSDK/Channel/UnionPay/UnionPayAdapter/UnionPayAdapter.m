#import "UnionPayAdapter.h"
#import "SaasWalletSDKAdapterProtocol.h"
#import "UPPayPlugin.h"
#import "VFWebViewController.h"

@interface UnionPayAdapter ()<SaasWalletSDKAdapterDelegate, UPPayPluginDelegate> 

@end


@implementation UnionPayAdapter

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static UnionPayAdapter *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[UnionPayAdapter alloc] init];
    });
    return instance;
}

- (BOOL)unionPay:(NSMutableDictionary *)dic {
    NSString *tn = [dic stringValueForKey:@"url" defaultValue:@""];
    if (tn.isValid) {
        if ([dic[@"viewController"] isKindOfClass:[UIViewController class] ]) {
            UIViewController *fromViewController = (UIViewController *)dic[@"viewController"];
            VFWebViewController *webViewController = [[VFWebViewController alloc] init];
            [webViewController setHTMLString:tn];
            
            [fromViewController presentViewController:webViewController animated:YES completion:^(){}];
            
            return YES;
        }
        else {
            return NO;
        }
    }
    return NO;
}

#pragma mark - Implementation UnionPayDelegate

- (void)UPPayPluginResult:(NSString *)result {
    int errcode = VFErrCodeSentFail;
    NSString *strMsg = @"支付失败";
    if ([result isEqualToString:@"success"]) {
        errcode = VFErrCodeSuccess;
        strMsg = @"支付成功";
    } else if ([result isEqualToString:@"cancel"]) {
        errcode = VFErrCodeUserCancel;
        strMsg = @"支付取消";
    }
    
    VFPayResp *resp = (VFPayResp *)[VFPayCache sharedInstance].vfResp;
    resp.resultCode = errcode;
    resp.resultMsg = strMsg;
    resp.errDetail = strMsg;
    [VFPayCache vfinanceDoResponse];
}

@end
