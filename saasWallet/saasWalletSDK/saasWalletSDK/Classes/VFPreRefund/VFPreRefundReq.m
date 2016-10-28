#import "VFPreRefundReq.h"
#import "VFPayUtil.h"
#import "VFPreRefundResp.h"

@implementation VFPreRefundReq

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = VFObjsTypePreRefundReq;
        self.channel = PayChannelNone;
        self.refundNo = @"";
        self.billNo = @"";
        self.refundFee = @"";
    }
    return self;
}

- (void)preRefundReq {
    [VFPayCache sharedInstance].vfResp = [[VFPreRefundResp alloc] initWithReq:self];
    
    if (![self checkParametersForPreRefund]) return ;
    
    NSString *cType = [VFPayUtil getChannelString: self.channel];
    
    NSMutableDictionary *parameters = [VFPayUtil prepareParametersForRequest];
    if (parameters == nil) {
        [VFPayUtil doErrorResponse:@"请检查是否全局初始化"];
        return;
    }
    
    if (![cType isEqualToString:@""]) {
        parameters[@"channel"] = [cType componentsSeparatedByString:@"_"][0];
    }
    parameters[@"refund_no"] = self.refundNo;
    parameters[@"refund_fee"] = [NSNumber numberWithInteger:[self.refundFee integerValue]];
    parameters[@"bill_no"] = self.billNo;
    
    if (self.optional) {
        parameters[@"optional"] = self.optional;
    }
    
    parameters[@"need_approval"] = @(YES);
    
    VFHTTPSessionManager *manager = [VFPayUtil getVFHTTPSessionManager];
    
    [manager POST:[VFPayUtil getBestHostWithFormat:kRestApiRefund] parameters:parameters progress:nil
          success:^(NSURLSessionTask *task, id response) {
              if ([response integerValueForKey:kKeyResponseResultCode defaultValue:VFErrCodeCommon] != 0) {
                  [VFPayUtil getErrorInResponse:(NSDictionary *)response];
              } else {
                  [VFPayCache sharedInstance].vfResp.vfId = [(NSDictionary *)response stringValueForKey:@"id" defaultValue:@""];
                  [VFPayCache sharedInstance].vfResp.resultCode = [response integerValueForKey:kKeyResponseResultCode defaultValue:VFErrCodeCommon];
                  [VFPayCache sharedInstance].vfResp.resultMsg = [response stringValueForKey:kKeyResponseResultMsg defaultValue:kUnknownError];
                  [VFPayCache sharedInstance].vfResp.errDetail = [response stringValueForKey:kKeyResponseErrDetail defaultValue:kUnknownError];
                  [VFPayCache vfinanceDoResponse];
              }
          } failure:^(NSURLSessionTask *operation, NSError *error) {
              [VFPayUtil doErrorResponse:kNetWorkError];
          }];

}

- (BOOL)checkParametersForPreRefund {
    if ([VFPayCache sharedInstance].sandbox) {
        [VFPayUtil doErrorResponse:@"当前为沙箱测试模式，不支持预退款功能"];
        return NO;
    } else if (!self.refundFee.isValid || !self.refundFee.isPureInt) {
        [VFPayUtil doErrorResponse:@"refundFee 以分为单位，必须是只包含数值的字符串"];
        return NO;
    } else if (!self.billNo.isValid || !self.billNo.isValidTraceNo || (self.billNo.length < 8) || (self.billNo.length > 32)) {
        [VFPayUtil doErrorResponse:@"billNo 必须是长度8~32位字母和/或数字组合成的字符串"];
        return NO;
    } else if (![self checkRefundNo])  {
        [VFPayUtil doErrorResponse:@"refundNo 格式必须为退款日期(8位) + 流水号(3~24 位)"];
        return NO;
    }
    return YES;
}

- (BOOL)checkRefundNo {
    if (!self.refundNo.isValid || !self.refundNo.isValidTraceNo || (self.refundNo.length < 11) || (self.refundNo.length > 32)) {
        return NO;
    }
    
    NSString *prefix = [self.refundNo substringToIndex:8];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *now = [dateFormatter stringFromDate:[NSDate date]];
    
    return [prefix isEqualToString:now];
}


@end
