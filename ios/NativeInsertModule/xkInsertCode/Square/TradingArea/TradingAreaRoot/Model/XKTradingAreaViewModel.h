//
//  XKTradingAreaViewModel.h
//  XKSquare
//
//  Created by Lin Li on 2018/10/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XKAutoScrollView;
@class XKAutoScrollImageItem;
NS_ASSUME_NONNULL_BEGIN

/**
 刷新block
 */
typedef void (^reloadDataBlock)(void);

/**
 头部的item点击事件block
 */
typedef void(^headerItemBlock)(UICollectionView *collectionView, NSIndexPath *indexPath,NSString *code ,NSMutableArray *iconArray);

/**
 cell点击的block
 */
typedef void(^cellSelcetBlock)(UITableView *tableView, NSIndexPath *indexPath);

/**
 banner的点击的block
 */
typedef void(^bannerItemBlock)(XKAutoScrollView *autoScrollView, XKAutoScrollImageItem *item ,NSInteger index);

@interface XKTradingAreaViewModel : NSObject <UITableViewDelegate,UITableViewDataSource>

/**
 注册cell
 */
- (void)registerClassForTableView:(UITableView *)tableView;
@property(nonatomic, assign) RefreshDataStatus refreshStatus;
@property(nonatomic, copy) reloadDataBlock reloadDataBlock;
@property(nonatomic, copy) headerItemBlock headerItemBlock;
@property(nonatomic, copy) cellSelcetBlock cellSelcetBlock;
@property(nonatomic, copy) bannerItemBlock bannerItemBlock;
/**商铺列表的数据*/
@property(nonatomic, strong) NSMutableArray *dataArray;
/**
 商铺列表的type（附近和热门）
 */
@property(nonatomic, copy) NSString *orderType;
/**
 商铺列表网络请求
 */
- (void)loadRequestShopListisRefresh:(BOOL)isRefresh WithType:(NSString *)orderType Block:(void(^)(NSMutableArray *array))block;
/**
 头部的item的列表的网络请求
 */
- (void)loadIconListBlock:(void(^)(NSMutableArray *array))block;
- (void)loadBannerBlock:(void(^)(NSMutableArray *array))block;

- (void)refreshAreaToolView;
@end

NS_ASSUME_NONNULL_END
