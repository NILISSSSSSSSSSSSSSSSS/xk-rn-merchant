/*******************************************************************************
 # File        : XKMineCommentRootController.h
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

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger,XKMineCommentPageType) {
    XKMineCommentPageTypeGoods = 0 ,
    XKMineCommentPageTypeCircle ,
    XKMineCommentPageTypeVideo,
    XKMineCommentPageTypeWalfare,
};

@interface XKMineCommentRootController : BaseViewController

/**pageType 0 商品 1商圈 2小视频 3福利*/
@property(nonatomic, assign) XKMineCommentPageType pageType;
/**segmentIndex 0 回复我的 1我发的 */
@property(nonatomic, assign) NSInteger segmentIndex;

@end
