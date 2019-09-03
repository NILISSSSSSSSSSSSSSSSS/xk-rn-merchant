//
//  XKWelfareListDoubleCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKBaseCollectionViewCell.h"
#import "XKWelfareGoodsListViewModel.h"
typedef NS_ENUM(NSInteger, WelfareListDoubleCellType) {
    WelfareListDoubleCellType_Time,
    WelfareListDoubleCellType_Progress,
    WelfareListDoubleCellType_ProgressAndTime,
    WelfareListDoubleCellType_ProgressOrTime,
};
@interface XKWelfareListDoubleCell : XKBaseCollectionViewCell

- (instancetype)WelfareListDoubleCellWithType:(WelfareListDoubleCellType)cellType;

- (void)bindData:(WelfareDataItem *)item;
@end
