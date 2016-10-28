#import "VFBaseReq.h"
#import "VFPayConstant.h"
#import "VFRefundStatusResp.h"

/**
 *  查询一笔退款的订单的状态，目前仅支持“WX”渠道
 */
@interface VFRefundStatusReq : VFBaseReq

/**
 *  渠道，目前仅支持微信、百度
 */
@property (nonatomic, assign) PayChannel channel;
/**
 *  发起退款时商户自定义的退款单号
 */
@property (nonatomic, retain) NSString *refundNo;

#pragma mark - Functions

/**
 *  查询退款记录,目前仅支持WX_APP
 */
- (void)refundStatusReq;

/**
 *  返回退款状态
 *
 *  @param dic 从VFinance服务返回的查询结果
 *
 *  @return 退款状态
 */
- (VFRefundStatusResp *)doQueryRefundStatus:(NSDictionary *)dic;

@end
