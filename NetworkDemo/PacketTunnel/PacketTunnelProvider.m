//
//  PacketTunnelProvider.m
//  PacketTunnel
//
//  Created by syrius on 2022/3/10.
//

#import "PacketTunnelProvider.h"
#import "HostUtil.h"
//#define XDX_NET_MTU                        1400
//#define XDX_NET_REMOTEADDRESS              "192.168.3.14"
//#define XDX_NET_SUBNETMASKS                "255.255.255.255"
//#define XDX_NET_DNS                        "223.5.5.5"
//#define XDX_LOCAL_ADDRESS                  "127.0.0.1"
//#define TVU_NET_TUNNEL_IPADDRESS           "10.10.10.10"

@implementation PacketTunnelProvider

// startVpn时, 会触发该回调. 用于处理配置
- (void)startTunnelWithOptions:(NSDictionary *)options completionHandler:(void (^)(NSError *))completionHandler {
    
    NSLog(@"-------> start");
    
    NEPacketTunnelNetworkSettings *tunnelNetworkSettings = [[NEPacketTunnelNetworkSettings alloc] initWithTunnelRemoteAddress:@"127.0.0.1"];
//    NEPacketTunnelNetworkSettings *tunnelNetworkSettings = [[NEPacketTunnelNetworkSettings alloc] initWithTunnelRemoteAddress:[HostUtil queryIpWithDomain:@"www.baidu.com"]];
    
    // 最大传输单元
    tunnelNetworkSettings.MTU = [NSNumber numberWithInteger:1400];
    tunnelNetworkSettings.tunnelOverheadBytes = @80;
    [self setIpV4Config:tunnelNetworkSettings];
    [self setIpV6Config:tunnelNetworkSettings];
    
    tunnelNetworkSettings.DNSSettings = [[NEDNSSettings alloc] initWithServers:@[@"1.1.1.1", @"8.8.8.8", @"8.8.4.4"]];
    tunnelNetworkSettings.DNSSettings.matchDomains = @[@""];
    
    [self setTunnelNetworkSettings:tunnelNetworkSettings completionHandler:^(NSError * _Nullable error) {
        NSLog(@"-------> error %@", error);
        if (error == nil) {
            completionHandler(nil);
        }else {
            completionHandler(error);
            return;
        }
    }];
    
    [self.packetFlow readPacketObjectsWithCompletionHandler:^(NSArray<NEPacket *> * _Nonnull packets) {
        [self.packetFlow writePacketObjects:packets];
    }];
//    [self.packetFlow readPacketsWithCompletionHandler:^(NSArray<NSData *> * _Nonnull packets, NSArray<NSNumber *> * _Nonnull protocols) {
        //        [packets enumerateObjectsUsingBlock:^(NSData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //            NSString *packetStr = [NSString stringWithFormat:@"%@",obj];
        //        }];
//        NSLog(@"-------> read");
//    }];
    
}

-(void)setIpV4Config:(NEPacketTunnelNetworkSettings *)settings{
    settings.IPv4Settings = [[NEIPv4Settings alloc] initWithAddresses:@[@"127.0.0.1", @"0.0.0.0"]  subnetMasks:@[@"0.0.0.0", @"0.0.0.0"]];
    // 需要拦截的地址
    settings.IPv4Settings.includedRoutes = @[[NEIPv4Route defaultRoute]];
//    NEIPv4Settings *excludeRoute = [[NEIPv4Settings alloc] initWithAddresses:@[@"127.0.0.1"] subnetMasks:@[@"255.255.255.255"]];
//    // 不需要拦截的地址
//    settings.IPv4Settings.excludedRoutes = @[excludeRoute];
}

-(void)setIpV6Config:(NEPacketTunnelNetworkSettings *)settings{
    settings.IPv6Settings = [[NEIPv6Settings alloc] initWithAddresses:@[@"127.0.0.1", @"0.0.0.0"] networkPrefixLengths:@[@10, @10]];
    // 需要拦截的地址
    settings.IPv6Settings.includedRoutes = @[[NEIPv6Route defaultRoute]];
//    NEIPv6Settings *excludeRoute = [[NEIPv6Settings alloc] initWithAddresses:@[@"127.0.0.1"] networkPrefixLengths:@[@10]];
//    // 不需要拦截的地址
//    settings.IPv4Settings.excludedRoutes = @[excludeRoute];
}




- (void)stopTunnelWithReason:(NEProviderStopReason)reason completionHandler:(void (^)(void))completionHandler {
    // Add code here to start the process of stopping the tunnel.
    completionHandler();
}

- (void)handleAppMessage:(NSData *)messageData completionHandler:(void (^)(NSData *))completionHandler {
    // Add code here to handle the message.
}

- (void)sleepWithCompletionHandler:(void (^)(void))completionHandler {
    // Add code here to get ready to sleep.
    completionHandler();
}

- (void)wake {
    // Add code here to wake up.
}

@end
