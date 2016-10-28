#import <Foundation/Foundation.h>
#import "VFPayUtil.h"

@interface NSString (IsValid)
- (BOOL)isValid;
- (BOOL)isPureInt;
- (BOOL)isValidTraceNo;
- (BOOL)isPureFloat;
- (BOOL)isValidUUID;
- (BOOL)isValidMobile;

@end
