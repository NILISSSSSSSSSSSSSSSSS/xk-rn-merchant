/*******************************************************************************
 # File        : XKMineFansCell.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/14
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
#import "XKContactModel.h"

@interface XKMineFansCell : UITableViewCell

/**圆角类型*/
@property(nonatomic, assign) XKCornerClipType clipType;
/***/
@property(nonatomic, strong) NSIndexPath *indexPath;

/**<##>*/
@property(nonatomic, strong) XKContactModel *model;
- (void)setFocusModel:(XKContactModel *)model;
/**添加好友点击*/
@property(nonatomic, copy) void(^addClick)(NSIndexPath *indexPath);
/**关注点击*/
@property(nonatomic, copy) void(^focusClick)(NSIndexPath *indexPath);
@end
