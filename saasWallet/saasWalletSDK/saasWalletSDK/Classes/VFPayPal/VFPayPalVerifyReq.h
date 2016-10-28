#import "VFBaseReq.h"

#pragma mark VFPayPalVerifyReq

@interface VFPayPalVerifyReq : VFBaseReq

/**
 *  支付实例
 */
@property (nonatomic, strong) id payment;
/**
 *  扩展参数,可以传入任意数量的key/value对来补充对业务逻辑的需求
 */
@property (nonatomic, strong) NSDictionary *optional;

@end
