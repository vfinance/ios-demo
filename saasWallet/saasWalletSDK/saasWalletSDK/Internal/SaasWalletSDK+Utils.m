#import "SaasWalletSDK+Utils.h"
#import "SaasWalletSDKAdapter.h"

@implementation SaasWalletSDK (Utils)

#pragma mark Pay Request

- (void)reqPay:(VFPayReq *)req {
    [req payReq];
}

- (void)reqPreRefund:(VFPreRefundReq *)req {
    [req preRefundReq];
}

- (void)queryPayChannel {
    
    VFBaseResp *resp = [[VFBaseResp alloc] init];
    resp.request = [[VFBaseReq alloc] init];
    resp.resultCode = VFErrCodeCommon;
    resp.resultMsg = @"";
    resp.errDetail = @"";
    resp.type = VFObjsTypeQueryChannel;
    
    [VFPayCache sharedInstance].vfResp = resp;
    
    VFHTTPSessionManager *manager = [VFPayUtil getVFHTTPSessionManager];
    
    [manager GET:[VFPayUtil getBestHostWithFormat:kRestApiQueryChannel] parameters:@{@"appKey": [VFPayCache sharedInstance].appId} progress:nil success:^(NSURLSessionTask *task, id response) {
        
        if (response != nil) {
            if ([response isKindOfClass: [NSDictionary class]]) {
                NSDictionary *dict = (NSDictionary *)response;
                if ([[dict objectForKey:@"channel"] isKindOfClass:[NSArray class]]) {
                    NSArray *channelArray = (NSArray *)[dict objectForKey:@"channel"];
                    NSString *resultString = @"";
                    
                    for (int i = 0; i < channelArray.count; i++) {
                        if ([channelArray[i] isKindOfClass:[NSString class]]) {
                            NSString *channel = [NSString stringWithFormat:@"%@,",(NSString *)channelArray[i]];
                            resultString = [resultString stringByAppendingString:channel];
                        }
                    }
                    
                    if (resultString.length > 0) {
                        resultString = [resultString substringToIndex:resultString.length-1];
                    }
                    
                    [VFPayCache sharedInstance].vfResp.resultMsg = resultString;
                    [VFPayCache sharedInstance].vfResp.resultCode = VFErrCodeSuccess;
                    
                    [VFPayCache vfinanceDoResponse];
                    return;
                }
            }
        }
        
        [VFPayCache sharedInstance].vfResp.resultMsg = kUnknownError;
        [VFPayCache sharedInstance].vfResp.resultCode = VFErrCodeSuccess;
        
        [VFPayCache vfinanceDoResponse];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        VFBaseResp *resp = [VFPayCache sharedInstance].vfResp;
        resp.resultCode = VFErrCodeCommon;
        resp.resultMsg = kNetWorkError;
        resp.errDetail = kNetWorkError;
        [VFPayCache vfinanceDoResponse];
    }];
}

#pragma mark - 条件查询支付订单

- (void)reqQueryBills:(VFQueryBillsReq *)req {
    [req queryBillsReq];
}

#pragma mark - 查询符合条件的订单数目
- (void)reqBillsCount:(VFQueryBillsCountReq *)req {
    [req queryBillsCountReq];
}

#pragma mark - 条件查询退款订单

- (void)reqQueryRefunds:(VFQueryRefundsReq *)req {
    [req queryRefundsReq];
}

#pragma mark - 查询符合条件的退款数目 

- (void)reqRefundsCount:(VFQueryRefundsCountReq *)req {
    [req queryRefundsCountReq];
}

#pragma mark - 根据id查询支付订单

- (void)reqQueryBillById:(VFQueryBillByIdReq *)req {
    [req queryBillByIdReq];
}

#pragma mark - 根据id查询退款订单

- (void)reqQueryRefundById:(VFQueryRefundByIdReq *)req {
    [req queryRefundByIdReq];
}

#pragma mark - 查询退款状态

- (void)reqRefundStatus:(VFRefundStatusReq *)req {
    [req refundStatusReq];
}

#pragma mark - Offline Pay

- (void)reqOfflinePay:(id)req {
    [SaasWalletSDKAdapter saasWalletOfflinePay:[NSMutableDictionary dictionaryWithObjectsAndKeys:req, kAdapterOffline, nil]];
}

#pragma mark - OffLine BillStatus

- (void)reqOfflineBillStatus:(id)req {
    [SaasWalletSDKAdapter saasWalletOfflineStatus:[NSMutableDictionary dictionaryWithObjectsAndKeys:req, kAdapterOffline, nil]];
}

#pragma mark - OffLine BillRevert

- (void)reqOfflineBillRevert:(id)req {
    [SaasWalletSDKAdapter saasWalletOfflineRevert:[NSMutableDictionary dictionaryWithObjectsAndKeys:req, kAdapterOffline, nil]];
}

#pragma mark PayPal

- (void)reqPayPal:(VFPayPalReq *)req {
    [SaasWalletSDKAdapter saasWalletPayPal:[NSMutableDictionary dictionaryWithObjectsAndKeys:req, kAdapterPayPal,nil]];
}

- (void)reqPayPalVerify:(VFPayPalVerifyReq *)req {
    [SaasWalletSDKAdapter saasWalletPayPalVerify:[NSMutableDictionary dictionaryWithObjectsAndKeys:req, kAdapterPayPal, nil]];
}

@end
