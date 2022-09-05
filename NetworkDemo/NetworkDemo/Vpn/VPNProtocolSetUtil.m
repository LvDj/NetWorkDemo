//
//  VPNProtocolSetUtil.m
//  NetworkDemo
//
//  Created by syrius on 2022/3/10.
//

#import "VPNProtocolSetUtil.h"
#import "VpnConfigModel.h"

@implementation VPNProtocolSetUtil

+ (NETunnelProviderProtocol *) createTunnelProviderProtocol {
    NSMutableDictionary *dic = [@{
        @"port":@"1",
        @"server":@"2",
        @"ip":@"3",
        @"subnet":@"4",
        @"dns":@"5",
    } mutableCopy];
    NETunnelProviderProtocol *protocol = [[NETunnelProviderProtocol alloc] init];
    protocol.providerConfiguration = dic;
    protocol.providerBundleIdentifier = @"com.gtsdlt.test.NetworkDemo";
    [VPNProtocolSetUtil setBaseConfigToProtocol:protocol];
    return protocol;
}

+ (NEVPNProtocol *)setBaseConfigToProtocol:(NEVPNProtocol *) protocol {
    
    VpnConfigModel *model = [[VpnConfigModel alloc] init];
    protocol.serverAddress = model.serverAddress;
    protocol.username = model.username;
    
    // 睡眠是否断开vpn连接
    protocol.disconnectOnSleep = model.disconnectOnSleep;
    protocol.proxySettings =  [[NEProxySettings alloc] init];
    protocol.proxySettings.autoProxyConfigurationEnabled = YES;
    [protocol.proxySettings setHTTPEnabled:YES];
    [protocol.proxySettings setHTTPSEnabled:NO];
    
    //    protocol.proxySettings.matchDomains;
    //    protocol.proxySettings.exceptionList;
    //    protocol.proxySettings.httpsServer;
    //    protocol.proxySettings.proxyAutoConfigurationJavaScript;
    return protocol;
}

+(NSArray<NEOnDemandRule *> *)createConnectionRuleArray {
    NEEvaluateConnectionRule *connectionRule = [[NEEvaluateConnectionRule alloc] initWithMatchDomains:@[@"apple.com"]
                                                                                            andAction:NEEvaluateConnectionRuleActionConnectIfNeeded];
                    connectionRule.useDNSServers = @[@"apple.com",@"127.0.0.1",@"0.0.0.0"];
    NEOnDemandRuleEvaluateConnection *exaluteRule = [[NEOnDemandRuleEvaluateConnection alloc] init];
    exaluteRule.interfaceTypeMatch = NEOnDemandRuleInterfaceTypeAny;
    exaluteRule.connectionRules = @[connectionRule];
    return @[exaluteRule];
}

@end
