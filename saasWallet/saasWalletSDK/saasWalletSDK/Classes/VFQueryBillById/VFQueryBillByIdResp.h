#import "VFBaseResp.h"
#import "VFQueryBillResult.h"

@interface VFQueryBillByIdResp : VFBaseResp

/**
 *  支付订单记录，
 */
@property (nonatomic, retain) VFQueryBillResult *bill;

@end
