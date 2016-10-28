#import "VFPayPalReq.h"

@implementation VFPayPalReq

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = VFObjsTypePayPal;
        self.items = nil;
        self.shipping = @"0";
        self.tax = @"0";
        self.payConfig = nil;
        self.viewController = nil;
    }
    return self;
}

@end
