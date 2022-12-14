//
//  DNSProxyProvider.m
//  DNSProxy
//
//  Created by syrius on 2022/3/14.
//

#import "DNSProxyProvider.h"

@implementation DNSProxyProvider

- (void)startProxyWithOptions:(NSDictionary *)options completionHandler:(void (^)(NSError *))completionHandler {
    // Add code here to start the DNS proxy.
    completionHandler(nil);
}

- (void)stopProxyWithReason:(NEProviderStopReason)reason completionHandler:(void (^)(void))completionHandler {
    // Add code here to stop the DNS proxy.
    completionHandler();
}

- (void)sleepWithCompletionHandler:(void (^)(void))completionHandler {
    // Add code here to get ready to sleep.
    completionHandler();
}

- (void)wake {
    // Add code here to wake up.
}

- (BOOL)handleNewFlow:(NEAppProxyFlow *)flow {
    // Add code here to handle the incoming flow.
    return NO;
}

@end
