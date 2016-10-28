#import "VFBaseResp.h"

#pragma mark VFQueryBillsResp
/**
 *  查询订单的响应，包括支付、退款订单
 */
@interface VFQueryBillsResp : VFBaseResp
/**
 *  查询到得结果数量
 */
@property (nonatomic, assign) NSUInteger count;
/**
 *  每个节点是VFQueryBillResult类型的实例
 */
@property (nonatomic, retain) NSMutableArray *results;

@end
