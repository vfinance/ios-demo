#import "VFBaseResp.h"

#pragma mark VFQueryRefundsResp
/**
 *  查询订单的响应，包括支付、退款订单
 */
@interface VFQueryRefundsResp : VFBaseResp
/**
 *  查询到得结果数量
 */
@property (nonatomic, assign) NSInteger count;
/**
 *  每个节点是VFQueryRefundResult类型的实例
 */
@property (nonatomic, retain) NSMutableArray *results;

@end
