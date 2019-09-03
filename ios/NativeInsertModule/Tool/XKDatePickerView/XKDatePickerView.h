//
//  XKDatePickerView.h
//  XKSquare
//
//  Created by Lin Li on 2018/9/5.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XKDatePickerViewDelegate <NSObject>

/**
 保存按钮代理方法
 
 @param time 选择的数据
 */
- (void)datePickerViewSaveBtnClickDelegate:(NSString *)time;
@optional
/**
 取消按钮代理方法
 */
- (void)datePickerViewCancelBtnClickDelegate;

@end
@interface XKDatePickerView : UIView
@property (weak, nonatomic) id <XKDatePickerViewDelegate> delegate;

@property (nonatomic, copy) NSString *CurrentDate;

/**
 显示  必须调用
 */
- (void)show;
@end
