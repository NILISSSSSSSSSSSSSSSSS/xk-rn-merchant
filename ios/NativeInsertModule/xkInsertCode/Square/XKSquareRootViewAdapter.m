//
//  XKSquareRootViewAdapter.m
//  XKSquare
//
//  Created by hupan on 2018/8/7.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSquareRootViewAdapter.h"

//------------view--------------
#import "XKSqureSectionHeaderView.h"
#import "XKSqureSectionFooterView.h"
#import "XKSqureToolHeaderView.h"
#import "XKSqureCarouselAndToolCell.h"
//#import "XKSqureSurpriseTableViewCell.h"
#import "XKSqureSubscriptionTableViewCell.h"
#import "XKSqureRewardTableViewCell.h"
#import "XKSqureStoreRecommendCell.h"
#import "XKSqureMerchantRecommendCell.h"
#import "XKSqureConsultCell.h"
#import "XKSqureFriendCircleCell.h"
#import "XKSqureVideoOfConcernedCell.h"
#import "XKRecommendGamesTableViewCell.h"
#import "XKSqureCommonNoDataCell.h"
#import "XKCommonSheetView.h"
#import "XKSquareUpdateTipsView.h"
#import "XKSquareCouponView.h"

//-----------模型----------------
#import "XKSubscriptionCellModel.h"
#import "XKSquareBannerModel.h"
#import "XKSquareGoodsRecommendModel.h"
#import "XKVideoDisplayModel.h"
#import "XKSqureConsultModel.h"
#import "XKSquareMerchantRecommendModel.h"
#import "XKSquareFriendsCirclelModel.h"
#import "XKSquareHomeToolModel.h"
#import "XKSquareCardCouponModel.h"

static NSString * const carouselAndToolCellID   = @"carouselAndTool";
static NSString * const rewardCellID            = @"rewardCell";
static NSString * const subscriptionCellID      = @"subscriptionCell";
static NSString * const storeRecommendID        = @"storeRecommend";
static NSString * const merchantRecommendCellID = @"merchantRecommendCell";
static NSString * const squreConsultCellID      = @"squreConsultCell";
static NSString * const friendCircleCellID      = @"friendCircleCell";
static NSString * const videoOfConcernedCellID  = @"videoOfConcernedCell";
static NSString * const gamesRecommendCellID    = @"gamesRecommendCell";
static NSString * const noDataCellID            = @"NoDataCellID";

static NSString * const sectionHeaderViewID     = @"sectionHeaderView";
static NSString * const sectionFooterViewID     = @"sectionFooterView";
static NSString * const sectionToolHeaderViewID = @"sectionToolHeaderViewID";

static CGFloat const SectoionHeaderHeight       = 40;
static CGFloat const SectoionFooterHeight       = 40 + 10;

@interface XKSquareRootViewAdapter ()<FriendCircleDelegate>

@property (nonatomic, assign) BOOL             pulled;

//数据源
@property (nonatomic, copy  ) NSArray   *bannerArr;
@property (nonatomic, copy  ) NSArray   *homeToolArr;
@property (nonatomic, copy  ) NSArray   *goodsRecommendArr;
@property (nonatomic, copy  ) NSArray   *videoRecommendArr;
@property (nonatomic, copy  ) NSArray   *squreConsultArr;
@property (nonatomic, copy  ) NSArray   *merchantRecommendArr;
@property (nonatomic, copy  ) NSArray   *friendsCircleRecommendArr;
@property (nonatomic, copy  ) NSArray   *gamesRecommendArr;

@end

@implementation XKSquareRootViewAdapter


