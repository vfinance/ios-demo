#import "VFBaseReq.h"

@interface VFOfflineRevertReq : VFBaseReq
/**
 *  发起支付时商户自定义的订单号
 */
@property (nonatomic, retain) NSString *billNo;
/**
 *  支付渠道(目前支持WX_SCAN, ALI_OFFLINE_QRCODE, ALI_SCAN)
 */
@property (nonatomic, assign) PayChannel channel;

@end
