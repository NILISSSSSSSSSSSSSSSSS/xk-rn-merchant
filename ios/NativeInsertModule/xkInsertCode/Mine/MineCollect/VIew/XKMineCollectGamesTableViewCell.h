/*******************************************************************************
 # File        : XKMineCollectGamesTableViewCell.h
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
#import "XKCollectGamesModel.h"
typedef  void(^choseBtnBlock)(void);
typedef  void(^shareBtnBlock)(XKCollectGamesModelDataItem *model);

@interface XKMineCollectGamesTableViewCell : XKDeleteCell
@property (nonatomic, strong)UIButton    *shareButton;
@property (nonatomic, strong)XKCollectGamesModelDataItem    *model;

/**
 选择按钮block
 */
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
