/*******************************************************************************
 # File        : XKTagsDisplayView.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/18
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 
 ******************************************************************************/

#import <UIKit/UIKit.h>

@interface XKTagsDisplayView : UIView

/**
 
 demo: masonry使用方式
 XKTagsDisplayView *view = [[XKTagsDisplayView alloc] init];

 [self.containView addSubview:view];
     [view mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.left.equalTo(self.containView);
         make.width.equalTo(@300);
         make.height.equalTo(@100);
     }];
 NSArray *arr = @[@"盘视图",@"盘视图盘视图",@"盘视",@"盘视图",@"盘视图(2)",@"盘视图",@"盘视图",@"盘视图盘视图",@"盘",@"盘视图",@"盘视图",@"盘视图"];
 [view setArr:arr];
 [view setHeightChange:^(CGFloat height, XKTagsDisplayView *tagsView) {
 NSLog(@"高度变化 %f",height);
         [tagsView mas_updateConstraints:^(MASConstraintMaker *make) {
             make.height.mas_equalTo(height);
         }];
 }];
 
 demo: frame使用方式
 
 XKTagsDisplayView *view = [[XKTagsDisplayView alloc] init];
 view.frame = CGRectMake(0, 100, 300, 100);
 [self.containView addSubview:view];
 
 NSArray *arr = @[@"盘视图",@"盘视图盘视图",@"盘视",@"盘视图",@"盘视图(2)",@"盘视图",@"盘视图",@"盘视图盘视图",@"盘",@"盘视图",@"盘视图",@"盘视图"];
 [view setArr:arr];
 [view setHeightChange:^(CGFloat height, XKTagsDisplayView *tagsView) {
 NSLog(@"高度变化 %f",height);

 */


/**设置高度无效 内部会动态设置自己的高度*/

- (void)setArr:(NSArray *)arr;

/**是否需要收起展开*/
@property(nonatomic, assign) BOOL isNeedFold;

/**默认选中*/
@property(nonatomic, assign) NSInteger defualtIndex;
/**选择回调*/
@property(nonatomic, copy) void(^itemChange)(NSInteger index, NSString *text, XKTagsDisplayView *tagsView);
/**高度变化回调*/
@property(nonatomic, copy) void(^heightChange)(CGFloat height,XKTagsDisplayView *tagsView);

@end
