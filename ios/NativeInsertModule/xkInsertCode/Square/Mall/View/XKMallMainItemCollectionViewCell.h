//
//  XKMainItemCollectionViewCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKMallMainItemCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) void (^choseBlock)(NSInteger index);
@property (nonatomic, strong) NSArray  *dataSourceArr;
//0  自营 1 福利   先这么写 留着优化
@property (nonatomic, assign) NSInteger  type;
@end
