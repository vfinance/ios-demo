#import "VFBaseResp.h"
#import "VFQueryRefundResult.h"

@interface VFQueryRefundByIdResp : VFBaseResp

/**
 *  退款订单记录
 */
@property (nonatomic, retain) VFQueryRefundResult *refund;

@end
