#import "VFBaseReq.h"
#import "VFQueryBillByIdResp.h"

@interface VFQueryBillByIdReq : VFBaseReq

/**
 *  支付订单记录id
 */
@property (nonatomic, retain) NSString *objectId;

#pragma mark - Functions

/**
 *  初始化
 *
 *  @param objectId 支付订单id
 *
 *  @return VFQueryBillByIdReq实例
 */
- (instancetype)initWithObjectId:(NSString *)objectId;

/**
 *  发起根据objectId查询支付订单请求
 */
- (void)queryBillByIdReq;

/**
 *  解析并返回支付订单数据
 *
 *  @param response VFinance服务返回的查询结果
 *
 *  @return 查询结果
 */
- (VFQueryBillByIdResp *)doQueryBillByIdResponse:(NSDictionary *)response;

@end
