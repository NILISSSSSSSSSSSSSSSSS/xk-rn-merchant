//
//  XKTradingAreaOrderReserveViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/28.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaOrderReserveViewController.h"
#import "XKOderReserveOrderInfoCell.h"
#import "XKOderReserveGoodsInfoCell.h"
#import "XKOderReserveHotelInfoCell.h"
#import "XKTradingAreaOrderReserveStatusViewController.h"
#import "XKOrderSureChooseSeatNumViewController.h"
#import "XKTradingAreaGoodsInfoModel.h"
#import "XKTradingAreaCreatOderModel.h"
#import "XKTradingAreaSeatListModel.h"
#import "XKSquareTradingAreaTool.h"

static NSString * const hotelInfoCellID        = @"hotelInfoCellID";
static NSString * const goodsInfoCellID        = @"goodsInfoCellID";
static NSString * const orderInfoCellID        = @"orderInfoCellID";

typedef enum : NSUInteger {
    OrderCellType_goodsInfo,//商品信息
    OrderCellType_orderInfo//订单信息
} OrderCellType;

@interface XKTradingAreaOrderReserveViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton    *sureButton;
@property (nonatomic, copy  ) NSString    *orderId;

@property (nonatomic, copy  ) NSDictionary *selectedMuDic;

//酒店订单参数
@property (nonatomic, copy  ) NSString   *startDateStr;
@property (nonatomic, copy  ) NSString   *endDateStr;
//@property (nonatomic, copy  ) NSString   *namesStr;//废弃参数
@property (nonatomic, assign) NSInteger   houseNum;
@property (nonatomic, assign) NSInteger  days;

//服务订单参数
@property (nonatomic, assign) NSInteger   goodsNum;
@property (nonatomic, copy  ) NSString    *seatNames;


//公用参数
@property (nonatomic, assign) NSInteger  peopleNum;
@property (nonatomic, copy  ) NSString   *tipStr;
@property (nonatomic, copy  ) NSString   *userName;
@property (nonatomic, copy  ) NSString   *phoneNum;

@end



@implementation XKTradingAreaOrderReserveViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_RGB(0xf6f6f6);
    self.phoneNum = [XKUserInfo getCurrentUserRealPhoneNumber];
    self.peopleNum = 1;
    self.houseNum = 1;
    self.goodsNum = 1;
    
    [self configNavigationBar];
    [self configTableView];
}

#pragma mark - Events

