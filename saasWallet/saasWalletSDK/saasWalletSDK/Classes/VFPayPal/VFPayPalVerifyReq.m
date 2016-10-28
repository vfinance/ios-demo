#import "VFPayPalVerifyReq.h"

@implementation VFPayPalVerifyReq

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = VFObjsTypePayPalVerify;
        self.payment = nil;
        self.optional = nil;
    }
    return self;
}

@end
