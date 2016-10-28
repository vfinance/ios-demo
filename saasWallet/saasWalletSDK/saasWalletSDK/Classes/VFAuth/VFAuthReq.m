#import "VFAuthReq.h"

@implementation VFAuthReq

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = VFObjsTypeAuthReq;
        self.name = @"";
        self.idNo = @"";
    }
    return self;
}

+ (void)authReqWithName:(NSString *)name idNo:(NSString *)idNo {
    [[VFAuthReq alloc] authReqWithName:name idNo:idNo];
}

- (void)authReqWithName:(NSString *)name idNo:(NSString *)idNo {
    self.name = name;
    self.idNo = idNo;
    [self authReq];
}

- (void)authReq {
    
    NSMutableDictionary *parameters = [VFPayUtil prepareParametersForRequest];
    if (parameters == nil) {
        [VFPayUtil doErrorResponse:@"请检查是否全局初始化"];
        return;
    }
    if (!self.name.isValid) {
        [VFPayUtil doErrorResponse:@"姓名错误"];
        return;
    }
    if (!self.idNo.isValid) {
        [VFPayUtil doErrorResponse:@"身份证号错误"];
        return;
    }
    parameters[@"name"] = self.name;
    parameters[@"id_no"] = self.idNo;
    
    VFHTTPSessionManager *manager = [VFPayUtil getVFHTTPSessionManager];
    
    [manager POST:[NSString stringWithFormat:@"%@/2/auth", kVFHost] parameters:parameters progress:nil
          success:^(NSURLSessionTask *task, id response) {
              [VFPayUtil getErrorInResponse:(NSDictionary *)response];
          } failure:^(NSURLSessionTask *operation, NSError *error) {
              [VFPayUtil doErrorResponse:kNetWorkError];
          }];
    
}

@end
