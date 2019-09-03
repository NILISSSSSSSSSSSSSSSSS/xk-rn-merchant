//
//  XKVideoHomePageCollectionHeaderView.h
//  XKSquare
//
//  Created by RyanYuan on 2018/10/9.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKVideoHomePageCollectionHeaderView;
@class XKLiveBannerModelListItem;

@protocol XKVideoHomePageCollectionHeaderViewDelegate <NSObject>

//- (void)headerView:(XKVideoHomePageCollectionHeaderView *)headerView clickAnchorControl:(UIControl *)control;
//- (void)headerView:(XKVideoHomePageCollectionHeaderView *)headerView clickMoneyControl:(UIControl *)control;

- (void)headerView:(XKVideoHomePageCollectionHeaderView *)headerView clickBannerWithUrlLink:(NSString *)urlString;

@end

@interface XKVideoHomePageCollectionHeaderView : UICollectionReusableView

@property (nonatomic, weak) id<XKVideoHomePageCollectionHeaderViewDelegate> delegate;

- (void)configHeaderViewWithModel:(NSArray<XKLiveBannerModelListItem *> *)liveBannerModelList;

@end
