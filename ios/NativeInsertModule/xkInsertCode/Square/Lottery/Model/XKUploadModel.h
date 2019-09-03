//
//  XKUploadModel.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/7.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, XKUploadModelType) {
    XKUploadModelTypeImg = 1 << 0,
    XKUploadModelTypeVideo = 1 << 1,
};

NS_ASSUME_NONNULL_BEGIN

@interface XKUploadModel : NSObject

@property (nonatomic, assign) XKUploadModelType type;

@property (nonatomic, strong) UIImage *img;

@property (nonatomic, copy) NSString *imgUrl;

@property (nonatomic, copy) NSString *videoPath;

@property (nonatomic, copy) NSString *videoUrl;

@property (nonatomic, strong) UIImage *videoFirstImg;

@property (nonatomic, copy) NSString *videoFirstImgUrl;

@end

NS_ASSUME_NONNULL_END
