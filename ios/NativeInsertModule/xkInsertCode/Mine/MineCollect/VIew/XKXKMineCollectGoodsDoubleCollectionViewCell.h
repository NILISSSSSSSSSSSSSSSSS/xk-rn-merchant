/*******************************************************************************
 # File        : XKXKMineCollectGoodsDoubleCollectionViewCell.h
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
#import "XKCollectGoodsModel.h"
typedef  void(^choseBtnBlock)(void);
typedef  void(^shareBtnBlock)(XKCollectGoodsDataItem *model);

@interface XKXKMineCollectGoodsDoubleCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)UIButton    *shareButton;
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
@end
