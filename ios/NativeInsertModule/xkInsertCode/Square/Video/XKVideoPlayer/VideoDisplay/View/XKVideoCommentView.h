//
//  XKVideoCommentView.h
//  XKSquare
//
//  Created by xudehuai on 2018/10/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKVideoCommentView;
@class XKVideoDisplayVideoListItemModel;

@protocol XKVideoCommentViewDelegate <NSObject>

@optional

// 显示
- (void)videoCommentViewDidShown:(XKVideoCommentView *) videoCommentView;
// 隐藏
- (void)videoCommentViewDidHidden:(XKVideoCommentView *) videoCommentView;
// 输入框输入了@符号
- (void)videoCommentViewDidInputedAtCharacter:(XKVideoCommentView *) videoCommentView;
// 点击了某个用户
- (void)videoCommentView:(XKVideoCommentView *) videoCommentView didClickedUser:(NSString *) userId;
// 评论数改变
- (void)videoCommentView:(XKVideoCommentView *) videoCommentView didCommentCountChanged:(NSUInteger) commentCount;

@end

NS_ASSUME_NONNULL_BEGIN

@interface XKVideoCommentView : UIView

/**
 初始化方法

 @param video 视频Model
 @param delegate 代理
 @return 评论视图实例
 */
- (instancetype)initWithVideo:(XKVideoDisplayVideoListItemModel *) video delegate:(id<XKVideoCommentViewDelegate>) delegate;

/**
 显示
 */
- (void)showInView:(UIView *) view;

/**
 隐藏
 */
- (void)hide;

@end

NS_ASSUME_NONNULL_END
