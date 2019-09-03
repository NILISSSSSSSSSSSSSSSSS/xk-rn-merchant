//
//  XKStoreInStoreOnlySevericeTableViewCell.h
//  XKSquare
//
//  Created by hupan on 2018/10/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ItemBlock)(UICollectionView *collectionView, NSIndexPath *indexPath);

@interface XKStoreInStoreOnlySevericeTableViewCell : UITableViewCell

@property (nonatomic, copy  ) ItemBlock       itemBlock;

@end
