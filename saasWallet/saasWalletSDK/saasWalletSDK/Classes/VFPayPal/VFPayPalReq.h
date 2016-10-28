#import "VFBaseReq.h"

#pragma mark  VFPayPalReq

@interface VFPayPalReq : VFBaseReq
/**
 *  商品列表
 */
@property (nonatomic, strong) NSArray *items;
/**
 *  运费
 */
@property (nonatomic, strong) NSString *shipping;
/**
 *  税
 */
@property (nonatomic, strong) NSString *tax;
/**
 *  订单描述
 */
@property (nonatomic, strong) NSString *shortDesc;
/**
 *  支付配置
 */
@property (nonatomic, strong) id payConfig;
/**
 *  从此页面显示
 */
@property (nonatomic, strong) id viewController;

@end
