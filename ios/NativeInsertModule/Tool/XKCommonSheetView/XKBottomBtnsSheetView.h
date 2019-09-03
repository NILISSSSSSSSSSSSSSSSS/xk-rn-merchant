/*******************************************************************************
 # File        : IKComplaintView.h
 # Project     : ErpApp
 # Author      : Jamesholy
 # Created     : 2018/2/11
 # Corporation : xk
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import <UIKit/UIKit.h>

@interface XKBottomBtnsSheetView : UIView

- (instancetype)initWithContents:(NSArray <NSString *>*)contents title:(NSString *)titile completeBlock:(void(^)(XKBottomBtnsSheetView *complaintView, NSArray <NSNumber *>*indexs))complete;

@property(nonatomic, strong) UIButton *sureBtn;

- (void)show;

- (void)dismiss;
@end
