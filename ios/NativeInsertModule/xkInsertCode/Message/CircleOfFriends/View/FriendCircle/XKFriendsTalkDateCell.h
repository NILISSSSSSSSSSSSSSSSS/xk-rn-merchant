/*******************************************************************************
 # File        : XKFriendsTalkDateCell.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/18
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
#import "XKFriendTalkModel.h"
#import "XKFriendCircleHeader.h"

@interface XKFriendsTalkDateCell : UITableViewCell
/**内容视图*/
@property(nonatomic, strong) UIView *totoalView;
/**模式   0.点赞全部显示 1 点赞一行 */
@property(nonatomic, assign) NSInteger mode;
/**模式   内容是否有折叠状态 */
@property(nonatomic, assign) NSInteger contentExistFold;
/**indexPath*/
@property(nonatomic, strong) NSIndexPath *indexPath;
/**刷新block*/
@property(nonatomic, copy) void(^refreshBlock)(NSIndexPath *indexPath);
/**评论*/
@property(nonatomic, copy) void(^commentClickBlock)(NSIndexPath *indexPath,NSString *atUserName,NSString *userId);
/**点赞*/
@property(nonatomic, copy) void(^favorClickBlock)(NSIndexPath *indexPath);
/**礼物*/
@property(nonatomic, copy) void(^giftClickBlock)(NSIndexPath *indexPath);
/**用户点击*/
@property(nonatomic, copy) void(^userClickBlock)(NSIndexPath *indexPath,NSString *userId);

/**model*/
@property(nonatomic, strong) XKFriendTalkModel *model;

//+ (CGFloat)getFavorHeight:(XKFriendTalkModel *)model favorAttStr:(NSAttributedString **)favorAttStr;

@end
