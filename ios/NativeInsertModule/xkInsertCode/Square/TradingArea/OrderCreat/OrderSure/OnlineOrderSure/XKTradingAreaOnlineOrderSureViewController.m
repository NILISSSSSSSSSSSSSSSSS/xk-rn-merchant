//
//  XKTradingAreaOnlineOrderSureViewController.m
//  XKSquare
//
//  Created by hupan on 2018/10/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaOnlineOrderSureViewController.h"
#import "XKStoreSectionHeaderView.h"
#import "XKOderSureGoodsInfoCell.h"
#import "XKOnlineOderSureTipCell.h"
#import "XKOnlineOderSureChooseWayCell.h"
#import "XKOnlineOrderSureGoodsInfoFooterView.h"
#import "XKOnlineOrderSureGoodsInfoFooterView2.h"
#import "XKTradingAreaOrderDetailViewController.h"
#import "XKMineConfigureRecipientListViewController.h"
#import "XKTradingAreaOnlineChooseTimeView.h"
#import "XKCommonSheetView.h"
#import "XKSquareTradingAreaTool.h"
#import "XKTradingAreaShopInfoModel.h"
#import "XKTradingAreaGoodsInfoModel.h"
#import "XKTradingAreaCreatOderModel.h"
#import "XKMineConfigureRecipientListModel.h"
#import "XKTradingAreaShopCarManager.h"


static NSString * const chooseWayCellID              = @"chooseWayCell";
static NSString * const goodsInfoCellID              = @"goodsInfoCell";
static NSString * const auxiliaryInfoCellID          = @"auxiliaryInfoCell";

static NSString * const goodsInfoHeaderViewID   = @"goodsInfoHeaderView";
static NSString * const goodsInfoFooterViewID   = @"goodsInfoFooterView";
static NSString * const goodsInfoFooterViewID2  = @"goodsInfoFooterView2";


typedef enum : NSUInteger {
    OrderCellType_chooseWay,    //选择方式
    OrderCellType_goodsInfo,    //商品信息
    OrderCellType_auxiliaryInfo //附属信息
} OrderCellType;

@interface XKTradingAreaOnlineOrderSureViewController () <UITableViewDelegate, UITableViewDataSource, ConfigureRecipientListDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton    *sureButton;
@property (nonatomic, assign) NSInteger   wayType;//0 送货上门   1 到店自取
@property (nonatomic, copy  ) NSString    *orderId;



@property (nonatomic, strong) XKCommonSheetView                 *commonSheetView;
@property (nonatomic, strong) XKTradingAreaOnlineChooseTimeView *chooseTimeView;


//自提
@property (nonatomic, copy  ) NSString  *shopAddr;
@property (nonatomic, copy  ) NSString  *shopPhone;


//送货上门
@property (nonatomic, copy  ) NSString   *sendAddress;
@property (nonatomic, copy  ) NSString   *sendAddrId;


//公用
@property (nonatomic, copy  ) NSString   *yuyueTime;
@property (nonatomic, copy  ) NSString   *tipStr;
@property (nonatomic, copy  ) NSString   *phoneNum;
@property (nonatomic, assign) CGFloat    totalPrice;
@property (nonatomic, assign) CGFloat    payPrice;


@end

@implementation XKTradingAreaOnlineOrderSureViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = XKSeparatorLineColor;
    self.phoneNum = [XKUserInfo getCurrentUserRealPhoneNumber];
    for (NSArray *subArr in self.goodsArr) {
        if (subArr.count) {
            GoodsSkuVOListItem *item = subArr[0];
            self.totalPrice += subArr.count * item.discountPrice.floatValue;
        }
    }
    self.totalPrice = self.totalPrice / 100.0;
    self.payPrice = self.totalPrice;
    
    [self configNavigationBar];
    [self configTableView];
    [self requsetShopInfo];
}

- (void)requsetShopInfo {
    
    [XKSquareTradingAreaTool tradingAreaShopInfo:@{@"shopId":self.shopId ? self.shopId : @"",
                                                   @"lng":@(0),
                                                   @"lat":@(0)}
                                           group:nil
                                         success:^(XKTradingAreaShopInfoModel *model) {
                                             self.shopAddr = model.distance;
                                             if (model.mShop.contactPhones.count) {
                                                 self.shopPhone = model.mShop.contactPhones.firstObject;
                                             } else {
                                                 self.shopPhone = @"暂无";
                                             }
                                             [self.tableView reloadData];
                                         } faile:^(XKHttpErrror *error) {
                                             
                                         }];
    
}

#pragma mark - Events