#pragma mark - UITableViewDelegate & UITableViewDataSoure

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.subscriptionArray.count + 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == CellType_carouselAndTool || section == CellType_reward || section == CellType_subscription) {
        return 1;
        
    } else {
        XKSubscriptionCellModel *model = self.subscriptionArray[section - 3];
        NSInteger index = model.itemId.integerValue + 3;

        if (index == CellType_storeRecommend || index == CellType_videoOfConcerned) {
            return 1;
        } else if (index == CellType_merchantRecommend) {
            return self.merchantRecommendArr.count ? self.merchantRecommendArr.count : 1;
        } else if (index == CellType_squreConsult) {
            return self.squreConsultArr.count ? self.squreConsultArr.count : 1;
        } else if (index == CellType_friendCircle) {
            return self.friendsCircleRecommendArr.count ? self.friendsCircleRecommendArr.count : 1;
        } else if (index == CellType_gamesRecommend) {
            return self.gamesRecommendArr.count ? self.gamesRecommendArr.count : 1;
        }
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == CellType_carouselAndTool) {
    
        XKSqureCarouselAndToolCell *cell = [tableView dequeueReusableCellWithIdentifier:carouselAndToolCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    } else if (indexPath.section == CellType_reward) {
        
        XKSqureRewardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rewardCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.xk_openClip = YES;
        cell.xk_radius = 5;
        cell.xk_clipType = XKCornerClipTypeBottomLeft | XKCornerClipTypeBottomRight;
        return cell;
        
    } else if (indexPath.section == CellType_subscription) {
        
        XKSqureSubscriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:subscriptionCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.xk_openClip = YES;
        cell.xk_radius = 5;
        cell.xk_clipType = XKCornerClipTypeTopLeft | XKCornerClipTypeTopRight;
        return cell;

    } else {
        
        XKSubscriptionCellModel *model = self.subscriptionArray[indexPath.section - 3];
        NSInteger index = model.itemId.integerValue + 3;

        if (index == CellType_storeRecommend) {
            
            if (self.goodsRecommendArr.count) {
                XKSqureStoreRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:storeRecommendID forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                XKWeakSelf(weakSelf);
                cell.storeRecommendItemBlock = ^(UICollectionView *collectionView, NSIndexPath *indexPath, NSDictionary *dic) {
                    [weakSelf toreRecommendItemClicked:collectionView indexPath:indexPath info:dic];
                };
                [cell setValueWithArr:self.goodsRecommendArr];
                return cell;
                
            } else {
                
                XKSqureCommonNoDataCell *cell = [tableView dequeueReusableCellWithIdentifier:noDataCellID forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell hiddenLineView:YES];
                return cell;
            }
        } else if (index == CellType_merchantRecommend) {
            
            if (self.merchantRecommendArr.count) {
                XKSqureMerchantRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:merchantRecommendCellID forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setValueWithModel:self.merchantRecommendArr[indexPath.row]];
                return cell;
                
            } else {

                XKSqureCommonNoDataCell *cell = [tableView dequeueReusableCellWithIdentifier:noDataCellID forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell hiddenLineView:NO];
                return cell;
            }
            
        } else if (index == CellType_squreConsult) {
            
            if (self.squreConsultArr.count) {
                XKSqureConsultCell *cell = [tableView dequeueReusableCellWithIdentifier:squreConsultCellID forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setValueWithModel:self.squreConsultArr[indexPath.row]];
                return cell;
                
            } else {
                
                XKSqureCommonNoDataCell *cell = [tableView dequeueReusableCellWithIdentifier:noDataCellID forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell hiddenLineView:NO];
                return cell;
            }
            
        } else if (index == CellType_friendCircle) {
            
            if (self.friendsCircleRecommendArr.count) {
                
                XKSqureFriendCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:friendCircleCellID forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
                [cell setValueWithModel:self.friendsCircleRecommendArr[indexPath.row] indexPath:indexPath];
                return cell;
                
            } else {
                
                XKSqureCommonNoDataCell *cell = [tableView dequeueReusableCellWithIdentifier:noDataCellID forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell hiddenLineView:NO];
                return cell;
            }
            
        } else if (index == CellType_videoOfConcerned) {
            
            if (self.videoRecommendArr.count) {
                XKSqureVideoOfConcernedCell *cell = [tableView dequeueReusableCellWithIdentifier:videoOfConcernedCellID forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                XKWeakSelf(weakSelf);
                cell.videoItemBlock = ^(UICollectionView *collectionView, NSIndexPath *indexPath, NSDictionary *dic) {
                    [weakSelf videoItemSelected:collectionView indexPath:indexPath infoDic:dic];
                };
                [cell setValueWithArr:self.videoRecommendArr];
                return cell;
                
            } else {
                XKSqureCommonNoDataCell *cell = [tableView dequeueReusableCellWithIdentifier:noDataCellID forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell hiddenLineView:NO];
                return cell;
            }
            
        } else {
            
            if (self.gamesRecommendArr.count) {
                XKRecommendGamesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:gamesRecommendCellID forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;;
                return cell;
            } else {
                XKSqureCommonNoDataCell *cell = [tableView dequeueReusableCellWithIdentifier:noDataCellID forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell hiddenLineView:NO];
                return cell;
            }
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == CellType_carouselAndTool) {
        NSUInteger onelineCount = 5;
        CGFloat bannarHeight = 150*ScreenScale+20;
        CGFloat toolViewH = 70*ScreenScale;
        NSInteger line = self.homeToolArr.count % onelineCount ? (self.homeToolArr.count / onelineCount + 1) : (self.homeToolArr.count / onelineCount);
        return self.pulled ? (bannarHeight + (toolViewH * line) + 30) : (bannarHeight + toolViewH + 30);
    } else if (section == CellType_reward) {
        return SectoionHeaderHeight;
    } else if (section == CellType_subscription) {
        return 0;
    } else {
        return SectoionHeaderHeight;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == CellType_carouselAndTool || section == CellType_subscription) {
        return 0;
    } else if (section == CellType_reward) {
        return 10;
    } else {
//        XKSubscriptionCellModel *model = self.subscriptionArray[section - 3];
//        NSInteger index = model.itemId.integerValue + 3;
        return SectoionFooterHeight;
    }
    return 10;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == CellType_carouselAndTool) {
        
        XKSqureToolHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionToolHeaderViewID];
        if (!view) {
            view = [[XKSqureToolHeaderView alloc] initWithReuseIdentifier:sectionToolHeaderViewID];
            
            XKWeakSelf(weakSelf);
            view.toolItemBlock = ^(UICollectionView *collectionView, NSIndexPath *indexPath) {
                [weakSelf toolItemClicked:collectionView indexPath:indexPath];
            };
            view.viewItemBlock = ^(NSString *jumpAddress, NSUInteger jumpType) {
                
                [weakSelf autoScrollViewItemSelectedWithJumpType:jumpType jumpAddress:jumpAddress];
            };
            view.pullDownBlock = ^(UIButton *sender) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
                [weakSelf pullDownButtonClicked:sender indexPath:indexPath];
            };
        }
        
        [view setBannarView:self.bannerArr];
        [view setHomeToolView:self.homeToolArr isPulled:self.pulled];
        return view;
        
    } else if (section == CellType_subscription) {
        return nil;
        
    } else {
        
        XKSqureSectionHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionHeaderViewID];
        if (!sectionHeaderView) {
            sectionHeaderView = [[XKSqureSectionHeaderView alloc] initWithReuseIdentifier:sectionHeaderViewID];
            sectionHeaderView.backView.xk_openClip = YES;
            sectionHeaderView.backView.xk_radius = 5;
        }
        
        NSString *title = @"";

        if (section == CellType_reward) {
            sectionHeaderView.backView.xk_clipType = XKCornerClipTypeTopLeft | XKCornerClipTypeTopRight;
            title = @"中奖信息";
        } else {
            
            XKSubscriptionCellModel *model = self.subscriptionArray[section - 3];
            NSInteger index = model.itemId.integerValue + 3;
            
            if (section == 3) {
                sectionHeaderView.backView.xk_clipType = XKCornerClipTypeNone;
            } else {
                sectionHeaderView.backView.xk_clipType = XKCornerClipTypeTopLeft | XKCornerClipTypeTopRight;
            }
            if (index == CellType_storeRecommend) {
                title = @"商城推荐";
            } else if (index == CellType_merchantRecommend) {
                title = @"商家推荐";
            } else if (index == CellType_squreConsult) {
                title = @"广场资讯";
            } else if (index == CellType_friendCircle) {
                title = @"我的朋友圈";
            } else if (index == CellType_videoOfConcerned) {
                title = @"小视频推荐";
            } else if (index == CellType_gamesRecommend) {
                title = @"游戏推荐";
            }
        }
        [sectionHeaderView setTitleName:title];
        return sectionHeaderView;

    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section >= 3) {
        
        XKSubscriptionCellModel *model = self.subscriptionArray[section - 3];
        NSInteger index = model.itemId.integerValue + 3;

        XKSqureSectionFooterView *sectionFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionFooterViewID];
        if (!sectionFooterView) {
            sectionFooterView = [[XKSqureSectionFooterView alloc] initWithReuseIdentifier:sectionFooterViewID];
            [sectionFooterView setFooterViewImg:[UIImage imageNamed:@"xk_btn_home_sectionFooter_more"]];
            sectionFooterView.backView.xk_openClip = YES;
            sectionFooterView.backView.xk_radius = 5;
            sectionFooterView.backView.xk_clipType = XKCornerClipTypeBottomLeft | XKCornerClipTypeBottomRight;
        }
        if (index == CellType_storeRecommend) {
            [sectionFooterView hiddenLineView:NO];
        } else {
            [sectionFooterView hiddenLineView:YES];
        }
        [sectionFooterView setFooterButtonTag:index];
        
        XKWeakSelf(weakSelf);
        sectionFooterView.footerViewBlock = ^(UIButton *sender) {
            [weakSelf footerMoreViewClicked:sender];
        };
        return sectionFooterView;

    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == CellType_carouselAndTool || indexPath.section == CellType_reward ||indexPath.section == CellType_subscription) {
        if (_delegate && [_delegate respondsToSelector:@selector(adapterTableView:didSelectRowAtIndexPath:infoDic:)]) {
            [_delegate adapterTableView:tableView didSelectRowAtIndexPath:indexPath infoDic:nil];
        }
    } else if (indexPath.section >= 3) {
        XKSubscriptionCellModel *model = self.subscriptionArray[indexPath.section - 3];
        NSInteger index = model.itemId.integerValue + 3;
        
        if ((index == CellType_storeRecommend && !self.goodsRecommendArr.count) ||
            (index == CellType_merchantRecommend && !self.merchantRecommendArr.count) ||
            (index == CellType_squreConsult && !self.squreConsultArr.count) ||
            (index == CellType_friendCircle && !self.friendsCircleRecommendArr.count) ||
            (index == CellType_videoOfConcerned && !self.videoRecommendArr.count) ||
            (index == CellType_gamesRecommend && !self.gamesRecommendArr.count)) {
            return;
        }
        
        NSDictionary *infoDic = nil;
        if (index == CellType_friendCircle) {
            FriendsCirclelListItem *item = self.friendsCircleRecommendArr[indexPath.row];
            infoDic = @{@"did":item.did ? item.did : @""};
        } else if (index == CellType_merchantRecommend) {
            MerchantRecommendItem *item = self.merchantRecommendArr[indexPath.row];
            infoDic = @{@"itemId":item.itemId ? item.itemId : @""};
        } else if (index == CellType_squreConsult) {
            ConsultItemModel *item = self.squreConsultArr[indexPath.row];
            infoDic = @{@"url":item.url ? item.url : @"",
                        @"imgUrl":item.image ? item.image : @"",
                        @"title":item.title ? item.title : @"",
                        @"content":item.content ? item.content : @"",
                        };
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(adapterTableView:didSelectRowAtIndexPath:infoDic:)]) {
            [_delegate adapterTableView:tableView didSelectRowAtIndexPath:indexPath infoDic:infoDic];
        }
    }
    
}

