#import "VFOfflineRevertResp.h"

@implementation VFOfflineRevertResp

- (instancetype)initWithReq:(VFBaseReq *)request {
    self = [super init];
    if (self) {
        self.type = VFObjsTypeOfflineRevertResp;
        self.revertStatus = NO;
        self.request = request;
    }
    return self;
}

@end