- (void)sureBtnClicked {

    if (self.wayType == 0) {//送货上门
        if (self.sendAddress.length == 0) {
            [XKAlertView showCommonAlertViewWithTitle:@"请选择配送地址"];
            return;
        }
    } else {//自提
       //不处理
    }
    
    if (self.yuyueTime.length == 0) {
        [XKAlertView showCommonAlertViewWithTitle:@"请选择预约时间"];
        return;
    }

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //商品
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
    
    //地址
    NSMutableDictionary *addDic = [NSMutableDictionary dictionary];
    if (self.wayType == 0) {
        [addDic setObject:@"user" forKey:@"userType"];
    } else {
        [addDic setObject:@"muser" forKey:@"userType"];
    }
    if (self.sendAddrId) {
        [addDic setObject:self.sendAddrId forKey:@"addressId"];
    }
    [dic setObject:addDic forKey:@"address"];
    
    //时间
    NSArray *timeArr = [self.yuyueTime componentsSeparatedByString:@" "];
    if (timeArr.count == 2) {
        NSString *str1 = timeArr.firstObject;
        NSString *str2 = timeArr.lastObject;
        if (str1.length == 7) {
            str1 = [str1 substringFromIndex:2];
        }
        NSArray *timA = [str2 componentsSeparatedByString:@"-"];
        if (timA.count == 2) {
            NSString *startStr = [NSString stringWithFormat:@"%@-%@ %@:00", [XKTimeSeparateHelper backYearStringWithDate:[NSDate date]], str1, timA.firstObject];
            NSString *endStr = [NSString stringWithFormat:@"%@-%@ %@:00", [XKTimeSeparateHelper backYearStringWithDate:[NSDate date]], str1, timA.lastObject];
            NSString *startTimestamp = [XKTimeSeparateHelper backTimestampStringWithTimeString:startStr];
            NSString *endTimestamp = [XKTimeSeparateHelper backTimestampStringWithTimeString:endStr];
            [dic setObject:[NSString stringWithFormat:@"%@-%@", startTimestamp, endTimestamp] forKey:@"appointRange"];
        }
    }
    
    [XKHudView showLoadingTo:self.tableView animated:YES];
    [XKSquareTradingAreaTool tradingAreaCreatOrder:@{@"orderCreate":dic}
                                           success:^(XKTradingAreaCreatOderModel *model) {
                                               [XKHudView hideHUDForView:self.tableView];
                                               self.orderId = model.orderId;
                                               //清空对应类型的购物车
                                               [[XKTradingAreaShopCarManager shareManager] clearnShopCarWithShopId:self.shopId industryType:XKIndustryType_online];
                                               
                                               XKTradingAreaOrderDetailViewController *vc = [[XKTradingAreaOrderDetailViewController alloc] init];
                                               vc.orderId = self.orderId;
                                               [self.navigationController pushViewController:vc animated:YES];
                                               
                                           } faile:^(XKHttpErrror *error) {
                                               [XKHudView hideHUDForView:self.tableView];
                                               
                                           }];
}


#pragma mark - Private Metheods

- (void)configNavigationBar {
    [self setNavTitle:@"预定" WithColor:[UIColor whiteColor]];
}

- (void)configTableView {
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 74)];
    [footerView addSubview:self.sureButton];
    self.tableView.tableFooterView = footerView;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(NavigationAndStatue_Height, 0, 0, 0));
    }];
}



