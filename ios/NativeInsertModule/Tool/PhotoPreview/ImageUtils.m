//
//  ImageLoader.m
//  DemoTest
//
//  Created by rztime on 2017/8/15.
//  Copyright © 2017年 rztime. All rights reserved.
//

#import "ImageUtils.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIImageView+WebCache.h>
#import <Photos/Photos.h>
@interface ImageUtils ()

@property (nonatomic, strong) NSMutableDictionary *dicts;

@end

@implementation ImageUtils

+ (instancetype)shareInstance {
    static ImageUtils *loader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loader = [[ImageUtils alloc] init];
    });
    return loader;
}

+ (void)getImageWithURL:(NSURL *)url resultBlock:(void(^)(NSError *error, UIImage *image))block {
    NSString *urlstring = url.absoluteString;
    if ([urlstring hasPrefix:@"assets-library://"]) {
//        ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
//        [lib assetForURL:url resultBlock:^(ALAsset *asset) {
//            // 使用asset来获取本地图片
//            ALAssetRepresentation *assetRep = [asset defaultRepresentation];
//            CGImageRef imgRef = [assetRep fullScreenImage];
//            UIImage *image = [UIImage imageWithCGImage:imgRef
//                                                 scale:assetRep.scale
//                                           orientation:(UIImageOrientation)assetRep.orientation];
////            UIImage *image = [UIImage imageWithCGImage:[asset thumbnail]];
//            if (image) {
//                if (block) {
//                    block(nil, image);
//                }
//            } else { // 获取图片失败
//                if (block) {
//                    block([NSError errorWithDomain:@"相册中的图片未获取到" code:1 userInfo:nil], nil);
//                }
//            }
//        } failureBlock:^(NSError *error) { // 说明获取图片失败.
//            if (block) {
//                block([NSError errorWithDomain:@"相册中的图片未获取到" code:1 userInfo:nil], nil);
//            }
//        }];
    } else {
        [[ImageUtils shareInstance] getImageWithURL:url resultBlock:block];
    }
}

- (void)getImageWithURL:(NSURL *)url resultBlock:(void(^)(NSError *error, UIImage *image))block {
    if (![self.dicts.allKeys containsObject:url]) {
        UIImageView *imageview = [[UIImageView alloc] init];
		if (url) {
			[self.dicts setObject:imageview forKey:url];
		}
        __weak typeof (self) wself = self;
        [imageview sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (block) {
				if (!image) {
					image = [UIImage imageWithContentsOfFile:url.absoluteString];
				}
                block(error, image);
				if (url) {
					[wself.dicts removeObjectForKey:url];
				}
            }
        }];
        
    } else {
        UIImageView *imageview = [self.dicts objectForKey:url];
        __weak typeof (self) wself = self;
        [imageview sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (block) {
				if (!image) {
					image = [UIImage imageWithContentsOfFile:url.absoluteString];
				}
                block(error, image);
				if (url) {
					[wself.dicts removeObjectForKey:url];
				}
            }
        }];
    }
}

- (NSMutableDictionary *)dicts {
    if (!_dicts) {
        _dicts = [NSMutableDictionary new];
    }
    return _dicts;
}
@end
