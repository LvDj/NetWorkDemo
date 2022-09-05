//
//  VPNProtocolSetUtil.h
//  NetworkDemo
//
//  Created by syrius on 2022/3/10.
//

#import <Foundation/Foundation.h>
@import NetworkExtension;
NS_ASSUME_NONNULL_BEGIN

@interface VPNProtocolSetUtil : NSObject

+ (NEVPNProtocol *)setBaseConfigToProtocol:(NEVPNProtocol *) protocol;
+ (NETunnelProviderProtocol *) createTunnelProviderProtocol;

+(NSArray<NEOnDemandRule *> *)createConnectionRuleArray;

@end

NS_ASSUME_NONNULL_END
