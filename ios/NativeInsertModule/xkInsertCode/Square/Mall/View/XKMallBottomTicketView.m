//
//  XKMallBottomTicketView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallBottomTicketView.h"
#import "XKBottomAlertSheetCell.h"
#import "XKMallBuyCarViewModel.h"
#import "XKTradingAreaOrderCouponModel.h"

@interface XKMallBottomTicketView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)UIView *headerView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)NSString *titleStr;
@end

@implementation XKMallBottomTicketView

- (instancetype)initWithTicketArr:(NSArray *)ticketArr titleStr:(NSString *)title {
    self = [[XKMallBottomTicketView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 4 * 50 + kBottomSafeHeight)];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
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
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKBottomAlertSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKBottomAlertSheetCell" forIndexPath:indexPath];
    if (self.viewType == TicketViewType_mall) {
        XKMallBuyCarItem *item = _dataArr[indexPath.row];
        cell.nameLabel.text =  item.state == 1 ? item.cardName : [NSString stringWithFormat:@"%@(优惠暂不可用)",item.cardName];
        cell.nameLabel.textAlignment = NSTextAlignmentLeft;
        cell.nameLabel.textColor = item.state == 1 ? UIColorFromRGB(0x222222) : UIColorFromRGB(0xcccccc);
        cell.nameLabel.font = XKRegularFont(14.f);
    } else if (self.viewType == TicketViewType_tradingArea) {
        XKTradingAreaOrderCouponModel *item = _dataArr[indexPath.row];
        cell.nameLabel.text = item.state == 1 ? item.cardName : [NSString stringWithFormat:@"%@(优惠暂不可用)",item.cardName];
        cell.nameLabel.textAlignment = NSTextAlignmentLeft;
        cell.nameLabel.textColor = item.state == 1 ? UIColorFromRGB(0x222222) : UIColorFromRGB(0xcccccc);
        cell.nameLabel.font = XKRegularFont(14.f);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.viewType == TicketViewType_mall) {
        if(self.choseBlock) {
            self.choseBlock(_dataArr[indexPath.row]);
        }
    } else if (self.viewType == TicketViewType_tradingArea) {
        XKTradingAreaOrderCouponModel *item = _dataArr[indexPath.row];
        if (item.state == 1) {//可用时才回调
            if(self.tradingAreaChoseBlock) {
                self.tradingAreaChoseBlock(_dataArr[indexPath.row]);
            }
        }
    }
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[XKBottomAlertSheetCell class] forCellReuseIdentifier:@"XKBottomAlertSheetCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIView *)headerView {
    if(!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _headerView.backgroundColor = [UIColor whiteColor];
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
