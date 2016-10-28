#import "VFQueryBillsReq.h"
#import "VFPayUtil.h"

#pragma mark query request
@implementation VFQueryBillsReq

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = VFObjsTypeQueryBillsReq;
        self.skip = 0;
        self.limit = 10;
        self.startTime = @"";
        self.endTime = @"";
        self.billNo = @"";
        self.billStatus = BillStatusAll;
        self.needMsgDetail = NO;
    }
    return self;
}

#pragma mark Query Bills

- (void)queryBillsReq {
    [VFPayCache sharedInstance].vfResp = [[VFQueryBillsResp alloc] initWithReq:self];
    
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
    parameters[@"need_detail"] = @(self.needMsgDetail);
    if (cType.isValid) {
        parameters[@"channel"] = cType;
    }
    parameters[@"skip"] = [NSNumber numberWithInteger:self.skip];
    parameters[@"limit"] =  self.limit > 50 ? @50 : [NSNumber numberWithInteger:self.limit];
    
    NSMutableDictionary *preparepara = [VFPayUtil getWrappedParametersForGetRequest:parameters];
    
    VFHTTPSessionManager *manager = [VFPayUtil getVFHTTPSessionManager];
    __weak VFQueryBillsReq *weakSelf = self;
    [manager GET:[VFPayUtil getBestHostWithFormat: kRestApiQueryBills] parameters:preparepara progress:nil
         success:^(NSURLSessionTask *task, id response) {
             VFPayLog(@"resp = %@", response);
             [weakSelf doQueryBillsResponse:(NSDictionary *)response];
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             [VFPayUtil doErrorResponse:kNetWorkError];
         }];
}

- (VFQueryBillsResp *)doQueryBillsResponse:(NSDictionary *)response {
    VFQueryBillsResp *resp = (VFQueryBillsResp *)[VFPayCache sharedInstance].vfResp;
    resp.resultCode = [response integerValueForKey:kKeyResponseResultCode defaultValue:VFErrCodeCommon];
    resp.resultMsg = [response stringValueForKey:kKeyResponseResultMsg defaultValue:kUnknownError];
    resp.errDetail = [response stringValueForKey:kKeyResponseErrDetail defaultValue:kUnknownError];
    resp.results = [self parseBillsResults:response];
    resp.count = resp.results.count;
    [VFPayCache vfinanceDoResponse];
    return resp;
}

- (NSMutableArray *)parseBillsResults:(NSDictionary *)dic {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    for (NSDictionary *result in [dic arrayValueForKey:@"bills" defaultValue:nil]) {
        VFQueryBillResult *bill = [[VFQueryBillResult alloc] initWithResult:result];
        if (bill) {
            [array addObject:bill];
        }
    }
    return array;
}

@end
