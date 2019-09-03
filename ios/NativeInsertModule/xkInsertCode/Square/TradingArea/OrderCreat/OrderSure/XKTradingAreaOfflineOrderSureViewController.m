//
//  XKTradingAreaOfflineOrderSureViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaOfflineOrderSureViewController.h"
#import "XKOrderSureGoodsInfoHeaderView.h"
#import "XKOrderSureBookingNumTableViewCell.h"
#import "XKOderSureGoodsInfoCell.h"
#import "XKOderSureOrderInfoCell.h"
#import "XKOrderSureGoodsInfoFooterView.h"
#import "XKOrderSureChooseSeatNumViewController.h"
#import "XKTradingAreaOrderDetailViewController.h"

#import "XKTradingAreaGoodsInfoModel.h"
#import "XKTradingAreaSeatListModel.h"
#import "XKTradingAreaCreatOderModel.h"
#import "XKSquareTradingAreaTool.h"
#import "XKTradingAreaShopCarManager.h"

static NSString * const bookingNumCellID              = @"bookingNumCellID";
static NSString * const goodsInfoCellID               = @"goodsInfoCellID";
static NSString * const orderInfoCellID               = @"orderInfoCellID";

static NSString * const goodsInfoHeaderViewID   = @"goodsInfoHeaderView";
static NSString * const goodsInfoFooterViewID   = @"goodsInfoFooterView";


typedef enum : NSUInteger {
//    OrderCellType_seat,//座位
    OrderCellType_goodsInfo,//商品信息
    OrderCellType_orderInfo//订单信息
} OrderCellType;

@interface XKTradingAreaOfflineOrderSureViewController () <UITableViewDelegate, UITableViewDataSource/*, ChooseBookingNumDelegate*/>

@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic, strong) UIButton              *sureButton;
@property (nonatomic, copy  ) NSDictionary          *selectedMuDic;
@property (nonatomic, copy  ) NSString              *orderId;

//参数
@property (nonatomic, copy  ) NSString              *seatNames;
//@property (nonatomic, copy  ) NSString              *phoneNum;
@property (nonatomic, copy  ) NSString              *peopleNum;
@property (nonatomic, copy  ) NSString              *tipStr;
@property (nonatomic, assign) CGFloat               totalPrice;

@end

@implementation XKTradingAreaOfflineOrderSureViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_RGB(0xf6f6f6);
    
//    self.phoneNum = [XKUserInfo getCurrentUserRealPhoneNumber];
    self.peopleNum = @"1";
    
    for (NSArray *subArr in self.goodsArr) {
        if (subArr.count) {
            GoodsSkuVOListItem *item = subArr[0];
            self.totalPrice += subArr.count * item.discountPrice.floatValue;
        }
    }
    self.totalPrice = self.totalPrice / 100.0;
    [self configNavigationBar];
    [self configTableView];
}

#pragma mark - Events

