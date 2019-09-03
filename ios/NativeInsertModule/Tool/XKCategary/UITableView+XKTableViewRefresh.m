//
//  UITableView+XKTableViewRefresh.m
//  XKSquare
//
//  Created by hupan on 2018/10/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "UITableView+XKTableViewRefresh.h"

@implementation UITableView (XKTableViewRefresh)

- (void)stopRefreshing {
    [self.mj_footer endRefreshing];
    [self.mj_header endRefreshing];
}

@end
