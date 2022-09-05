//
//  HostUtil.h
//  PacketTunnel
//
//  Created by syrius on 2022/3/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HostUtil : NSObject

+ (NSString *)queryIpWithDomain:(NSString *)domain;

@end

NS_ASSUME_NONNULL_END
