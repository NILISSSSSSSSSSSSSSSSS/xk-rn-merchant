//
//  XKVideoSearchHeaderView.h
//  XKSquare
//
//  Created by xudehuai on 2018/10/15.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XKVideoSearchUserModel.h"
#import "XKVideoSearchTopicModel.h"

@class XKVideoSearchResultModel;
@class XKVideoSearchCollectionHeader;


@protocol XKVideoSearchCollectionHeaderDelegate <NSObject>

@optional

// 点击了更多用户
- (void)header:(XKVideoSearchCollectionHeader *) header didClikedMoreUser:(XKVideoSearchUserModel *) user;
// 点击了某个用户
- (void)header:(XKVideoSearchCollectionHeader *) header didClikedUser:(XKVideoSearchUserModel *) user;
// 点击了更多话题
- (void)headerDidClikedMoreTopic:(XKVideoSearchCollectionHeader *) header;
// 点击了某个话题
- (void)header:(XKVideoSearchCollectionHeader *) header didClikedTopic:(XKVideoSearchTopicModel *) topic;

@end

NS_ASSUME_NONNULL_BEGIN

@interface XKVideoSearchCollectionHeader : UICollectionReusableView

@property (nonatomic, strong) XKVideoSearchResultModel *resultModel;

@property (nonatomic, weak) id<XKVideoSearchCollectionHeaderDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
