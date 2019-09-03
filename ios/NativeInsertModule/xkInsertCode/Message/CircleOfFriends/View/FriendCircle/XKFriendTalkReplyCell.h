/*******************************************************************************
 # File        : XKFriendTalkReplyCell.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/17
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import <UIKit/UIKit.h>
#import "XKFriendCircleHeader.h"

@interface XKFriendTalkReplyCell : UITableViewCell
@property(nonatomic, assign) BOOL shortCell;

/**视图*/
@property(nonatomic, strong) UIView *totalView;
/**indexPath*/
@property(nonatomic, strong) NSIndexPath *indexPath;

///**评论*/
//@property(nonatomic, copy) void(^commentClickBlock)(NSIndexPath *indexPath,FriendsCirclelCommentsItem *comment);
/**用户点击*/
@property(nonatomic, copy) void(^userClickBlock)(NSIndexPath *indexPath,NSString *userId);

/**model*/
@property(nonatomic, strong) XKFriendTalkModel *model;

@property(nonatomic, strong, readonly) FriendsCirclelCommentsItem *comment;

- (void)hideSperate:(BOOL)hide;
@end
