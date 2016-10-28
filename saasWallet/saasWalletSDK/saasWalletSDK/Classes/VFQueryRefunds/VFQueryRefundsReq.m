#import "VFQueryRefundsReq.h"

#import "VFPayUtil.h"

#pragma mark query refund request
@implementation VFQueryRefundsReq

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = VFObjsTypeQueryRefundsReq;
        self.refundNo = @"";
        self.needApproved = NeedApprovalAll;
        self.needMsgDetail = NO;
    }
    return self;
}

#pragma mark - QueryRefunds

- (void)queryRefundsReq {
    [VFPayCache sharedInstance].vfResp = [[VFQueryRefundsResp alloc] initWithReq:self];
    
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
    parameters[@"need_detail"] = @(self.needMsgDetail);
    
    parameters[@"skip"] = [NSNumber numberWithInteger:self.skip];
    parameters[@"limit"] =  self.limit > 50 ? @50 : [NSNumber numberWithInteger:self.limit];
    
    NSMutableDictionary *preparepara = [VFPayUtil getWrappedParametersForGetRequest:parameters];
    
    VFHTTPSessionManager *manager = [VFPayUtil getVFHTTPSessionManager];
    __weak VFQueryRefundsReq *weakSelf = self;
    [manager GET:[VFPayUtil getBestHostWithFormat:kRestApiQueryRefunds] parameters:preparepara progress:nil
         success:^(NSURLSessionTask *operation, id response) {
             VFPayLog(@"resp = %@", response);
             [weakSelf doQueryRefundsResponse:(NSDictionary *)response];
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             [VFPayUtil doErrorResponse:kNetWorkError];
         }];
}

- (VFQueryRefundsResp *)doQueryRefundsResponse:(NSDictionary *)response {
    VFQueryRefundsResp *resp = (VFQueryRefundsResp *)[VFPayCache sharedInstance].vfResp;
    resp.resultCode = [response integerValueForKey:kKeyResponseResultCode defaultValue:VFErrCodeCommon];
    resp.resultMsg = [response stringValueForKey:kKeyResponseResultMsg defaultValue:kUnknownError];
    resp.errDetail = [response stringValueForKey:kKeyResponseErrDetail defaultValue:kUnknownError];
    resp.results = [self parseRefundsResults:response];
    resp.count = resp.results.count;
    [VFPayCache vfinanceDoResponse];
    return resp;
}

- (NSMutableArray *)parseRefundsResults:(NSDictionary *)dic {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    for (NSDictionary *result in [dic arrayValueForKey:@"refunds" defaultValue:nil]) {
        VFQueryRefundResult *refund = [[VFQueryRefundResult alloc] initWithResult:result];
        if (refund) {
            [array addObject:refund];
        }
    } ;
    return array;
}

@end
