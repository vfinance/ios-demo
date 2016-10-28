#ifndef VFPaySDK_VFPayObjects_h
#define VFPaySDK_VFPayObjects_h

#import "VFBaseReq.h"
#import "VFBaseResp.h"

#import "VFPayReq.h"
#import "VFPayResp.h"

#import "VFPreRefundReq.h"
#import "VFPreRefundResp.h"

#import "VFQueryBillsReq.h"
#import "VFQueryBillsResp.h"

#import "VFQueryBillByIdReq.h"
#import "VFQueryBillByIdResp.h"

#import "VFQueryBillsCountReq.h"
#import "VFQueryBillsCountResp.h"

#import "VFQueryRefundsReq.h"
#import "VFQueryRefundsResp.h"

#import "VFQueryRefundByIdReq.h"
#import "VFQueryRefundByIdResp.h"

#import "VFQueryRefundsCountReq.h"
#import "VFQueryRefundsCountResp.h"

#import "VFRefundStatusReq.h"
#import "VFRefundStatusResp.h"

#import "VFBaseResult.h"
#import "VFQueryBillResult.h"
#import "VFQueryRefundResult.h"

#import "VFPayPalReq.h"
#import "VFPayPalVerifyReq.h"

#import "VFCategory.h"
#import "VFSubscription.h"
#import "VFAuthReq.h"

#pragma mark - SaasWalletSDKDelegate

@protocol SaasWalletSDKDelegate <NSObject>
@required
/**
 *  不同类型的请求，对应不同的响应
 *
 *  @param resp 响应体
 */
- (void)onSaasWalletSDKResp:(VFBaseResp *)resp;

@end

#endif
