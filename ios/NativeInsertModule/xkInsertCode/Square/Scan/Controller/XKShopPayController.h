/*******************************************************************************
 # File        : XKShopPayController.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/4
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


typedef NS_ENUM(NSInteger,ShopPayControllerType) {
    ShopPayControllerFixationType = 1,//固定额度
    ShopPayControllerUnfixationType = 2,//可变
};

@interface XKShopPayController : BaseViewController

/**标题*/
@property(nonatomic, copy) NSString *customTitle;

/**定额和不定额*/
@property(nonatomic, assign) ShopPayControllerType vcType;

/**金额*/
@property(nonatomic, copy) NSString *money;

/**店铺id*/
@property(nonatomic, copy) NSString *shopId;
@end
