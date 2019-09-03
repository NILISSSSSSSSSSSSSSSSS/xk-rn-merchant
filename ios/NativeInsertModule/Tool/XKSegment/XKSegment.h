/*******************************************************************************
 # File        : XKSegment.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/11/6
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

@interface XKSegment : UIView

- (instancetype)initWithTitleArray:(NSArray <NSString *> *)titleArray;
- (instancetype)initWithTitleArray:(NSArray<NSString *> *)titleArray selectColor:(UIColor *)selectColor normalColor:(UIColor *)normalColor;
/**<##>*/
@property(nonatomic, assign) NSInteger selectIndex;
/**点击回调*/
@property(nonatomic, copy) void(^segmentChange)(NSInteger index);


@end
