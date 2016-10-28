#import "VFBaseReq.h"
#import "VFPayUtil.h"

@interface VFAuthReq : VFBaseReq
/**
 *  姓名
 */
@property (nonatomic, retain) NSString *name;
/**
 *  身份证号码
 */
@property (nonatomic, retain) NSString *idNo;

+ (void)authReqWithName:(NSString *)name idNo:(NSString *)idNo;

@end