#pragma mark - request

- (void)requestLaunchAdvertisementData {
    
}

// 请求更新信息
- (void)requestUpdateInfoData {
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"] forKey:@"clientVersion"];
    
    [HTTPClient postEncryptRequestWithURLString:[XKAPPNetworkConfig getAppVersionCheckUrl] timeoutInterval:20.0 parameters:para success:^(id responseObject) {
        if (responseObject) {
            NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            // 服务器返回版本
            NSInteger theVersion = [dict[@"defVersion"] integerValue];
            
            NSArray <NSString *>*versionArray = [[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"] componentsSeparatedByString:@"."];
            // 本地版本好 将版本号转换为数字 版本规则为 X.X.X X范围为0～99
            NSInteger localVersion = 0;
            if (versionArray.count >= 1) {
                localVersion += 10000 * versionArray[0].integerValue;
            }
            if (versionArray.count >= 2) {
                localVersion += 100 * versionArray[1].integerValue;
            }
            if (versionArray.count >= 3) {
                localVersion += versionArray[2].integerValue;
            }
            if (localVersion > theVersion) {
                // 本地版本号大于最新稳定版本号，说明是审核包

            } else if (localVersion < theVersion) {
                // 本地版本号小于最新稳定版本号，则需要更新
                XKCommonSheetView *sheetView = [[XKCommonSheetView alloc] init];
                XKSquareUpdateTipsView *updateView = [[XKSquareUpdateTipsView alloc] init];
                updateView.frame = CGRectMake(0.0, kStatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusBarHeight);
                updateView.versionStr = [NSString stringWithFormat:@"%tu.%tu.%tu", theVersion / 10000, theVersion % 10000 / 100, theVersion % 10000 % 100 / 1];
                updateView.updateContent = dict[@"updateMessage"];
                if ([AFNetworkReachabilityManager sharedManager].isReachableViaWiFi) {
                    // WIFI环境
                    updateView.remarkContent = @"您的版本过低，需更新后才能正常使用";
                    updateView.updateBtnTitle = @"立即更新";
                } else {
                    // 非WIFI环境
                    updateView.remarkContent = [NSString stringWithFormat:@"您当前网络环境为移动网络，新版本大小为%.2fM，确定更新吗？", [dict[@"appSize"] doubleValue]];
                    updateView.updateBtnTitle = @"确认更新";
                }
                [updateView setCloseBtnHidden:[dict[@"isForce"] boolValue]];
                updateView.closeBtnBlock = ^{
                    [sheetView dismiss];
                    [self requestSquareCardCouponsData];
                };
                updateView.updateBtnBlock = ^{
                    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:dict[@"url"]]]) {
                        if (@available(iOS 10, *)) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dict[@"url"]] options:@{} completionHandler:nil];
                        } else {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dict[@"url"]]];
                        }
                    }
                    if (![dict[@"isForce"] boolValue]) {
                        [sheetView dismiss];
                        [self requestSquareCardCouponsData];
                    }
                };
                sheetView.animationWay = AnimationWay_centerShow;
                sheetView.contentView = updateView;
                [sheetView addSubview:updateView];
                [sheetView show];
            } else {

            }
        }
    } failure:^(XKHttpErrror *error) {
        NSLog(@"首页版本检查接口：%@", error.message);
        [self requestSquareCardCouponsData];
    }];
}

