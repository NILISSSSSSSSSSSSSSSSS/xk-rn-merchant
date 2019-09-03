//
//  XKWelfareBuyCarCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKBaseTableViewCell.h"
#import "XKWelfareBuyCarViewModel.h"
typedef NS_ENUM(NSInteger, XKWelfareBuyCarCellType) {
    XKWelfareBuyCarCellType_Time,
    XKWelfareBuyCarCellType_Progress,
    XKWelfareBuyCarCellType_ProgressAndTime,
    XKWelfareBuyCarCellType_ProgressOrTime,
};
@interface XKWelfareBuyCarCell : XKBaseTableViewCell
@property (nonatomic, copy)void(^calculateBlock)(NSInteger row,NSInteger currentCount);
@property (nonatomic, copy)void(^choseBlock)(NSInteger row,UIButton *sender);
- (void)handleDataModel:(XKWelfareBuyCarItem *)model managerModel:(BOOL)manager;

@end
