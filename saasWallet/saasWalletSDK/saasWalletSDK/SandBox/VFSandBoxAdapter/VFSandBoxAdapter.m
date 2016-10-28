#import "VFSandboxAdapter.h"
#import "SaasWalletSDKAdapterProtocol.h"
#import "VFPayUtil.h"
#import "VFPayCache.h"
#import "PaySandboxViewController.h"

@interface VFSandboxAdapter () <SaasWalletSDKAdapterDelegate>

@end

@implementation VFSandboxAdapter

- (BOOL)sandboxPay {
    
    VFPayReq *req = (VFPayReq *)[VFPayCache sharedInstance].vfResp.request;
    
    if (req.viewController) {
        PaySandboxViewController *view = [[PaySandboxViewController alloc] init];
        [req.viewController presentViewController:view animated:YES completion:^{
        }];
        return YES;
    }
    return NO;
}

@end
