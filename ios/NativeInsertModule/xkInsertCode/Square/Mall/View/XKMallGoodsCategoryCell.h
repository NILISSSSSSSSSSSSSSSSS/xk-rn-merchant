//
//  XKMallGoodsCategoryCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/16.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger ,ItemStatus) {
    ItemStatusChose,
    ItemStatusDelete,
    ItemStatusNone
};
@interface XKMallGoodsCategoryCell : UICollectionViewCell
@property (nonatomic, strong) NSIndexPath  *index;
@property (nonatomic, copy) void(^choseBlock)(NSIndexPath *index, UIButton *sender);

- (void)updateStatus:(ItemStatus )status withTitle:(NSString *)title;
@end
