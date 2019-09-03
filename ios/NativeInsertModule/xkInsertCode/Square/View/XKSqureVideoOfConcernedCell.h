//
//  XKSqureVideoOfConcernedCell.h
//  XKSquare
//
//  Created by hupan on 2018/10/16.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^VideoOfConcernedTiemBlock)(UICollectionView *collectionView, NSIndexPath *indexPath, NSDictionary *dic);

@interface XKSqureVideoOfConcernedCell : UITableViewCell

@property (nonatomic, copy  ) VideoOfConcernedTiemBlock  videoItemBlock;

- (void)setValueWithArr:(NSArray *)recommendModelArr;

@end
