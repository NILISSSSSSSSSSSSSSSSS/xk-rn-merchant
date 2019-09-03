//
//  XKPhotoPickHelper
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/3.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface XKPhotoPickHelper : NSObject

/** 选中图片回调*/
@property (nonatomic, copy)void(^choseImageBlcok)(NSArray<UIImage *> * _Nullable images);

/** 选中视频回调*/
@property (nonatomic, copy)void(^choseVideoBlcok)(UIImage *coverImage, id asset);

/** 拍摄视频回调*/
@property (nonatomic, copy)void(^choseVideoPathBlcok)(NSString *videoPath , UIImage *coverImg);
/**照片数量限制*/
@property (nonatomic, assign)NSInteger maxCount;

/**
 允许裁剪,默认为no
 */
@property (nonatomic, assign)BOOL allowCrop;

/**
 判断是否有相机功能
 */
+ (BOOL)isCameraAvailable;

/**
 是否需要拍摄视频的选项
 
 @param need 是否
 */
- (void)handleVideoChoseWithNeeded:(BOOL)need;

- (void)showView;

/**
 从相册选择图片

 @param choseImageBlcok 选择后的回调
 */
- (void)imageFromLibiaryWithBlock:(void(^)(NSArray<UIImage *> * _Nullable images))choseImageBlcok;

/**
 拍摄照片
 
 @param choseImageBlcok 拍摄后的回调
 */
- (void)imageFromCameraWithBlock:(void(^)(NSArray<UIImage *> * _Nullable images))choseImageBlcok;

/**
 拍摄视频

 @param choseVideoPathBlcok 拍摄后的回调
 */
- (void)videoFromCameraWithBlock:(void(^)(NSString *videoPath , UIImage *coverImg))choseVideoPathBlcok;

/**
 从相册选择视频
 
 @param choseVideoBlcok 选择后的回调
 */
- (void)videoFromLibiaryWithBlock:(void(^)(UIImage *coverImage, id asset))choseVideoBlcok;

@end
