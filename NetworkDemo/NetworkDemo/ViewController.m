//
//  ViewController.m
//  NetworkDemo
//
//  Created by syrius on 2022/3/7.
//

#import "ViewController.h"
#import "CustomURLProtocol.h"
#import "CustomURLSchemeHandler.h"
#import "VpnCenter.h"
#import "WebServerManager.h"

@import WebKit;


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [[WebServerManager instance] runServer];
//    [VpnCenter instance];
//    
//    return;
    
    Class cls = NSClassFromString(@"WKBrowsingContextController");
    SEL sel = NSSelectorFromString(@"registerSchemeForCustomProtocol:");
    if ([(id)cls respondsToSelector:sel]) {
        // 注册http(s) scheme, 把 http和https请求交给 NSURLProtocol处理
        [(id)cls performSelector:sel withObject:@"http"];
        [(id)cls performSelector:sel withObject:@"https"];
    }
    
    [NSURLProtocol registerClass:[CustomURLProtocol class]];
    
    //    WKWebViewConfiguration *webViewConfiguration = [[WKWebViewConfiguration alloc] init];
    //    [webViewConfiguration setURLSchemeHandler:[[CustomURLSchemeHandler alloc] init] forURLScheme:@"https"];
    //    [webViewConfiguration setURLSchemeHandler:[[CustomURLSchemeHandler alloc] init] forURLScheme:@"http"];
    
    WKWebView *wkweb = [[WKWebView alloc] init];
    wkweb.frame = self.view.bounds;
    [self.view addSubview:wkweb];
    [wkweb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.bilibili.com"]]];
    
    //    UIWebView *uiweb = [[UIWebView alloc] init];
    //    uiweb.frame = self.view.bounds;
    //    [self.view addSubview:uiweb];
    //    [uiweb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
}


@end
