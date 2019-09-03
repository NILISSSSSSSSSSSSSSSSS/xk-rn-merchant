//
//  XKSqureToolHeaderView.h
//  XKSquare
//
//  Created by hupan on 2018/8/3.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKAutoScrollView;
@class XKAutoScrollImageItem;

typedef void(^PullDownBlock)(UIButton *sender);
typedef void(^ToolItemBlock)(UICollectionView *collectionView, NSIndexPath *indexPath);
typedef void(^ScrollViewItemBlock)(NSString *jumpAddress, NSUInteger jumpType);

@interface XKSqureToolHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) ToolItemBlock        toolItemBlock;
@property (nonatomic, copy) ScrollViewItemBlock  viewItemBlock;
@property (nonatomic, copy) PullDownBlock        pullDownBlock;

- (void)setBannarView:(NSArray *)arr;
- (void)setHomeToolView:(NSArray *)toolArr isPulled:(BOOL)isPulled;

@end
