//
//  XKSysMessageTableViewCell.h
//  XKSquare
//
//  Created by Lin Li on 2018/10/8.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKSysMessageModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef  void(^choseBtnBlock)(void);

@interface XKSysMessageTableViewCell : UITableViewCell
/**model*/
@property(nonatomic, strong) XKSysMessageModel *model;

@property(nonatomic, copy) choseBtnBlock block;

@property (nonatomic, strong)UIView      *myContentView;

@end

NS_ASSUME_NONNULL_END
