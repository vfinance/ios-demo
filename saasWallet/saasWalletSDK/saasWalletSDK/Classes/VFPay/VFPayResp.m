#import "VFPayResp.h"

#pragma mark pay response
@implementation VFPayResp

- (instancetype)initWithReq:(VFPayReq *)request {
    self = [super initWithReq:request];
    if (self) {
        self.type = VFObjsTypePayResp;
    }
    return self;
}

@end
