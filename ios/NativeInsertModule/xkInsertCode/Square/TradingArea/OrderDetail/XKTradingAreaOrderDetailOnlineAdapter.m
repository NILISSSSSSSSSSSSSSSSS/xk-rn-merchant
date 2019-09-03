//
//  XKTradingAreaOrderDetailOnlineAdapter.m
//  XKSquare
//
//  Created by hupan on 2018/8/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaOrderDetailOnlineAdapter.h"
#import "XKStoreSectionHeaderView.h"
#import "XKTradingAreaOrderFooterView.h"
#import "XKOrderDetailBookingStatusTableViewCell.h"
#import "XKOrderDetailDecTableViewCell.h"
#import "XKOderSureGoodsInfoCell.h"
#import "XKOrderAddressTableViewCell.h"
#import "XKSquareTradingAreaTool.h"
//模型
#import "XKTradingAreaOrderDetaiModel.h"

static NSString * const statusCellID                  = @"statusCellID";
static NSString * const goodsInfoCellID               = @"goodsInfoCellID";
static NSString * const addressInfoCellID             = @"addressInfoCellID";
static NSString * const orderInfoCellID               = @"orderInfoCellID";
static NSString * const afterSeleCellID               = @"afterSeleCellID";
static NSString * const sectionHeaderViewID           = @"sectionHeaderViewID";
static NSString * const sectionFooterViewID           = @"sectionFooterViewID";

typedef enum : NSUInteger {
    OrderCellType_status,         //外卖类型时为 状态
    OrderCellType_sendInfo,       //外卖类型时为 配送信息
    OrderCellType_shopInfo,       //外卖类型时为 商店信息
    OrderCellType_orderDetail,    //外卖类型时为 订单信息
    OrderCellType_goodsInfo,      //外卖类型时为 商品列表
    //加购 信息
} OrderCellType;

@interface XKTradingAreaOrderDetailOnlineAdapter ()

@end


@implementation XKTradingAreaOrderDetailOnlineAdapter