// 请求首页卡券数据
- (void)requestSquareCardCouponsData {
    
    [HTTPClient postEncryptRequestWithURLString:[XKAPPNetworkConfig getSquareCardCouponListUrl] timeoutInterval:20.0 parameters:nil success:^(id responseObject) {
        if (responseObject) {
            NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            if (array.count) {
                if ([[self getCurrentUIVC] isKindOfClass:NSClassFromString(@"XKSquareRootViewController")]) {
                    NSArray *temp = [NSArray yy_modelArrayWithClass:[XKSquareCardCouponModel copy] json:array];
                    XKCommonSheetView *sheetView = [[XKCommonSheetView alloc] init];
                    CGFloat height = 80 * 3 + 130 * ScreenScale + 40;
                    XKSquareCouponView *cardCouponView = [[XKSquareCouponView alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT / 2 - height / 2, SCREEN_WIDTH - 40, height)];
                    cardCouponView.transform = CGAffineTransformMakeScale(0, 0);
                    cardCouponView.layer.masksToBounds = YES;
                    cardCouponView.layer.cornerRadius = 5;
                    sheetView.animationWay = AnimationWay_centerShow;
                    sheetView.contentView = cardCouponView;
                    [sheetView addSubview:cardCouponView];
                    [sheetView show];
                    cardCouponView.cardCoupons = temp;
                    cardCouponView.useBtnBlock = ^(XKSquareCardCouponModel *theCardCoupon) {
                        
                    };
                    cardCouponView.closeBlock = ^{
                        [sheetView dismiss];
                    };
                    [sheetView show];
                }
            }
        }
    } failure:^(XKHttpErrror *error) {
        NSLog(@"首页优惠券列表接口：%@", error.message);
    }];
}


