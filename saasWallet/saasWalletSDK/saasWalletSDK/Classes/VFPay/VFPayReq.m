#import "VFPayReq.h"
#import "VFPayUtil.h"
#import "SaasWalletSDKAdapter.h"

#pragma mark pay request

@implementation VFPayReq

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = VFObjsTypePayReq;
        self.channel = PayChannelNone;
        self.title = @"";
        self.totalFee = @"";
        self.billNo = @"";
        self.scheme = @"";
        self.viewController = nil;
        self.cardType = 0;
        self.billTimeOut = 0;
    }
    return self;
}

- (void)payReq {
    [VFPayCache sharedInstance].vfResp = [[VFPayResp alloc] initWithReq:self];
    
    if (![self checkParametersForReqPay]) return;
    
    NSString *cType = [VFPayUtil getChannelString:self.channel];
    
    NSMutableDictionary *parameters = [VFPayUtil prepareParametersForRequest];
    if (parameters == nil) {
        [VFPayUtil doErrorResponse:@"请检查是否全局初始化"];
        return;
    }
    
    parameters[@"amount"] = [NSString stringWithFormat:@"%.02f", [self.totalFee integerValue]/100.0f];
    parameters[@"instOrderNo"] = self.billNo;
    parameters[@"channelCode"] = cType;
    parameters[@"proSubject"] = self.title;
    
    VFHTTPSessionManager *manager = [VFPayUtil getVFHTTPSessionManager];
    __weak VFPayReq *weakSelf = self;
    
    [manager POST:[VFPayUtil getBestHostWithFormat:kRestApiPay] parameters:parameters progress:nil
          success:^(NSURLSessionTask *task, id response) {
              if ([response integerValueForKey:kKeyResponseResultCode defaultValue:VFErrCodeCommon] != 0) {
                  [VFPayUtil getErrorInResponse:(NSDictionary *)response];
              } else {
                  if ([VFPayCache sharedInstance].sandbox) {
                      [weakSelf doPayActionInSandbox:(NSDictionary *)response];
                  } else {
                      [weakSelf doPayAction:(NSDictionary *)response];
                  }
              }
          } failure:^(NSURLSessionTask *operation, NSError *error) {
              [VFPayUtil doErrorResponse:kNetWorkError];
          }];
}

#pragma mark - Pay Action

- (BOOL)doPayAction:(NSDictionary *)response {
    BOOL bSendPay = NO;
    if (response) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:
                                    (NSDictionary *)response];
        if (self.channel == PayChannelAliApp) {
            [dic setObject:self.scheme forKey:@"scheme"];
        } else if (self.channel == PayChannelUnApp || self.channel == PayChannelApplePay ||
                   self.channel == PayChannelApplePayTest || self.channel == PayChannelVFApp ||
                   self.channel == PayChannelVFWXApp) {
            [dic setObject:self.viewController forKey:@"viewController"];
            if (self.channel == PayChannelApplePayTest || self.channel == PayChannelApplePay) {
                [dic setObject:@(self.channel) forKey:@"channel"];
            }
        }
        [VFPayCache sharedInstance].vfResp.vfId = [dic objectForKey:@"id"];
        switch (self.channel) {
            case PayChannelWxApp:
                bSendPay = [SaasWalletSDKAdapter saasWalletWXPay:dic];
                break;
            case PayChannelAliApp:
                bSendPay = [SaasWalletSDKAdapter saasWalletAliPay:dic];
                break;
            case PayChannelVFApp:
            case PayChannelUnApp:
                bSendPay = [SaasWalletSDKAdapter saasWalletUnionPay:dic];
                break;
            case PayChannelBaiduApp:
                bSendPay = [SaasWalletSDKAdapter saasWalletBaiduPay:dic].isValid;
                break;
            case PayChannelApplePayTest:
            case PayChannelApplePay:
                NSLog(@"applePay %@", dic);
                bSendPay = [SaasWalletSDKAdapter saasWalletApplePay:dic];
                break;
            case PayChannelVFWXApp:
                [SaasWalletSDKAdapter saasWalletVFWXPay:dic];
                break;
            default:
                break;
        }
    }
    return bSendPay;
}

- (BOOL)doPayActionInSandbox:(NSDictionary *)response {
    
    if (response) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:
                                    (NSDictionary *)response];
        [VFPayCache sharedInstance].vfResp.vfId = [dic objectForKey:@"id"];
        [SaasWalletSDKAdapter saasWalletSandboxPay];
        return YES;
    }
    return NO;
}

- (BOOL)checkParametersForReqPay {
    if (!self.title.isValid || [VFPayUtil getBytes:self.title] > 32) {
        [VFPayUtil doErrorResponse:@"title 必须是长度不大于32个字节,最长16个汉字的字符串的合法字符串"];
        return NO;
    } else if (!self.totalFee.isValid || !self.totalFee.isPureInt) {
        [VFPayUtil doErrorResponse:@"totalFee 以分为单位，必须是只包含数值的字符串"];
        return NO;
    } else if (!self.billNo.isValid || !self.billNo.isValidTraceNo || (self.billNo.length < 8) || (self.billNo.length > 32)) {
        [VFPayUtil doErrorResponse:@"billNo 必须是长度8~32位字母和/或数字组合成的字符串"];
        return NO;
    } else if ((self.channel == PayChannelAliApp) && !self.scheme.isValid) {
        [VFPayUtil doErrorResponse:@"scheme 不是合法的字符串，将导致无法从支付宝钱包返回应用"];
        return NO;
    } else if ((self.channel == PayChannelUnApp || self.channel == PayChannelApplePay ||
                self.channel == PayChannelVFApp || self.channel == PayChannelVFWXApp) && (self.viewController == nil)) {
        [VFPayUtil doErrorResponse:@"viewController 不合法，将导致无法正常支付"];
        return NO;
    } else if ([SaasWalletSDK getCurrentMode] && (self.viewController == nil)) {
        [VFPayUtil doErrorResponse:@"viewController 不合法，将导致无法正常支付"];
        return NO;
    } else if ((self.channel == PayChannelWxApp && ![SaasWalletSDKAdapter saasWalletIsWXAppInstalled]) && ![SaasWalletSDK getCurrentMode]) {
        [VFPayUtil doErrorResponse:@"未找到微信客户端，请先下载安装"];
        return NO;
    } else if ((self.channel == PayChannelApplePay || self.channel == PayChannelApplePayTest) && ![SaasWalletSDK canMakeApplePayments:self.cardType]) {
        switch (self.cardType) {
            case 0:
                [VFPayUtil doErrorResponse:@"此设备不支持Apple Pay"];
                break;
            case 1:
                [VFPayUtil doErrorResponse:@"不支持借记卡"];
                break;
            case 2:
                [VFPayUtil doErrorResponse:@"不支持信用卡"];
                break;
        }
        return NO;
    }
    return YES;
}

@end
