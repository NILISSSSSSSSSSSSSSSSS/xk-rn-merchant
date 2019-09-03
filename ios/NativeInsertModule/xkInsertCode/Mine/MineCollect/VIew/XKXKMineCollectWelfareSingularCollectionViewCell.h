/*******************************************************************************
 # File        : XKXKMineCollectWelfareSingularCollectionViewCell.h
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
#import "XKCollectWelfareModel.h"
typedef  void(^choseBtnBlock)(void);
typedef  void(^shareBtnBlock)(XKCollectWelfareDataItem *model);

@interface XKXKMineCollectWelfareSingularCollectionViewCell : XKDeleteCollectionViewCell
@property (nonatomic, strong)UIButton    *shareButton;
/**model*/
@property(nonatomic, strong) XKCollectWelfareDataItem *model;
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