//订单确认
- (void)sureBtnClicked {

    if (self.reserveVCType == OrderReserveVC_hotel) {
        if (self.days < 1) {
            [XKAlertView showCommonAlertViewWithTitle:@"时间选择错误，请重新选择"];
            return;
        }
        /*if (self.namesStr.length == 0) {
            [XKAlertView showCommonAlertViewWithTitle:@"请填写入住人姓名"];
            return;
        }*/
        
    } else if (self.reserveVCType == OrderReserveVC_service) {
        if (!self.selectedMuDic && self.skuItem.purchased) {
            [XKAlertView showCommonAlertViewWithTitle:@"请选择席位"];
            return;
        }
    }
    
    if (self.peopleNum == 0) {
        [XKAlertView showCommonAlertViewWithTitle:@"请选择人数"];
        return;
    }
    
    if (self.userName.length == 0) {
        [XKAlertView showCommonAlertViewWithTitle:@"请填写联系人姓名"];
        return;
    }
    if (self.phoneNum.length == 0 || self.phoneNum.length != 11) {
        if (self.phoneNum.length == 0) {
            [XKAlertView showCommonAlertViewWithTitle:@"请填写联系手机号码"];
        } else {
            [XKAlertView showCommonAlertViewWithTitle:@"手机号码有误，请重新输入"];
        }
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *goodsDic = [NSMutableDictionary dictionary];
    
    GoodsSkuVOListItem *skuItem = self.skuItem;
    [goodsDic setObject:skuItem.goodsId forKey:@"goodsId"];
    [goodsDic setObject:skuItem.skuCode forKey:@"goodsSkuCode"];
    [goodsDic setObject:self.reserveVCType == OrderReserveVC_service ? @(self.goodsNum) : @(self.houseNum) forKey:@"goodsSum"];

    [dic setObject:[NSArray arrayWithObject:goodsDic] forKey:@"goodsParams"];
    if (self.tipStr.length) {
        [dic setObject:self.tipStr forKey:@"remark"];
    }
    [dic setObject:self.phoneNum forKey:@"subPhone"];
    [dic setObject:@(self.peopleNum) forKey:@"consumerNum"];
    [dic setObject:self.userName forKey:@"consumer"];

    if (self.reserveVCType == OrderReserveVC_service) {
        [dic setObject:[XKTimeSeparateHelper backTimestampStringWithTimeString:self.reserveTime] forKey:@"appointRange"];
        
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
        
    } else if (self.reserveVCType == OrderReserveVC_hotel) {
        NSString *startTimestamp = [XKTimeSeparateHelper backTimestampStringWithYMDTimeString:self.startDateStr];
        NSString *endTimestamp = [XKTimeSeparateHelper backTimestampStringWithYMDTimeString:self.endDateStr];
        [dic setObject:[NSString stringWithFormat:@"%@-%@", startTimestamp, endTimestamp] forKey:@"appointRange"];
    }
    
    [XKHudView showLoadingTo:self.tableView animated:YES];
    [XKSquareTradingAreaTool tradingAreaCreatOrder:@{@"orderCreate":dic}
                                           success:^(XKTradingAreaCreatOderModel *model) {
                                               [XKHudView hideHUDForView:self.tableView];
                                               self.orderId = model.orderId;
                                               XKTradingAreaOrderReserveStatusViewController *vc = [[XKTradingAreaOrderReserveStatusViewController alloc] init];
                                               vc.orderId = self.orderId;
                                               [self.navigationController pushViewController:vc animated:YES];
                                           } faile:^(XKHttpErrror *error) {
                                               [XKHudView hideHUDForView:self.tableView];
                                           }];
    
}


- (void)saveValueWithStartDateStr:(NSString *)startDateStr endDateStr:(NSString *)endDateStr houseNum:(NSInteger)houseNum peopleNum:(NSInteger)peopleNum tipStr:(NSString *)tipStr fresh:(BOOL)refresh {
    
    self.startDateStr = startDateStr;
    self.endDateStr = endDateStr;
//    self.namesStr = names;
    self.tipStr = tipStr;
    self.houseNum = houseNum;
    self.peopleNum = peopleNum;
    self.days = [XKTimeSeparateHelper backDaysWithStartDateStr:self.startDateStr endDateStr:self.endDateStr];

    //时间都有有数据时
    if (startDateStr && endDateStr) {
        if (self.days < 1) {
            [XKAlertView showCommonAlertViewWithTitle:@"时间选择错误，请重新选择"];
            return;
        }
    }
    
    if (refresh) {
        [self.tableView reloadData];
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }
}


- (void)saveValueWithNum:(NSInteger)num peopleNum:(NSInteger)peopleNum tipStr:(NSString *)tipStr refresh:(BOOL)refresh {
    
    self.goodsNum = num;
    self.peopleNum = peopleNum;
    self.tipStr = tipStr;
    
    if (refresh) {
        self.selectedMuDic = nil;
        self.seatNames = nil;
        [self.tableView reloadData];
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - Private Metheods

- (void)configNavigationBar {
    [self setNavTitle:@"预定" WithColor:[UIColor whiteColor]];
}

- (void)configTableView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [footerView addSubview:self.sureButton];
    self.tableView.tableFooterView = footerView;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(NavigationAndStatue_Height, 0, 0, 0));
    }];
}



