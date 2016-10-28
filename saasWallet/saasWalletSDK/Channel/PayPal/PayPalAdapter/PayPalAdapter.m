#import "PayPalAdapter.h"
#import "SaasWalletSDKAdapterProtocol.h"
#import "PayPalMobile.h"
#import "VFPayUtil.h"
#import "VFPayCache.h"

@interface PayPalAdapter ()<SaasWalletSDKAdapterDelegate>

@property (nonatomic, assign) BOOL isSandbox;

@end

@implementation PayPalAdapter

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static PayPalAdapter *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[PayPalAdapter alloc] init];
    });
    return instance;
}

- (void)registerPayPal:(NSString *)clientID secret:(NSString *)secret sandbox:(BOOL)isSandbox {
    if(clientID.isValid && secret.isValid) {
        
        if (isSandbox) {
            [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"YOUR_PRODUCTION_CLIENT_ID",
                                                                   PayPalEnvironmentSandbox : clientID}];
            [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentSandbox];
        } else {
            [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : clientID,
                                                                   PayPalEnvironmentSandbox : @"YOUR_SANDbox_CLIENT_ID"}];
            [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentProduction];
        }
        
    }
}

- (void)payPal:(NSMutableDictionary *)dic {

    VFPayPalReq *req = (VFPayPalReq *)[dic objectForKey:kAdapterPayPal];
    [VFPayCache sharedInstance].vfResp = [[VFBaseResp alloc] initWithReq:req];
    
    if (![self checkParameters:req]) return;
    
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:req.items];
    
    // Optional: include payment details
    NSDecimalNumber *dShipping = [[NSDecimalNumber alloc] initWithString:req.shipping];
    NSDecimalNumber *dTax = [[NSDecimalNumber alloc] initWithString:req.tax];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:dShipping
                                                                                    withTax:dTax];
    
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:dShipping] decimalNumberByAdding:dTax];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = total;
    payment.currencyCode = ((PayPalItem *)req.items.lastObject).currency;
    payment.shortDescription = req.shortDesc;
    payment.items = req.items;
    payment.paymentDetails = paymentDetails;
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:(PayPalConfiguration *)req.payConfig
                                                                                                     delegate:req.viewController];
    [(UIViewController *)req.viewController presentViewController:paymentViewController animated:YES completion:nil];
}

- (void)payPalVerify:(NSMutableDictionary *)dic {
    VFPayPalVerifyReq *req = (VFPayPalVerifyReq *)[dic objectForKey:kAdapterPayPal];
    [VFPayCache sharedInstance].vfResp = [[VFBaseResp alloc] initWithReq:req];
    [self reqPayPalAccessToken:req];
}

- (void)reqPayPalAccessToken:(VFPayPalVerifyReq *)req {
    
    VFHTTPSessionManager *manager = [VFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = NO;
    manager.requestSerializer = [VFHTTPRequestSerializer serializer];
    
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:[VFPayCache sharedInstance].payPalClientID password:[VFPayCache sharedInstance].payPalSecret];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@"client_credentials" forKey:@"grant_type"];
    __weak PayPalAdapter * weakSelf = [PayPalAdapter sharedInstance];
    [manager POST:[VFPayCache sharedInstance].isPayPalSandbox?kPayPalAccessTokenSandbox:kPayPalAccessTokenProduction parameters:params progress:nil success:^(NSURLSessionTask *task, id response) {
        VFPayLog(@"token %@", response);
        NSDictionary *dic = (NSDictionary *)response;
        [weakSelf doPayPalVerify:req accessToken:[NSString stringWithFormat:@"%@ %@", [dic stringValueForKey:@"token_type" defaultValue:@""],[dic stringValueForKey:@"access_token" defaultValue:@""]]];
    }  failure:^(NSURLSessionTask *operation, NSError *error) {
        [VFPayUtil doErrorResponse:kNetWorkError];
    }];
}

- (void)doPayPalVerify:(VFPayPalVerifyReq *)req accessToken:(NSString *)accessToken {
    
    if (req == nil || req.payment == nil) {
        [VFPayUtil doErrorResponse:@"请求参数格式不合法"];
        return ;
    }
    NSMutableDictionary *parameters = [VFPayUtil prepareParametersForRequest];
    if (parameters == nil) {
        [VFPayUtil doErrorResponse:@"请检查是否全局初始化"];
        return;
    }
    if ([VFPayCache sharedInstance].isPayPalSandbox) {
        parameters[@"channel"] = @"PAYPAL_SANDBOX";
    } else {
        parameters[@"channel"] = @"PAYPAL_LIVE";
    }
    if (req.optional) {
        parameters[@"optional"] = req.optional;
    }
    PayPalPayment *payment = (PayPalPayment *)req.payment;
    parameters[@"title"] = payment.shortDescription;
    parameters[@"total_fee"] = @((int)([payment.amount floatValue] * 100));
    parameters[@"currency"] = payment.currencyCode;
    parameters[@"bill_no"] = [[payment.confirmation[@"response"] objectForKey:@"id"] stringByReplacingOccurrencesOfString:@"PAY-" withString:@""];
    parameters[@"access_token"] = accessToken;
    
    VFHTTPSessionManager *manager = [VFPayUtil getVFHTTPSessionManager];
    
    [manager POST:[VFPayUtil getBestHostWithFormat:kRestApiPay] parameters:parameters progress:nil
          success:^(NSURLSessionTask *task, id response) {
              [VFPayUtil getErrorInResponse:response];
          } failure:^(NSURLSessionTask *operation, NSError *error) {
              [VFPayUtil doErrorResponse:kNetWorkError];
          }];
}


- (BOOL)checkParameters:(VFBaseReq *)request {
    
    if (request == nil) {
        [VFPayUtil doErrorResponse:@"请求结构体不合法"];
    } else if (request.type == VFObjsTypePayPal) {
        VFPayPalReq *req = (VFPayPalReq *)request;
        if (req.items == nil || req.items.count == 0) {
            [VFPayUtil doErrorResponse:@"payitem 格式不合法"];
            return NO;
        } else if (!req.shipping.isValid) {
            [VFPayUtil doErrorResponse:@"shipping 格式不合法"];
            return NO;
        }  else if (!req.tax.isValid) {
            [VFPayUtil doErrorResponse:@"tax 格式不合法"];
            return NO;
        } else if (req.payConfig == nil || ![req.payConfig isKindOfClass:[PayPalConfiguration class]]) {
            [VFPayUtil doErrorResponse:@"payConfig 格式不合法"];
            return NO;
        } else if (req.viewController == nil) {
            [VFPayUtil doErrorResponse:@"viewController 格式不合法"];
            return NO;
        }
        return YES;
    }
    return NO ;
}

@end
