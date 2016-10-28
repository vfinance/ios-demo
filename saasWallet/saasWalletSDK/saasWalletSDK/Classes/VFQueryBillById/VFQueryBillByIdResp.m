#import "VFQueryBillByIdResp.h"
#import "VFQueryBillByIdReq.h"

@implementation VFQueryBillByIdResp

- (instancetype)initWithReq:(VFQueryBillByIdReq *)request {
    self = [super initWithReq:request];
    if (self) {
        self.type = VFObjsTypeQueryBillByIdResp;
        self.bill = nil;
    }
    return self;
}

@end
