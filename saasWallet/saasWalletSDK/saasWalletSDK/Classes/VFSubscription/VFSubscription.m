#import "VFSubscription.h"


@implementation VFSubscription

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static VFSubscription *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[VFSubscription alloc] init];
    });
    return instance;
}

+ (void)setSubDelegate:(id<VFSubscriptionDelegate>)delegate {
    [VFSubscription sharedInstance].delegate = delegate;
}

+ (void)smsReq:(NSString *)phone {
    if (phone.isValidMobile) {
        NSMutableDictionary *params = [VFPayUtil prepareParametersForRequest];
        VFHTTPSessionManager *manager = [VFPayUtil getVFHTTPSessionManager];
        
        params[@"phone"] = phone;
        [manager POST:[NSString stringWithFormat:@"%@/sms",subscription_host] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSMutableDictionary *response = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)responseObject];
            response[@"type"] = @(VFSubTypeSMS);
            [VFSubscription doSubscriptionResponse:response];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [VFSubscription doSubscriptionErrorResponse:kNetWorkError];
        }];
    }
}

+ (void)subscriptionBanks {
    
    NSMutableDictionary *params = [VFPayUtil prepareParametersForRequest];
    VFHTTPSessionManager *manager = [VFPayUtil getVFHTTPSessionManager];
    
    [manager GET:[NSString stringWithFormat:@"%@/subscription_banks", subscription_host] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableDictionary *response = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)responseObject];
        response[@"type"] = @(VFSubTypeBanks);
        [VFSubscription doSubscriptionResponse:response];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [VFSubscription doSubscriptionErrorResponse:kNetWorkError];
    }];
}

+ (void)subscriptionCancel:(NSString *)sub_id {
    NSMutableDictionary *params = [VFPayUtil prepareParametersForRequest];
    VFHTTPSessionManager *manager = [VFPayUtil getVFHTTPSessionManager];
    
    [manager DELETE:[NSString stringWithFormat:@"%@/subscription/%@", subscription_host,sub_id] parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableDictionary *response = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)responseObject];
        response[@"type"] = @(VFSubTypeSubscriptionCancel);
        [VFSubscription doSubscriptionResponse:response];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [VFSubscription doSubscriptionErrorResponse:kNetWorkError];
    }];
}

+ (void)doSubscriptionErrorResponse:(NSString *)errMsg {
    NSMutableDictionary *resp = [NSMutableDictionary dictionaryWithCapacity:10];
    resp[@"resultCode"] = @(VFErrCodeCommon);
    resp[@"resultMsg"] = errMsg;
    resp[@"errDetail"] = errMsg;
    
    [VFSubscription doSubscriptionResponse:resp];
}

+ (void)doSubscriptionResponse:(NSMutableDictionary *)response {
    
    VFSubscription *shared = [VFSubscription sharedInstance];
    
    if (shared.delegate && [shared.delegate respondsToSelector:@selector(onVFSubscriptionResp:)]) {
        [shared.delegate onVFSubscriptionResp:response];
    }
}


@end
