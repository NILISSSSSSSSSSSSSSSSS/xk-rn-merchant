//
//  XKMineConfigureRecipientEditViewController.h
//  XKSquare
//
//  Created by RyanYuan on 2018/8/27.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, XKMineConfigureRecipientEditViewControllerState) {
    XKMineConfigureRecipientEditViewControllerStateEdit = 0,    /**< 编辑地址 */
    XKMineConfigureRecipientEditViewControllerStateCreat        /**< 新建地址 */
};

@class XKMineConfigureRecipientItem;
@class XKMineConfigureRecipientEditViewController;

@protocol XKMineConfigureRecipientEditViewControllerDelegate <NSObject>

- (void)viewController:(XKMineConfigureRecipientEditViewController *)viewController didDeletedRecipientItem:(XKMineConfigureRecipientItem *)recipientItem;
- (void)viewController:(XKMineConfigureRecipientEditViewController *)viewController creatNewRecipientItem:(XKMineConfigureRecipientItem *)recipientItem;

@end


@interface XKMineConfigureRecipientEditViewController : BaseViewController

@property (nonatomic, weak) id<XKMineConfigureRecipientEditViewControllerDelegate> delegate;
@property (nonatomic, assign) XKMineConfigureRecipientEditViewControllerState state;
@property (nonatomic, strong) XKMineConfigureRecipientItem *recipientItem;
@property (nonatomic, assign) BOOL isForceDefault;

@end