//轮播图
- (void)requestBannerData {
    
    [self postRequestWithURLStr:GetSquareBannerUrl parameters:@{@"regionCode":self.cityCode ? self.cityCode : @"510100", @"bannerModule":@"XKSQUARE"} timeoutInterval:20.0];

}

//home工具接口
- (void)requestSquareHomeToolData {
    [self postRequestWithURLStr:GetSquareHomeToolUrl parameters:nil timeoutInterval:20.0];
}

//抽奖信息
- (void)requestSqureRewardData {
    [self postRequestWithURLStr:GetSqureRewardUrl parameters:nil timeoutInterval:20.0];
}


//商城的商品推荐
- (void)requestStoreRecommendData {
    NSDictionary *parmDic = @{@"page":@1,
                              @"limit":@3,
                              @"condition":@{@"districtCode":self.cityCode ? self.cityCode : @"510100"}};
    
    [self postRequestWithURLStr:GetSquareStoreRecommendUrl parameters:parmDic timeoutInterval:20.0];
}


//请求商圈商家推荐
- (void)requestMerchantRecommendData {
    NSDictionary *parmDic = @{@"page":@"1",
                              @"limit":@"3",
                              @"lng":@(self.lng),
                              @"lat":@(self.lat)};
    [self postRequestWithURLStr:GetSquareMerchantRecommendUrl parameters:parmDic timeoutInterval:20.0];
}


//广场资讯
- (void)requestSquareConsultData {
    [self postRequestWithURLStr:GetSquareConsultUrl parameters:@{@"page":@"1", @"limit":@"3"} timeoutInterval:20.0];
}

