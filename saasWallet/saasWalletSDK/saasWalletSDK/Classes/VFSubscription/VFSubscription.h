#import "VFBaseReq.h"
#import "VFPayUtil.h"

@protocol VFSubscriptionDelegate <NSObject>

- (void)onVFSubscriptionResp:(NSMutableDictionary *)resp;

@end

static NSString * const subscription_host = @"https://apidynamic.vfinance.cn/2";

typedef NS_ENUM(NSInteger, VFSubType) {
    VFSubTypeSMS = 1,
    VFSubTypeBanks,
    
    VFSubTypeNewPlan = 10,
    VFSubTypePlans,
    VFSubTypePlansCount,
    
    VFSubTypeNewSubscription = 20,
    VFSubTypeSubscriptions,
    VFSubTypeSubscriptionsCount,
    VFSubTypeSubscriptionCancel
};

@interface VFSubscription : VFBaseReq

@property (nonatomic, weak) id<VFSubscriptionDelegate> delegate;

/**
 *  设置代理
 *
 *  @param delegate 代理
 */
+ (void)setSubDelegate:(id<VFSubscriptionDelegate>)delegate;
/**
 *  发送短信验证码
 *
 *  @param phone 手机号
 */
+ (void)smsReq:(NSString *)phone;
/**
 *  获取支持的银行列表
 */
+ (void)subscriptionBanks;
/**
 *  取消订阅
 *
 *  @param sub_id 订阅记录id
 */
+ (void)subscriptionCancel:(NSString *)sub_id;
/**
 *  返回请求结果
 *
 *  @param response 请求返回结果
 */
+ (void)doSubscriptionResponse:(NSMutableDictionary *)response;
/**
 *  请求出错返回结果
 *
 *  @param errMsg 返回请求出错结果
 */
+ (void)doSubscriptionErrorResponse:(NSString *)errMsg;


@end
