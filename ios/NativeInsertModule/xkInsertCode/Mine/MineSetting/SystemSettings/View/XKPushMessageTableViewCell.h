//
//  XKPushMessageTableViewCell.h
//  XKSquare
//
//  Created by Lin Li on 2018/9/7.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^switchChangeBLock)(UISwitch *xkSwitch);
@interface XKPushMessageTableViewCell : UITableViewCell
@property (nonatomic, strong)UILabel  *titleLabel;
@property (nonatomic, strong)UILabel  *rightTitlelabel;
@property (nonatomic, strong)UISwitch *xkSwitch;
@property (nonatomic, copy)switchChangeBLock switchChangeBLock;

@end