//朋友圈推荐
- (void)requestSquareFriendsCircleRecommendData {
    [self postRequestWithURLStr:GetSquareFriendsCircleRecommendUrl parameters:@{@"page":@"1", @"limit":@"3"} timeoutInterval:20.0];
}

//小视频推荐
- (void)requestVideoRecommendData {
    
    NSString *rand = [XKUserInfo getCurrentRecommendVideoRand] ? [XKUserInfo getCurrentRecommendVideoRand] : @"";
    NSDictionary *params = @{@"rand":rand,
                             @"page":@"0",
                             @"limit":@"4"};
    [XKZBHTTPClient postRequestWithURLString:GetSquareVideoRecommendUrl
                             timeoutInterval:20.0
                                  parameters:params
                                     success:^(id responseObject) {
                                        XKVideoDisplayModel *model =  [XKVideoDisplayModel yy_modelWithJSON:responseObject];
                                        NSString *rand = model.body.rand;
                                         [XKUserInfo currentUser].recommendVideoRand = rand;
                                         [XKUserInfo synchronizeUser];
                                        self.videoRecommendArr = model.body.video_list;

                                         dispatch_group_leave(self.group);
                                    } failure:^(XKHttpErrror *error) {
                                        dispatch_group_leave(self.group);
                                        [XKHudView showErrorMessage:error.message];
                                    }];
}

//游戏推荐
- (void)requestGamesRecommendData {
    [self postRequestWithURLStr:GetSquareGamesRecommendUrl parameters:nil timeoutInterval:20.0];
}


- (void)postRequestWithURLStr:(NSString *)url parameters:(NSDictionary *)parameters timeoutInterval:(NSUInteger)timeoutInterval {
    
    [HTTPClient postEncryptRequestWithURLString:url
                                timeoutInterval:timeoutInterval
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            if (responseObject) {
                                                
                                                if ([url isEqualToString:GetSquareBannerUrl]) {//轮播
                                                    NSLog(@"轮播请求成功");
                                                    NSArray *arr = [NSArray yy_modelArrayWithClass:[XKSquareBannerModel class] json:responseObject];
                                                    self.bannerArr = arr;
                                                    [self.tableView reloadData];
                                                    
                                                } else if ([url isEqualToString:GetSquareHomeToolUrl]) {//工具
                                                    NSLog(@"工具请求成功");
                                                    NSArray *iconArr = [NSArray yy_modelArrayWithClass:[XKSquareHomeToolModel class] json:responseObject];
                                                    if (iconArr.count) {
                                                        self.homeToolArr = [self reSaveHomeIcon:iconArr];
                                                    }
                                                    
                                                } else if ([url isEqualToString:GetSqureRewardUrl]) {//抽奖
                                                     NSLog(@"抽奖请求成功");
                                                    
                                                } else if ([url isEqualToString:GetSquareStoreRecommendUrl]) {//商品推荐
                                                    NSLog(@"商品请求成功");
                                                    XKSquareGoodsRecommendModel *model = [XKSquareGoodsRecommendModel yy_modelWithJSON:responseObject];
                                                    self.goodsRecommendArr = model.data;
                                                    
                                                } else if ([url isEqualToString:GetSquareMerchantRecommendUrl]) {//商家推荐
                                                    NSLog(@"商家请求成功");
                                                    XKSquareMerchantRecommendModel *model = [XKSquareMerchantRecommendModel yy_modelWithJSON:responseObject];
                                                    self.merchantRecommendArr = model.data;
                                                    
                                                } else if ([url isEqualToString:GetSquareConsultUrl]) {//广场资讯
                                                    NSLog(@"广场资讯请求成功");
                                                    XKSqureConsultModel *model = [XKSqureConsultModel yy_modelWithJSON:responseObject];
                                                    self.squreConsultArr = model.data;
                                                    
                                                } else if ([url isEqualToString:GetSquareFriendsCircleRecommendUrl]) {//朋友圈
                                                    NSLog(@"朋友圈请求成功");
                                                    XKSquareFriendsCirclelModel *model = [XKSquareFriendsCirclelModel yy_modelWithJSON:responseObject];
                                                    self.friendsCircleRecommendArr = model.list;
                                                    
                                                } else if ([url isEqualToString:GetSquareGamesRecommendUrl]) {//游戏推荐
                                                    NSLog(@"游戏请求成功");
                                                    
                                                }
                                            }
                                            dispatch_group_leave(self.group);
                                        } failure:^(XKHttpErrror *error) {
                                            dispatch_group_leave(self.group);
                                            [XKHudView showErrorMessage:error.message];
                                        }];
    
}

