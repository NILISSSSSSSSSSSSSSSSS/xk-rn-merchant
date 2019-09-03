/*******************************************************************************
 # File        : DragStickinessView.h
 # Project     : QQRedDot
 # Author      : Jamesholy
 # Created     : 2018/9/28
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

typedef NS_ENUM(NSInteger,DragStickinessBackMode) {
    DragStickinessBackAlwaysMode = 0 ,// 始终回去
    DragStickinessBackNoneMode, // 不回去
    DragStickinessBackMixMode // 断裂了就不回去 不断裂就回去
};

@interface DragStickinessView : UIView

//父视图
@property (nonatomic,strong)UIView *containerView;

//气泡上显示数字的label
@property (nonatomic,strong)UILabel *bubbleLabel;

//气泡的直径
@property (nonatomic,assign)CGFloat bubbleWidth;

//气泡粘性系数，越大可以拉得越长
@property (nonatomic,assign)CGFloat viscosity;

//气泡颜色
@property (nonatomic,strong)UIColor *bubbleColor;

//需要隐藏气泡时候可以使用这个属性：self.frontView.hidden = YES;
@property (nonatomic,strong)UIView *frontView;

/**回到初始位置模式*/
@property (nonatomic,assign) DragStickinessBackMode autoBackMode;
/**限制拖动区域*/
@property(nonatomic, assign) UIEdgeInsets limitInset;

//@property (nonatomic,assign)int bezierAngleFactor;

-(id)initWithPoint:(CGPoint)point superView:(UIView *)view;
-(void)setUp;


@end
