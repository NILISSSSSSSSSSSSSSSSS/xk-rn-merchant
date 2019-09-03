//
//  XKMineConfigureRecipientListViewController.h
//  XKSquare
//
//  Created by RyanYuan on 2018/8/27.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

@class XKMineConfigureRecipientItem;

@protocol ConfigureRecipientListDelegate <NSObject>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath item:(XKMineConfigureRecipientItem *)item;

@end

@interface XKMineConfigureRecipientListViewController : BaseViewController
    
@property (nonatomic, weak  ) id<ConfigureRecipientListDelegate> delegate;

@end
