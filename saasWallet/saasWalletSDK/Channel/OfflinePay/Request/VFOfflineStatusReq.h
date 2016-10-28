#import "VFBaseReq.h"

@interface VFOfflineStatusReq : VFBaseReq
/**
 *  发起支付时商户自定义的订单号
 */
@property (nonatomic, retain) NSString *billNo;
/**
 *  支付渠道(WX_NATIVE, WX_SCAN, ALI_OFFLINE_QRCODE, ALI_SCAN)
 */
@property (nonatomic, assign) PayChannel channel;

@end
