//
//  XKBottomAlertSheetView.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/31.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKBottomAlertSheetView : UIView

@property (nonatomic, copy)NSArray *dataSource;
/**
 view
 @param dataSource 从上到下的标题数组  包括最后的取消
 @param color 第一个cell的颜色  传nil默认222222
 @param choseBlock 选择标题后的回调
 @return view
 */


- (instancetype)initWithBottomSheetViewWithDataSource:(NSArray *)dataSource firstTitleColor:(UIColor *)color choseBlock:(void(^)(NSInteger index, NSString *choseTitle))choseBlock;


- (void)show;

- (void)dismissSelf;

- (void)updataData;
@end