#pragma mark - Custom Block

//工具item
- (void)toolItemClicked:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(adapterToolItemClicked:indexPath:itemCode:)]) {
        XKSquareHomeToolModel *model = nil;
        if (indexPath.section * 5 + indexPath.row < self.homeToolArr.count) {
            model = self.homeToolArr[indexPath.section * 5 + indexPath.row];
        }
        [_delegate adapterToolItemClicked:collectionView indexPath:indexPath itemCode:model.code];
    }
}
//工具下拉条
- (void)pullDownButtonClicked:(UIButton *)sender indexPath:(NSIndexPath *)indexPath{
    self.pulled = sender.selected;
    
    if (_delegate && [_delegate respondsToSelector:@selector(adapterPullDownButtonClicked:cellIndexPath:)]) {
        [_delegate adapterPullDownButtonClicked:sender cellIndexPath:indexPath];
    }
}
//轮播图
- (void)autoScrollViewItemSelectedWithJumpType:(NSUInteger)jumpType jumpAddress:(NSString *)jumpAddress {
    
if (_delegate && [_delegate respondsToSelector:@selector(adapterAutoScrollViewItemSelectedWithJumpType:jumpAddress:)]) {
        [_delegate adapterAutoScrollViewItemSelectedWithJumpType:jumpType jumpAddress:jumpAddress];
    }
}


//商城推荐
- (void)toreRecommendItemClicked:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath info:(NSDictionary *)info {
    
    if (_delegate && [_delegate respondsToSelector:@selector(adapterStoreRecommendCollectionView:didSelectRowAtIndexPath:info:)]) {
        [_delegate adapterStoreRecommendCollectionView:collectionView didSelectRowAtIndexPath:indexPath info:info];
    }
}


- (void)footerMoreViewClicked:(UIButton *)sender {

    if (self.delegate && [self.delegate respondsToSelector:@selector(footerMoreViewSelected:)]) {
        [self.delegate footerMoreViewSelected:sender.tag];
    }
}

- (void)likeBtnClicked:(XKSqureFriendCircleCell *)cell sender:(UIButton *)sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.row < self.friendsCircleRecommendArr.count - 1) {
        FriendsCirclelListItem *model = self.friendsCircleRecommendArr[indexPath.row];
        model.isLike = sender.selected;
        NSMutableArray *muArr = [NSMutableArray arrayWithArray:self.friendsCircleRecommendArr];
        [muArr replaceObjectAtIndex:indexPath.row withObject:model];
        self.friendsCircleRecommendArr = [muArr copy];
    }
}

- (void)unfoldButtonClick:(XKSqureFriendCircleCell *)cell index:(NSInteger)index {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    if (indexPath.row < self.friendsCircleRecommendArr.count) {
        FriendsCirclelListItem *model = self.friendsCircleRecommendArr[indexPath.row];
        model.unfold = !model.unfold;
        NSMutableArray *muArr = [NSMutableArray arrayWithArray:self.friendsCircleRecommendArr];
        [muArr replaceObjectAtIndex:indexPath.row withObject:model];
        self.friendsCircleRecommendArr = [muArr copy];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)friendCircleCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath imgUrlArr:(NSArray *)imgUrlArr {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(adapterFriendsCircleCollectionView:didSelectItemAtIndexPath:imgUrlArr:)]) {
        [self.delegate adapterFriendsCircleCollectionView:collectionView didSelectItemAtIndexPath:indexPath imgUrlArr:imgUrlArr];
    }
}


- (void)videoItemSelected:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath infoDic:(NSDictionary *)dic {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoRecommendItemSelected:indexPath:infoDic:)]) {
        [self.delegate videoRecommendItemSelected:collectionView indexPath:indexPath infoDic:dic];
    }
}



#pragma mark - privice

