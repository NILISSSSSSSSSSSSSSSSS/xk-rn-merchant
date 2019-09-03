//
//  XKMyProductionViewController.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/22.
//  Copyright © 2018 xk. All rights reserved.
//

#import "BaseViewController.h"

@class XKVideoDisplayVideoListItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface XKMyProductionViewController : BaseViewController

@property (nonatomic, copy) void(^sendProductionsBlock)(NSArray <XKVideoDisplayVideoListItemModel *>*productions);

@end

NS_ASSUME_NONNULL_END