- (void)sureBtnClicked {
    
    if (!self.selectedMuDic) {
        [XKAlertView showCommonAlertViewWithTitle:@"请选择席位"];
        return;
    }
    /*
     if (self.phoneNum.length == 0 || self.phoneNum.length != 11) {
         if (self.phoneNum.length == 0) {
             [XKAlertView showCommonAlertViewWithTitle:@"请填写联系手机号码"];
         } else {
             [XKAlertView showCommonAlertViewWithTitle:@"手机号码有误，请重新输入"];
         }
         return;
     }*/
    if (self.peopleNum.intValue < 1) {
        [XKAlertView showCommonAlertViewWithTitle:@"请选择人数"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSMutableArray *goodsMuarr = [NSMutableArray array];
    for (NSArray *subArr in self.goodsArr) {
        NSMutableDictionary *goodsDic = [NSMutableDictionary dictionary];
        if (subArr.count) {
            GoodsSkuVOListItem *item = subArr[0];
            [goodsDic setObject:item.goodsId forKey:@"goodsId"];
            [goodsDic setObject:item.skuCode forKey:@"goodsSkuCode"];
            [goodsDic setObject:@(subArr.count) forKey:@"goodsSum"];
        }
        [goodsMuarr addObject:goodsDic];
    }
    [dic setObject:goodsMuarr forKey:@"goodsParams"];
    if (self.tipStr.length) {
        [dic setObject:self.tipStr forKey:@"remark"];
    }
    /*[dic setObject:self.phoneNum forKey:@"subPhone"];*/
    [dic setObject:self.peopleNum forKey:@"consumerNum"];
    
//        [dic setObject:[XKTimeSeparateHelper backTimestampStringWithTimeString:self.reserveTime] forKey:@"appointRange"];
    
    NSArray *arr = self.selectedMuDic.allValues;
    NSMutableArray *seatArr = [NSMutableArray array];
    for (NSArray *subArr in arr) {
        for (XKTradingAreaSeatListModel *item in subArr) {
            NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
            [muDic setObject:item.seatId forKey:@"seatId"];
            [muDic setObject:item.name forKey:@"seatName"];
            [muDic setObject:item.seatTypeId forKey:@"seatCode"];
            [seatArr addObject:muDic];
        }
    }
    [dic setObject:seatArr forKey:@"seats"];
    
    [XKHudView showLoadingTo:self.tableView animated:YES];
    [XKSquareTradingAreaTool tradingAreaCreatOrder:@{@"orderCreate":dic}
                                           success:^(XKTradingAreaCreatOderModel *model) {
                                               [XKHudView hideHUDForView:self.tableView];
                                               self.orderId = model.orderId;
                                               //清空对应类型的购物车
                                               [[XKTradingAreaShopCarManager shareManager] clearnShopCarWithShopId:self.shopId industryType:XKIndustryType_offline];
                                               //订单详情
                                               XKTradingAreaOrderDetailViewController *vc = [[XKTradingAreaOrderDetailViewController alloc] init];
                                               vc.orderId = self.orderId;
                                               [self.navigationController pushViewController:vc animated:YES];
                                               
                                           } faile:^(XKHttpErrror *error) {
                                               [XKHudView hideHUDForView:self.tableView];
                                           }];
}

#pragma mark - Private Metheods

- (void)configNavigationBar {
    [self setNavTitle:@"确认订单" WithColor:[UIColor whiteColor]];
}



- (void)configTableView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [footerView addSubview:self.sureButton];
    self.tableView.tableFooterView = footerView;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(NavigationAndStatue_Height, 0, 0, 0));
    }];
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
}



