//
//  XKWelfareListSingleCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKBaseCollectionViewCell.h"
#import "XKWelfareGoodsListViewModel.h"
typedef NS_ENUM(NSInteger, WelfareListSingleCellType) {
    WelfareListSingleCellType_Time,
    WelfareListSingleCellType_Progress,
    WelfareListSingleCellType_ProgressAndTime,
    WelfareListSingleCellType_ProgressOrTime,
};
@interface XKWelfareListSingleCell : XKBaseCollectionViewCell

- (instancetype)WelfareListSingleCellWithType:(WelfareListSingleCellType)cellType;
//layoutType 1 新首页 铺满  0 其他有空隙
- (void)bindData:(WelfareDataItem *)item WithType:(NSInteger)layoutType;

@end
