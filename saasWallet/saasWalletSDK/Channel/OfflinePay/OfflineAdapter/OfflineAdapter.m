#import "OfflineAdapter.h"
#import "VFPayUtil.h"
#import "VFPayCache.h"
#import "SaasWalletSDKAdapterProtocol.h"
#import "VFOffinePay.h"

@interface OfflineAdapter ()<SaasWalletSDKAdapterDelegate>
@end

@implementation OfflineAdapter

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static OfflineAdapter *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[OfflineAdapter alloc] init];
    });
    return instance;
}

- (void)offlinePay:(NSMutableDictionary *)dic {
    VFOfflinePayReq *req = (VFOfflinePayReq *)[dic objectForKey:kAdapterOffline];
    [VFPayCache sharedInstance].vfResp = [[VFOfflinePayResp alloc] initWithReq:req];
    
    if (![self checkParameters:req]) return;
    
    NSString *cType = [VFPayUtil getChannelString:req.channel];
    
    NSMutableDictionary *parameters = [VFPayUtil prepareParametersForRequest];
    if (parameters == nil) {
        [self doErrorResponse:@"请检查是否全局初始化"];
        return;
    }
    
    parameters[@"channel"] = cType;
    parameters[@"total_fee"] = [NSNumber numberWithInteger:[req.totalFee integerValue]];
    parameters[@"bill_no"] = req.billNo;
    parameters[@"title"] = req.title;
    if (req.channel == PayChannelWxScan || req.channel == PayChannelAliScan) {
        parameters[@"auth_code"] = req.authcode;
    }
    if (req.channel == PayChannelAliScan) {
        if (req.terminalId.isValid) {
            parameters[@"terminal_id"] = req.terminalId;
        }
        if (req.storeId.isValid) {
            parameters[@"store_id"] = req.storeId;
        }
    }
    if (req.optional) {
        parameters[@"optional"] = req.optional;
    }
    
    VFHTTPSessionManager *manager = [VFPayUtil getVFHTTPSessionManager];
    __weak OfflineAdapter *weakSelf = [OfflineAdapter sharedInstance];
    [manager POST:[VFPayUtil getBestHostWithFormat:kRestApiOfflinePay] parameters:parameters progress:nil
          success:^(NSURLSessionTask *task, id response) {
              
              NSDictionary *source = (NSDictionary *)response;
              VFPayLog(@"channel=%@,resp=%@", cType, response);
              VFOfflinePayResp *resp = (VFOfflinePayResp *)[VFPayCache sharedInstance].vfResp;
              resp.resultCode = [source integerValueForKey:kKeyResponseResultCode defaultValue:VFErrCodeCommon];
              resp.resultMsg = [source stringValueForKey:kKeyResponseResultMsg defaultValue:kUnknownError];
              resp.errDetail = [source stringValueForKey:kKeyResponseErrDetail defaultValue:kUnknownError];
              if (resp.resultCode == 0) {
                  if (req.channel == PayChannelAliOfflineQrCode || req.channel == PayChannelWxNative) {
                      resp.codeurl = [source stringValueForKey:kKeyResponseCodeUrl defaultValue:@""];
                  }
              }
              [VFPayCache vfinanceDoResponse];
              
          } failure:^(NSURLSessionTask *operation, NSError *error) {
              [weakSelf doErrorResponse:kNetWorkError];
          }];
}

#pragma mark - OffLine BillStatus

- (void)offlineStatus:(NSMutableDictionary *)dic {
    VFOfflineStatusReq *req = (VFOfflineStatusReq *)[dic objectForKey:kAdapterOffline];
    [VFPayCache sharedInstance].vfResp = [[VFOfflineStatusResp alloc] initWithReq:req];
    if (req == nil) {
        [self doErrorResponse:@"请求结构体不合法"];
        return;
    } else if (!req.billNo.isValid || !req.billNo.isValidTraceNo || (req.billNo.length < 8) || (req.billNo.length > 32)) {
        [self doErrorResponse:@"billno 必须是长度8~32位字母和/或数字组合成的字符串"];
        return;
    }
    
    NSString *cType = [VFPayUtil getChannelString:req.channel];
    
    NSMutableDictionary *parameters = [VFPayUtil prepareParametersForRequest];
    if (parameters == nil) {
        [self doErrorResponse:@"请检查是否全局初始化"];
        return;
    }
    
    parameters[@"channel"] = cType;
    parameters[@"bill_no"] = req.billNo;
    
    VFHTTPSessionManager *manager = [VFPayUtil getVFHTTPSessionManager];
    __weak OfflineAdapter *weakSelf = [OfflineAdapter sharedInstance];
    [manager POST:[VFPayUtil getBestHostWithFormat:kRestApiOfflineBillStatus] parameters:parameters progress:nil
          success:^(NSURLSessionTask *operation, id response) {
              
              VFPayLog(@"channel=%@,resp=%@", cType, response);
              VFOfflineStatusResp *resp = (VFOfflineStatusResp *)[VFPayCache sharedInstance].vfResp;
              resp.resultCode = [response integerValueForKey:kKeyResponseResultCode defaultValue:VFErrCodeCommon];
              resp.resultMsg = [response stringValueForKey:kKeyResponseResultMsg defaultValue:kUnknownError];
              resp.errDetail = [response stringValueForKey:kKeyResponseErrDetail defaultValue:kUnknownError];
              if (resp.resultCode == 0) {
                  resp.payResult = [response boolValueForKey:KKeyResponsePayResult defaultValue:NO];
              }
              [VFPayCache vfinanceDoResponse];
          } failure:^(NSURLSessionTask *operation, NSError *error) {
              [weakSelf doErrorResponse:kNetWorkError];
          }];
}

