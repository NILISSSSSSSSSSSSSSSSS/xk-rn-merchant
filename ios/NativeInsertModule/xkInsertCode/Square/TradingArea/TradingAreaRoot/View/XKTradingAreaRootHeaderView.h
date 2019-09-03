//
//  XKTradingAreaRootHeaderView.h
//  XKSquare
//
//  Created by Lin Li on 2018/10/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XKAutoScrollView;
@class XKAutoScrollImageItem;

NS_ASSUME_NONNULL_BEGIN
typedef void(^iconHeaderItemBlock)(UICollectionView *collectionView, NSIndexPath *indexPath ,NSString *code);
typedef void(^ScrollViewItemBlock)(XKAutoScrollView *autoScrollView, XKAutoScrollImageItem *item ,NSInteger index);

@interface XKTradingAreaRootHeaderView : UITableViewHeaderFooterView
@property (nonatomic, copy) iconHeaderItemBlock        headerItemBlock;
@property (nonatomic, copy) ScrollViewItemBlock    viewItemBlock;
@property (nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong)UICollectionViewFlowLayout *flowLayout;

/**icon dataArray*/
@property(nonatomic, strong) NSMutableArray *dataArray;

/**
 设置banner图

 @param bannerAarray bannerArray
 */
- (void)loopViewImageArray:(NSMutableArray *)bannerAarray;

/**
 更新设置icon视图的高度
 */
- (void)reloadLayoutToolBackView;
@end

NS_ASSUME_NONNULL_END
