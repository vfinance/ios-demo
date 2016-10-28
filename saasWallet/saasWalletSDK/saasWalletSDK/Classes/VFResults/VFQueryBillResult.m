#import "VFQueryBillResult.h"

@implementation VFQueryBillResult

- (instancetype) initWithResult:(NSDictionary *)dic {
    self = [super initWithResult:dic];
    if (self) {
        self.type = VFObjsTypeBillResults;
        self.payResult = [dic boolValueForKey:@"spay_result" defaultValue:NO];
        self.tradeNo = [dic stringValueForKey:@"trade_no" defaultValue:@""];
        self.revertResult = [dic boolValueForKey:@"revert_result" defaultValue:NO];
        self.refundResult = [dic boolValueForKey:@"refund_result" defaultValue:NO];
    }
    return self;
}


@end
