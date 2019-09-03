/*******************************************************************************
 # File        : XKMineCollectRootViewController.h
 # Project     : XKSquare
 # Author      : Lin Li
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
@protocol CollectMethodProtocol <NSObject>
/**
 编辑模式
 */
- (void)updateEditLayout;

/**
 正常模式
 */
- (void)restoreLayout;

/**
 第一次请求，防止进来之后全部一起加载
 */
- (void)requestFirst;

/**
 是否是编辑模式
 */

- (BOOL)checkIsEdit;
@end
typedef void(^sendColloctionItemBlock)(NSMutableArray *array);
@interface XKMineCollectRootViewController : BaseViewController
@property (nonatomic, assign)XKControllerType controllerType;
/**发送按钮的回调（仅仅在XKMeassageCollectControllerType类型使用）*/
@property(nonatomic, copy) sendColloctionItemBlock sendColloctionItemBolck;
@end
