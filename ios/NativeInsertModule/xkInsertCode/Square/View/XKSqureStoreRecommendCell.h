//
//  XKSqureStoreRecommendCell.h
//  XKSquare
//
//  Created by hupan on 2018/8/6.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^StoreRecommendItemBlock)(UICollectionView *collectionView, NSIndexPath *indexPath, NSDictionary *dic);

@interface XKSqureStoreRecommendCell : UITableViewCell

@property (nonatomic, copy  ) StoreRecommendItemBlock  storeRecommendItemBlock;

- (void)setValueWithArr:(NSArray *)recommendModelArr;

@end
