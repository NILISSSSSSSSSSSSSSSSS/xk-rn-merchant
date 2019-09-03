/*******************************************************************************
 # File        : XKMineCollectGoodsSingularTableViewCell.h
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
#import "XKDeleteCollectionViewCell.h"
#import "XKCollectGoodsModel.h"
typedef  void(^shareBtnBlock)(XKCollectGoodsDataItem *model);
typedef  void(^choseBtnBlock)(void);

@interface XKMineCollectGoodsSingularTableViewCell : XKDeleteCollectionViewCell
@property (nonatomic, strong)UIButton    *shareButton;
/**model*/
@property(nonatomic, strong) XKCollectGoodsDataItem *model;
@property(nonatomic, copy) choseBtnBlock block;
/**
 分享按钮block
 */
@property(nonatomic, copy) shareBtnBlock shareBlock;
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
