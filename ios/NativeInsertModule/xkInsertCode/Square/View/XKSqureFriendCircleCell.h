//
//  XKSqureFriendCircleCell.h
//  XKSquare
//
//  Created by hupan on 2018/8/6.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XKSqureFriendCircleCell;
@class FriendsCirclelListItem;

@protocol FriendCircleDelegate <NSObject>

@optional

- (void)likeBtnClicked:(XKSqureFriendCircleCell *)cell sender:(UIButton *)sender;
- (void)unfoldButtonClick:(XKSqureFriendCircleCell *)cell index:(NSInteger)index;
- (void)friendCircleCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath imgUrlArr:(NSArray *)imgUrlArr;

@end

@interface XKSqureFriendCircleCell : UITableViewCell

@property (nonatomic, weak  ) id<FriendCircleDelegate> delegate;

- (void)setValueWithModel:(FriendsCirclelListItem *)model indexPath:(NSIndexPath *)indexPath;

@end
