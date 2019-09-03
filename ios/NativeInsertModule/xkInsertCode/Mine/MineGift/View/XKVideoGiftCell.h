/*******************************************************************************
 # File        : XKVideoGiftCell.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/13
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
#import "XKFriendGiftCell.h"
#import "XKGoodsView.h"

@interface XKVideoGiftCell : XKFriendGiftCell
/***/
@property(nonatomic, strong) XKGoodsView *infoView;

/***/
@property(nonatomic, copy) void(^infoViewClick)(NSIndexPath *indexPath);
@end
