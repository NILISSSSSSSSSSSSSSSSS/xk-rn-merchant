/*******************************************************************************
 # File        : XKDropDownList.h
 # Project     : XKSquare
 # Author      : Lin Li
 # Created     : 2018/9/12
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import <UIKit/UIKit.h>

@interface XKDropDownList : UIView
/**
 闭包回调,传值
 */
@property (nonatomic, copy) void(^selectBlock)(NSInteger row, NSString *title);
@property (nonatomic, copy) void(^taptBlock)(void);

// tableview的模型数据
@property (nonatomic, strong) NSArray *dataArray;


/**
 初始化下拉框
 
 @param frame 下拉框的大小
 @param dataArray 数据
 @param view 加载的视图
 @return 实例对象
 */
- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)dataArray onTheView:(UIView *)view;

- (void)reloadData;
@end
