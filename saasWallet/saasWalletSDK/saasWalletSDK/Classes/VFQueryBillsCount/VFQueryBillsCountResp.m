#import "VFQueryBillsCountResp.h"
#import "VFQueryBillsCountReq.h"

@implementation VFQueryBillsCountResp

- (instancetype)initWithReq:(VFQueryBillsCountReq *)request {
    self = [super initWithReq:request];
    if (self) {
        self.type = VFObjsTypeQueryBillsCountResp;
        self.count = 0;
    }
    return self;
}

@end
