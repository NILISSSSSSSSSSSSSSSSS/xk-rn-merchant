//
//  XKStoreInStoreTableViewCell.h
//  XKSquare
//
//  Created by hupan on 2018/9/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ATShopsItem;

typedef void(^LookStoreButtonBlock)(NSString *shopId);

@interface XKStoreInStoreTableViewCell : UITableViewCell

@property (nonatomic, copy  ) LookStoreButtonBlock   lookStoreBlock;

- (void)setValueWithModel:(ATShopsItem *)model;
- (void)hiddenLineView:(BOOL)hidden;

@end
