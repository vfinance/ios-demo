#import "VFWXPayAdapter.h"
#import "SaasWalletSDKAdapterProtocol.h"
#import "VFPayUtil.h"
#import "SPayClient.h"

@interface VFWXPayAdapter ()<SaasWalletSDKAdapterDelegate>

@end

@implementation VFWXPayAdapter

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static VFWXPayAdapter *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[VFWXPayAdapter alloc] init];
    });
    return instance;
}

- (void)initVFWXPay:(NSString *)wxAppId {
    SPayClientWechatConfigModel *wechatConfigModel = [[SPayClientWechatConfigModel alloc] init];
    wechatConfigModel.appScheme = wxAppId;
    wechatConfigModel.wechatAppid = wxAppId;
    //配置微信APP支付
    [[SPayClient sharedInstance] wechatpPayConfig:wechatConfigModel];
}

- (void)vfWXPay:(NSMutableDictionary *)dic {
    
    [[SPayClient sharedInstance] pay:dic[@"viewController"]
                              amount:0
                   spayTokenIDString:dic[@"token_id"]
                   payServicesString:@"pay.weixin.app"
                              finish:^(SPayClientPayStateModel *payStateModel,
                                       SPayClientPaySuccessDetailModel *paySuccessDetailModel) {
                                  
                              }];
}




@end
