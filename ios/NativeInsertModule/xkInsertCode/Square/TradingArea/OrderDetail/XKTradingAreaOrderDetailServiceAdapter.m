//
//  XKTradingAreaOrderDetailServiceAdapter.m
//  XKSquare
//
//  Created by hupan on 2018/8/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaOrderDetailServiceAdapter.h"
#import "XKStoreSectionHeaderView.h"
#import "XKTradingAreaOrderFooterView.h"
#import "XKOrderDetailBookingStatusTableViewCell.h"
#import "XKOrderDetailDecTableViewCell.h"
#import "XKOderSureGoodsInfoCell.h"
#import "XKOrderAddressTableViewCell.h"
#import "XKOderConsumerCodeTableViewCell.h"
#import "XKTradingAreaOrderDetaiModel.h"
#import "XKSqureCommonNoDataCell.h"
#import "XKSquareTradingAreaTool.h"

static NSString * const statusCellID                  = @"statusCellID";
static NSString * const consumerCodeCellID            = @"consumerCodeCellID";
static NSString * const goodsInfoCellID               = @"goodsInfoCellID";
static NSString * const addressInfoCellID             = @"addressInfoCellID";
static NSString * const orderInfoCellID               = @"orderInfoCellID";
static NSString * const afterSeleCellID               = @"afterSeleCellID";
static NSString * const noDataCellID                  = @"noDataCellID";
static NSString * const sectionHeaderViewID           = @"sectionHeaderViewID";
static NSString * const sectionFooterViewID           = @"sectionFooterViewID";

typedef enum : NSUInteger {
    OrderCellType_status,            //状态
    OrderCellType_consumerCode,      //消费码
    OrderCellType_shopInfo,          //商店信息
    OrderCellType_sevicesOrHetolCell,//服务或者酒店
    OrderCellType_orderInfo,         //订单信息
    //加购 信息
} OrderCellType;

@interface XKTradingAreaOrderDetailServiceAdapter ()

@end


@implementation XKTradingAreaOrderDetailServiceAdapter

