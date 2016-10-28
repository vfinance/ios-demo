#import "VFQueryRefundsCountResp.h"
#import "VFQueryRefundsCountReq.h"

@implementation VFQueryRefundsCountResp

- (instancetype)initWithReq:(VFQueryRefundsCountReq *)request {
    self = [super initWithReq:request];
    if (self) {
        self.type = VFObjsTypeQueryRefundsCountResp;
        self.count = 0;
    }
    return self;
}

@end
