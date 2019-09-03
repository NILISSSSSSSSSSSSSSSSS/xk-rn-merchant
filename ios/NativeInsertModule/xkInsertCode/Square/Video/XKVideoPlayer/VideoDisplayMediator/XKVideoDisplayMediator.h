//
//  XKVideoDisplayMediator.h
//  XKSquare
//
//  Created by RyanYuan on 2018/11/7.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XKVideoDisplayVideoListItemModel;

@interface XKVideoDisplayMediator : NSObject

/**
 *  获取并播放推荐小视频列表
 *
 *  @param viewController 当前控制器
 */
+ (void)displayRecommendVideoListWithViewController:(UIViewController *)viewController;

/**
 *  根据视频Model播放单个小视频
 *
 *  @param viewController 当前控制器
 *  @param model 视频model
 */
+ (void)displaySingleVideoWithViewController:(UIViewController *)viewController videoListItemModel:(XKVideoDisplayVideoListItemModel *)model;

/**
 *  根据视频ID获取并播放小视频
 *
 *  @param viewController 当前控制器
 *  @param videoId 视频ID
 */
+ (void)displaySingleVideoWithViewController:(UIViewController *)viewController videoId:(NSString *)videoId;

/**
 *  根据视频URL播放视频，不展示视频信息，支持 http(s) (url 以 http:// https:// 开头)及 rtmp (url 以 rtmp:// 开头) 协议
 *
 *  @param viewController 当前控制器
 *  @param urlString 视频URL字符串
 */
+ (void)displaySingleVideoClearWithViewController:(UIViewController *)viewController urlString:(NSString *)urlString;

/**
 *  根据视频本地路径播放视频，不展示视频信息，支持 file:// 及 assets-library://
 *
 *  @param viewController 当前控制器
 *  @param localFilePath 本地视频路径
 */
+ (void)displayLocalSingleVideoClearWithViewController:(UIViewController *)viewController localFilePath:(NSString *)localFilePath;

#pragma mark 转场动画 AVAILABLE（2018.11.14）

/**
 *  根据视频Model播放单个小视频，附带转场动画
 *
 *  @param viewController 当前控制器
 *  @param model 视频model
 *  @param view 触发播放操作的视图，用于生成转场动画
 */
+ (void)displaySingleVideoWithViewController:(UIViewController *)viewController videoListItemModel:(XKVideoDisplayVideoListItemModel *)model fromView:(UIView *)view;

/**
 *  根据视频ID获取并播放小视频，附带转场动画
 *
 *  @param viewController 当前控制器
 *  @param videoId 视频ID
 *  @param view 触发播放操作的视图，用于生成转场动画
 */
+ (void)displaySingleVideoWithViewController:(UIViewController *)viewController videoId:(NSString *)videoId fromView:(UIView *)view;

/**
 *  根据视频URL播放视频，不展示视频信息，附带转场动画，支持 http(s) (url 以 http:// https:// 开头)及 rtmp (url 以 rtmp:// 开头) 协议
 *
 *  @param viewController 当前控制器
 *  @param urlString 视频URL字符串
 *  @param view 触发播放操作的视图，用于生成转场动画
 */
+ (void)displaySingleVideoClearWithViewController:(UIViewController *)viewController urlString:(NSString *)urlString fromView:(UIView *)view;

/**
 *  根据视频本地路径播放视频，不展示视频信息，附带转场动画，支持 file:// 及 assets-library://
 *
 *  @param viewController 当前控制器
 *  @param localFilePath 本地视频路径
 *  @param view 触发播放操作的视图，用于生成转场动画
 */
+ (void)displayLocalSingleVideoClearWithViewController:(UIViewController *)viewController localFilePath:(NSString *)localFilePath fromView:(UIView *)view;

@end
