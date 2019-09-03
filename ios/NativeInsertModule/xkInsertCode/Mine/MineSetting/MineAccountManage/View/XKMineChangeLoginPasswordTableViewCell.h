//
//  XKMineChangeLoginPasswordTableViewCell.h
//  XKSquare
//
//  Created by RyanYuan on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XKMineChangeLoginPasswordTableViewCellType) {
    XKMineChangeLoginPasswordTableViewCellTypeOldPassword = 0,
    XKMineChangeLoginPasswordTableViewCellTypeNewPassword,
    XKMineChangeLoginPasswordTableViewCellTypeEnsurePassword
};

@class XKMineChangeLoginPasswordTableViewCell;

@protocol XKMineChangeLoginPasswordTableViewCellDelegate <NSObject>

- (void)cell:(XKMineChangeLoginPasswordTableViewCell *)cell changePasswordWithString:(NSString *)password;

@end

@interface XKMineChangeLoginPasswordTableViewCell : UITableViewCell

@property (nonatomic, assign) XKMineChangeLoginPasswordTableViewCellType type;
@property (nonatomic, weak) id<XKMineChangeLoginPasswordTableViewCellDelegate> delegate;

- (void)configChangeLoginPasswordTableViewCell:(NSString *)password;
- (void)showCellSeparator;
- (void)hiddenCellSeparator;
- (void)clearInputTextField;

@end
