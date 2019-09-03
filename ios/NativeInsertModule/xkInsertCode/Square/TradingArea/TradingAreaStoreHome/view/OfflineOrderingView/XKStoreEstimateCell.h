//
//  XKStoreEstimateCell.h
//  XKSquare
//
//  Created by hupan on 2018/8/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentListItem;

@protocol StoreEstimateDelegate <NSObject>

@optional
- (void)unfoldButtonClick:(UITableViewCell *)cell;
- (void)estimateCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath imgArr:(NSArray *)imgArr;

@end

@interface XKStoreEstimateCell : UITableViewCell

@property (nonatomic, weak  ) id<StoreEstimateDelegate> delegate;

- (void)setValueWithModel:(CommentListItem *)model;
- (void)hiddenLine:(BOOL)hidden;

@end
