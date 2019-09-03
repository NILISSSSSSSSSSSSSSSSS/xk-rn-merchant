//
//  XKComplaintsUpPictureTableViewCell.h
//  XKSquare
//
//  Created by Lin Li on 2018/9/5.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^letKeyBoardHidden)(void);
typedef void(^selectItemBlock)(NSIndexPath *indexpath,UICollectionView *collectionView);

@interface XKComplaintsUpPictureTableViewCell : UITableViewCell
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) letKeyBoardHidden block;
@property (nonatomic, copy) selectItemBlock selectBlock;

@end
