/*******************************************************************************
 # File        : XKMineCollectShopTableViewCell.h
 # Project     : XKSquare
 # Author      : Lin Li
 # Created     : 2018/9/10
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
#import "XKDeleteCell.h"
#import "XKCollectShopModel.h"
typedef  void(^choseBtnBlock)(NSIndexPath *index,UIButton *sender);
typedef  void(^shareBtnBlock)(XKCollectShopModelDataItem *model);

@interface XKMineCollectShopTableViewCell : XKDeleteCell
@property (nonatomic, strong)UIButton    *shareButton;
@property (nonatomic, strong)XKCollectShopModelDataItem    *model;
/**选择按钮的block*/
@property(nonatomic, copy) choseBtnBlock block;
@property(nonatomic, copy) shareBtnBlock shareBlock;

@property (nonatomic, strong)NSIndexPath    *index;

/**
 进入管理模式
 */
- (void)updateLayout;

/**
 退出管理模式
 */
- (void)restoreLayout;

@property (nonatomic, assign)XKControllerType controllerType;


/**
 发送选择按钮block
 */
@property(nonatomic, copy) shareBtnBlock sendChoseblock;
@end
