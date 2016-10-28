#import "VFPreRefundResp.h"
#import "VFPreRefundReq.h"

@implementation VFPreRefundResp

- (instancetype)initWithReq:(VFPreRefundReq *)request {
    self = [super initWithReq:request];
    if (self) {
        self.type = VFObjsTypePreRefundResp;
    }
    return self;
}

@end
