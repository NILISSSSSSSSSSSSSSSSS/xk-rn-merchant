//
//  XKMessageSysAndPraiseViewModel.m
//  XKSquare
//
//  Created by Lin Li on 2018/11/19.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMessageSysAndPraiseViewModel.h"
#import "XKMessageSysAndPraiseCell.h"
#import "XKSysDetailMessageModel.h"

static NSString * const cellID  = @"cell";

@interface XKMessageSysAndPraiseViewModel ()

@end

@implementation XKMessageSysAndPraiseViewModel

- (void)registerCellForTableView:(UITableView *)tableView {
    [tableView registerClass:[XKMessageSysAndPraiseCell class] forCellReuseIdentifier:cellID];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKSysDetailMessageModelDataItem *model = self.dataArray[indexPath.row];
    XKMessageSysAndPraiseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.model = model;
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
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

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
    }];
    return @[deleteAction];
}
@end
