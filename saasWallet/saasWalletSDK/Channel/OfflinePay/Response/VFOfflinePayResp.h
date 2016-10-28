#import "VFBaseResp.h"
#import "VFOfflinePayReq.h"
@interface VFOfflinePayResp : VFBaseResp
/**
 *  待生成二维码的URL,例 weixin://wxpay/bizpayurl?pr=1NGRIa4
 */
@property (nonatomic, retain) NSString *codeurl;

@end
