//
//  VpnCenter.m
//  NetworkDemo
//
//  Created by syrius on 2022/3/11.
//

#import "VpnCenter.h"
#import "VPNProtocolSetUtil.h"
@import NetworkExtension;

@implementation VpnCenter

+(VpnCenter *)instance{
    static VpnCenter *center;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        center = [[VpnCenter alloc] init];
    });
    return center;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setVpn];
    }
    return self;
}

-(void)setVpn{
    // VPN配置变更
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vpnStateChange:) name:NEVPNConfigurationChangeNotification object:nil];
    // vpn状态变更
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vpnStateChange:) name:NEVPNStatusDidChangeNotification object:nil];
    if(0){
        [self codeNEVPNManager];
    }else{
        [self codeNEPacketTunnelProvider];
    }
}

-(void)codeNEPacketTunnelProvider{
    
    //    NEPacketTunnelProvider a;
    [NETunnelProviderManager loadAllFromPreferencesWithCompletionHandler:^(NSArray<NETunnelProviderManager *> * _Nullable managers, NSError * _Nullable error) {
        if(error == nil){
            NETunnelProviderManager *manager;
            if(managers.count > 0){
                manager = managers.firstObject;
            }else{
                manager = [[NETunnelProviderManager alloc] init];
                manager.localizedDescription = @"全局描述";
                manager.onDemandEnabled = YES;// 按需连接
            }
            manager.protocolConfiguration = [VPNProtocolSetUtil createTunnelProviderProtocol];
            [manager setOnDemandRules:[VPNProtocolSetUtil createConnectionRuleArray]];
            [manager setEnabled:YES];
            NETunnelProviderProtocol *pp =  (NETunnelProviderProtocol *)manager.protocolConfiguration;
            pp.providerConfiguration = @{};
            manager.protocolConfiguration = pp;
            [manager saveToPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
                [manager loadFromPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
                    NSError *startError;
                    BOOL result = [[manager connection] startVPNTunnelAndReturnError:&startError];
                    if(!result || startError != nil){
                        NSLog(@"start error");
                    }
                }];
            }];
            
        }else{
            NSLog(@"Error");
        }
    }];
}

-(void) codeNEVPNManager {
    __weak typeof(self) weakSelf = self;
    NEVPNManager *manager = [NEVPNManager sharedManager];
    [manager loadFromPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
        if(error) {
            NSLog(@"Load error: %@", error);
        } else {
            __strong VpnCenter *strongSelf = weakSelf;
            if(strongSelf){
                
                [manager setEnabled:YES];
                [manager setProtocolConfiguration:[strongSelf getProtocol]];
                [manager setOnDemandEnabled:NO];
                [manager setLocalizedDescription:@"设置内显示名"];

//                [manager loadFromPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
//                                    
//                }];
                [manager saveToPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
                    
                    if(error) {
                        NSLog(@"Save error: %@", error);
                    } else {
                        NSError *startError;
                        BOOL r = [[NEVPNManager sharedManager].connection startVPNTunnelAndReturnError:&startError];
                    }
                }];
            }
        }
    }];
    /*
     NotificationCenter.default.addObserver(self, selector: #selector(vpnConfigurationDidChanged(notification:)), name: .NEVPNConfigurationChange, object: nil)
     NotificationCenter.default.addObserver(self, selector: #selector(vpnStatusDidChanged(notification:)), name: .NEVPNStatusDidChange, object: nil)
     /// vpn配置改变监听
     func vpnConfigurationDidChanged(notification: Notification) {
     }
     /// vpn状态改变监听
     func vpnStatusDidChanged(notification: Notification) {
     }
     */
}

-(void)vpnStateChange:(NSNotification *)notify{
    
}

-(NEVPNProtocol *)getProtocol{
    if(0){
        return [self getProtocolIKEv2];
    }else{
        return [self getProtocolIPSec];
    }
}
// 个人Vpn
-(NEVPNProtocol *)getProtocolIKEv2{
    NEVPNProtocolIKEv2* ikev = [[NEVPNProtocolIKEv2 alloc] init];
    [VPNProtocolSetUtil setBaseConfigToProtocol:ikev];
    ikev.certificateType = NEVPNIKEv2CertificateTypeRSA;
    ikev.authenticationMethod = NEVPNIKEAuthenticationMethodNone;
    ikev.useExtendedAuthentication = YES;
    
    ikev.remoteIdentifier = @"identity";
    ikev.identityReference = [@"identity" dataUsingEncoding:4];//使用iOS钥匙串(keyChain)存入的identity;
    return ikev;
}
// 个人Vpn
-(NEVPNProtocol *)getProtocolIPSec{
    
    NEVPNProtocolIPSec* ipsec = [[NEVPNProtocolIPSec alloc] init];
    [VPNProtocolSetUtil setBaseConfigToProtocol:ipsec];
    ipsec.useExtendedAuthentication = true;
    // 认证方式（证书 和 预共享密钥）
    ipsec.authenticationMethod = NEVPNIKEAuthenticationMethodNone;
    
    // 秘钥认证
    //    ipsec.authenticationMethod = NEVPNIKEAuthenticationMethodSharedSecret;
    //    ipsec.sharedSecretReference = [@"预共享密钥" dataUsingEncoding:4];
    
    // 证书认证
    //    ipsec.authenticationMethod = NEVPNIKEAuthenticationMethodCertificate;
    //     ipsec.identityData = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "client", ofType: "p12")!))
    //     ipsec.identityDataPassword = "证书导入密钥"
    
    
    return ipsec;
}

@end
