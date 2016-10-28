#import "VFOfflineRevertReq.h"

@implementation VFOfflineRevertReq

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = VFObjsTypeOfflineRevertReq;
    }
    return self;
}

@end
