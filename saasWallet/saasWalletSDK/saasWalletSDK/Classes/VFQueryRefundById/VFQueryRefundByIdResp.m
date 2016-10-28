#import "VFQueryRefundByIdResp.h"
#import "VFQueryRefundByIdReq.h"

@implementation VFQueryRefundByIdResp

- (instancetype)initWithReq:(VFQueryRefundByIdReq *)request {
    self = [super initWithReq:request];
    if (self) {
        self.type = VFObjsTypeQueryRefundByIdResp;
        self.refund = nil;
    }
    return self;
}

@end
