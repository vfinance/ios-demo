#import "BaiduAdapter.h"
#import "SaasWalletSDKAdapterProtocol.h"
#import "VFPayUtil.h"
#import "BDWalletSDKMainManager.h"

static NSString * const kBaiduOrderInfo = @"orderInfo";

@interface BaiduAdapter ()<SaasWalletSDKAdapterDelegate>
@end

@implementation BaiduAdapter

- (NSString *)baiduPay:(NSMutableDictionary *)dic {
    VFPayResp *resp = (VFPayResp *)[VFPayCache sharedInstance].vfResp;
    resp.resultCode = [dic integerValueForKey:kKeyResponseResultCode defaultValue:VFErrCodeCommon];
    resp.resultMsg = [dic stringValueForKey:kKeyResponseResultMsg defaultValue:kUnknownError];
    resp.errDetail = [dic stringValueForKey:kKeyResponseErrDetail defaultValue:kUnknownError];
    NSString *orderInfo = [dic stringValueForKey:kBaiduOrderInfo defaultValue:@""];
    resp.paySource = [NSDictionary dictionaryWithObjectsAndKeys:orderInfo, kBaiduOrderInfo,nil];
    [VFPayCache vfinanceDoResponse];
    return orderInfo;
}

@end
