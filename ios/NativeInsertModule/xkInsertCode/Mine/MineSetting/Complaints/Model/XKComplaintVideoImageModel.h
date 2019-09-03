//
//  XKComplaintVideoImageModel.h
//  XKSquare
//
//  Created by Lin Li on 2018/10/31.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKComplaintVideoImageModel : NSObject
/**视频地址*/
@property(nonatomic, strong) NSURL   *videoUrl;
/**图片*/
@property(nonatomic, strong) UIImage *image;
/**首诊图*/
@property(nonatomic, strong) UIImage *coverImg;
/**是否是视频*/
@property(nonatomic, assign) BOOL     isVideo;

@property(nonatomic, copy) NSString *imageNetAddr;

/**视频地址。。net*/
@property(nonatomic, copy) NSString *videoNetAddr;
/**视频首帧地址。。net*/
@property(nonatomic, copy) NSString *videoFirstImgNetAddr;

@end

NS_ASSUME_NONNULL_END
