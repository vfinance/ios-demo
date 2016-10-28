#import "WXPayAdapter.h"
#import "WXApi.h"
#import "SaasWalletSDKAdapterProtocol.h"
#import "VFPayUtil.h"

@interface WXPayAdapter ()<SaasWalletSDKAdapterDelegate, WXApiDelegate>

@end

@implementation WXPayAdapter

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static WXPayAdapter *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[WXPayAdapter alloc] init];
    });
    return instance;
}

- (BOOL)registerWeChat:(NSString *)appid {
    return [WXApi registerApp:appid];
}

- (BOOL)handleOpenUrl:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:[WXPayAdapter sharedInstance]];
}

- (BOOL)isWXAppInstalled {
    return [WXApi isWXAppInstalled];
}

- (BOOL)wxPay:(NSMutableDictionary *)dic {
    if ([dic[@"url"] isKindOfClass: [NSDictionary class]]) {
        NSDictionary *url = (NSDictionary *)dic[@"url"];
        PayReq *request = [[PayReq alloc] init];
        request.partnerId = [url stringValueForKey:@"partnerid" defaultValue:@""];
        request.prepayId = [url stringValueForKey:@"prepayid" defaultValue:@""];
        request.package = [url stringValueForKey:@"package" defaultValue:@""];
        request.nonceStr = [url stringValueForKey:@"noncestr" defaultValue:@""];
        NSString *time = [url stringValueForKey:@"timestamp" defaultValue:@""];
        request.timeStamp = time.intValue;
        request.sign = [url stringValueForKey:@"sign" defaultValue:@""];
        return [WXApi sendReq:request];
    }
    else if ([dic[@"url"] isKindOfClass:[NSString class]]) {
        NSString *jsonString = (NSString *)dic[@"url"];
        id dict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            NSDictionary *url = (NSDictionary *)dict;
            PayReq *request = [[PayReq alloc] init];
            request.partnerId = [url stringValueForKey:@"partnerid" defaultValue:@""];
            request.prepayId = [url stringValueForKey:@"prepayid" defaultValue:@""];
            request.package = [url stringValueForKey:@"package" defaultValue:@""];
            request.nonceStr = [url stringValueForKey:@"noncestr" defaultValue:@""];
            NSString *time = [url stringValueForKey:@"timestamp" defaultValue:@""];
            request.timeStamp = time.intValue;
            request.sign = [url stringValueForKey:@"sign" defaultValue:@""];
            return [WXApi sendReq:request];
        }
        else {
            return NO;
        }
    }
    else {
        return NO;
    }
    
}

#pragma mark - Implementation WXApiDelegate

- (void)onResp:(BaseResp *)resp {
    
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *tempResp = (PayResp *)resp;
        NSString *strMsg = nil;
        int errcode = 0;
        switch (tempResp.errCode) {
            case WXSuccess:
                strMsg = @"支付成功";
                errcode = VFErrCodeSuccess;
                break;
            case WXErrCodeUserCancel:
                strMsg = @"支付取消";
                errcode = VFErrCodeUserCancel;
                break;
            default:
                strMsg = @"支付失败";
                errcode = VFErrCodeSentFail;
                break;
        }
        NSString *result = tempResp.errStr.isValid?[NSString stringWithFormat:@"%@,%@",strMsg,tempResp.errStr]:strMsg;
        VFPayResp *resp = (VFPayResp *)[VFPayCache sharedInstance].vfResp;
        resp.resultCode = errcode;
        resp.resultMsg = result;
        resp.errDetail = result;
        [VFPayCache vfinanceDoResponse];
    }
}

@end
