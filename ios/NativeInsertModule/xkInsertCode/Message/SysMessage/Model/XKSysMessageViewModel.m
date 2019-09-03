//
//  XKSysMessageViewModel.m
//  XKSquare
//
//  Created by Lin Li on 2018/10/8.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSysMessageViewModel.h"
#import "XKSysMessageTableViewCell.h"
#import "XKPersonalInformationViewController.h"


static NSString * const cellID  = @"cell";
@interface XKSysMessageViewModel()
@end

@implementation XKSysMessageViewModel

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:XKTabbarMessageSystemRedPointChangeNotification object:nil];
    }
    return self;
}
- (void)registerCellForTableView:(UITableView *)tableView {
    [tableView registerClass:[XKSysMessageTableViewCell class] forCellReuseIdentifier:cellID];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKSysMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.myContentView.xk_radius = 8;
    cell.myContentView.xk_openClip = YES;
    cell.model = self.dataArray[indexPath.row];
    if (indexPath.row == 0) {
        cell.myContentView.xk_clipType = XKCornerClipTypeTopBoth;
    }else if (indexPath.row == self.dataArray.count -1){
        cell.myContentView.xk_clipType = XKCornerClipTypeBottomBoth;
    }else{
        cell.myContentView.xk_clipType = XKCornerClipTypeNone;
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectBlock) {
        self.selectBlock(indexPath);
    }
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)loadNetWork {
    [HTTPClient postEncryptRequestWithURLString:@"im/ua/sysFictitiousUserList/1.0" timeoutInterval:20.0 parameters:@{} success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        self.dataArray = [[NSArray yy_modelArrayWithClass:[XKSysMessageModel class] json:responseObject]mutableCopy];
        [self tableViewReoadData];
    } failure:^(XKHttpErrror *error) {
        
    }];
}


- (void)viewModeldealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)tableViewReoadData {
    if (self.loadBlock) {
        self.loadBlock();
    }
}
/**
 请求列表数据
 */
- (void)refreshData {
    [self loadNetWork];
    [self tableViewReoadData];
}

@end
