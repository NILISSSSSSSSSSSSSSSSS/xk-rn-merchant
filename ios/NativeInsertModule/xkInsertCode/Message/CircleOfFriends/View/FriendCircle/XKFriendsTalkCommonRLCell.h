/*******************************************************************************
 # File        : XKFriendsTalkBaseCell.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/8/24
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

@interface XKFriendsTalkCommonRLCell : UITableViewCell <XKFriendTalkHeightCalculatePrococol>
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
@property(nonatomic, copy) void(^deleteClickBlock)(NSIndexPath *indexPath);

/**model*/
@property(nonatomic, strong) XKFriendTalkModel *model;


/**得到正常回答高度  以及是否可折叠 以及折叠展开后的高度 */
+ (CGFloat)getContentHeight:(XKFriendTalkModel *)model contentAtt:(NSAttributedString **)contentAtt isNeedFold:(BOOL *)needFold totalHeight:(CGFloat *)totalHeight;
+ (CGFloat)getFavorHeight:(XKFriendTalkModel *)model favorAttStr:(NSAttributedString **)favorAttStr;
//+ (CGFloat)getCommentHeight:(XKFriendTalkModel *)model commentAttStr:(NSAttributedString **)commentAttStr;

@end
