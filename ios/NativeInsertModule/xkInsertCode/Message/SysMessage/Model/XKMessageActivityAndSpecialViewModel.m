//
//  XKMessageActivityAndSpecialViewModel.m
//  XKSquare
//
//  Created by Lin Li on 2018/11/20.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMessageActivityAndSpecialViewModel.h"
#import "XKMessageActivityAndSpecialCell.h"

static NSString * const cellID  = @"cell";

@interface XKMessageActivityAndSpecialViewModel ()

@end
@implementation XKMessageActivityAndSpecialViewModel

- (void)registerCellForTableView:(UITableView *)tableView {
    [tableView registerClass:[XKMessageActivityAndSpecialCell class] forCellReuseIdentifier:cellID];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKWeakSelf(ws);
    XKMessageActivityAndSpecialCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.delBlock = ^{
        
    };
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.dataArray.count;
    return 5;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 213;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectBlock) {
        self.selectBlock(indexPath);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]init];
}
@end
