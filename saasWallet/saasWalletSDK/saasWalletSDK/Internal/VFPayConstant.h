#import <Foundation/Foundation.h>

#ifndef VFPaySDK_VFPayConstant_h
#define VFPaySDK_VFPayConstant_h

static NSString * const kApiVersion = @"3.6.0";//api版本号

static NSString * const kNetWorkError = @"网络请求失败";
static NSString * const kUnknownError = @"未知错误";
static NSString * const kKeyResponseResultCode = @"code";
static NSString * const kKeyResponseResultMsg = @"error";
static NSString * const kKeyResponseErrDetail = @"error";

static NSString * const kKeyResponseCodeUrl = @"code_url";
static NSString * const KKeyResponsePayResult = @"pay_result";
static NSString * const kKeyResponseRevertResult = @"revert_status";

static NSString * const kVFHost = @"https://www.vfnetwork.cn";

static NSString * const reqApiVersion = @"/gateway-mobile/vfinance";

//rest api online
static NSString * const kRestApiQueryChannel = @"%@%@/getAllChannels";
static NSString * const kRestApiNotifyTradeResult = @"%@%@/syn_trade";
static NSString * const kRestApiPay = @"%@%@/all_pay";
static NSString * const kRestApiRefund = @"%@%@/refund";
static NSString * const kRestApiQueryBills = @"%@%@/bills";
static NSString * const kRestApiQueryRefunds = @"%@%@/refunds";
static NSString * const kRestApiRefundState = @"%@%@/refund/status";
static NSString * const kRestApiQueryBillById = @"%@%@/bill/";
static NSString * const kRestApiQueryRefundById = @"%@%@/refund/";
static NSString * const kRestApiQueryBillsCount = @"%@%@/bills/count";
static NSString * const kRestApiQueryRefundsCount = @"%@%@/refunds/count";

//rest api offline
static NSString * const kRestApiOfflinePay = @"%@%@/offline/bill";
static NSString * const kRestApiOfflineBillStatus = @"%@%@/offline/bill/status";
static NSString * const kRestApiOfflineBillRevert = @"%@%@/offline/bill/";

//paypal accesstoken
static NSString * const kPayPalAccessTokenProduction = @"https://api.paypal.com/v1/oauth2/token";
static NSString * const kPayPalAccessTokenSandbox = @"https://api.sandbox.paypal.com/v1/oauth2/token";

//sandbox
static NSString * const kRestApiSandboxNotify = @"%@%@/notify/";

//Adapter
static NSString * const kAdapterWXPay = @"WXPayAdapter";
static NSString * const kAdapterAliPay = @"AliPayAdapter";
static NSString * const kAdapterUnionPay = @"UnionPayAdapter";
static NSString * const kAdapterApplePay = @"ApplePayAdapter";
static NSString * const kAdapterPayPal = @"PayPalAdapter";
static NSString * const kAdapterOffline = @"OfflineAdapter";
static NSString * const kAdapterBaidu = @"BaiduAdapter";
static NSString * const kAdapterSandbox = @"VFSandboxAdapter";
static NSString * const kAdapterVFWXPay = @"VFWXPayAdapter";

/**
 *  VFPay URL type for handling URLs.
 */
typedef NS_ENUM(NSInteger, VFPayUrlType) {
    /**
     *  Unknown type.
     */
    VFPayUrlUnknown,
    /**
     *  WeChat pay.
     */
    VFPayUrlWeChat,
    /**
     *  Alipay.
     */
    VFPayUrlAlipay
};


typedef NS_ENUM(NSInteger, PayChannel) {
    PayChannelNone = 0,
    PayChannelVFApp,
    PayChannelVFWXApp,
    
    PayChannelWx = 10, //微信
    PayChannelWxApp,//微信APP
    PayChannelWxNative,//微信扫码
    PayChannelWxJsApi,//微信JSAPI(H5)
    PayChannelWxScan,
    
    PayChannelAli = 20,//支付宝
    PayChannelAliApp,//支付宝APP
    PayChannelAliWeb,//支付宝网页即时到账
    PayChannelAliWap,//支付宝手机网页
    PayChannelAliQrCode,//支付宝扫码即时到帐
    PayChannelAliOfflineQrCode,//支付宝线下扫码
    PayChannelAliScan,
    
    PayChannelUn = 30,//银联
    PayChannelUnApp,//银联APP
    PayChannelUnWeb,//银联网页
    PayChannelApplePay,
    PayChannelApplePayTest,
    
    PayChannelPayPal = 40,
    PayChannelPayPalLive,
    PayChannelPayPalSandbox,
    
    PayChannelBaidu = 50,
    PayChannelBaiduApp,
    PayChannelBaiduWeb,
    PayChannelBaiduWap
};

typedef NS_ENUM(NSInteger, VFErrCode) {
    VFErrCodeSuccess    = 0,    /**< 成功    */
    VFErrCodeCommon     = -1,   /**< 参数错误类型    */
    VFErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
    VFErrCodeSentFail   = -3,   /**< 发送失败    */
    VFErrCodeUnsupport  = -4,   /**< SaasWalletSDK不支持 */
};

typedef NS_ENUM(NSInteger, VFObjsType) {
    VFObjsTypeBaseReq = 100,
    VFObjsTypePayReq,
    VFObjsTypeQueryBillsReq,
    VFObjsTypeQueryBillByIdReq,
    VFObjsTypeQueryBillsCountReq,
    VFObjsTypeQueryRefundsReq,
    VFObjsTypeQueryRefundByIdReq,
    VFObjsTypeQueryRefundsCountReq,
    VFObjsTypeRefundStatusReq,
    VFObjsTypeOfflinePayReq,
    VFObjsTypeOfflineBillStatusReq,
    VFObjsTypeOfflineRevertReq,
    VFObjsTypePreRefundReq,
    VFObjsTypeAuthReq,
    
    VFObjsTypeBaseResp = 200,
    VFObjsTypePayResp,
    VFObjsTypeQueryBillsResp,
    VFObjsTypeQueryBillByIdResp,
    VFObjsTypeQueryBillsCountResp,
    VFObjsTypeQueryRefundsResp,
    VFObjsTypeQueryRefundByIdResp,
    VFObjsTypeQueryRefundsCountResp,
    VFObjsTypeRefundStatusResp,
    VFObjsTypeOfflinePayResp,
    VFObjsTypeOfflineBillStatusResp,
    VFObjsTypeOfflineRevertResp,
    VFObjsTypePreRefundResp,
    
    VFObjsTypeBaseResults = 300,
    VFObjsTypeBillResults,
    VFObjsTypeRefundResults,
    
    VFObjsTypePayPal = 400,
    VFObjsTypePayPalVerify,
    
    VFObjsTypeQueryChannel,
    
};

typedef NS_ENUM(NSUInteger, BillStatus) {
    BillStatusAll, //所有支付订单
    BillStatusOnlySuccess,//支付成功的订单
    BillStatusOnlyFail //支付失败的订单
};

typedef NS_ENUM(NSUInteger, NeedApproval) {
    NeedApprovalAll,  //所有退款
    NeedApprovalOnlyTrue, //预退款
    NeedApprovalOnlyFalse //非预退款
};

static NSString * const kVFDateFormat = @"yyyy-MM-dd HH:mm:ss";

#endif
