#import "VFBaseReq.h"
#import "VFQueryBillsCountResp.h"

@interface VFQueryBillsCountReq : VFBaseReq

/**
 *  支付渠道(具体支持渠道请参考Enum PayChannel)
 */
@property (nonatomic, assign) PayChannel channel;
/**
 *  发起支付时商家自定义的订单号
 */
@property (nonatomic, retain) NSString *billNo;
/**
 *  订单创建时间,@"yyyyMMddHHmm"格式; 例如2015年11月17日 00:00,@"201511170000"
 */
@property (nonatomic, assign) NSString *startTime;
/**
 *  订单创建时间,@"yyyyMMddHHmm"格式; 例如2015年11月17日 12:00,@"201511171200"
 */
@property (nonatomic, assign) NSString *endTime;

/**
 *  根据订单状态查询
 */
@property (nonatomic, assign) BillStatus billStatus;

#pragma mark - Functions 

/**
 *  查询满足条件的订单数目
 */
- (void)queryBillsCountReq;

/**
 *  解析从VFinance服务返回的数据
 *
 *  @param response 从VFinance服务返回的数据
 *
 *  @return 查询结果
 */
- (VFQueryBillsCountResp *)doQueryBillsCountResponse:(NSDictionary *)response;

@end
