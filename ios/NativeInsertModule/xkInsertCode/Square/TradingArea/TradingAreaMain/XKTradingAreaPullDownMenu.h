//
//  XKTradingAreaPullDownMenu.h
//  XKSquare
//
//  Created by hupan on 2018/10/8.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XKTradingAreaPullDownMenuDelegate <NSObject>

- (void)selectedKeyWord:(NSString *)keyWord indexPath:(NSIndexPath *)indexPath currentMenuIndex:(NSInteger)index;

@end

@interface XKTradingAreaPullDownMenu : UIView

/* 二维数组，存放每个Button对应下的TableView数据。。 */
@property (nonatomic,strong) NSMutableArray                       *menuDataArray;
@property (nonatomic, weak) id<XKTradingAreaPullDownMenuDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame menuTitleArray:(NSArray *)titleArray;

/*!@brief 数据源如果改变的话需调用此方法刷新数据。 */
- (void)setDefauldSelectedCell;

- (void)addPullTableView;
- (void)addPullMaskingView;
//收回
- (void)takeBackTableView;

/*
 参数1：所选择的按钮位置
 参数2：所选择的项目位置
 */
- (void)selectedAtIndex:(NSInteger)index items:(NSInteger)items;

@end

@interface DownMenuCell : UITableViewCell

@property (nonatomic) BOOL  isSelected;

@end