- (void)registerAllCells {
    
    [self.tableView registerClass:[XKSqureCarouselAndToolCell class] forCellReuseIdentifier:carouselAndToolCellID];
    [self.tableView registerClass:[XKSqureRewardTableViewCell class] forCellReuseIdentifier:rewardCellID];
    [self.tableView registerClass:[XKSqureSubscriptionTableViewCell class] forCellReuseIdentifier:subscriptionCellID];
    [self.tableView registerClass:[XKSqureStoreRecommendCell class] forCellReuseIdentifier:storeRecommendID];
    [self.tableView registerClass:[XKSqureMerchantRecommendCell class] forCellReuseIdentifier:merchantRecommendCellID];
    [self.tableView registerClass:[XKSqureConsultCell class] forCellReuseIdentifier:squreConsultCellID];
    [self.tableView registerClass:[XKSqureFriendCircleCell class] forCellReuseIdentifier:friendCircleCellID];
    [self.tableView registerClass:[XKSqureVideoOfConcernedCell class] forCellReuseIdentifier:videoOfConcernedCellID];
    [self.tableView registerClass:[XKRecommendGamesTableViewCell class] forCellReuseIdentifier:gamesRecommendCellID];
    [self.tableView registerClass:[XKSqureCommonNoDataCell class] forCellReuseIdentifier:noDataCellID];
    //工具栏给个默认的几个工具
    [self configBaseData];
}


- (NSArray *)reSaveHomeIcon:(NSArray *)iconArr {
    
    XKUserInfo *info =  [XKUserInfo currentUser];

    NSMutableArray *fixedArr =  [NSMutableArray array];
    NSMutableArray *notFixedArr =  [NSMutableArray array];
    for (XKSquareHomeToolModel *item in iconArr) {
        if (item.moveEnable) {
            [notFixedArr addObject:item];
        } else {
            [fixedArr addObject:item];
        }
    }
    //保存系统的
    info.xkHomeSysIcon = [fixedArr yy_modelToJSONString];
    [XKUserInfo saveCurrentUser:info];

    return [XKGlobleCommonTool recombineIconArrWithFixedArr:fixedArr notFixedArr:notFixedArr iconType:BannerIconType_home];
    
}


- (void)configBaseData {
    
    NSMutableArray *muArr = [NSMutableArray array];

    XKUserInfo *info = [XKUserInfo currentUser];
    NSArray *sysIconArr = [NSArray yy_modelArrayWithClass:[XKSquareHomeToolModel class] json:info.xkHomeSysIcon];
    if (sysIconArr.count == 0) {
        NSArray *defaultArr = @[@{@"name":@"积分夺奖", @"code":@"101", @"icon":@"xk_btn_home_welfare", @"iconInLocation":@(YES)},
                                @{@"name":@"精选商城", @"code":@"102", @"icon":@"xk_btn_home_store", @"iconInLocation":@(YES)},
                                @{@"name":@"口碑商圈", @"code":@"103", @"icon":@"xk_btn_home_neardy", @"iconInLocation":@(YES)},
                                @{@"name":@"小视频", @"code":@"104", @"icon":@"xk_btn_home_smallVideo", @"iconInLocation":@(YES)},
                                @{@"name":@"游戏中心", @"code":@"105", @"icon":@"xk_btn_home_games", @"iconInLocation":@(YES)},
                                @{@"name":@"更多", @"code":@"1", @"icon":@"xk_btn_home_more", @"iconInLocation":@(YES)}];
        for (NSDictionary *dic in defaultArr) {
            XKSquareHomeToolModel *item = [XKSquareHomeToolModel yy_modelWithDictionary:dic];
            [muArr addObject:item];
        }
        
    } else {
        [muArr addObjectsFromArray:sysIconArr];
        XKSquareHomeToolModel *item = [XKSquareHomeToolModel yy_modelWithDictionary:@{@"name":@"更多",@"code":@"1", @"icon":@"xk_btn_home_more", @"iconInLocation":@(YES)}];
        [muArr addObject:item];
    }
    self.homeToolArr = [NSArray arrayWithArray:muArr.copy];
}


- (void)refreshHomeToolView {
    
    NSArray *sysIconArr = [NSArray yy_modelArrayWithClass:[XKSquareHomeToolModel class] json:[XKUserInfo currentUser].xkHomeSysIcon];
    NSMutableArray *sysMuarr = [NSMutableArray arrayWithArray:sysIconArr];

    NSArray *optionIconArr = [NSArray yy_modelArrayWithClass:[XKSquareHomeToolModel class] json:[XKUserInfo currentUser].xkHomeOptionalIcon];
    NSMutableArray *optionMuarr = [NSMutableArray arrayWithArray:optionIconArr];

    self.homeToolArr = [XKGlobleCommonTool recombineIconArrWithFixedArr:sysMuarr notFixedArr:optionMuarr iconType:BannerIconType_home];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:CellType_carouselAndTool] withRowAnimation:UITableViewRowAnimationNone];
}

- (dispatch_group_t)group {
    if (!_group) {
        _group = dispatch_group_create();
    }
    return _group;
}

@end
