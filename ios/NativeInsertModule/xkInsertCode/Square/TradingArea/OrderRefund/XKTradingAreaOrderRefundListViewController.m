//
//  XKTradingAreaOrderRefundListViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/27.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaOrderRefundListViewController.h"
#import "XKTradingAreaOrderSeviceRefundCell.h"
#import "XKOrderSureGoodsInfoFooterView.h"
#import "XKTradingAreaAddGoodsListViewController.h"
#import "XKTradingAreaOrderRefundViewController.h"
#import "XKTradingAreaOrderDetaiModel.h"

static NSString * const CellID               = @"CellID";
static NSString * const footerViewID         = @"footerViewID";


@interface XKTradingAreaOrderRefundListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView                 *tableView;
@property (nonatomic, strong) UIButton                    *allChooseBtn;
@property (nonatomic, strong) UIButton                    *footerButton;

@end


@implementation XKTradingAreaOrderRefundListViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_RGB(0xf6f6f6);
    [self configNavigationBar];
    [self configViews];
}

#pragma mark - Events

- (void)footerBtnClicked:(UIButton *)sender {
    NSMutableArray *muArr = [NSMutableArray array];
    for (OrderItems *items in self.arr) {
        if (items.isSelected) {
            [muArr addObject:items];
        }
    }
    if (muArr.count == 0) {
        [XKHudView showErrorMessage:@"您暂未选择！"];
        return;
    }
    XKTradingAreaOrderRefundViewController *VC = [[XKTradingAreaOrderRefundViewController alloc] init];
    VC.type = OrderRefundType_refundSeverOrHetol;
    VC.orderItemsArr = muArr.copy;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)allChooseButtonClicked:(UIButton *)sender {
    
    NSMutableArray *muArr = [NSMutableArray array];
    for (OrderItems *items in self.arr) {
        items.isSelected = YES;
        [muArr addObject:items];
    }
    self.arr = muArr.copy;
    [self.tableView reloadData];
}


#pragma mark - Private Metheods

- (void)configNavigationBar {
    [self setNavTitle:@"选择服务" WithColor:[UIColor whiteColor]];
    [self setNaviCustomView:self.allChooseBtn withframe:CGRectMake(SCREEN_WIDTH - 45, 0, 40, 40)];

}

- (void)configViews {
    
 
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerButton];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NavigationAndStatue_Height);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.footerButton.mas_top);
    }];
    [self.footerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@50);
        make.bottom.equalTo(self.view);
    }];
}



#pragma mark - UITableViewDelegate, UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    XKTradingAreaOrderSeviceRefundCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[XKTradingAreaOrderSeviceRefundCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    XKWeakSelf(weakSelf);
    cell.lookDetailBlock = ^{
        [weakSelf lookDetailClicked:indexPath.row];
    };
    [cell setValueWithModel:self.arr[indexPath.row] shopName:self.shopName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderItems *items = self.arr[indexPath.row];
    items.isSelected = !items.isSelected;
    
    NSMutableArray *muArr = [NSMutableArray arrayWithArray:self.arr];
    [muArr replaceObjectAtIndex:indexPath.row withObject:items];
    self.arr = muArr.copy;
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(25, 20, SCREEN_WIDTH - 50, 60)];
    lable.font = XKRegularFont(16);
    lable.numberOfLines = 0;
    [lable rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.paragraphStyle.alignment(NSTextAlignmentLeft).lineSpacing(10);
        confer.text(@"温馨提示：").textColor(HEX_RGB(0xee6161));
        confer.text(@"\n");
        confer.text(@"服务退款，相关席位已加购的商品会做退款处理").textColor(HEX_RGB(0x222222));
    }];
    [view addSubview:lable];
    
    return view;
}


#pragma mark - customDelegate


#pragma mark - costomBlock

- (void)lookDetailClicked:(NSInteger)index {
    
    XKTradingAreaAddGoodsListViewController *vc = [[XKTradingAreaAddGoodsListViewController alloc] init];
    vc.listType = GoodsListType_lookGoods;
    OrderItems *items = self.arr[index];
    vc.seatName = items.seatName;
    vc.goodsArr = items.purchases;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - lazy load

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
        _tableView.backgroundColor = HEX_RGB(0xf6f6f6);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 200;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


- (UIButton *)footerButton {
    if (!_footerButton) {
        _footerButton = [[UIButton alloc] init];
        _footerButton.backgroundColor = XKMainTypeColor;
        [_footerButton setTitle:@"确定" forState:UIControlStateNormal];
        _footerButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
        [_footerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_footerButton addTarget:self action:@selector(footerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerButton;
}


- (UIButton *)allChooseBtn {
    if (!_allChooseBtn) {
        _allChooseBtn = [[UIButton alloc] init];
        [_allChooseBtn addTarget:self action:@selector(allChooseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_allChooseBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_allChooseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _allChooseBtn;
}

@end
