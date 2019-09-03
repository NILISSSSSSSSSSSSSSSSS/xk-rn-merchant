//
//  XKMallApplyAfterSaleListViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallApplyAfterSaleListViewController.h"
#import "XKMallOrderListBottomView.h"
#import "XKMallApplyAfterSaleListCell.h"
#import "XKMallOrderApplyRefundTypeViewController.h"
#import "XKMallOrderDetailViewModel.h"
@interface XKMallApplyAfterSaleListViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *choseArr;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)XKMallOrderListBottomView *bottomView;
@property (nonatomic, strong)UIAlertController *cancelAlert;
@property (nonatomic, strong)XKCustomNavBar *navBar;

@end

@implementation XKMallApplyAfterSaleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)handleData {
    [super handleData];
    _page = 0;
    _choseArr = [NSMutableArray array];
}

- (void)addCustomSubviews {
    [self hideNavigation];
    XKWeakSelf(ws);
    _navBar =  [[XKCustomNavBar alloc] init];
    _navBar.leftButtonBlock = ^{
        [ws.navigationController popViewControllerAnimated:YES];
    };
    [_navBar customNaviBarWithTitle:@"申请售后" andRightButtonImageTitle:@""];
    [self.view addSubview:_navBar];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
}

#pragma mark 网络请求
- (void)requestWithTip:(BOOL)tip {
    if(tip) {
        [XKHudView showLoadingTo:self.view animated:YES];
    }
    _page ++;
}

#pragma mark tableview代理 数据源
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.clearHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.clearFooterView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _goodsArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKWeakSelf(ws);
    XKMallApplyAfterSaleListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMallApplyAfterSaleListCell" forIndexPath:indexPath];
    if (self.applyType == XKApplyEnterTypeDetail) {
        XKMallOrderDetailGoodsItem *obj = _goodsArr[indexPath.row];
        obj.index = indexPath;
        [cell bindDetailItem:obj];
        cell.choseBtnBlock = ^(UIButton *sender, NSIndexPath *index) {
            XKMallOrderDetailGoodsItem *obj = ws.goodsArr[index.row];
            obj.isChose = !obj.isChose;
            if (obj.isChose) {
                [ws.choseArr addObject:obj];
                if (ws.choseArr.count == ws.goodsArr.count) {
                    [ws.bottomView choseAll:YES];
                }
            } else {
                [ws.choseArr removeObject:obj];
                [ws.bottomView choseAll:NO];
            }
            [ws.tableView reloadData];
        };
    } else {
        MallOrderListObj *obj = _goodsArr[indexPath.row];
        obj.index = indexPath;
        [cell bindListItem:obj];
        cell.choseBtnBlock = ^(UIButton *sender, NSIndexPath *index) {
            MallOrderListObj *obj = ws.goodsArr[index.row];
            obj.isChose = !obj.isChose;
            if (obj.isChose) {
                [ws.choseArr addObject:obj];
                if (ws.choseArr.count == ws.goodsArr.count) {
                    [ws.bottomView choseAll:YES];
                }
            } else {
                [ws.choseArr removeObject:obj];
                [ws.bottomView choseAll:NO];
            }
            [ws.tableView reloadData];
        };
    }

    
    if(_goodsArr.count == 1) {
        [cell cutCornerForType:XKCornerCutTypeOnly WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 100)];
    } else {
        if(indexPath.row == 0) {
            [cell hiddenSeperateLine:NO];
            [cell cutCornerForType:XKCornerCutTypeFitst WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 100)];
        } else if(indexPath.row == _goodsArr.count - 1) {
             [cell hiddenSeperateLine:YES];
            [cell cutCornerForType:XKCornerCutTypeLast WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 100)];
        } else {
             [cell hiddenSeperateLine:NO];
            cell.layer.mask = nil;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

#pragma mark 懒加载
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, kIphoneXNavi(64), SCREEN_WIDTH - 20,  SCREEN_HEIGHT - kIphoneXNavi(64)  - 50 - kBottomSafeHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[XKMallApplyAfterSaleListCell class] forCellReuseIdentifier:@"XKMallApplyAfterSaleListCell"];
        XKWeakSelf(ws);
        MJRefreshNormalHeader *narmalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            ws.page = 0;
            [ws requestWithTip:NO];
        }];
        _tableView.mj_header = narmalHeader;
        
        MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [ws requestWithTip:NO];
        }];
        _tableView.mj_footer = foot;
        
    }
    return _tableView;
}

- (XKMallOrderListBottomView *)bottomView {
    if(!_bottomView) {
        XKWeakSelf(ws);
        _bottomView = [XKMallOrderListBottomView MallOrderListBottomViewWithType:MallOrderListBottomViewAfterSale];
        _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - kBottomSafeHeight - 50, SCREEN_WIDTH, 50 + kBottomSafeHeight);
        _bottomView.choseBlock  = ^(UIButton *sender) {
            [ws.choseArr removeAllObjects];
            sender.selected = !sender.selected;
            if (sender.selected) {
                for(MallOrderListObj *obj in ws.goodsArr) {
                    obj.isChose = YES;
                    
                }
                [ws.choseArr addObjectsFromArray:ws.goodsArr];
            } else {
                for(MallOrderListObj *obj in ws.goodsArr) {
                    obj.isChose = NO;
                }
            }
            [ws.tableView reloadData];
        };
        
        _bottomView.sureBtnBlock = ^(UIButton *sender) {
            [ws.choseArr removeAllObjects];
            XKMallOrderApplyRefundTypeViewController *refund =  [XKMallOrderApplyRefundTypeViewController new];
            for(MallOrderListObj *obj in ws.goodsArr) {
                if (obj.isChose) {
                    [ws.choseArr addObject:obj];
                }
            }
            refund.orderId =  ws.orderId;
            refund.goodsArr = [ws.choseArr copy];
            [ws.navigationController pushViewController:refund animated:YES];
        };
    }
    return _bottomView;
}

@end
