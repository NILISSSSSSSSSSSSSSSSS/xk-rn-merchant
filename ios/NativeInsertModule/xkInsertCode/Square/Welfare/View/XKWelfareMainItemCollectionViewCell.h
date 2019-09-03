//
//  XKWelfareMainItemCollectionViewCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/11/23.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKWelfareMainItemCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) void (^choseBlock)(NSInteger index);
@property (nonatomic, strong) NSArray  *dataSourceArr;
@end

NS_ASSUME_NONNULL_END