#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return OrderCellType_orderInfo + 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    /*if (section == OrderCellType_seat) {
        return 1;
    } else*/ if (section == OrderCellType_goodsInfo) {
        return self.goodsArr.count;
    } else if (section == OrderCellType_orderInfo) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*if (indexPath.section == OrderCellType_seat) {
        XKOrderSureBookingNumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bookingNumCellID];
        if (!cell) {
            cell = [[XKOrderSureBookingNumTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:bookingNumCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.xk_openClip = YES;
            cell.xk_radius = 5;
            cell.xk_clipType = XKCornerClipTypeTopLeft | XKCornerClipTypeTopRight;
            cell.delegate = self;
        }
        [cell setValueWithSeatNames:self.seatNames];
        return cell;

    } else*/ if (indexPath.section == OrderCellType_goodsInfo) {

        XKOderSureGoodsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsInfoCellID];
        if (!cell) {
            cell = [[XKOderSureGoodsInfoCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:goodsInfoCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSArray *arr = self.goodsArr[indexPath.row];
        [cell setValueWithModel:arr.count ? arr[0] : nil num:arr.count];
        return cell;
        
    } else if (indexPath.section == OrderCellType_orderInfo) {
        
        XKOderSureOrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:orderInfoCellID];
        if (!cell) {
            cell = [[XKOderSureOrderInfoCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:orderInfoCellID];
            XKWeakSelf(weakSelf);
            cell.chooseBookingNum = ^{
                [weakSelf chooseBookNum];
            };
            cell.orderValueBlock = ^(NSString *seatName, NSString *peopleNum, NSString *tipStr, CGFloat totalPrice, BOOL refresh) {
                [weakSelf refreshOrderValue:seatName peopleNum:peopleNum tipStr:tipStr totalPrice:totalPrice refresh:refresh];
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.xk_openClip = YES;
            cell.xk_radius = 5;
            cell.xk_clipType = XKCornerClipTypeBottomLeft | XKCornerClipTypeBottomRight;
        }
        
        [cell setValueWithSeatName:self.seatNames peopleNum:self.peopleNum tipStr:self.tipStr totalPrice:self.totalPrice];
        return cell;
    }
    return nil;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == OrderCellType_goodsInfo) {
        return 50;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == OrderCellType_goodsInfo) {
        return 44;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == OrderCellType_goodsInfo) {
        XKOrderSureGoodsInfoHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:goodsInfoHeaderViewID];
        if (!sectionHeaderView) {
            sectionHeaderView = [[XKOrderSureGoodsInfoHeaderView alloc] initWithReuseIdentifier:goodsInfoHeaderViewID];
            sectionHeaderView.xk_openClip = YES;
            sectionHeaderView.xk_radius = 5;
            sectionHeaderView.xk_clipType = XKCornerClipTypeTopBoth;
        }
        [sectionHeaderView setTitleName:self.shopName];
        return sectionHeaderView;
    }
    return nil;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == OrderCellType_goodsInfo) {
        XKOrderSureGoodsInfoFooterView *sectionFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:goodsInfoFooterViewID];
        if (!sectionFooterView) {
            sectionFooterView = [[XKOrderSureGoodsInfoFooterView alloc] initWithReuseIdentifier:goodsInfoFooterViewID];
            [sectionFooterView hiddenLine1View:NO line2View:YES];
            [sectionFooterView setPriceValue:[NSString stringWithFormat:@"%.2f", self.totalPrice] totalPrice:@""];
        }
        
        return sectionFooterView;
    }
    return nil;
}

#pragma mark - customDelegate
/*
- (void)chooseBookingNumber:(NSString *)oldNumber {
    [self chooseBookingNum];
}*/

- (void)chooseBookNum {
    //选座位号
    XKOrderSureChooseSeatNumViewController *vc = [[XKOrderSureChooseSeatNumViewController alloc] init];
    vc.shopId = self.shopId;
    vc.maxSeat = 1;
    vc.selectedSetMuDic = self.selectedMuDic.mutableCopy;
    XKWeakSelf(weakSelf);
    vc.refreshBlock = ^(NSMutableDictionary *selectedMuDic) {
        [weakSelf resetData:selectedMuDic];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)resetData:(NSMutableDictionary *)selectedMuDic {
    self.selectedMuDic = selectedMuDic;
    
    NSArray *arr = self.selectedMuDic.allValues;
    NSMutableArray *nameArr = [NSMutableArray array];
    for (NSArray *subArr in arr) {
        for (XKTradingAreaSeatListModel *item in subArr) {
            [nameArr addObject:item.name];
        }
    }
    self.seatNames = [nameArr componentsJoinedByString:@","];
    [self.tableView reloadData];
}


#pragma mark - coustomBlock


- (void)refreshOrderValue:(NSString *)seatName peopleNum:(NSString *)peopleNum tipStr:(NSString *)tipStr totalPrice:(CGFloat)totalPrice refresh:(BOOL)refresh {
    
//    self.phoneNum = phoneNum;
    self.peopleNum = peopleNum;
    self.tipStr = tipStr;
    self.totalPrice = totalPrice;
    
    if (refresh) {
        [self.tableView reloadData];
    }
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

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 44)];
        _sureButton.backgroundColor = XKMainTypeColor;
        _sureButton.layer.masksToBounds = YES;
        _sureButton.layer.cornerRadius = 5;
        
        _sureButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
        [_sureButton setTitle:@"提交菜单" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [_sureButton addTarget:self action:@selector(sureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}


@end
