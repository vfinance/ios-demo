#import "VFQueryRefundsCountReq.h"
#import "VFPayUtil.h"

@implementation VFQueryRefundsCountReq

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = VFObjsTypeQueryRefundsCountReq;
        self.refundNo = @"";
        self.billNo = @"";
        self.startTime = @"";
        self.endTime = @"";
        self.needApproved = NeedApprovalAll;
    }
    return self;
}

- (void)queryRefundsCountReq {
    [VFPayCache sharedInstance].vfResp = [[VFQueryRefundsCountResp alloc] initWithReq:self];
    
    NSString *cType = [VFPayUtil getChannelString:self.channel];
    
    NSMutableDictionary *parameters = [VFPayUtil prepareParametersForRequest];
    if (parameters == nil) {
        [VFPayUtil doErrorResponse:@"请检查是否全局初始化"];
        return;
    }
    
    if (self.billNo.isValid) {
        parameters[@"bill_no"] = self.billNo;
    }
    if (self.refundNo.isValid) {
        parameters[@"refund_no"] = self.refundNo;
    }
    if (self.startTime.isValid) {
        parameters[@"start_time"] = [NSNumber numberWithLongLong:[VFPayUtil dateStringToMillisecond:self.startTime]];
    }
    if (self.endTime.isValid) {
        parameters[@"end_time"] = [NSNumber numberWithLongLong:[VFPayUtil dateStringToMillisecond:self.endTime]];
    }
    if (cType.isValid) {
        parameters[@"channel"] = cType;
    }
    if (self.needApproved != NeedApprovalAll) {
        parameters[@"need_approval"] = self.needApproved == NeedApprovalOnlyTrue ? @YES : @NO;
    }
    
    NSMutableDictionary *preparepara = [VFPayUtil getWrappedParametersForGetRequest:parameters];
    
    VFHTTPSessionManager *manager = [VFPayUtil getVFHTTPSessionManager];
    __weak VFQueryRefundsCountReq *weakSelf = self;
    [manager GET:[VFPayUtil getBestHostWithFormat:kRestApiQueryRefundsCount] parameters:preparepara progress:nil
         success:^(NSURLSessionTask *task, id response) {
             VFPayLog(@"resp = %@", response);
             [weakSelf doQueryRefundsCountResponse:(NSDictionary *)response];
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             [VFPayUtil doErrorResponse:kNetWorkError];
         }];
}

- (VFQueryRefundsCountResp *)doQueryRefundsCountResponse:(NSDictionary *)response {
    VFQueryRefundsCountResp *resp = (VFQueryRefundsCountResp *)[VFPayCache sharedInstance].vfResp;
    resp.resultCode = [response integerValueForKey:kKeyResponseResultCode defaultValue:VFErrCodeCommon];
    resp.resultMsg = [response stringValueForKey:kKeyResponseResultMsg defaultValue:kUnknownError];
    resp.errDetail = [response stringValueForKey:kKeyResponseErrDetail defaultValue:kUnknownError];
    resp.count = [response integerValueForKey:@"count" defaultValue:0];
    [VFPayCache vfinanceDoResponse];
    return resp;
}

@end
