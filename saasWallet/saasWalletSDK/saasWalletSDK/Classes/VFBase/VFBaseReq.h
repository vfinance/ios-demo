#import <Foundation/Foundation.h>
#import "VFPayConstant.h"

#pragma mark VFBaseReq
/**
 *  所有请求事件的基类,具体请参考VFRequest目录
 */
@interface VFBaseReq : NSObject
/**
 *  请求事件类型
 */
@property (nonatomic, assign) VFObjsType type;//100

@end
