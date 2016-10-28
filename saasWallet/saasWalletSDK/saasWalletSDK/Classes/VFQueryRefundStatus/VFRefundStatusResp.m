#import "VFRefundStatusResp.h"
#import "VFRefundStatusReq.h"

@implementation VFRefundStatusResp

- (instancetype)initWithReq:(VFRefundStatusReq *)request {
    self = [super initWithReq:request];
    if (self) {
        self.type = VFObjsTypeRefundStatusResp;
    }
    return self;
}

@end
