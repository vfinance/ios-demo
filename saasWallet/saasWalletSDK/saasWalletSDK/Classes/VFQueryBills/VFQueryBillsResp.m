#import "VFQueryBillsResp.h"
#import "VFQueryBillsReq.h"

@implementation VFQueryBillsResp

- (instancetype)initWithReq:(VFQueryBillsReq *)request {
    self = [super initWithReq:request];
    if (self) {
        self.type = VFObjsTypeQueryBillsResp;
    }
    return self;
}
@end
