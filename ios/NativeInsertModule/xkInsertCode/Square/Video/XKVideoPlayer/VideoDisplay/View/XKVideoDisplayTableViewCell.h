//
//  XKVideoDisplayTableViewCell.h
//  XKSquare
//
//  Created by RyanYuan on 2018/10/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKVideoDisplayTableViewCell;
@class XKVideoDisplayVideoListItemModel;
@protocol XKVideoDisplayTableViewCellDelegate <NSObject>

- (void)tableViewCell:(XKVideoDisplayTableViewCell *)cell clickBackButtonWithModel:(XKVideoDisplayVideoListItemModel *)model;
- (void)tableViewCell:(XKVideoDisplayTableViewCell *)cell clickLiveButtonWithModel:(XKVideoDisplayVideoListItemModel *)model;
- (void)tableViewCell:(XKVideoDisplayTableViewCell *)cell clickAdvertisementButtonWithModel:(XKVideoDisplayVideoListItemModel *)model;
- (void)tableViewCell:(XKVideoDisplayTableViewCell *)cell clickRedEnvelopeButtonWithModel:(XKVideoDisplayVideoListItemModel *)model;
- (void)tableViewCell:(XKVideoDisplayTableViewCell *)cell clickHeaderButtonWithModel:(XKVideoDisplayVideoListItemModel *)model;
- (void)tableViewCell:(XKVideoDisplayTableViewCell *)cell clickAttentionButtonWithModel:(XKVideoDisplayVideoListItemModel *)model;
- (void)tableViewCell:(XKVideoDisplayTableViewCell *)cell clickLikeButtonWithModel:(XKVideoDisplayVideoListItemModel *)model;
- (void)tableViewCell:(XKVideoDisplayTableViewCell *)cell clickCommentButtonWithModel:(XKVideoDisplayVideoListItemModel *)model;
- (void)tableViewCell:(XKVideoDisplayTableViewCell *)cell clickShareButtonWithModel:(XKVideoDisplayVideoListItemModel *)model;
- (void)tableViewCell:(XKVideoDisplayTableViewCell *)cell clickGiftButtonWithModel:(XKVideoDisplayVideoListItemModel *)model;

@end

@interface XKVideoDisplayTableViewCell : UITableViewCell

@property (nonatomic, weak) id<XKVideoDisplayTableViewCellDelegate> delegate;

/**
 * 配置cell数据源
 */
- (void)configTableViewCellWithModel:(XKVideoDisplayVideoListItemModel *)model;

/**
 * 刷新视频信息相关视图
 */
- (void)updateUserInfoViews:(XKVideoDisplayVideoListItemModel *)model;

/**
 * 标记视频是否需要播放
 */
- (void)videoNeedsToPlay:(BOOL)isNeed;

/**
 * 暂停播放
 */
- (void)pausePlayVideo;

/**
 * 继续播放
 */
- (void)resumePlayVideo;

/**
 * 停止视频播放
 */
- (void)stopPlayVideo;

/**
 * 移除播放控件
 */
- (void)removePlayVideo;

    
@end
