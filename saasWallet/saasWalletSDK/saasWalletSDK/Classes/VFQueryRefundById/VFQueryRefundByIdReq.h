#import "VFBaseReq.h"
#import "VFQueryRefundByIdResp.h"

@interface VFQueryRefundByIdReq : VFBaseReq

/**
 *  退款订单记录id
 */
@property (nonatomic, retain) NSString *objectId;

#pragma mark - Functions

/**
 *  初始化
 *
 *  @param objectId 退款订单id
 *
 *  @return VFQueryRefundByIdReq实例
 */
- (instancetype)initWithObjectId:(NSString *)objectId;

/**
 *  发起根据objectId查询退款记录
 */
- (void)queryRefundByIdReq;

/**
 *  解析并返回退款订单数据
 *
 *  @param response VFinance服务返回的查询结果
 *
 *  @return 查询结果
 */
- (VFQueryRefundByIdResp *)doQueryRefundByIdResponse:(NSDictionary *)response;

@end
