//
//  XKMallBottomDiscountTicketView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallBottomDiscountTicketView.h"
#import "XKDiscountTicketTableViewCell.h"

@interface XKMallBottomDiscountTicketView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)UIView *headerView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)NSString *titleStr;
@end

@implementation XKMallBottomDiscountTicketView

- (instancetype)initWithTicketArr:(NSArray *)ticketArr titleStr:(NSString *)title {
    self = [[XKMallBottomDiscountTicketView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 360 + kBottomSafeHeight)];
    if(self) {
        self.dataArr = ticketArr;
        self.titleStr = title;
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
        
    }
    return self;
}

- (void)addCustomSubviews {
    [self addSubview:self.tableView];
}

- (void)addUIConstraint {
    
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kBottomSafeHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = UIColorFromRGB(0xf0f0f0);
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKWeakSelf(ws);
    
    XKDiscountTicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKDiscountTicketTableViewCell" forIndexPath:indexPath];
    cell.index = indexPath;
    XKMallBuyCarItem *item = _dataArr[indexPath.row];
    cell.detailClickBlock = ^(UIButton *sender) {
        [ws.tableView reloadData];
    };
    cell.choseClickBlock = ^(UIButton *sender, NSIndexPath *index) {
         XKMallBuyCarItem *item = ws.dataArr[index.row];
        if (ws.choseBlock) {
            ws.choseBlock(item);
        };
    };
    
    [cell bindData:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
 
}
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        [_tableView registerClass:[XKDiscountTicketTableViewCell class] forCellReuseIdentifier:@"XKDiscountTicketTableViewCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIView *)headerView {
    if(!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _headerView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        [_headerView addSubview:self.titleLabel];
    }
    return _headerView;
}

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _titleLabel.text = self.titleStr;
        _titleLabel.textColor =  [UIColor blackColor];
        _titleLabel.font = XKRegularFont(17.f);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
