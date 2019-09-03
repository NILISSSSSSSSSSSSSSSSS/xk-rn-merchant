//
//  XKStoreRecommendBaseAdapter.h
//  XKSquare
//
//  Created by hupan on 2018/8/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKStoreIntroductionTableViewCell.h"
@class XKTradingAreaGoodsInfoModel;

@protocol XKStoreRecommendBaseAdapterDelegate <NSObject>

@optional
//cell
- (void)adapterTableView:(UITableView *)tableView didSelectRowAtIndex:(NSInteger)index info:(NSDictionary *)info;
//店铺头部轮播图选择
- (void)adapterAutoScrollView:(XKAutoScrollView *)autoScrollView didSelectItem:(XKAutoScrollImageItem *)item index:(NSInteger)index;
//评论图片
- (void)adapterEstimateCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath imgArr:(NSArray *)imgArr;
//店铺信息图片选择
- (void)adapterStoreIntroductionImgCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath imgArr:(NSArray *)imgArr;
//进入店中店
- (void)adapterLookStore:(NSString *)shopId;
//查看跟多
- (void)adapterFooterMoreViewClicked:(NSInteger)moreViewTag shopId:(NSString *)shopId severCode:(NSString *)severCode shopName:(NSString *)shopName;
//查看地址
- (void)addressButtonSelected:(NSString *)addressName lat:(double)lat lng:(double)lng;
//预定
- (void)reservationButtonSelected:(UIButton *)sender phoneArray:(NSArray *)phoneArr cellType:(IntroductionCellType)cellType;
//查看更多评论
- (void)adapterLookMoreEstimate:(NSInteger)type;
//预定与购买
- (void)buyButtonSelected:(NSString *)goodsId goodsDetail:(XKTradingAreaGoodsInfoModel *)goodsDetail type:(NSInteger)type;
//现场购买 外卖 item clicked
- (void)goodsItemSelected:(NSString *)goodsId index:(NSInteger)index;

@end


@interface XKStoreRecommendBaseAdapter : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView                             *tableView;
@property (nonatomic, weak  ) id<XKStoreRecommendBaseAdapterDelegate> delegate;
@property (nonatomic, copy  ) NSArray                                 *dataArray;

@end
