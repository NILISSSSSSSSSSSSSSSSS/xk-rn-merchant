//
//  XKTradingAreaOrderRefundViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/27.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaOrderRefundViewController.h"
#import "XKTradingAreaOrderRefundTableViewCell.h"
#import "XKTradingAreaOrderRefundOtherReasonCell.h"
#import "XKSquareTradingAreaTool.h"
#import "XKTradingAreaOrderDetaiModel.h"

static NSString * const cellID             = @"CellID";
static NSString * const otherReasonCellID  = @"otherReasonCellID";

@interface XKTradingAreaOrderRefundViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView      *footerView;
@property (nonatomic, strong) UIButton    *footerButton;
@property (nonatomic, assign) NSInteger   index;
@property (nonatomic, copy  ) NSArray     *dataSource;
@property (nonatomic, copy  ) NSString    *reason;


@end


@implementation XKTradingAreaOrderRefundViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_RGB(0xf6f6f6);
    self.index = -1;
    [self configNavigationBar];
    [self configViews];
    self.dataSource = @[@"计划有变，没时间消费", @"选错了"];
}

#pragma mark - Events

- (void)footerBtnClicked:(UIButton *)sender {
    if (self.index <= 0 && self.reason.length == 0) {
        [XKHudView showInfoMessage:@"请选择或者填写理由！"];
        return;
    }
    NSString *str = @"";
    if (self.index - 1 < self.dataSource.count) {
        str = self.dataSource[self.index - 1];
    } else {
        str = self.reason;
    }
    
    if (self.type == OrderRefundType_cancelOrder) {
        [XKSquareTradingAreaTool tradingAreaCancelOrder:@{@"orderId":self.orderId ? self.orderId : @"",
                                                          @"cause":str
                                                          } success:^(XKTradingAreaCreatOderModel *model) {
                                                              //提交
                                                              [self backLastViewController];
                                                          } faile:^(XKHttpErrror *error) {
                                                          }];
    } else if (self.type == OrderRefundType_refundSeverOrHetol) {
        
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSMutableArray *muArr = [NSMutableArray array];
        for (OrderItems *items in self.orderItemsArr) {
            [muArr addObject:items.itemId];
        }
        [dic setObject:muArr forKey:@"itemIds"];

        if (self.orderItemsArr.count) {
            OrderItems *items = self.orderItemsArr[0];
            [dic setObject:items.orderId forKey:@"orderId"];
        }
        [dic setObject:str forKey:@"refundMessage"];
  
        [XKSquareTradingAreaTool tradingAreaCancelServiceOrder:dic success:^(NSInteger status) {
            //提交
            [self backLastViewController];
        } faile:^(XKHttpErrror *error) {
        }];
    } else if (self.type == OrderRefundType_cancelPurchase) {

        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSMutableArray *muArr = [NSMutableArray array];
        for (PurchasesItem *item in self.purchasesItemArr) {
            [muArr addObject:item.purchaseOrderId];
        }
        [dic setObject:muArr forKey:@"purchaseOrderIds"];
        [dic setObject:str forKey:@"reason"];
        [XKSquareTradingAreaTool tradingAreaCancelPurchaseOrder:dic success:^(NSInteger status) {
            //提交
            [self backLastViewController];
        } faile:^(XKHttpErrror *error) {
        }];
        
    } else if (self.type == OrderRefundType_refundPurchase) {

        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSMutableArray *muArr = [NSMutableArray array];
        for (PurchasesItem *item in self.purchasesItemArr) {
            [muArr addObject:item.purchaseOrderId];
        }
        [dic setObject:muArr forKey:@"purchaseOrderIds"];
        [dic setObject:str forKey:@"refundMessage"];
        if (self.purchasesItemArr.count) {
            PurchasesItem *item = self.purchasesItemArr[0];
            [dic setObject:item.itemId forKey:@"itemId"];
            [dic setObject:item.orderId forKey:@"orderId"];
        }
        [XKSquareTradingAreaTool tradingAreaRefundPurchaseOrder:dic success:^(NSInteger status) {
            //提交
            [self backLastViewController];
        } faile:^(XKHttpErrror *error) {
        }];
    }
}


- (void)backLastViewController {
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:NSClassFromString(@"XKTradingAreaOrderDetailViewController")]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
}

#pragma mark - Private Metheods

- (void)configNavigationBar {
    [self setNavTitle:@"申请理由" WithColor:[UIColor whiteColor]];
}

- (void)configViews {
    
    [self.footerView addSubview:self.footerButton];
    self.tableView.tableFooterView = self.footerView;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NavigationAndStatue_Height);
        make.left.right.bottom.equalTo(self.view);
    }];
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
}



#pragma mark - UITableViewDelegate, UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row != self.dataSource.count + 1) {
        XKTradingAreaOrderRefundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[XKTradingAreaOrderRefundTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row == 0) {
            [cell setNameLableText:@"选择退款原因" textColor:HEX_RGB(0x999999)];
            [cell setImageView:nil];
            cell.xk_openClip = YES;
            cell.xk_radius = 5;
            cell.xk_clipType = XKCornerClipTypeTopLeft | XKCornerClipTypeTopRight;
        } else {
            [cell setNameLableText:self.dataSource[indexPath.row - 1] textColor:HEX_RGB(0x222222)];
            [cell setImageView:indexPath.row == self.index ? @"xk_ic_contact_chose" : @"xk_ic_contact_nochose"];
        }
        return cell;
        
    } else {
        XKTradingAreaOrderRefundOtherReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:otherReasonCellID];
        if (!cell) {
            cell = [[XKTradingAreaOrderRefundOtherReasonCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:otherReasonCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            XKWeakSelf(weakSelf);
            cell.valueChangedBlock = ^(NSString *reson) {
                weakSelf.reason = reson;
                if (weakSelf.index != -1) {
                    weakSelf.index = -1;
                    [weakSelf.tableView reloadData];
                }
            };
        }
        cell.xk_openClip = YES;
        cell.xk_radius = 5;
        cell.xk_clipType = XKCornerClipTypeBottomLeft | XKCornerClipTypeBottomRight;
        [cell setNameLableText:@"其他原因" textColor:HEX_RGB(0x999999)];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.row != self.index) && indexPath.row != 0 && indexPath.row != self.dataSource.count + 1) {
        
        //在赋值前
        NSIndexPath *oldInxdexPath = [NSIndexPath indexPathForRow:self.index inSection:0];
        NSIndexPath *newInxdexPath = indexPath;
        //赋值
        self.index = indexPath.row;
        
        [self.tableView reloadRowsAtIndexPaths:@[oldInxdexPath, newInxdexPath] withRowAnimation:(UITableViewRowAnimationNone)];
    } else {
        self.index = -1;
        [self.tableView reloadData];
    }
}

#pragma mark - customDelegate


#pragma mark - costomBlock

#pragma mark - lazy load

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
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
        _footerButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 44)];
        _footerButton.backgroundColor = XKMainTypeColor;
        _footerButton.layer.masksToBounds = YES;
        _footerButton.layer.cornerRadius = 5;
        [_footerButton setTitle:@"提交申请" forState:UIControlStateNormal];
        _footerButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
        [_footerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_footerButton addTarget:self action:@selector(footerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerButton;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    }
    return _footerView;
}

@end
