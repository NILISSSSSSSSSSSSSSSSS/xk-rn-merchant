/*******************************************************************************
 # File        : XKOrderEvaluationController.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/5
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
#import "XKMallOrderDetailViewModel.h"
#import "XKBusinessAreaOrderListModel.h"
#import "XKMallOrderViewModel.h"
typedef NS_ENUM(NSInteger,XKEvaluationType) {
    XKEvaluationTypeArea = 0,
    XKEvaluationTypeMallList,
    XKEvaluationTypeMallDetail
};
@interface XKOrderEvaluationController : BaseViewController
@property (nonatomic, assign) XKEvaluationType  evaluationType;
/**
 自营详情传入
 */
@property (nonatomic, strong) XKMallOrderDetailViewModel  *item;

/**
 自营列表传入
 */
@property (nonatomic, strong) MallOrderListDataItem  *listItem;

/**
 商圈
 */
@property (nonatomic, strong) AreaOrderListModel  *model;
@end
