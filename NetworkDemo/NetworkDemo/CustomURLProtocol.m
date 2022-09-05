//
//  CustomURLProtocol.m
//  NetworkDemo
//
//  Created by syrius on 2022/3/7.
//

#import "CustomURLProtocol.h"


static NSMutableDictionary *requestMap;

@interface CustomURLProtocol () <NSURLSessionDelegate>
@property NSURLSessionDataTask *task;
@property NSURLSession *session;
@end

@implementation CustomURLProtocol

// 是否能响应
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    
    if(requestMap == nil){
        requestMap = [[NSMutableDictionary alloc] init];
    }
    if(requestMap[request.URL]){
        return NO;
    }
    requestMap[request.URL] = request;
    return YES;
}

// 是否额外处理request
+(NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    return request;
}

//- (instancetype)initWithRequest:(NSURLRequest *)request cachedResponse:(nullable NSCachedURLResponse *)cachedResponse client:(nullable id <NSURLProtocolClient>)client
//{
//    self = [super initWithRequest:request cachedResponse:cachedResponse client:client];
//    if (self) {
//
//    }
//    return self;
//}

-(void)startLoading{
    
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                 delegate:self
                                            delegateQueue:[NSOperationQueue currentQueue]];
    
    self.task = [self.session dataTaskWithRequest:self.request];
    [self.task resume];
}

-(void)stopLoading{
    [self.task cancel];
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error{
    if(error){
        [self.client URLProtocol:self didFailWithError:error];
    }else{
        [self.client URLProtocolDidFinishLoading:self];
    }
    requestMap[self.request.URL] = nil;
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    if(completionHandler){
        completionHandler(NSURLSessionResponseAllow);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{
    [self.client URLProtocol:self didLoadData:data];
    
    NSArray<NSString *> *findList = @[@".mp4", @".flv"];
    for (NSString *item in findList) {
        NSRange findMp4Range = [self.request.URL.absoluteString rangeOfString:item];
        if(findMp4Range.location != NSNotFound){
            // TODO       Find Target!!!
            break;
        }
    }
    NSLog(@"--> %@ \n\n\n %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], self.request);
}


@end
