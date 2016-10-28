#import "VFOfflinePayReq.h"

@implementation VFOfflinePayReq

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = VFObjsTypeOfflinePayReq;
    }
    return self;
}

@end
