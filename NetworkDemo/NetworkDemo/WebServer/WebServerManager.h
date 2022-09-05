//
//  WebServerManager.h
//  NetworkDemo
//
//  Created by syrius on 2022/3/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebServerManager : NSObject

+ (WebServerManager *)instance;
- (void)runServer;

@end

NS_ASSUME_NONNULL_END