#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == OrderCellType_goodsInfo) {
        return 1;
    } else if (section == OrderCellType_orderInfo) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == OrderCellType_goodsInfo) {
        
        if (self.reserveVCType == OrderReserveVC_service) {
            
            XKOderReserveGoodsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsInfoCellID];
            if (!cell) {
                cell = [[XKOderReserveGoodsInfoCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:goodsInfoCellID];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.xk_openClip = YES;
                cell.xk_radius = 5;
                cell.xk_clipType = XKCornerClipTypeTopLeft | XKCornerClipTypeTopRight;
                
                XKWeakSelf(weakSelf);
                cell.valueBlock = ^(NSInteger num, NSInteger peopleNum, NSString *tipStr, BOOL refresh) {
                    [weakSelf saveValueWithNum:num peopleNum:peopleNum tipStr:tipStr refresh:refresh];
                };
                cell.seatChooseBlock = ^{
                    [weakSelf seatChoose];
                };
            }
            [cell setValueWithModel:self.skuItem reserveTime:self.reserveTime num:self.goodsNum peopleNum:self.peopleNum seatName:self.seatNames];
            
            return cell;
            
        } else if (self.reserveVCType == OrderReserveVC_hotel) {
            
            XKOderReserveHotelInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:hotelInfoCellID];
            if (!cell) {
                cell = [[XKOderReserveHotelInfoCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:hotelInfoCellID];

                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.xk_openClip = YES;
                cell.xk_radius = 5;
                cell.xk_clipType = XKCornerClipTypeTopLeft | XKCornerClipTypeTopRight;
                XKWeakSelf(weakSelf);
                cell.valueBlock = ^(NSString *startDateStr, NSString *endDateStr, NSInteger num, NSInteger peopleNum, NSString *tips, BOOL refresh) {
                    [weakSelf saveValueWithStartDateStr:startDateStr endDateStr:endDateStr houseNum:num peopleNum:peopleNum tipStr:tips fresh:refresh];
                };
            }
            
            [cell setValueWithModel:self.skuItem startDateStr:self.startDateStr endDateStr:self.endDateStr hoseNum:self.houseNum peopleNum:self.peopleNum tipStr:self.tipStr];
            return cell;
        }
        
    } else if (indexPath.section == OrderCellType_orderInfo) {
        
        XKOderReserveOrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:orderInfoCellID];
        if (!cell) {
            cell = [[XKOderReserveOrderInfoCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:orderInfoCellID];
            XKWeakSelf(weakSelf);
            cell.valueBlock = ^(NSString *phoneNun, NSString *userName) {
                weakSelf.phoneNum = phoneNun;
                weakSelf.userName = userName;
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.xk_openClip = YES;
            cell.xk_radius = 5;
            cell.xk_clipType = XKCornerClipTypeBottomLeft | XKCornerClipTypeBottomRight;
        }
        //服务都要联系人
        cell.hiddenUserName = NO;
        if (self.reserveVCType == OrderReserveVC_service) {
            [cell setValueWithSinglePrice:self.skuItem.discountPrice.floatValue/100.0 num:self.goodsNum days:1 phoneNum:self.phoneNum userName:self.userName];
        } else if (self.reserveVCType == OrderReserveVC_hotel) {
            [cell setValueWithSinglePrice:self.skuItem.discountPrice.floatValue/100.0 num:self.houseNum days:self.days phoneNum:self.phoneNum userName:self.userName];
        }
        return cell;
    }
    return nil;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}



#pragma mark - customDelegate


#pragma mark - coustomBlock

- (void)seatChoose {
    //选座位号
    XKOrderSureChooseSeatNumViewController *vc = [[XKOrderSureChooseSeatNumViewController alloc] init];
    vc.shopId = self.skuItem.shopId;
    vc.maxSeat = self.goodsNum;
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
        [_sureButton setTitle:@"提交订单" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [_sureButton addTarget:self action:@selector(sureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}


@end
