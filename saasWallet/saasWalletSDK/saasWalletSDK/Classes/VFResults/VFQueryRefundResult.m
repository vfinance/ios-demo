#import "VFQueryRefundResult.h"

@implementation VFQueryRefundResult

- (instancetype) initWithResult:(NSDictionary *)dic {
    self = [super initWithResult:dic];
    if (self) {
        self.type = VFObjsTypeRefundResults;
        if (dic) {
            self.refundNo = [dic stringValueForKey:@"refund_no" defaultValue:@""];
            self.refundFee = [dic integerValueForKey:@"refund_fee" defaultValue:0];
            self.finish = [dic boolValueForKey:@"finish" defaultValue:NO];
            self.result = [dic boolValueForKey:@"result" defaultValue:NO];
        }
    }
    return self;
}

@end
