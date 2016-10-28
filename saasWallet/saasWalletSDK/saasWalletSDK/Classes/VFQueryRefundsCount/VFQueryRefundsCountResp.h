#import "VFBaseResp.h"

@interface VFQueryRefundsCountResp : VFBaseResp

/**
 *  满足条件的退款订单总数
 */
@property (nonatomic, assign) NSUInteger count;

@end
