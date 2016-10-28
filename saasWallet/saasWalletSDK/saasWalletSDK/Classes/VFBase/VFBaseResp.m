#import "VFBaseResp.h"

#pragma mark base response
@implementation VFBaseResp

- (instancetype)initWithReq:(VFBaseReq *)request {
    self = [super init];
    if (self) {
        self.type = VFObjsTypeBaseResp;
        self.request = request;
        self.resultCode = VFErrCodeCommon;
        self.resultMsg = @"";
        self.errDetail = @"";
    }
    return self;
}
@end
