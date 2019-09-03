//
//  XKMallOrderApplyRefundTypeViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/11/6.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMallOrderApplyRefundTypeViewController.h"
#import "XKMallOrderApplyRefundCell.h"
#import "XKRefundProgressViewController.h"
#import "XKMallOrderApplyRefundViewController.h"
#import "XKMallOrderApplyRefundGoodsViewController.h"
@interface XKMallOrderApplyRefundTypeViewController ()<UITableViewDelegate, UITableViewDataSource>
/*导航栏*/
@property (nonatomic, strong)XKCustomNavBar *navBar;
@property (nonatomic, strong)UITableView *tableView;

@end

@implementation XKMallOrderApplyRefundTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark 默认加载方法
- (void)handleData {
    [super handleData];
}

- (void)addCustomSubviews {
    [self hideNavigation];
    XKWeakSelf(ws);
    _navBar =  [[XKCustomNavBar alloc] init];
    _navBar.leftButtonBlock = ^{
        [ws.navigationController popViewControllerAnimated:YES];
    };
    [_navBar customNaviBarWithTitle:@"售后申请" andRightButtonImageTitle:@""];
    [self.view addSubview:_navBar];
    [self.view addSubview:self.tableView];
}

#pragma mark delegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? _goodsArr.count : 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 100 : 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        XKMallOrderApplyRefundCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMallOrderApplyRefundCell" forIndexPath:indexPath];
        [cell handleOrderObj:_goodsArr[indexPath.row]];
        if (_goodsArr.count == 1) {
            [cell hiddenSeperateLine:YES];
            cell.xk_clipType = XKCornerClipTypeAllCorners;
        } else {
            if(indexPath.row == 0) {
                [cell hiddenSeperateLine:NO];
                cell.xk_clipType = XKCornerClipTypeTopBoth;
            } else if(indexPath.row == _goodsArr.count - 1) {
                [cell hiddenSeperateLine:YES];
                cell.xk_clipType = XKCornerClipTypeBottomBoth;
            } else {
                [cell hiddenSeperateLine:NO];
                cell.layer.mask = nil;
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = UIColorFromRGB(0x222222);
        cell.textLabel.font = XKRegularFont(14);
        cell.detailTextLabel.textColor = UIColorFromRGB(0x777777);
        cell.detailTextLabel.font = XKRegularFont(12);
        if (indexPath.row == 0) {
            cell.textLabel.text = @"仅退款";
            cell.detailTextLabel.text = @"未收到货(包含未签收)，与卖家协商同意前提下";
            [cell cutCornerForType:XKCornerCutTypeFitst WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 60)];
            
        } else {
            cell.textLabel.text = @"退货退款";
            cell.detailTextLabel.text = @"已收到货，需要退换已收到的货物";
            [cell cutCornerForType:XKCornerCutTypeLast WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 60)];
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.clearFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return  self.clearHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            XKMallOrderApplyRefundViewController *refund = [XKMallOrderApplyRefundViewController new];
            refund.refundType = indexPath.row == 0 ? @"REFUND" : @"REFUND_GOODS";
            refund.goodsArr = self.goodsArr;
            refund.orderId = self.orderId;
            [self.navigationController pushViewController:refund animated:YES];
        } else {
            XKMallOrderApplyRefundGoodsViewController   *refund = [XKMallOrderApplyRefundGoodsViewController new];
            refund.refundType = indexPath.row == 0 ? @"REFUND" : @"REFUND_GOODS";
            refund.goodsArr = self.goodsArr;
            refund.orderId = self.orderId;
            [self.navigationController pushViewController:refund animated:YES];
        }
    }

}

#pragma mark 懒加载
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, kIphoneXNavi(64), SCREEN_WIDTH - 20,SCREEN_HEIGHT - kIphoneXNavi(64) - kBottomSafeHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = XKSeparatorLineColor;
        [_tableView registerClass:[XKMallOrderApplyRefundCell class] forCellReuseIdentifier:@"XKMallOrderApplyRefundCell"];
        
    }
    return _tableView;
}

@end
