/*******************************************************************************
 # File        : XKFriendTalkContentView.h
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

@interface XKFriendTalkContentView : UIView

- (instancetype)initWithWidth:(CGFloat)width;
/**model*/
@property(nonatomic, strong) XKFriendTalkModel *model;
/**indexPath*/
@property(nonatomic, strong) NSIndexPath *indexPath;

@property(nonatomic, copy) void(^refreshBlock)(NSIndexPath *indexPath);
/**模式   内容是否有折叠状态 */
@property(nonatomic, assign) NSInteger contentNeedFold;

@end
