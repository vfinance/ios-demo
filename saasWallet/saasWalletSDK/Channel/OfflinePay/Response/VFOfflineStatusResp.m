#import "VFOfflineStatusResp.h"

@implementation VFOfflineStatusResp

- (instancetype)initWithReq:(VFBaseReq *)request {
    self = [super init];
    if (self) {
        self.type = VFObjsTypeOfflineBillStatusResp;
        self.payResult = NO;
        self.request = request;
    }
    return self;
}

@end
