#import "VFBaseReq.h"

#pragma makr base request
@implementation VFBaseReq

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = VFObjsTypeBaseReq;
    }
    return self;
}

@end
