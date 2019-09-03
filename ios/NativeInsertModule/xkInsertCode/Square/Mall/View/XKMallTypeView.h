//
//  XKMallTypeView.h
//  XKSquare
//
//  Created by hupan on 2018/9/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TypeView_mall,//商城
    TypeView_tradingArea,
} TypeView;

@interface XKMallTypeView : UIView

@property (nonatomic, assign) TypeView typeView;
@property(nonatomic, copy)void(^collectionBlock)(UIButton *sender);
@property(nonatomic, copy)void(^choseIndexBlock)(NSInteger firstCode, NSInteger firstIndex, NSInteger secondCode, NSInteger secondIndex, NSString *secondName);

- (void)updateDataSourceForDataSource:(NSArray *)dataSource forIndex:(NSInteger)index;
- (void)updateDataSourceForLeftDataSource:(NSArray *)leftDataSource rightDataSource:(NSArray *)rightDataSource forIndex:(NSInteger)index;


@end
