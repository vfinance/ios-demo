#import "VFBaseResp.h"
#import "VFOfflineStatusReq.h"

@interface VFOfflineStatusResp : VFBaseResp
/**
 *  订单支付状态
 *  YES 支付成功
 *  NO  支付失败
 */
@property (nonatomic, assign) BOOL payResult;
@end
