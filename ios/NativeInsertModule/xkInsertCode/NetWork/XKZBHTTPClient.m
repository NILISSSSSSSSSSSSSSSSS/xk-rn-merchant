//
//  XKZBHTTPClient.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/15.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKZBHTTPClient.h"

#import "XKHttpErrror.h"

@implementation XKZBHTTPClient

+ (XKZBHTTPClient *)sharedHttpClient {
  
  static XKZBHTTPClient *_sharedHttpClient = nil;
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    _sharedHttpClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:BaseLiveUrl]];
    _sharedHttpClient.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*"]];
  });
  return _sharedHttpClient;
}

+ (XKZBHTTPClient *)sharedDownHttpClient {
  
  static XKZBHTTPClient *_sharedHttpClient = nil;
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    _sharedHttpClient = [[self alloc] initWithBaseURL:nil];
    _sharedHttpClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"video/mpeg",@"video/mp4",@"audio/mp3",nil];
  });
  return _sharedHttpClient;
}

//post不加密请求
+ (void)postRequestWithURLString:(NSString *)URLString
                 timeoutInterval:(NSTimeInterval)timeoutInterval
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(XKHttpErrror *error))failure {
  NSDictionary *parameterDic = [self getParameterDictonaryWithUrlString:URLString parameters:parameters encryption:NO];
  [self sharedHttpClient].requestSerializer.timeoutInterval = timeoutInterval;
  [[self sharedHttpClient] POST:URLString parameters:parameterDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    if (success) {
      [self parseResponseObject:responseObject urlString:URLString isEncrypt:NO success:success failed:failure];
    }
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    failure([self handleError:error]);
  }];
}

//post加密请求
+ (void)postEncryptRequestWithURLString:(NSString *)URLString
                        timeoutInterval:(NSTimeInterval)timeoutInterval
                             parameters:(NSDictionary *)parameters
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(XKHttpErrror *error))failure {
  NSDictionary *parameterDic = [self getParameterDictonaryWithUrlString:URLString parameters:parameters encryption:YES];
  [self sharedHttpClient].requestSerializer.timeoutInterval = timeoutInterval;
  [[self sharedHttpClient] POST:URLString parameters:parameterDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    if (success) {
      [self parseResponseObject:responseObject urlString:URLString isEncrypt:YES success:success failed:failure];
    }
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    failure([self handleError:error]);
  }];
}

+ (void)downloadFileWithUrlStr:(NSString *) urlStr
                      savePath:(NSString *) savePath
                      progress:(void (^)(NSProgress *progress)) progress
                       success:(void (^)(NSURL *filePath)) success
                       failure:(void (^)(NSError *error)) failure {
  urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
  NSURLSessionDownloadTask *task = [[self sharedDownHttpClient] downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]] progress:^(NSProgress * _Nonnull downloadProgress) {
    if (progress) {
      progress(downloadProgress);
    }
  } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
    return [NSURL fileURLWithPath:savePath];
  } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
    if (error) {
      if (failure) {
        failure(error);
      }
    } else {
      if (success) {
        success(filePath);
      }
    }
  }];
  [task resume];
}

@end
