//
//  HostUtil.m
//  PacketTunnel
//
//  Created by syrius on 2022/3/14.
//

#import "HostUtil.h"
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>

@implementation HostUtil

// 域名转换IP
+ (NSString *)queryIpWithDomain:(NSString *)domain {
    struct hostent *hs;
    struct sockaddr_in server;
    if ((hs = gethostbyname([domain UTF8String])) != NULL) {
        server.sin_addr = *((struct in_addr*)hs->h_addr_list[0]);
        return [NSString stringWithUTF8String:inet_ntoa(server.sin_addr)];
    }
    
    return nil;
}
@end
