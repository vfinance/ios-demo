#import "VFPayUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import "VFPayCache.h"
#import "VFRSA.h"

@implementation VFPayUtil

+ (VFHTTPSessionManager *)getVFHTTPSessionManager {
    VFHTTPSessionManager *manager = [VFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = NO;
    manager.requestSerializer = [VFJSONRequestSerializer serializer];
    return manager;
}

+ (NSMutableDictionary *)getWrappedParametersForGetRequest:(NSDictionary *) parameters {
    NSData *parameterData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString *parameterString = [[NSString alloc] initWithBytes:[parameterData bytes] length:[parameterData length]
                                                       encoding:NSUTF8StringEncoding];
    NSMutableDictionary *paramWrapper = [NSMutableDictionary dictionary];
    [paramWrapper setObject:parameterString forKey:@"para"];
    return paramWrapper;
}

+ (NSMutableDictionary *)prepareParametersForRequest {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *createTime = [VFPayUtil dateToString:[NSDate date]];
    NSString *appSign = [VFPayUtil getAppSignature:[VFPayCache sharedInstance].appId];
    if(appSign) {
        [parameters setObject:[VFPayCache sharedInstance].appId forKey:@"appKey"];
        [parameters setObject:createTime forKey:@"createTime"];
        [parameters setObject:appSign forKey:@"toRSA"];
        return parameters;
    }
    return nil;
}

+ (NSString *)getAppSignature:(NSString *)timeStamp {
    return [VFRSA encryptString:timeStamp publicKey:[VFPayCache sharedInstance].appSecret];
}

+ (VFPayUrlType)getUrlType:(NSURL *)url {
    if ([url.host isEqualToString:@"safepay"])
        return VFPayUrlAlipay;
    else if ([url.scheme hasPrefix:@"wx"] && [url.host isEqualToString:@"pay"])
        return VFPayUrlWeChat;
    else
        return VFPayUrlUnknown;
}

+ (NSString *)getBestHostWithFormat:(NSString *)format {
    NSString *verHost = [NSString stringWithFormat:@"%@%@", kVFHost, reqApiVersion];
    return [NSString stringWithFormat:format, verHost, [VFPayCache sharedInstance].sandbox ? @"/sandbox" : @""];
}

+ (NSString *)getChannelString:(PayChannel)channel {
    NSString *cType = @"";
    switch (channel) {
        case PayChannelVFApp:
            cType = @"VF_APP";
            break;
        case PayChannelVFWXApp:
            cType = @"VF_WX_APP";
            break;
#pragma mark PayChannel_WX
        case PayChannelWx:
            cType = @"WX";
            break;
        case PayChannelWxApp:
            cType = @"WXAPPPAY";
            break;
        case PayChannelWxNative:
            cType = @"WX_NATIVE";
            break;
        case PayChannelWxJsApi:
            cType = @"WX_JSAPI";
            break;
        case PayChannelWxScan:
            cType = @"WX_SCAN";
            break;
#pragma mark PayChannel_ALI
        case PayChannelAli:
            cType = @"ALI";
            break;
        case PayChannelAliApp:
            cType = @"ALIAPPPAY";
            break;
        case PayChannelAliWeb:
            cType = @"ALI_WEB";
            break;
        case PayChannelAliWap:
            cType = @"ALI_WAP";
            break;
        case PayChannelAliQrCode:
            cType = @"ALI_QRCODE";
            break;
        case PayChannelAliOfflineQrCode:
            cType = @"ALI_OFFLINE_QRCODE";
            break;
        case PayChannelAliScan:
            cType = @"ALI_SCAN";
            break;
#pragma mark PayChannel_UN
        case PayChannelUn:
            cType = @"UN";
            break;
        case PayChannelUnApp:
            cType = @"UNIONPAY";
            break;
        case PayChannelUnWeb:
            cType = @"UN_WEB";
            break;
        case PayChannelApplePay:
            cType = @"APPLE";
            break;
        case PayChannelApplePayTest:
            cType = @"APPLE_TEST";
            break;
#pragma mark PayChannel_PayPal
        case PayChannelPayPal:
            cType = @"PAYPAL";
            break;
        case PayChannelPayPalLive:
            cType = @"PAYPAL_LIVE";
            break;
        case PayChannelPayPalSandbox:
            cType = @"PAYPAL_SANDBOX";
            break;
#pragma mark PayChannel_Baidu
        case PayChannelBaidu:
            cType = @"BD";
            break;
        case PayChannelBaiduApp:
            cType = @"BD_APP";
            break;
        case PayChannelBaiduWap:
            cType = @"BD_WAP";
            break;
        case PayChannelBaiduWeb:
            cType = @"BD_WEB";
            break;
        default:
            break;
    }
    return cType;
}

#pragma mark - Util Response

+ (VFBaseResp *)doErrorResponse:(NSString *)errMsg {
    VFBaseResp *resp = [VFPayCache sharedInstance].vfResp;
    resp.resultCode = VFErrCodeCommon;
    resp.resultMsg = errMsg;
    resp.errDetail = errMsg;
    [VFPayCache vfinanceDoResponse];
    return resp;
}

+ (VFBaseResp *)getErrorInResponse:(NSDictionary *)response {
    VFBaseResp *resp = [VFPayCache sharedInstance].vfResp;
    resp.resultCode = [response integerValueForKey:kKeyResponseResultCode defaultValue:VFErrCodeCommon];
    resp.resultMsg = [response stringValueForKey:kKeyResponseResultMsg defaultValue:kUnknownError];
    resp.errDetail = [response stringValueForKey:kKeyResponseErrDetail defaultValue:kUnknownError];
    [VFPayCache vfinanceDoResponse];
    return resp;
}

#pragma mark - Util
+ (NSString *)generateRandomUUID {
    return [[NSUUID UUID] UUIDString].lowercaseString;
}

+ (NSDate *)millisecondToDate:(long long)millisecond {
    return [NSDate dateWithTimeIntervalSince1970:((double)millisecond / 1000.0)];
}

+ (NSString *)millisecondToDateString:(long long)millisecond {
    return [VFPayUtil dateToString:[VFPayUtil millisecondToDate:millisecond]];
}

+ (long long)dateToMillisecond:(NSDate *)date {
    if (date == nil) return 0;
    return (long long)([date timeIntervalSince1970] * 1000.0);
}

+ (long long)dateStringToMillisecond:(NSString *)string {
    NSDate *dat = [VFPayUtil stringToDate:string];
    if (dat) return [VFPayUtil dateToMillisecond:dat];
    return 0;
}

+ (NSDate *)stringToDate:(NSString *)string {
    if (string == nil || string.length == 0) return nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kVFDateFormat];
    return [dateFormatter dateFromString:string];
}

+ (NSString *)dateToString:(NSDate *)date {
    if (date == nil) return nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kVFDateFormat];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)stringToMD5:(NSString *)string {
    if(string == nil || [string isEqualToString:@""]) return @"";
    const char *cStr = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr),result );
    NSMutableString *hash =[NSMutableString string];
    for (int i = 0; i < 16; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash uppercaseString];
}

+ (BOOL)isValidEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isValidMobile:(NSString *)mobile {
    NSString *phoneRegex = @"^([0|86|17951]?(13[0-9])|(15[^4,\\D])|(17[678])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+ (BOOL)isLetter:(unichar)ch {
    return (BOOL)((ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z'));
}

+ (BOOL)isDigit:(unichar)ch {
    return (BOOL)(ch >= '0' && ch <= '9');
}

+ (NSUInteger)getBytes:(NSString *)str {
    if (!str.isValid) {
        return 0;
    } else {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSData* da = [str dataUsingEncoding:enc];
        return [da length];
    }
}

@end

void VFPayLog(NSString *format,...) {
    if ([VFPayCache sharedInstance].willPrintLogMsg) {
        va_list list;
        va_start(list,format);
        NSLogv(format, list);
        va_end(list);
    }
}
