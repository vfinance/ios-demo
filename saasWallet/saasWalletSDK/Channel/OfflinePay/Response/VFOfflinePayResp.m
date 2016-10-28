#import "VFOfflinePayResp.h"

@implementation VFOfflinePayResp

- (instancetype)initWithReq:(VFBaseReq *)request {
    self = [super init];
    if (self) {
        self.type = VFObjsTypeOfflinePayResp;
        self.request = request;
    }
    return self;
}

@end
