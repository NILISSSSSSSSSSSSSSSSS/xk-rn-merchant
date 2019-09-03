/*******************************************************************************
 # File        : XKGoodsAllCommentController.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/18
 # Corporation : 水木科技
 # Description :
 自营商城
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "BaseViewController.h"
#import "XKGoodsAllCommentViewModel.h"


@interface XKGoodsAllCommentController : BaseViewController

/**自营还是福利*/
@property(nonatomic, assign) XKAllCommentType type;
/**商品id*/
@property(nonatomic, copy) NSString *goodsId;

@end
