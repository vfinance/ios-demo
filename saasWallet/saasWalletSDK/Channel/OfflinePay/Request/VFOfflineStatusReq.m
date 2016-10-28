#import "VFOfflineStatusReq.h"

@implementation VFOfflineStatusReq

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = VFObjsTypeOfflineBillStatusReq;
        self.billNo = @"";
    }
    return self;
}

@end
