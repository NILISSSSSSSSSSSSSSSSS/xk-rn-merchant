//
//  XKMenuView.h
//  Demo
//


#import <UIKit/UIKit.h>

@class XKMenuAction;
@interface XKMenuView : UIView
//默认倒角   default = 5.0
@property (nonatomic,assign) CGFloat                        cornerRaius;
//设置分割线颜色 default = 灰色
@property (nonatomic,strong) UIColor                       *separatorColor;
//设置分割线左右边距 default = 0
@property (nonatomic,assign) CGFloat                       separatorPadding;
//设置菜单颜色  default = 白色（也可以通过BackgroundColor设置）
@property (nonatomic,strong) UIColor                       *menuColor;
//设置菜单单元格高度  default = 44
@property (nonatomic,assign) CGFloat                        menuCellHeight;
//最大显示数量  default = 6
@property (nonatomic,assign) NSInteger                      maxDisplayCount;
//是否显示阴影 default = YES(默认设置，也可以自己通过layer属性设置)
@property (nonatomic,assign,getter = isShadowShowing)BOOL   isShowShadow;
//选择菜单选项后消失 default = YES
@property (nonatomic,assign)  BOOL                          dismissOnselected;
//点击菜单外消失 default = YES
@property (nonatomic,assign)  BOOL                          dismissOnTouchOutside;
//设置字体大小 default = 15
@property (nonatomic,assign)  UIFont                        *textFont;
//设置字体颜色 default = 黑色
@property (nonatomic,strong)  UIColor                       *textColor;
//设置图片与文字的间距
@property (nonatomic,assign)  CGFloat                       textImgSpace;
//设置内容和视图的内间距 default = 0
@property (nonatomic,assign)  CGFloat                       contentPadding;
//设置内容的对齐方式 default = UIControlContentHorizontalAlignmentCenter
@property (nonatomic,assign)  UIControlContentHorizontalAlignment contentAlignment;
//设置偏移距离 default = 0（与触摸点在Y轴上的偏移）
@property (nonatomic,assign)  CGFloat                       offset;
/**红点坐标*/
@property(nonatomic, copy) NSArray <NSNumber *>             *redPointArray;
/**强制方向模式 default = 0  (0 自动 1向上 2向下)*/
@property(nonatomic, assign) NSInteger  forceStyle;

@property(nonatomic,strong)UITableView              *tableView;

/**从关联点创建 block形式*/
+ (instancetype)menuWithTitles:(NSArray<NSString *> *)titles images:(nullable NSArray<UIImage *> *)images width:(CGFloat)width atPoint:(CGPoint)point clickBlock:(void(^)(NSInteger index, NSString *text))click;
/**从关联视图创建（可以是UIView和UIBarButtonItem） block形式*/
+ (instancetype)menuWithTitles:(NSArray<NSString *> *)titles images:(nullable NSArray<UIImage *> *)images width:(CGFloat)width relyonView:(id)view clickBlock:(void(^)(NSInteger index, NSString *text))click;

/** 从关联点创建 自建action模式*/
+ (instancetype)menuWithActions:(NSArray<XKMenuAction *> *)actions width:(CGFloat)width atPoint:(CGPoint)point;
/** 从关联视图创建（可以是UIView和UIBarButtonItem） 自建action模式*/
+ (instancetype)menuWithActions:(NSArray<XKMenuAction *> *)actions width:(CGFloat)width relyonView:(id)view;
- (void)show;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end

@interface XKMenuAction : NSObject
@property (nonatomic, readonly) NSString      *title;
@property (nonatomic, readonly) UIImage       *image;
@property (nonatomic,copy, readonly) void (^handler)(XKMenuAction *action);
+ (instancetype)actionWithTitle:(NSString *)title image:(UIImage *)image handler:(void (^)(XKMenuAction *action))handler;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end




