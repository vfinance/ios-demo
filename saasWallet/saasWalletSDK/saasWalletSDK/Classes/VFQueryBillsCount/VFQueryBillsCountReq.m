#import "VFQueryBillsCountReq.h"
#import "VFPayUtil.h"

@implementation VFQueryBillsCountReq

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = VFObjsTypeQueryBillsCountReq;
        self.billNo = @"";
        self.startTime = @"";
        self.endTime = @"";
        self.billStatus = BillStatusAll;
    }
    return self;
}

- (void)queryBillsCountReq {
    [VFPayCache sharedInstance].vfResp = [[VFQueryBillsCountResp alloc] initWithReq:self];
    
    NSString *cType = [VFPayUtil getChannelString:self.channel];
    
    NSMutableDictionary *parameters = [VFPayUtil prepareParametersForRequest];
    if (parameters == nil) {
        [VFPayUtil doErrorResponse:@"请检查是否全局初始化"];
        return;
    }
    
    if (self.billNo.isValid) {
        parameters[@"bill_no"] = self.billNo;
    }
    if (self.startTime.isValid) {
        parameters[@"start_time"] = [NSNumber numberWithLongLong:[VFPayUtil dateStringToMillisecond:self.startTime]];
    }
    if (self.endTime.isValid) {
        parameters[@"end_time"] = [NSNumber numberWithLongLong:[VFPayUtil dateStringToMillisecond:self.endTime]];
    }
    if (self.billStatus != BillStatusAll) {
        parameters[@"spay_result"] = self.billStatus == BillStatusOnlySuccess ? @YES : @NO;
    }
    if (cType.isValid) {
        parameters[@"channel"] = cType;
    }
    
    NSMutableDictionary *preparepara = [VFPayUtil getWrappedParametersForGetRequest:parameters];
    
    VFHTTPSessionManager *manager = [VFPayUtil getVFHTTPSessionManager];
    __weak VFQueryBillsCountReq *weakSelf = self;
    [manager GET:[VFPayUtil getBestHostWithFormat:kRestApiQueryBillsCount] parameters:preparepara progress:nil
         success:^(NSURLSessionTask *task, id response) {
             VFPayLog(@"resp = %@", response);
             [weakSelf doQueryBillsCountResponse:(NSDictionary *)response];
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             [VFPayUtil doErrorResponse:kNetWorkError];
         }];
}

- (VFQueryBillsCountResp *)doQueryBillsCountResponse:(NSDictionary *)response {
    VFQueryBillsCountResp *resp = (VFQueryBillsCountResp *)[VFPayCache sharedInstance].vfResp;
    resp.resultCode = [response integerValueForKey:kKeyResponseResultCode defaultValue:VFErrCodeCommon];
    resp.resultMsg = [response stringValueForKey:kKeyResponseResultMsg defaultValue:kUnknownError];
    resp.errDetail = [response stringValueForKey:kKeyResponseErrDetail defaultValue:kUnknownError];
    resp.count = [response integerValueForKey:@"count" defaultValue:0];
    [VFPayCache vfinanceDoResponse];
    return resp;
}

@end
