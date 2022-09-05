//
//  WebServerManager.m
//  NetworkDemo
//
//  Created by syrius on 2022/3/18.
//

#import "WebServerManager.h"
#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"

@interface WebServerManager ()
@property (nonatomic, strong) GCDWebServer* webServer;
@end

@implementation WebServerManager

+ (WebServerManager *)instance {
    static WebServerManager *manager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[WebServerManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)runServer {
    GCDWebServer *webServer = [[GCDWebServer alloc] init];
    
    // Add a handler to respond to GET requests on any URL
    [webServer addDefaultHandlerForMethod:@"GET"
                             requestClass:[GCDWebServerRequest class]
                             processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
        
        return [GCDWebServerDataResponse responseWithHTML:@"<html><body><p>Hello World</p></body></html>"];
    }];
    [webServer startWithPort:8080 bonjourName:nil];
    NSLog(@"Visit %@ in your web browser", webServer.serverURL);
    self.webServer = webServer;
}

@end
