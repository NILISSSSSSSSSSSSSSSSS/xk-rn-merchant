//
//  ImageLoader.h
//  DemoTest
//
//  Created by rztime on 2017/8/15.
//  Copyright © 2017年 rztime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageUtils : NSObject

+ (void)getImageWithURL:(NSURL *)url resultBlock:(void(^)(NSError *error, UIImage *image))block;

@end
