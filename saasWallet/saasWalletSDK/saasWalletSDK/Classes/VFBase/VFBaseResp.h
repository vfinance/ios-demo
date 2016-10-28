#import <Foundation/Foundation.h>
#import "VFPayConstant.h"
#import "VFBaseReq.h"

#pragma mark VFBaseResp
/**
 *  SaasWalletSDK所有响应的基类,具体参考VFResponse目录
 */
@interface VFBaseResp : NSObject
/**
 *  响应的事件类型
 */
@property (nonatomic, assign) VFObjsType type;//200;
/** 
 *  响应码,部分响应码请参考VFPayConstant.h/(Enum VFErrCode),默认为VFErrCodeCommon
 */
@property (nonatomic, assign) NSInteger resultCode;
/** 
 *  响应提示字符串，默认为@""
 */
@property (nonatomic, retain) NSString *resultMsg;
/** 
 *  错误详情,默认为@""
 */
@property (nonatomic, retain) NSString *errDetail;
/** 
 *  请求体，具体参考VFRequest目录
 */
@property (nonatomic, retain) VFBaseReq *request;
/** 
 *  成功下单或者退款后返回的订单记录唯一标识;格式为UUID
 *  根据id查询支付或退款订单时,传入的vfId
 */
@property (nonatomic, retain) NSString *vfId;

/**
 *  初始化一个响应结构体
 *
 *  @param request 请求结构体
 *
 *  @return 响应结构体
 */
- (instancetype)initWithReq:(VFBaseReq *)request;

@end
