//
//  VFWebViewController.m
//  saasWallet
//
//  Created by huangjiawei on 16/10/18.
//  Copyright © 2016年 vfinance. All rights reserved.
//

#import "VFWebViewController.h"
#import "SaasWalletSDKAdapterProtocol.h"
#import <WebKit/WebKit.h>

@interface VFWebViewController ()<NSURLConnectionDelegate, NSURLConnectionDataDelegate, WKNavigationDelegate, WKScriptMessageHandler> {
    WKWebView *payWebView;
    NSString *HTMLString;
}

@end

@implementation VFWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect rect = self.view.frame;
    rect.origin.y = 64.0f;
    rect.size.height = rect.size.height - 64.0f;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, rect.size.width, 64.0f)];
    topView.backgroundColor = [UIColor colorWithRed:92/255.0f green:163/255.0f blue:218/255.0f alpha:1.0f];
    
    UIButton *button = [[UIButton alloc] initWithFrame: CGRectMake(8.0, 22.0, 50.0, 40.0)];
    [button.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithWhite:210/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [topView addSubview:button];
    [self.view addSubview:topView];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKUserContentController* userContent = [[WKUserContentController alloc] init];
    [userContent addScriptMessageHandler:self name:@"nativeListner"];
    config.userContentController = userContent;
    
    payWebView = [[WKWebView alloc] initWithFrame:rect configuration:config];
    payWebView.navigationDelegate = self;
    
    [self.view addSubview:payWebView];
    
    [payWebView loadHTMLString:HTMLString baseURL:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [payWebView.configuration.userContentController removeScriptMessageHandlerForName:@"nativeListner"];
    
    [super viewWillDisappear:animated];
}

- (void)cancelButtonAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"交易尚未完成，确定放弃？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){}]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self dismissViewControllerAnimated:YES completion:^(){}];
    }]];
    [self presentViewController:alert animated:YES completion:^(){}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setHTMLString:(NSString *)html {
    HTMLString = html;
}

#pragma mark - Web View Delegate

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    
    NSArray *trustedHost = @[@"101.231.204.87", @"101.231.204.80"];
    
    for (int i = 0; i < trustedHost.count; i++) {
        if ([challenge.protectionSpace.host isEqualToString:trustedHost[i]]) {
            NSURLCredential *cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, cre);
            return;
        }
    }
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    if ([@"nativeListner" isEqualToString:message.name]) {
        if ([@"close" isEqualToString:message.body]) {
            [self dismissViewControllerAnimated:YES completion:^(){}];
            
            VFPayResp *resp = (VFPayResp *)[VFPayCache sharedInstance].vfResp;
            resp.resultCode = VFErrCodeSuccess;
            resp.resultMsg = @"支付成功";
            resp.errDetail = @"支付成功";
            [VFPayCache vfinanceDoResponse];
        }
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
}

@end
