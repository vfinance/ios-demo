#import "VFQueryRefundsResp.h"
#import "VFQueryRefundsReq.h"

@implementation VFQueryRefundsResp

- (instancetype)initWithReq:(VFQueryRefundsReq *)request {
    self = [super initWithReq:request];
    if (self) {
        self.type = VFObjsTypeQueryRefundsResp;
    }
    return self;
}

@end
