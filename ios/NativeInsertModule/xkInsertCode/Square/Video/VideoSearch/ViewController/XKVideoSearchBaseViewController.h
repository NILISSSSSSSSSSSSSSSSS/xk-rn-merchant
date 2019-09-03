//
//  XKVideoSearchBaseViewController.h
//  XKSquare
//
//  Created by xudehuai on 2018/10/14.
//  Copyright © 2018 xk. All rights reserved.
//

#import "BaseViewController.h"

@class XKCustomSearchBar;

NS_ASSUME_NONNULL_BEGIN

@interface XKVideoSearchBaseViewController : BaseViewController

@property (nonatomic, strong) XKCustomSearchBar *searchBar;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) XKEmptyPlaceView *tableViewEmptyView;

@end

NS_ASSUME_NONNULL_END
