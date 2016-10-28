#import "VFQueryRefundByIdReq.h"

#import "VFPayUtil.h"

@implementation VFQueryRefundByIdReq

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = VFObjsTypeQueryRefundByIdReq;
        self.objectId = @"";
    }
    return self;
}

- (instancetype)initWithObjectId:(NSString *)objectId {
    VFQueryRefundByIdReq *req = [[VFQueryRefundByIdReq alloc] init];
    req.objectId = objectId;
    return req;
}

#pragma mark - QueryRefundById

- (void)queryRefundByIdReq {
    
    [VFPayCache sharedInstance].vfResp = [[VFQueryRefundByIdResp alloc] initWithReq:self];
    
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
    
    NSString *preHost = [VFPayUtil getBestHostWithFormat:kRestApiQueryRefundById];
    NSString *host = [NSString stringWithFormat:@"%@%@", preHost, self.objectId];
    
    VFHTTPSessionManager *manager = [VFPayUtil getVFHTTPSessionManager];
    __weak VFQueryRefundByIdReq *weakSelf = self;
    [manager GET:host parameters:preparepara progress:nil
         success:^(NSURLSessionTask *task, id response) {
             [weakSelf doQueryRefundByIdResponse:(NSDictionary *)response];
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             [VFPayUtil doErrorResponse:kNetWorkError];
         }];
}

- (VFQueryRefundByIdResp *)doQueryRefundByIdResponse:(NSDictionary *)response {
    VFQueryRefundByIdResp *resp = (VFQueryRefundByIdResp *)[VFPayCache sharedInstance].vfResp;
    resp.resultCode = [response integerValueForKey:kKeyResponseResultCode defaultValue:VFErrCodeCommon];
    resp.resultMsg = [response stringValueForKey:kKeyResponseResultMsg defaultValue:kUnknownError];
    resp.errDetail = [response stringValueForKey:kKeyResponseErrDetail defaultValue:kUnknownError];
    NSDictionary *refund = [response dictValueForKey:@"refund"  defaultValue:nil];
    if (refund) {
        resp.refund = [[VFQueryRefundResult alloc] initWithResult:refund];
    }
    [VFPayCache vfinanceDoResponse];
    return resp;
}

@end
