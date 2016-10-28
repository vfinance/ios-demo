#import "VFBaseResp.h"
#import "VFPayReq.h"

#pragma mark VFPayResp
/**
 *  支付请求的响应
 */
@interface VFPayResp : VFBaseResp  //type=201;
/**
 *  部分渠道(Ali,Baidu)回调会返回一些信息。
 *  Ali是@{@"resultStatus":@"9000",
           @"memo": @"",
           @"result": @"partner="2088101568358171"&seller_id= "xxx@vfinance.cn"&out_trade_no="2015111712120048"&subject="test"&body="test"
     "&total_fee="0.01"&it_b_pay= "30m"&..."}
 *  Baidu是结构为@{@"orderInfo":@"...."};其中orderInfo对应的value为前台支付必须;
 */
@property (nonatomic, retain) NSDictionary *paySource;

@end
