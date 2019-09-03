//
//  XKZBHTTPClient.h
//  XKSquare
//
//  Created by xudehuai on 2018/10/15.
//  Copyright © 2018 xk. All rights reserved.
//

#import "HTTPClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKZBHTTPClient : HTTPClient

+ (XKZBHTTPClient *)sharedHttpClient;

//post不加密请求
+ (void)postRequestWithURLString:(NSString *)URLString
                 timeoutInterval:(NSTimeInterval)timeoutInterval
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(XKHttpErrror *error))failure;

//post加密请求
+ (void)postEncryptRequestWithURLString:(NSString *)URLString
                        timeoutInterval:(NSTimeInterval)timeoutInterval
                             parameters:(NSDictionary *)parameters
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(XKHttpErrror *error))failure;
//下载文件
+ (void)downloadFileWithUrlStr:(NSString *) urlStr
                      savePath:(NSString *) savePath
                      progress:(void (^)(NSProgress *progress)) progress
                       success:(void (^)(NSURL *filePath)) success
                       failure:(void (^)(NSError *error)) failure;

@end

NS_ASSUME_NONNULL_END
