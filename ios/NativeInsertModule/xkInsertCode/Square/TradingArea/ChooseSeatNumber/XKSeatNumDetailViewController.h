//
//  XKSeatNumDetailViewController.h
//  XKSquare
//
//  Created by hupan on 2018/10/22.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^RefreshSetBlock)(void);

@interface XKSeatNumDetailViewController : BaseViewController

@property (nonatomic, copy  ) RefreshSetBlock refreshSetBlock;
@property (nonatomic, assign) BOOL            selected;
@property (nonatomic, copy  ) NSArray         *dataSource;


@end