#pragma mark - OffLine BillRevert

- (void)offlineRevert:(NSMutableDictionary *)dic {
    VFOfflineRevertReq *req = (VFOfflineRevertReq *)[dic objectForKey:kAdapterOffline];
    [VFPayCache sharedInstance].vfResp = [[VFOfflineRevertResp alloc] initWithReq:req];
    if (req == nil) {
        [self doErrorResponse:@"请求结构体不合法"];
        return;
    } else if (!req.billNo.isValid || !req.billNo.isValidTraceNo || (req.billNo.length < 8) || (req.billNo.length > 32)) {
        [self doErrorResponse:@"billno 必须是长度8~32位字母和/或数字组合成的字符串"];
        return;
    }
    
    NSString *cType = [VFPayUtil getChannelString:req.channel];
    
    NSMutableDictionary *parameters = [VFPayUtil prepareParametersForRequest];
    if (parameters == nil) {
        [self doErrorResponse:@"请检查是否全局初始化"];
        return;
    }
    
    parameters[@"channel"] = cType;
    parameters[@"method"] = @"REVERT";
    
    VFHTTPSessionManager *manager = [VFPayUtil getVFHTTPSessionManager];
    __weak OfflineAdapter *weakSelf = [OfflineAdapter sharedInstance];
    [manager POST:[[VFPayUtil getBestHostWithFormat:kRestApiOfflineBillRevert] stringByAppendingString:req.billNo] parameters:parameters progress:nil
          success:^(NSURLSessionTask *operation, id response) {
    
              VFPayLog(@"channel=%@,resp=%@", cType, response);
              VFOfflineRevertResp *resp = (VFOfflineRevertResp *)[VFPayCache sharedInstance].vfResp;
              resp.resultCode = [response integerValueForKey:kKeyResponseResultCode defaultValue:VFErrCodeCommon];
              resp.resultMsg = [response stringValueForKey:kKeyResponseResultMsg defaultValue:kUnknownError];
              resp.errDetail = [response stringValueForKey:kKeyResponseErrDetail defaultValue:kUnknownError];
              if (resp.resultCode == 0) {
                  resp.revertStatus = [response boolValueForKey:kKeyResponseRevertResult defaultValue:NO];
              }
              [VFPayCache vfinanceDoResponse];
          } failure:^(NSURLSessionTask *operation, NSError *error) {
              [weakSelf doErrorResponse:kNetWorkError];
          }];
}

- (BOOL)checkParameters:(VFBaseReq *)request {
    
    if (request == nil) {
        [self doErrorResponse:@"请求结构体不合法"];
    } else if (request.type == VFObjsTypeOfflinePayReq) {
        VFOfflinePayReq *req = (VFOfflinePayReq *)request;
        if (!req.title.isValid || [VFPayUtil getBytes:req.title] > 32) {
            [self doErrorResponse:@"title 必须是长度不大于32个字节,最长16个汉字的字符串的合法字符串"];
            return NO;
        } else if (!req.totalFee.isValid || !req.totalFee.isPureInt) {
            [self doErrorResponse:@"totalfee 以分为单位，必须是只包含数值的字符串"];
            return NO;
        } else if (!req.billNo.isValid || !req.billNo.isValidTraceNo || (req.billNo.length < 8) || (req.billNo.length > 32)) {
            [self doErrorResponse:@"billno 必须是长度8~32位字母和/或数字组合成的字符串"];
            return NO;
        } else if ((req.channel == PayChannelAliScan || req.channel == PayChannelWxScan) && !req.authcode.isValid) {
            [self doErrorResponse:@"authcode 不是合法的字符串"];
            return NO;
        } else if ((req.channel == PayChannelAliScan) && (!req.terminalId.isValid || !req.storeId.isValid)) {
            [self doErrorResponse:@"terminalid或storeid 不是合法的字符串"];
            return NO;
        }
        return YES;
    }
    return NO ;
}

- (void)doErrorResponse:(NSString *)errMsg {
    VFOfflineStatusResp *resp = (VFOfflineStatusResp *)[VFPayCache sharedInstance].vfResp;
    resp.resultCode = VFErrCodeCommon;
    resp.resultMsg = errMsg;
    resp.errDetail = errMsg;
    [VFPayCache vfinanceDoResponse];
}

@end
