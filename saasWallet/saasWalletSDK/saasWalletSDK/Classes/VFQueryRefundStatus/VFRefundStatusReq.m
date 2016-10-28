#import "VFRefundStatusReq.h"
#import "VFPayUtil.h"

@implementation VFRefundStatusReq

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = VFObjsTypeRefundStatusReq;
        self.refundNo = @"";
    }
    return self;
}

#pragma mark Refund Status For WeChat

- (void)refundStatusReq {
    
    [VFPayCache sharedInstance].vfResp = [[VFRefundStatusResp alloc] initWithReq:self];
    
    NSMutableDictionary *parameters = [VFPayUtil prepareParametersForRequest];
    if (parameters == nil) {
        [VFPayUtil doErrorResponse:@"请检查是否全局初始化"];
        return;
    }
    NSString *cType = [VFPayUtil getChannelString:self.channel];
    
    if (!self.refundNo.isValid || !cType.isValid) {
        [VFPayUtil doErrorResponse:@"请求参数不合法"];
        return;
    }
    parameters[@"refund_no"] = self.refundNo;
    parameters[@"channel"] = cType;
    
    NSMutableDictionary *preparepara = [VFPayUtil getWrappedParametersForGetRequest:parameters];
    
    VFHTTPSessionManager *manager = [VFPayUtil getVFHTTPSessionManager];
    __weak VFRefundStatusReq *weakSelf = self;
    
    [manager GET:[VFPayUtil getBestHostWithFormat:kRestApiRefundState] parameters:preparepara progress:nil
         success:^(NSURLSessionTask *task, id response) {
             [weakSelf doQueryRefundStatus:(NSDictionary *)response];
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             [VFPayUtil doErrorResponse:kNetWorkError];
         }];
}

- (VFRefundStatusResp *)doQueryRefundStatus:(NSDictionary *)dic {
    VFRefundStatusResp *resp = (VFRefundStatusResp *)[VFPayCache sharedInstance].vfResp;
    resp.resultCode = [dic integerValueForKey:kKeyResponseResultCode defaultValue:VFErrCodeCommon];
    resp.resultMsg = [dic stringValueForKey:kKeyResponseResultMsg defaultValue:kUnknownError];
    resp.errDetail = [dic stringValueForKey:kKeyResponseErrDetail defaultValue:kUnknownError];
    resp.refundStatus = [dic stringValueForKey:@"refund_status" defaultValue:@""];
    [VFPayCache vfinanceDoResponse];
    return resp;
}

@end
