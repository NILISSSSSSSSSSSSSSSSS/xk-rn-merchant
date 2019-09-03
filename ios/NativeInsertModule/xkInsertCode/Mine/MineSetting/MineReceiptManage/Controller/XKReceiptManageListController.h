/*******************************************************************************
 # File        : XKReceiptManageListController.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/7
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
#import "XKReceiptInfoModel.h"

typedef NS_ENUM(NSInteger,XKReceiptManageListUseType) {
    XKReceiptManageListUseTypeNoraml = 0 ,// 普通
    XKReceiptManageListUseTypeSelect  //选择
};

@interface XKReceiptManageListController : BaseViewController

@property(nonatomic, assign) XKReceiptManageListUseType useType;

@property(nonatomic, copy) void(^chooseBlock)(NSArray<XKReceiptInfoModel *>*receipts);

@end