#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.wayType) {
        return 3;
    }
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == OrderCellType_chooseWay) {
        return 1;
    } else if (section == OrderCellType_goodsInfo) {
        return self.goodsArr.count;
    } else if (section == OrderCellType_auxiliaryInfo) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == OrderCellType_chooseWay) {
        
        XKOnlineOderSureChooseWayCell *cell = [tableView dequeueReusableCellWithIdentifier:chooseWayCellID];
        if (!cell) {
            cell = [[XKOnlineOderSureChooseWayCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:chooseWayCellID];
            XKWeakSelf(weakSelf);
            cell.wayChooseBlock = ^(NSInteger wayType, NSString *address, NSString *phoneNumber, NSString *time) {
                weakSelf.wayType = wayType;
                [weakSelf changeWayButtonClicked];
            };
            cell.chooseAddressBlock = ^{
                [weakSelf chooseAddressButtonClicked];
            };
            cell.chooseTimeBlock = ^{
                [weakSelf chooseTimeButtonClicked];
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.xk_openClip = YES;
            cell.xk_radius = 5;
            cell.xk_clipType = XKCornerClipTypeAllCorners;
        }
        [cell setValueWithSendAddr:self.sendAddress yuyueTime:self.yuyueTime shopAddr:self.shopAddr shopPhone:self.shopPhone];
        return cell;

    } else if (indexPath.section == OrderCellType_goodsInfo) {

        XKOderSureGoodsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsInfoCellID];
        if (!cell) {
            cell = [[XKOderSureGoodsInfoCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:goodsInfoCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSArray *arr = self.goodsArr[indexPath.row];
        [cell setValueWithModel:arr.count ? arr[0] : nil num:arr.count];
        return cell;
        
    } else if (indexPath.section == OrderCellType_auxiliaryInfo) {
        
        XKOnlineOderSureTipCell *cell = [tableView dequeueReusableCellWithIdentifier:auxiliaryInfoCellID];
        if (!cell) {
            cell = [[XKOnlineOderSureTipCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:auxiliaryInfoCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            XKWeakSelf(weakSelf);
            cell.orderValueBlock = ^(NSString *phoneNum, NSString *tipStr, BOOL refresh) {
                [weakSelf orderValueRefresh:phoneNum tipStr:tipStr refresh:refresh];
            };
        }
        [cell setValueWithPhoneNum:self.phoneNum tipStr:self.tipStr];
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
        if (self.wayType) {
            return 96;
        } else {
            return 216;
        }
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == OrderCellType_goodsInfo) {
        
        XKStoreSectionHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:goodsInfoHeaderViewID];
        if (!sectionHeaderView) {
            sectionHeaderView = [[XKStoreSectionHeaderView alloc] initWithReuseIdentifier:goodsInfoHeaderViewID];
            sectionHeaderView.backView.xk_openClip = YES;
            sectionHeaderView.backView.xk_radius = 5;
            sectionHeaderView.backView.xk_clipType = XKCornerClipTypeTopLeft | XKCornerClipTypeTopRight;
        }
        NSString *titleName = self.shopName;
        [sectionHeaderView setTitleName:titleName titleColor:HEX_RGB(0x777777) titleFont:XKRegularFont(14)];
        return sectionHeaderView;
    }
    return nil;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == OrderCellType_goodsInfo) {
        if (self.wayType) {
            XKOnlineOrderSureGoodsInfoFooterView2 *sectionFooterView2 = [tableView dequeueReusableHeaderFooterViewWithIdentifier:goodsInfoFooterViewID2];
            if (!sectionFooterView2) {
                sectionFooterView2 = [[XKOnlineOrderSureGoodsInfoFooterView2 alloc] initWithReuseIdentifier:goodsInfoFooterViewID2];
                sectionFooterView2.xk_openClip = YES;
                sectionFooterView2.xk_radius = 5;
                sectionFooterView2.xk_clipType = XKCornerClipTypeBottomLeft | XKCornerClipTypeBottomRight;
            }
            [sectionFooterView2 setValueWithTotalPrice:self.totalPrice payPrice:self.payPrice];
            return sectionFooterView2;
            
        } else {
            XKOnlineOrderSureGoodsInfoFooterView *sectionFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:goodsInfoFooterViewID];
            if (!sectionFooterView) {
                sectionFooterView = [[XKOnlineOrderSureGoodsInfoFooterView alloc] initWithReuseIdentifier:goodsInfoFooterViewID];
                sectionFooterView.xk_openClip = YES;
                sectionFooterView.xk_radius = 5;
                sectionFooterView.xk_clipType = XKCornerClipTypeBottomLeft | XKCornerClipTypeBottomRight;
                XKWeakSelf(weakSelf);
                sectionFooterView.tipStrBlock = ^(NSString *tipStr) {
                    weakSelf.tipStr = tipStr;
                };
            }
            [sectionFooterView setValueWithTotalPrice:self.totalPrice payPrice:self.payPrice yunFei:5 tipStr:self.tipStr];
            
            return sectionFooterView;
        }
    }
    return nil;
}

#pragma mark - customDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath item:(XKMineConfigureRecipientItem *)item {
//    NSLog(@"%@", item);
    self.sendAddress = [NSString stringWithFormat:@"%@ %@ %@ %@", item.provinceName, item.cityName, item.districtName, item.street];
    self.sendAddrId = item.ID;
    [self.tableView reloadData];
}

#pragma mark - coustomBlock

- (void)chooseAddressButtonClicked {
    
    XKMineConfigureRecipientListViewController *vc = [[XKMineConfigureRecipientListViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)chooseTimeButtonClicked {
    [self.commonSheetView show];
}

- (void)changeWayButtonClicked {
    [self.tableView reloadData];
}

- (void)chooseCouponButtonClicked:(NSString *)couponId {

    
}

- (void)timeChoose:(NSString *)date time:(NSString *)time {
    [self.commonSheetView dismiss];

    self.yuyueTime = [NSString stringWithFormat:@"%@ %@", date, time];
    [self.tableView reloadData];
}

- (void)orderValueRefresh:(NSString *)phoneNum tipStr:(NSString *)tipStr refresh:(BOOL)refresh {
    self.phoneNum = phoneNum;
    self.tipStr = tipStr;
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
        _tableView.estimatedRowHeight = 100;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH-20, 44)];
        _sureButton.backgroundColor = XKMainTypeColor;
        _sureButton.layer.masksToBounds = YES;
        _sureButton.layer.cornerRadius = 5;
        
        _sureButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
        [_sureButton setTitle:@"提交订单" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [_sureButton addTarget:self action:@selector(sureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}


- (XKTradingAreaOnlineChooseTimeView *)chooseTimeView {
    if (!_chooseTimeView) {
        _chooseTimeView = [[XKTradingAreaOnlineChooseTimeView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 360)];
        XKWeakSelf(weakSelf);
        _chooseTimeView.sureBlock = ^(NSString *date, NSString *time) {
            //获取时间
            [weakSelf timeChoose:date time:time];
        };
    }
    return _chooseTimeView;
}

- (XKCommonSheetView *)commonSheetView {
    
    if (!_commonSheetView) {
        _commonSheetView = [[XKCommonSheetView alloc] init];
        _commonSheetView.contentView = self.chooseTimeView;
        [_commonSheetView addSubview:self.chooseTimeView];
    }
    return _commonSheetView;
}

@end
