#import "VFQueryBillByIdReq.h"

#import "VFPayUtil.h"

@implementation VFQueryBillByIdReq

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = VFObjsTypeQueryBillByIdReq;
        self.objectId = @"";
    }
    return self;
}

- (instancetype)initWithObjectId:(NSString *)objectId {
    VFQueryBillByIdReq *req = [[VFQueryBillByIdReq alloc] init];
    req.objectId = objectId;
    return req;
}

#pragma mark - QueryBillById

- (void)queryBillByIdReq {
    [VFPayCache sharedInstance].vfResp = [[VFQueryBillByIdResp alloc] initWithReq:self];
    
    if (!self.objectId.isValidUUID) {
        [VFPayUtil doErrorResponse:@"objectId 不合法"];
        return;
    }
    NSMutableDictionary *parameters = [VFPayUtil prepareParametersForRequest];
    if (parameters == nil) {
        [VFPayUtil doErrorResponse:@"请检查是否全局初始化"];
        return;
    }
    NSMutableDictionary *preparepara = [VFPayUtil getWrappedParametersForGetRequest:parameters];
    
    NSString *preHost = [VFPayUtil getBestHostWithFormat:kRestApiQueryBillById];
    NSString *host = [NSString stringWithFormat:@"%@%@", preHost, self.objectId];
    
    VFHTTPSessionManager *manager = [VFPayUtil getVFHTTPSessionManager];
    __weak VFQueryBillByIdReq *weakSelf = self;
    [manager GET:host parameters:preparepara progress:nil
         success:^(NSURLSessionTask *task, id response) {
             [weakSelf doQueryBillByIdResponse:(NSDictionary *)response];
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             [VFPayUtil doErrorResponse:kNetWorkError];
         }];
}

- (VFQueryBillByIdResp *)doQueryBillByIdResponse:(NSDictionary *)response {
    if (response) {
        VFQueryBillByIdResp *resp = (VFQueryBillByIdResp *)[VFPayCache sharedInstance].vfResp;
        resp.resultCode = [response integerValueForKey:kKeyResponseResultCode defaultValue:VFErrCodeCommon];
        resp.resultMsg = [response stringValueForKey:kKeyResponseResultMsg defaultValue:kUnknownError];
        resp.errDetail = [response stringValueForKey:kKeyResponseErrDetail defaultValue:kUnknownError];
        NSDictionary *bill = [response dictValueForKey:@"pay" defaultValue:nil];
        if (bill) {
            resp.bill = [[VFQueryBillResult alloc] initWithResult:bill];
        }
        [VFPayCache vfinanceDoResponse];
        return resp;
    }
    return nil;
}

@end
