#import "VFBaseResp.h"
#import "VFOfflineRevertReq.h"

@interface VFOfflineRevertResp : VFBaseResp
/**
 *  订单撤销状态
 *  YES 表示撤销成功
 *  NO  表示撤销失败
 *  撤销失败的订单可重新发起撤销请求
 */
@property (nonatomic, assign) BOOL revertStatus;

@end