#pragma mark - UITableViewDelegate & UITableViewDataSoure

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.orderStatus == OrderStatus_afterSale) {//售后中
        return OrderCellType_orderInfo + 1 + self.purchaseMuarr.count + 1;//purchaseMuarr为加购的席位数量
    }
    return OrderCellType_orderInfo + 1 + self.purchaseMuarr.count;//purchaseMuarr为加购的席位数量
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == OrderCellType_status) {
        return 1;
        
    } else if (section == OrderCellType_consumerCode) {
        
        if (self.orderStatus == OrderStatus_use) {
            //其他订单只有待消费才有消费码
            return 1;
        }
        return 0;
        
    } else if (section == OrderCellType_shopInfo) {
        //纯服务或者酒店
        if ([self.orderModel.sceneStatus isEqualToString:@"SERVICE_OR_STAY"]) {
            return 3;
        } else {
            return 4;
        }
        
    } else if (section == OrderCellType_sevicesOrHetolCell) {
        
        return self.orderModel.items.count;
        
    } else if (section == OrderCellType_orderInfo) {
        
        if (self.orderType == OrderDetailType_hotel) {
            if (self.orderStatus == OrderStatus_afterSale) {//售后中
                return 7;
            }
            return 6;
            
        } else if (self.orderType == OrderDetailType_service) {
            if (self.purchaseMuarr.count) {//服务加加购
                if (self.orderStatus == OrderStatus_afterSale) {//售后中
                    return 6;
                }
                return 5;
            } else {
                if (self.orderStatus == OrderStatus_afterSale) {//售后中
                    return 5;
                }
                return 4;
            }
        }
    } else if (section == OrderCellType_orderInfo + 1 + self.purchaseMuarr.count) {//售后中
        return 5;
        
    } else {//加购
        NSInteger index = section - OrderCellType_orderInfo - 1;
        if (index >= 0 && index < self.purchaseMuarr.count) {
            OrderItems *items = self.purchaseMuarr[index];
            return items.purchases.count ? items.purchases.count : 1;
        }
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
        
    } else if (indexPath.section == OrderCellType_consumerCode) {
        XKOderConsumerCodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:consumerCodeCellID];
        if (!cell) {
            cell = [[XKOderConsumerCodeTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:consumerCodeCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSString *QRStr = [NSString stringWithFormat:@"xkgc://order_detail?orderId=%@&storeId=%@&userId=%@&consumeCode=%@&sceneStatus=%@", self.orderModel.orderId, self.orderModel.shopId, [XKUserInfo getCurrentUserId], self.orderModel.consumeCode, self.orderModel.sceneStatus];
        [cell setValueWithQRStr:QRStr consumeCode:self.orderModel.consumeCode];
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
                [cell showShareButton];
                XKWeakSelf(weakSelf);
                cell.addresBtnBlock = ^(UIButton *sender) {
                    [weakSelf addressButtonClicked];
                };
                cell.reservationBtnBlock = ^(UIButton *sender, NSArray *phoneArr) {
                    [weakSelf phoneButtonClicked:sender phoneArray:phoneArr];
                };
                cell.shareStoreButtonBlock = ^(UIButton *sender) {
                    [weakSelf shareStoreButtonClicked];
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
                //纯服务或者酒店
                if ([self.orderModel.sceneStatus isEqualToString:@"SERVICE_OR_STAY"]) {
                    cell.xk_clipType = XKCornerClipTypeBottomBoth;
                    [cell hiddenLineView:YES];
                } else {
                    cell.xk_clipType = XKCornerClipTypeNone;
                    [cell hiddenLineView:NO];
                }
            } else if (indexPath.row == 3) {
                name = @"订单密码";
                dec = self.orderModel.orderCipher ? self.orderModel.orderCipher : @"暂无";
                cell.xk_clipType = XKCornerClipTypeBottomBoth;
                [cell hiddenLineView:YES];
            }
            [cell setValueWithName:name dec:dec];
            return cell;
        }
        
    } else if (indexPath.section == OrderCellType_sevicesOrHetolCell) {

        XKOderSureGoodsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsInfoCellID];
        if (!cell) {
            cell = [[XKOderSureGoodsInfoCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:goodsInfoCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setValueWithModel:self.orderModel.items[indexPath.row]];
        [cell hiddenLineView:NO];
        return cell;
    
        
    } else if (indexPath.section == OrderCellType_orderInfo) {

        XKOrderDetailDecTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderInfoCellID];
        if (!cell) {
            cell = [[XKOrderDetailDecTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:orderInfoCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.xk_openClip = YES;
            cell.xk_radius = 5;
        }
        NSString *name = @"";
        NSString *dec = @"";
        
        if (self.orderType == OrderDetailType_hotel) {
            if (indexPath.row == 0) {
                name = @"住店时间";
                NSArray *timeArr = [self.orderModel.appointRange componentsSeparatedByString:@"-"];
                if (timeArr.count == 2) {
                    dec = [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:timeArr.firstObject];
                }
                cell.xk_clipType = XKCornerClipTypeTopBoth;
                [cell hiddenLineView:NO];
                
            } else if (indexPath.row == 1) {
                name = @"离店时间";
                NSArray *timeArr = [self.orderModel.appointRange componentsSeparatedByString:@"-"];
                if (timeArr.count == 2) {
                    dec = [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:timeArr.lastObject];
                }
                cell.xk_clipType = XKCornerClipTypeNone;
                [cell hiddenLineView:NO];
                
            } else if (indexPath.row == 2) {
                name = @"预约手机";
                dec = self.orderModel.subPhone;
                cell.xk_clipType = XKCornerClipTypeNone;
                [cell hiddenLineView:NO];
                
            } else if (indexPath.row == 3) {
                name = @"房间数";
                dec = [NSString stringWithFormat:@"%d间", (int)self.orderModel.items.count];
                cell.xk_clipType = XKCornerClipTypeNone;
                [cell hiddenLineView:NO];
                
            } else if (indexPath.row == 4) {
                name = @"人数";
                dec = [NSString stringWithFormat:@"%@人", self.orderModel.consumerNum];
                cell.xk_clipType = XKCornerClipTypeNone;
                [cell hiddenLineView:NO];
                
            } else if (indexPath.row == 5) {
                name = @"备注";
                dec = self.orderModel.remark ? self.orderModel.remark : @"暂无备注";
                if (self.orderStatus == OrderStatus_afterSale) {//售后中
                    cell.xk_clipType = XKCornerClipTypeNone;
                    [cell hiddenLineView:NO];
                } else {
                    cell.xk_clipType = XKCornerClipTypeBottomBoth;
                    [cell hiddenLineView:YES];
                }
            } else if (indexPath.row == 6) {
                name = @"取消原因";
                dec = self.orderModel.refundReason ? self.orderModel.refundReason : @"暂无原因";
                cell.xk_clipType = XKCornerClipTypeBottomBoth;
                [cell hiddenLineView:YES];
            }
            
        } else if (self.orderType == OrderDetailType_service) {
            
            if (self.purchaseMuarr.count) {//服务加加购
                if (indexPath.row == 0) {
                    name = @"预约时间";
                    dec = [XKTimeSeparateHelper backYMDHMSStringByStrigulaSegmentWithTimestampString:self.orderModel.appointRange];
                    cell.xk_clipType = XKCornerClipTypeTopBoth;
                    [cell hiddenLineView:NO];
                    
                } else if (indexPath.row == 1) {
                    name = @"席位选择";
                    dec = [NSString stringWithFormat:@"已选%d个", (int)self.orderModel.items.count];
                    cell.xk_clipType = XKCornerClipTypeNone;
                    [cell hiddenLineView:NO];
                    
                } else if (indexPath.row == 2) {
                    name = @"预约手机";
                    dec = self.orderModel.subPhone;
                    cell.xk_clipType = XKCornerClipTypeNone;
                    [cell hiddenLineView:NO];
                    
                } else if (indexPath.row == 3) {
                    name = @"人数";
                    dec = [NSString stringWithFormat:@"%@人", self.orderModel.consumerNum];
                    cell.xk_clipType = XKCornerClipTypeNone;
                    [cell hiddenLineView:NO];
                    
                } else if (indexPath.row == 4) {
                    name = @"备注";
                    dec = self.orderModel.remark ? self.orderModel.remark : @"暂无备注";
                    if (self.orderStatus == OrderStatus_afterSale) {//售后中
                        cell.xk_clipType = XKCornerClipTypeNone;
                        [cell hiddenLineView:NO];
                    } else {
                        cell.xk_clipType = XKCornerClipTypeBottomBoth;
                        [cell hiddenLineView:YES];
                    }
                } else if (indexPath.row == 5) {
                    name = @"取消原因";
                    dec = self.orderModel.refundReason ? self.orderModel.refundReason : @"暂无原因";
                    cell.xk_clipType = XKCornerClipTypeBottomBoth;
                    [cell hiddenLineView:YES];
                }
            } else {
                
                if (indexPath.row == 0) {
                    name = @"预约时间";
                    dec = [XKTimeSeparateHelper backYMDHMSStringByStrigulaSegmentWithTimestampString:self.orderModel.appointRange];
                    cell.xk_clipType = XKCornerClipTypeTopBoth;
                    [cell hiddenLineView:NO];
                    
                } else if (indexPath.row == 1) {
                    name = @"预约手机";
                    dec = self.orderModel.subPhone;
                    cell.xk_clipType = XKCornerClipTypeNone;
                    [cell hiddenLineView:NO];
                    
                } else if (indexPath.row == 2) {
                    name = @"人数";
                    dec = [NSString stringWithFormat:@"%@人", self.orderModel.consumerNum];
                    cell.xk_clipType = XKCornerClipTypeNone;
                    [cell hiddenLineView:NO];
                    
                } else if (indexPath.row == 3) {
                    name = @"备注";
                    dec = self.orderModel.remark ? self.orderModel.remark : @"暂无备注";
                    if (self.orderStatus == OrderStatus_afterSale) {//售后中
                        cell.xk_clipType = XKCornerClipTypeNone;
                        [cell hiddenLineView:NO];
                    } else {
                        cell.xk_clipType = XKCornerClipTypeBottomBoth;
                        [cell hiddenLineView:YES];
                    }
                } else if (indexPath.row == 4) {
                    name = @"取消原因";
                    dec = self.orderModel.refundReason ? self.orderModel.refundReason : @"暂无原因";
                    cell.xk_clipType = XKCornerClipTypeBottomBoth;
                    [cell hiddenLineView:YES];
                }
            }
            
        }
        [cell setValueWithName:name dec:dec];
        return cell;
        
    } else if (indexPath.section == OrderCellType_orderInfo + 1 + self.purchaseMuarr.count) {//售后中
        
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
        
    } else {
        
        OrderItems *items;
        NSInteger index = indexPath.section - OrderCellType_orderInfo - 1;
        if (index >= 0 && index < self.purchaseMuarr.count) {
            items = self.purchaseMuarr[index];
        }
        
        if (items.purchases.count) {
            XKOderSureGoodsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsInfoCellID];
            if (!cell) {
                cell = [[XKOderSureGoodsInfoCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:goodsInfoCellID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            XKWeakSelf(weakSelf);
            cell.gotoPayBlock = ^{
                [weakSelf gotoPayBlock];
            };
            if (items.purchases.count > indexPath.row) {
                [cell setValueWithPurchasesModel:items.purchases[indexPath.row] orderTpye:self.orderModel.orderStatus];
            }
            [cell hiddenLineView:NO];
            return cell;

        } else {
            
            XKSqureCommonNoDataCell *cell = [tableView dequeueReusableCellWithIdentifier:noDataCellID];
            if (!cell) {
                cell = [[XKSqureCommonNoDataCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:noDataCellID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backView.xk_openClip = YES;
                cell.backView.xk_radius = 5;
            }
            if (indexPath.section == OrderCellType_orderInfo + self.purchaseMuarr.count) {
                cell.backView.xk_clipType = XKCornerClipTypeBottomBoth;
                [cell hiddenLineView:YES];
            } else {
                cell.backView.xk_clipType = XKCornerClipTypeNone;
                [cell hiddenLineView:NO];
            }
            [cell setNoDataTitleName:@"暂无加购"];
            return cell;
        }
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == OrderCellType_consumerCode) {
        if (self.orderStatus == OrderStatus_use) {
            //其他订单只有待消费才有消费码
            return 10;
            //没码0  有码10
        }
        return 0;
        
    } else if (section == OrderCellType_sevicesOrHetolCell) {
        return 50;
    } else if (section > OrderCellType_orderInfo) {
        if (section == OrderCellType_orderInfo + 1 + self.purchaseMuarr.count) {//售后
            return 10;
        }
        return 50;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == OrderCellType_shopInfo) {
        return 10;
        
    } else if (section == OrderCellType_sevicesOrHetolCell) {

        if (self.orderStatus == OrderStatus_afterSale) {
            return 195;
        } else {
            if (self.orderStatus == OrderStatus_finsh) {
                return 90;
            }
            return 55;
        }
        
    } else if (section == OrderCellType_orderInfo) {
        
        if (self.orderType == OrderDetailType_hotel) {
            return 0;
        } else if (self.orderType == OrderDetailType_service) {
            if (self.purchaseMuarr.count) {
                return 10;
            }
            return 0;
        }
        return 10;
        
    } else if (section == OrderCellType_orderInfo + self.purchaseMuarr.count) {//席位最后一个
        
        if (self.orderStatus == OrderStatus_afterSale) {
            if (self.addGoodsNum) {
                return 245;
            } else {
                return 0;
            }
        } else {
            if (self.addGoodsNum) {
                if (self.orderStatus == OrderStatus_finsh) {
                    return 120;//完成后要显示支付信息
                }
                return 100;
            }
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == OrderCellType_sevicesOrHetolCell || (section > OrderCellType_orderInfo && section != OrderCellType_orderInfo + 1 + self.purchaseMuarr.count)) {
        
        XKStoreSectionHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionHeaderViewID];
        if (!sectionHeaderView) {
            sectionHeaderView = [[XKStoreSectionHeaderView alloc] initWithReuseIdentifier:sectionHeaderViewID];
            sectionHeaderView.backView.xk_openClip = YES;
            sectionHeaderView.backView.xk_radius = 5;
            XKWeakSelf(weakSelf);
            sectionHeaderView.moreBlock = ^(UIButton *sender) {
                [weakSelf addGoodsButtonClicked:sender];
            };
        }
        NSString *titleName = @"";
        NSString *moreBtnImgName = @"";
        NSInteger moreBtnImgDirection = ButtonImgDirection_right;
        NSString *moreBtnTitleName = @"";
        
        if (section == OrderCellType_sevicesOrHetolCell) {
            sectionHeaderView.backView.xk_clipType = XKCornerClipTypeTopBoth;
            if (self.orderType == OrderDetailType_hotel) {
                titleName = @"酒店";
            } else if (self.orderType == OrderDetailType_service) {
                titleName = @"服务";
            }
            if (self.orderStatus == OrderStatus_use) {
                moreBtnTitleName = @"退款";
            }            
        } else { //加购的
            if (self.showPurchaseBtn) {
                moreBtnTitleName = @"添加";
                moreBtnImgName = @"xk_btn_TradingArea_add";
            }
            
            OrderItems *items;
            NSInteger index = section - OrderCellType_orderInfo - 1;
            if (index >= 0 && index < self.purchaseMuarr.count) {
                items = self.purchaseMuarr[index];
            }
            titleName = items.seatName;
            if (index == 0) {
                sectionHeaderView.backView.xk_clipType = XKCornerClipTypeTopBoth;
            } else {
                sectionHeaderView.backView.xk_clipType = XKCornerClipTypeNone;
            }
        }
        [sectionHeaderView setTitleName:titleName titleColor:HEX_RGB(0x222222) titleFont:XKMediumFont(16)];
        [sectionHeaderView setMoreButtonWithTitle:moreBtnTitleName titleColor:XKMainTypeColor titleFont:XKRegularFont(16) buttonTag:section];
        [sectionHeaderView setMoreButtonImageWithImageName:moreBtnImgName space:3 imgDirection:moreBtnImgDirection];
        
        return sectionHeaderView;
    }
    return nil;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    
    if (section == OrderCellType_orderInfo + self.purchaseMuarr.count/*席位最后一个*/ || section == OrderCellType_sevicesOrHetolCell) {
        if (section == OrderCellType_orderInfo + self.purchaseMuarr.count && self.orderStatus == OrderStatus_afterSale && self.addGoodsNum == 0) {
            return nil;
        }
        XKTradingAreaOrderFooterView *sectionFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionFooterViewID];
        if (!sectionFooterView) {
            sectionFooterView = [[XKTradingAreaOrderFooterView alloc] initWithReuseIdentifier:sectionFooterViewID];
            sectionFooterView.backView.xk_openClip = YES;
            sectionFooterView.backView.xk_radius = 5;
            sectionFooterView.backView.xk_clipType = XKCornerClipTypeBottomBoth;
        }
        
        if (section == OrderCellType_sevicesOrHetolCell) {
            if (self.orderStatus == OrderStatus_afterSale) {
                [sectionFooterView setAfterSaleValue:self.orderModel goodsNum:0];
            } else {
                [sectionFooterView setTitleWithTotalPrice:self.goodsPrice tip:nil];
            }
        } else {
            if (self.orderType == OrderDetailType_service) {
                if (self.orderStatus == OrderStatus_afterSale) {
                    [sectionFooterView setAfterSaleValue:self.orderModel goodsNum:self.addGoodsNum];
                } else {
                    [sectionFooterView setTitleWithNum:self.addGoodsNum totalPrice:self.addGoodsPrice payPrice:0];
                }
            } else if (self.orderType == OrderDetailType_offline) {
                if (self.orderStatus == OrderStatus_afterSale) {
                    [sectionFooterView setAfterSaleValue:self.orderModel goodsNum:self.addGoodsNum];
                } else {
                    [sectionFooterView setTitleWithNum:self.addGoodsNum totalPrice:self.addGoodsPrice payPrice:0];
                }
            }
        }
        return sectionFooterView;
    }
    return nil;
}

//
#pragma mark - 侧滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderItems *items;
    NSInteger index = indexPath.section - OrderCellType_orderInfo - 1;
    if (index >= 0 && index < self.purchaseMuarr.count) {
        items = self.purchaseMuarr[index];
        if (items.purchases.count > indexPath.row) {
            PurchasesItem * purchasesItem = items.purchases[indexPath.row];
            //加购订单待接单 且加购商品未支付
            //加购订单已接单=消费中=进行中=消费中  且加购商品未支付
            //加购订单待结算  且加购商品已支付
            if (([purchasesItem.mainStatus isEqualToString:@"STAY_ORDER"] && [purchasesItem.payStatus isEqualToString:@"NOT_PAY"]) ||
                ([purchasesItem.mainStatus isEqualToString:@"CONSUMPTION_CENTRE"] && [purchasesItem.payStatus isEqualToString:@"NOT_PAY"]) ||
                ([purchasesItem.mainStatus isEqualToString:@"STAY_CLEARING"] && [purchasesItem.payStatus isEqualToString:@"SUCCESS_PAY"])) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [XKAlertView showCommonAlertViewWithTitle:@"取消订单需要商家确认，如需退款，相应款项将在订单最终结算时原路退回" leftText:@"确认取消" rightText:@"我不退了" leftBlock:^{
            [self orderManager:indexPath];
        } rightBlock:^{
        }];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderItems *items;
    NSInteger index = indexPath.section - OrderCellType_orderInfo - 1;
    if (index >= 0 && index < self.purchaseMuarr.count) {
        items = self.purchaseMuarr[index];
        if (items.purchases.count) {
            return @"删除";
        }
    }
    return @"";
}


#pragma mark - cusotmBlock

- (void)gotoPayBlock {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoPayAddGoodsItem:)]) {
        //过滤掉没有加购的items
        NSMutableArray *muArr = [NSMutableArray array];
        for (OrderItems *items in self.orderModel.items) {
            if (items.purchases.count) {
                NSMutableArray *purchasesMuArr = [NSMutableArray arrayWithArray:items.purchases];
                for (PurchasesItem *item in items.purchases) {
                    //过滤掉后支付的商品
                    if (item.isFree) {
                        [purchasesMuArr removeObject:item];
                    }
                    //过滤掉不是未支付状态的商品 或者不是
                    if (![item.payStatus isEqualToString:@"NOT_PAY"] || ![item.mainStatus isEqualToString:@"CONSUMPTION_CENTRE"]) {
                        [purchasesMuArr removeObject:item];
                    }
                }
                items.purchases = purchasesMuArr.copy;
                [muArr addObject:items];
            }
        }
        [self.delegate gotoPayAddGoodsItem:muArr];
    }
}

- (void)addressButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addressButtonSelected:lat:lng:)]) {
        [self.delegate addressButtonSelected:self.orderModel.shopName lat:self.orderModel.lat.doubleValue lng:self.orderModel.lng.doubleValue];
    }
}


