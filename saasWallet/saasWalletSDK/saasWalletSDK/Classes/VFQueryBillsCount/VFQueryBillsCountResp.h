#import "VFBaseResp.h"

@interface VFQueryBillsCountResp : VFBaseResp

/**
 *  满足条件的支付订单总数
 */
@property (nonatomic, assign) NSUInteger count;

@end
