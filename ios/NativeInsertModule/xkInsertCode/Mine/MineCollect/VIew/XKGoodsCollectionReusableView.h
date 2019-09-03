/*******************************************************************************
 # File        : XKGoodsCollectionReusableView.h
 # Project     : XKSquare
 # Author      : Lin Li
 # Created     : 2018/9/27
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
#import "XKDropDownButton.h"

typedef void(^dropDownButtonBlock)(XKDropDownButton *dropDownButton);
typedef void(^layoutChangeBlock)(UIButton *button);

@interface XKGoodsCollectionReusableView : UICollectionReusableView

/**点击下拉菜单*/
@property(nonatomic, strong) XKDropDownButton *dropDownButton;
/**下拉菜单按钮回调*/
@property(nonatomic, copy) dropDownButtonBlock dropDownButtonBlock;
/**改变布局按钮回调*/
@property(nonatomic, copy) layoutChangeBlock layoutChangeBlock;
/**自营商城按钮回调*/
@property(nonatomic, copy) layoutChangeBlock autotrophyButtonBlock;
/**商圈按钮回调*/
@property(nonatomic, copy) layoutChangeBlock businessButtonBlock;
/**是否显示商品类型*/
- (void)setGoodsButtonHidden:(BOOL)hidden;

@property(nonatomic, strong) UIButton *layoutButton;

@end
