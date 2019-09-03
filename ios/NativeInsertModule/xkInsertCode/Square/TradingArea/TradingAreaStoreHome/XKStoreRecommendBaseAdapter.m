//
//  XKStoreRecommendBaseAdapter.m
//  XKSquare
//
//  Created by hupan on 2018/8/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKStoreRecommendBaseAdapter.h"
#import "XKStoreSectionHeaderView.h"
#import "XKSubscriptionFooterView.h"


static NSString * const sectionHeaderViewID     = @"sectionHeaderView";
static NSString * const sectionFooterViewID     = @"sectionFooterView";

@implementation XKStoreRecommendBaseAdapter

#pragma mark - UITableViewDelegate & UITableViewDataSoure


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section ? 15 : 10;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    XKStoreSectionHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionHeaderViewID];
    if (!sectionHeaderView) {
        sectionHeaderView = [[XKStoreSectionHeaderView alloc] initWithReuseIdentifier:sectionHeaderViewID];
    }
    [sectionHeaderView hiddenLineView:YES];
    [sectionHeaderView setTitleName:@"测试" titleColor:HEX_RGB(0x222222) titleFont:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:16]];
    return sectionHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section) {
        XKSubscriptionFooterView *sectionFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionFooterViewID];
        if (!sectionFooterView) {
            sectionFooterView = [[XKSubscriptionFooterView alloc] initWithReuseIdentifier:sectionFooterViewID];
        }
        return sectionFooterView;
    }
    return nil;
}




@end