#pragma mark - UITableViewDelegate & UITableViewDataSoure

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.orderStatus == OrderStatus_afterSale) {//售后中
        return OrderCellType_goodsInfo + 2;
    }
    return OrderCellType_goodsInfo + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == OrderCellType_status) {
        return 1;
        
    } else if (section == OrderCellType_sendInfo) {
        return 2;
        
    } else if (section == OrderCellType_shopInfo) {
        return 3;
        
    }  else if (section == OrderCellType_orderDetail) {
        if (self.takeoutWay == 0) {
            if (self.orderStatus == OrderStatus_afterSale) {//售后中
                return 4;
            }
            return 3;
        } else {
            if (self.orderStatus == OrderStatus_afterSale) {//售后中
                return 3;
            }
            return 2;
        }
    } else if (section == OrderCellType_goodsInfo) {
        return self.orderModel.items.count;
        
    } else if (section == OrderCellType_goodsInfo + 1) {
        return 5;//售后中
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == OrderCellType_status) {
        XKOrderDetailBookingStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:statusCellID];
        if (!cell) {
            cell = [[XKOrderDetailBookingStatusTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:statusCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            XKWeakSelf(weakSelf);
            cell.refreshOrderDetailBlock = ^{
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(refreshTradingAreaOrderDetail)]) {
                    [weakSelf.delegate refreshTradingAreaOrderDetail];
                }
            };
        }
        [cell setValueWithModel:self.orderModel orderType:self.orderType orderStatus:self.orderStatus];
        return cell;
        
    } else if (indexPath.section == OrderCellType_sendInfo) {
        
        XKOrderDetailDecTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderInfoCellID];
        if (!cell) {
            cell = [[XKOrderDetailDecTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:orderInfoCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.xk_openClip = YES;
            cell.xk_radius = 5;
        }
        NSString *name = @"";
        NSString *dec = @"";
        if (self.takeoutWay == 0) {
            if (indexPath.row == 0) {
                name = @"预约送达时间";
                NSArray *timeArr = [self.orderModel.appointRange componentsSeparatedByString:@"-"];
                if (timeArr.count == 2) {
                    NSString *str1 = [XKTimeSeparateHelper backYMDHMStringByStrigulaSegmentWithTimestampString:timeArr.firstObject];
                    NSString *str2 = [XKTimeSeparateHelper backYMDHMStringByStrigulaSegmentWithTimestampString:timeArr.lastObject];
                    if (str2.length >= 5) {
                        str2 = [str2 substringFromIndex:str2.length - 5];
                    }
                    dec = [NSString stringWithFormat:@"%@-%@", str1, str2];
                }
                cell.xk_clipType = XKCornerClipTypeTopBoth;
                [cell hiddenLineView:NO];
            } else if (indexPath.row == 1) {
                name = @"配送方式";
                dec = @"送货上门";
                cell.xk_clipType = XKCornerClipTypeBottomBoth;
                [cell hiddenLineView:YES];
            }
            
        } else {
            if (indexPath.row == 0) {
                name = @"取货时间";
                NSArray *timeArr = [self.orderModel.appointRange componentsSeparatedByString:@"-"];
                if (timeArr.count == 2) {
                    NSString *str1 = [XKTimeSeparateHelper backYMDHMStringByStrigulaSegmentWithTimestampString:timeArr.firstObject];
                    NSString *str2 = [XKTimeSeparateHelper backYMDHMStringByStrigulaSegmentWithTimestampString:timeArr.lastObject];
                    if (str2.length >= 5) {
                        str2 = [str2 substringFromIndex:str2.length - 5];
                    }
                    dec = [NSString stringWithFormat:@"%@-%@", str1, str2];
                }
                cell.xk_clipType = XKCornerClipTypeTopBoth;
                [cell hiddenLineView:NO];
            } else if (indexPath.row == 1) {
                name = @"取货地址";
                dec = self.orderModel.address;
                cell.xk_clipType = XKCornerClipTypeBottomBoth;
                [cell hiddenLineView:YES];
            }
        }
        
        [cell setValueWithName:name dec:dec];
        return cell;
        
    } else if (indexPath.section == OrderCellType_shopInfo) {
        
        if (indexPath.row == 0) {
            XKOrderAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addressInfoCellID];
            if (!cell) {
                cell = [[XKOrderAddressTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:addressInfoCellID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.xk_openClip = YES;
                cell.xk_radius = 5;
                cell.xk_clipType = XKCornerClipTypeTopBoth;
                XKWeakSelf(weakSelf);
                cell.addresBtnBlock = ^(UIButton *sender) {
                    [weakSelf addressButtonClicked];
                };
                cell.reservationBtnBlock = ^(UIButton *sender, NSArray *phoneArr) {
                    [weakSelf phoneButtonClicked:sender phoneArray:phoneArr];
                };
            }
            [cell setValueWithShopName:self.orderModel.shopName phoneList:self.orderModel.contactPhones address:self.orderModel.address lat:self.orderModel.lat.doubleValue lng:self.orderModel.lng.doubleValue];
            return cell;
            
        } else {
            
            XKOrderDetailDecTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderInfoCellID];
            if (!cell) {
                cell = [[XKOrderDetailDecTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:orderInfoCellID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.xk_openClip = YES;
                cell.xk_radius = 5;
            }
            NSString *name = @"";
            NSString *dec = @"";
            if (indexPath.row == 1) {
                name = @"订单编号";
                dec = self.orderModel.orderId;
                cell.xk_clipType = XKCornerClipTypeNone;
                [cell hiddenLineView:NO];
            } else if (indexPath.row == 2) {
                name = @"下单时间";
                dec = [XKTimeSeparateHelper backYMDHMSStringByStrigulaSegmentWithTimestampString:self.orderModel.createdAt];
                cell.xk_clipType = XKCornerClipTypeBottomBoth;
                [cell hiddenLineView:YES];
            }
            [cell setValueWithName:name dec:dec];
            return cell;
        }
        
    } else if (indexPath.section == OrderCellType_orderDetail) {
        
        
        XKOrderDetailDecTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderInfoCellID];
        if (!cell) {
            cell = [[XKOrderDetailDecTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:orderInfoCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.xk_openClip = YES;
            cell.xk_radius = 5;
        }
        NSString *name = @"";
        NSString *dec = @"";
        
        if (self.takeoutWay == 0) {
            if (indexPath.row == 0) {
                name = @"配送服务";
                dec = @"商家配送";
                cell.xk_clipType = XKCornerClipTypeTopBoth;
                [cell hiddenLineView:NO];
                
            } else if (indexPath.row == 1) {
                name = @"预约手机";
                dec = self.orderModel.subPhone;
                cell.xk_clipType = XKCornerClipTypeNone;
                [cell hiddenLineView:NO];
                
            } else if (indexPath.row == 2) {
                name = @"备注";
                dec = self.orderModel.remark ? self.orderModel.remark : @"暂无备注";
                if (self.orderStatus == OrderStatus_afterSale) {//售后中
                    cell.xk_clipType = XKCornerClipTypeNone;
                    [cell hiddenLineView:NO];
                } else {
                    cell.xk_clipType = XKCornerClipTypeBottomBoth;
                    [cell hiddenLineView:YES];
                }
            } else if (indexPath.row == 3) {
                name = @"取消原因";
                dec = self.orderModel.refundReason ? self.orderModel.refundReason : @"暂无原因";
                cell.xk_clipType = XKCornerClipTypeBottomBoth;
                [cell hiddenLineView:YES];
            }
        } else {
            
            if (indexPath.row == 0) {
                name = @"预约手机";
                dec = self.orderModel.subPhone;
                cell.xk_clipType = XKCornerClipTypeTopBoth;
                [cell hiddenLineView:NO];
                
            } else if (indexPath.row == 1) {
                name = @"备注";
                dec = self.orderModel.remark ? self.orderModel.remark : @"暂无备注";
                if (self.orderStatus == OrderStatus_afterSale) {//售后中
                    cell.xk_clipType = XKCornerClipTypeNone;
                    [cell hiddenLineView:NO];
                } else {
                    cell.xk_clipType = XKCornerClipTypeBottomBoth;
                    [cell hiddenLineView:YES];
                }
            } else if (indexPath.row == 2) {
                name = @"取消原因";
                dec = self.orderModel.refundReason ? self.orderModel.refundReason : @"暂无原因";
                cell.xk_clipType = XKCornerClipTypeBottomBoth;
                [cell hiddenLineView:YES];
            }
        }
        [cell setValueWithName:name dec:dec];
        return cell;
        
    } else if (indexPath.section == OrderCellType_goodsInfo){//OrderCellType_goodsInfo
        
        XKOderSureGoodsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsInfoCellID];
        if (!cell) {
            cell = [[XKOderSureGoodsInfoCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:goodsInfoCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setValueWithModel:self.orderModel.items[indexPath.row]];
        [cell hiddenLineView:NO];
        return cell;
        
    } else {//售后
        XKOrderDetailDecTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:afterSeleCellID];
        if (!cell) {
            cell = [[XKOrderDetailDecTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:afterSeleCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.xk_openClip = YES;
            cell.xk_radius = 5;
        }
        NSString *name = @"";
        NSString *dec = @"";
        
        if (indexPath.row == 0) {
            name = @"现金退款";
            dec = [NSString stringWithFormat:@"-￥%.2f", self.orderModel.totalRmbPrice.floatValue];
            cell.xk_clipType = XKCornerClipTypeTopBoth;
            [cell hiddenLineView:NO];
            [cell setDecTextColor:HEX_RGB(0xee6161)];
            
        } else if (indexPath.row == 1) {
            name = @"商家券退款";
            dec = [NSString stringWithFormat:@"-￥%.2f", self.orderModel.totalShopVoucherPrice.floatValue];
            cell.xk_clipType = XKCornerClipTypeNone;
            [cell hiddenLineView:NO];
            [cell setDecTextColor:HEX_RGB(0xee6161)];
            
        } else if (indexPath.row == 2) {
            name = @"消费券退款";
            dec = [NSString stringWithFormat:@"-￥%.2f", self.orderModel.totalVoucherPrice.floatValue];
            cell.xk_clipType = XKCornerClipTypeNone;
            [cell hiddenLineView:NO];
            [cell setDecTextColor:HEX_RGB(0xee6161)];
            
        } else if (indexPath.row == 3) {
            name = @"卡券退还";
            dec = @"已返回卡券包";
            cell.xk_clipType = XKCornerClipTypeNone;
            [cell hiddenLineView:NO];
            [cell setDecTextColor:HEX_RGB(0x555555)];
        } else if (indexPath.row == 4) {
            name = @"优惠说明";
            dec = @"一次只能使用一张商家券";
            cell.xk_clipType = XKCornerClipTypeBottomBoth;
            [cell hiddenLineView:YES];
            [cell setDecTextColor:HEX_RGB(0x555555)];
        }
        
        [cell setValueWithName:name dec:dec];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == OrderCellType_sendInfo) {
        return 10;
    } else if (section == OrderCellType_orderDetail) {
        return 10;
    } else if (section == OrderCellType_goodsInfo) {
        return 50;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == OrderCellType_shopInfo) {
        return 0;
    } else if (section == OrderCellType_orderDetail) {
        return 10;
    } else if (section == OrderCellType_goodsInfo) {
        if (self.orderStatus == OrderStatus_afterSale) {
            if (self.takeoutWay == 0) {
                return 245;
            } else {
                return 195;
            }
        } else {
            if (self.takeoutWay == 0) {
                return 90;
            } else {
                return 50;
            }
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == OrderCellType_goodsInfo) {
        
        XKStoreSectionHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionHeaderViewID];
        if (!sectionHeaderView) {
            sectionHeaderView = [[XKStoreSectionHeaderView alloc] initWithReuseIdentifier:sectionHeaderViewID];
            sectionHeaderView.backView.xk_openClip = YES;
            sectionHeaderView.backView.xk_radius = 5;
            sectionHeaderView.backView.xk_clipType = XKCornerClipTypeTopBoth;
        }
        [sectionHeaderView setTitleName:self.orderModel.shopName titleColor:HEX_RGB(0x222222) titleFont:XKMediumFont(16)];
        
        return sectionHeaderView;
    }
    return nil;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    
    if (section == OrderCellType_goodsInfo) {
        XKTradingAreaOrderFooterView *sectionFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionFooterViewID];
        if (!sectionFooterView) {
            sectionFooterView = [[XKTradingAreaOrderFooterView alloc] initWithReuseIdentifier:sectionFooterViewID];
            sectionFooterView.backView.xk_openClip = YES;
            sectionFooterView.backView.xk_radius = 5;
            sectionFooterView.backView.xk_clipType = XKCornerClipTypeBottomBoth;
        }
        if (self.orderStatus == OrderStatus_afterSale) {
            [sectionFooterView setAfterSaleValue:self.orderModel logisticFee:self.takeoutWay == 0 ? 5 : 0];
        } else {
            [sectionFooterView setTitleWithLogisticFee:self.takeoutWay == 0 ? 5 : 0 goodsPrice:self.goodsPrice];
        }
        return sectionFooterView;
    }
    return nil;
}

#pragma mark - cusotmBlock


- (void)addressButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addressButtonSelected:lat:lng:)]) {
        [self.delegate addressButtonSelected:self.orderModel.shopName lat:self.orderModel.lat.doubleValue lng:self.orderModel.lng.doubleValue];
    }
}

- (void)phoneButtonClicked:(UIButton *)sender phoneArray:(NSArray *)phoneArr {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(phoneButtonSelected:phoneArray:)]) {
        [self.delegate phoneButtonSelected:sender phoneArray:phoneArr];
    }
}


#pragma mark - request


#pragma mark - setter


@end
