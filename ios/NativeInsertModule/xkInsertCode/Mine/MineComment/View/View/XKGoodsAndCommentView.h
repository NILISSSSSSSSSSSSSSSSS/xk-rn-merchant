/*******************************************************************************
 # File        : XKGoodsAndCommentView.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/11
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
#import "XKGoodsView.h"
@interface XKGoodsAndCommentView : UIView
/**评论view*/
@property(nonatomic, strong, readonly) UILabel *commentLabel;
/**信息视图*/
@property(nonatomic, strong, readonly) XKGoodsView *goodsView;
@end
