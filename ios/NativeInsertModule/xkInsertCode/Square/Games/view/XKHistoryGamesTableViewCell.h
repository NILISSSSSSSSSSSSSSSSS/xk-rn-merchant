//
//  XKHistoryGamesTableViewCell.h
//  XKSquare
//
//  Created by hupan on 2018/9/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^HistoryGamesItemBlock)(UICollectionView *collectionView, NSIndexPath *indexPath, NSDictionary *dic);

@interface XKHistoryGamesTableViewCell : UITableViewCell

@property (nonatomic, copy  ) HistoryGamesItemBlock  historyGamesItemBlock;

@end