- (void)shareStoreButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareStoreButtonSelected)]) {
        [self.delegate shareStoreButtonSelected];
    }
}
- (void)phoneButtonClicked:(UIButton *)sender phoneArray:(NSArray *)phoneArr {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(phoneButtonSelected:phoneArray:)]) {
        [self.delegate phoneButtonSelected:sender phoneArray:phoneArr];
    }
}

- (void)addGoodsButtonClicked:(UIButton *)sender {
    
    if (sender.tag == OrderCellType_sevicesOrHetolCell) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(refundSeviceOrHotelItem:)]) {
            [self.delegate refundSeviceOrHotelItem:self.orderModel.items];
        }
    } else {
        if (sender.tag > OrderCellType_orderInfo) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(addGoodsWithShopId:orderId:itemId:)]) {
                OrderItems *items;
                NSInteger index = sender.tag - OrderCellType_orderInfo - 1;
                if (index >= 0 && index < self.purchaseMuarr.count) {
                    items = self.purchaseMuarr[index];
                }
                [self.delegate addGoodsWithShopId:self.orderModel.shopId orderId:self.orderModel.orderId itemId:items.itemId];
            }
        }
        
    }
}


#pragma mark - request

- (void)orderManager:(NSIndexPath *)indexPath {
    
    OrderItems *items;
    PurchasesItem * purchasesItem;
    NSInteger index = indexPath.section - OrderCellType_orderInfo - 1;
    if (index >= 0 && index < self.purchaseMuarr.count) {
        items = self.purchaseMuarr[index];
        if (items.purchases.count > indexPath.row) {
            purchasesItem = items.purchases[indexPath.row];
        }
    }
    //加购订单待接单 且加购商品未支付
    if ([purchasesItem.mainStatus isEqualToString:@"STAY_ORDER"] && [purchasesItem.payStatus isEqualToString:@"NOT_PAY"]) {
        NSArray *arr = @[purchasesItem.orderId];
        [self deletePurchaseOrder:@{@"purchaseOrderIds":arr} index:indexPath.row];
    }
    //加购订单已接单=消费中=进行中=消费中  且加购商品未支付
    else if ([purchasesItem.mainStatus isEqualToString:@"CONSUMPTION_CENTRE"] && [purchasesItem.payStatus isEqualToString:@"NOT_PAY"]) {
        NSArray<PurchasesItem *> *arr = @[purchasesItem];
        [self cancelPurchaseOrder:arr index:indexPath.row];
    }
    //加购订单待结算  且加购商品已支付
    else if ([purchasesItem.mainStatus isEqualToString:@"STAY_CLEARING"] && [purchasesItem.payStatus isEqualToString:@"SUCCESS_PAY"]) {
        NSArray<PurchasesItem *> *arr = @[purchasesItem];
        [self refundPurchaseOrder:arr index:indexPath.row];
    }
}

- (void)deletePurchaseOrder:(NSDictionary *)dic index:(NSUInteger)index {
    
    [XKSquareTradingAreaTool tradingAreaDeletePurchaseOrder:dic success:^(NSInteger status) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(deletePurchaseOrder)]) {
            [self.delegate deletePurchaseOrder];
        }
    } faile:^(XKHttpErrror *error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(deletePurchaseOrder)]) {
            [self.delegate deletePurchaseOrder];
        }
    }];
}

- (void)cancelPurchaseOrder:(NSArray<PurchasesItem *> *)purchaseArr index:(NSUInteger)index {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelPurchaseOrderWithPurchaseItems:)]) {
        [self.delegate cancelPurchaseOrderWithPurchaseItems:purchaseArr];
    }
}

- (void)refundPurchaseOrder:(NSArray<PurchasesItem *> *)purchaseArr index:(NSUInteger)index {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(refundPurchaseOrderWithPurchaseItems:)]) {
        [self.delegate refundPurchaseOrderWithPurchaseItems:purchaseArr];
    }
}

@end
