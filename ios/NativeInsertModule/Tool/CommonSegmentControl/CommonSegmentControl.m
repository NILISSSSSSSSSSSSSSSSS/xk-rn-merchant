/*******************************************************************************
 # File        : CommonSegmentControl.m
 # Project     : testDemo
 # Author      : fakepinge
 # Created     : 2017/5/3
 # Corporation : 成都晓可有限公司
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#define kRGBA(r,g,b,a) [UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:a]
#define kRGB(r,g,b) kRGBA(r,g,b,1)
#define kRGBGRAY(r) kRGBA(r,r,r,1)

#define kButtonTag 1000

// 默认值：item背景色
#define kSegmentBackgroundColor     kRGB(253.0f,239.0f,230.0f)
// 默认值：未选中时字体的颜色
#define  kTitleColor                kRGBGRAY(77)
// 默认值：选中时字体的颜色
#define  kSelectedColor             kRGB(233,97,31)
// 默认值：字体的大小
#define kTitleFont                  [UIFont fontWithName:@".Helvetica Neue Interface" size:14.0f]
// 默认值：下划线颜色
#define kDefaultLineColor           [UIColor redColor]
// 默认值：初始选中的item下标
#define kDefaultIndex               0
// 默认值：下划线动画的时间
#define kDefaultDuration            0.5

#import "CommonSegmentControl.h"
@interface CommonSegmentControl () {
    CGFloat _lineWidth;
}

/**frame*/
@property (nonatomic, assign) CGRect tempFrame;
/**下划线view*/
@property (nonatomic, strong) UIView *lineView;
/**标题宽*/
@property (nonatomic, assign) CGFloat titleWidth;
/**item数量*/
@property (nonatomic, assign) CGFloat itemCount;
/**buttonTag*/
@property (nonatomic, assign) CGFloat buttonTag;
/**button数组*/
@property (nonatomic, strong) NSMutableArray *itemButtonArray;
/**button右上角的小红点数组数组*/
@property (nonatomic, strong) NSMutableArray *itemButtonBadgeArray;

/**title数组*/
@property (nonatomic, copy) NSArray *itemTitleArray;
/**target*/
@property (nonatomic, weak) id target;
/**action*/
@property (nonatomic, assign) SEL action;

@end

@implementation CommonSegmentControl

#pragma mark - 创建segment
+ (instancetype )segmentWithFrame:(CGRect)frame items:(NSArray *)items toSuperView:(UIView *)superView swipView:(UIView *)swipView {
    return [[self alloc] initWithFrame:frame items:items toSuperView:superView swipView:swipView];
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items toSuperView:(UIView *)superView swipView:(UIView *)swipView {
    self = [super init];
    if (self) {
        // 初始化默认数据
        [self createDefaultData];
        _itemTitleArray = items;
        _tempFrame = frame;
        self.frame = frame;
        [self addItems:items];
        if (superView) {
            [superView addSubview:self];
        }
        if (swipView) {
            [self addSwipGestureIn:swipView];
        }
    }
    return self;
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
    self.itemButtonArray = [NSMutableArray array];
    self.itemButtonBadgeArray = [NSMutableArray array];
    self.selectedIndex = kDefaultIndex;
    self.titleFont = kTitleFont;
    self.selectFont = kTitleFont;
    self.segmentBackgroundColor = kSegmentBackgroundColor;
    self.titleColor = kTitleColor;
    self.selectColor = kSelectedColor;
    self.lineColor = kDefaultLineColor;
    [self setBackgroundColor:self.segmentBackgroundColor];
    self.lineWidth = 0.0;
    //使用kvo监测属性值变化
    [self addObserver:self forKeyPath:@"segmentBackgroundColor" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"segmentBackgroundColor"];
    [self addObserver:self forKeyPath:@"titleColor" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"titleColor"];
    [self addObserver:self forKeyPath:@"selectColor" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"selectColor"];
    [self addObserver:self forKeyPath:@"titleFont" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"titleFont"];
    [self addObserver:self forKeyPath:@"selectFont" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"selectFont"];
    [self addObserver:self forKeyPath:@"lineColor" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"lineColor"];
    [self addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"selectedIndex"];
}

#pragma mark - 移除观察者
- (void)dealloc {
    [self removeObserver:self forKeyPath:@"segmentBackgroundColor" context:@"segmentBackgroundColor"];
    [self removeObserver:self forKeyPath:@"titleColor" context:@"titleColor"];
    [self removeObserver:self forKeyPath:@"selectColor" context:@"selectColor"];
    [self removeObserver:self forKeyPath:@"titleFont" context:@"titleFont"];
    [self removeObserver:self forKeyPath:@"selectFont" context:@"selectFont"];
    [self removeObserver:self forKeyPath:@"lineColor" context:@"lineColor"];
    [self removeObserver:self forKeyPath:@"selectedIndex" context:@"selectedIndex"];
}

#pragma mark - 添加标题
- (void)addItems:(NSArray *)items {
    if (items.count == 0) {
        return;
    }
    _itemCount = items.count;
    _titleWidth = (self.bounds.size.width) / _itemCount;
    if (_lineWidth <= 0.0 || _lineWidth >= _titleWidth) {
        _lineWidth = _titleWidth;
    }
    for (int i = 0; i< items.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * _titleWidth, 0, _titleWidth, self.bounds.size.height - 2)];
        [button setTitle:items[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:self.titleFont];
        [button setTitleColor:self.titleColor forState:UIControlStateNormal];
        [button setTitleColor:self.selectColor forState:UIControlStateSelected];
        [button setTag:i];
        [button addTarget:self action:@selector(changeTheIndexWithButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.itemButtonArray addObject:button];
        [button layoutSubviews];
        
        // 右上角的小红点
        UIButton *badge = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addSubview:badge];
        badge.size = CGSizeMake(8, 8);
        badge.center = CGPointMake(CGRectGetMaxX(button.titleLabel.frame) + 5, CGRectGetMinY(button.titleLabel.frame));
        badge.backgroundColor = [UIColor redColor];
        badge.layer.masksToBounds = YES;
        badge.layer.cornerRadius = 4;
        badge.hidden = YES;
        [self.itemButtonBadgeArray addObject:badge];
    }
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        [_lineView setBackgroundColor:self.lineColor];
        [self addSubview:_lineView];
    }
    if (self.selectedIndex < _itemCount) {
        [self.itemButtonArray[self.selectedIndex] setSelected:YES];
        _lineView.frame = CGRectMake(self.selectedIndex * _titleWidth + _titleWidth/2 - _lineWidth/2, self.bounds.size.height - 2, _lineWidth, 2);
        _lineView.centerX = [((UIButton *)self.itemButtonArray[self.selectedIndex]) centerX];
    } else {
        [[self.itemButtonArray firstObject] setSelected:YES];
        _lineView.frame = CGRectMake(0 * _titleWidth, self.bounds.size.height - 2, _lineWidth, 2);
        _lineView.centerX = [((UIButton *)self.itemButtonArray.firstObject) centerX];
    }
}

- (void)changeTheIndexWithButton:(UIButton *)button {
    self.selectedIndex = button.tag;
}

- (void)changeTheSegment:(UIButton*)button {
    [self selectIndex:button.tag];
    _buttonTag = (NSInteger)button.tag;
    for (UIButton *btn in self.itemButtonArray) {
        if (button == btn) {
            [btn setTitleColor:self.titleColor forState:UIControlStateNormal];
            [btn setTitleColor:self.selectColor forState:UIControlStateSelected];
            [btn.titleLabel setFont:self.selectFont];
            btn.selected = YES;
        } else {
            [btn setTitleColor:self.titleColor forState:UIControlStateNormal];
            [btn setTitleColor:self.selectColor forState:UIControlStateSelected];
            [btn.titleLabel setFont:self.titleFont];
            btn.selected = NO;
        }
    }
}

#pragma mark - 添加手势
- (void)addSwipGestureIn:(UIView *)view {
    UISwipeGestureRecognizer *leftSwip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipTheScreen:)];
    leftSwip.direction = UISwipeGestureRecognizerDirectionLeft;
    [view addGestureRecognizer:leftSwip];
    
    UISwipeGestureRecognizer *rightSwip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipTheScreen:)];
    rightSwip.direction = UISwipeGestureRecognizerDirectionRight;
    [view addGestureRecognizer:rightSwip];
}

- (void)swipTheScreen:(UISwipeGestureRecognizer *)swip {
    if (swip.direction & UISwipeGestureRecognizerDirectionRight) {
        if (_buttonTag > 0) {
            _buttonTag--;
            self.selectedIndex =_buttonTag;
        }
    } else if (swip.direction & UISwipeGestureRecognizerDirectionLeft) {
        if (_buttonTag < _itemCount - 1) {
            _buttonTag ++;
            self.selectedIndex =_buttonTag;
        }
    }
}

#pragma mark - 选中某个item，调用协议方法
- (void)selectIndex:(NSInteger)index {
    [self handleSelectItemEventWith:index];
}

- (void)handleSelectItemEventWith:(NSInteger )index {
    if (index > _itemCount) {
        return;
    }
    
    [self.itemButtonArray[self.selectedIndex] setSelected:NO];
    [self.itemButtonArray[index] setSelected:YES];
    [UIView animateWithDuration:self.duration ? self.duration:kDefaultDuration animations:^{
        self->_lineView.frame = CGRectMake(index * self->_titleWidth, self.bounds.size.height - 2, self.lineWidth, 2);
        self->_lineView.centerX = [((UIButton *)self.itemButtonArray[index]) centerX];
    }];
    
    if (self.selectedIndex != index) {
        self.selectedIndex = index;
    }
    if ([_target respondsToSelector:_action]) {
        NSLog(@"_target 调用了 _action");
        [_target performSelector:_action withObject:self];
    }
}

#pragma mark - 利用kvo监测属性值的变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSString *cate = (__bridge NSString *)context;
    if ([cate isEqualToString:@"segmentBackgroundColor"]) {
        [self setBackgroundColor:self.segmentBackgroundColor];
    }
    if ([cate isEqualToString:@"lineColor"]) {
        [_lineView setBackgroundColor:self.lineColor];
    }
    if ([cate isEqualToString:@"selectedIndex"]) {
        NSInteger new = [change[@"new"] integerValue];
        NSInteger old = [change[@"old"] integerValue];
        if (new == old) {
            return;
        }
        UIButton *btn = self.itemButtonArray[self.selectedIndex];
        [self changeTheSegment:btn];
    }
    for (UIButton *button in self.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            if ([cate isEqualToString:@"titleColor"]){
                [button setTitleColor:self.titleColor forState:UIControlStateNormal];
            } else if ([cate isEqualToString:@"selectColor"]){
                [button setTitleColor:self.selectColor forState:UIControlStateSelected];
            } else if ([cate isEqualToString:@"titleFont"]){
                [button.titleLabel setFont:self.titleFont];
            }
        }
    }
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    if (self.selectedIndex < _itemCount) {
        [self.itemButtonArray[self.selectedIndex] setSelected:YES];
        _lineView.frame = CGRectMake(self.selectedIndex * _titleWidth, self.bounds.size.height - 2, lineWidth, 2);
        _lineView.centerX = [((UIButton *)self.itemButtonArray[self.selectedIndex]) centerX];
    } else {
        [[self.itemButtonArray firstObject] setSelected:YES];
        _lineView.frame = CGRectMake(0 * _titleWidth, self.bounds.size.height - 2, _lineWidth, 2);
        _lineView.centerX = [((UIButton *)self.itemButtonArray.firstObject) centerX];
    }
}

- (CGFloat)lineWidth {
    if (_lineWidthArray.count != 0 && _lineWidthArray.count == _itemCount) {
        _lineWidth = [_lineWidthArray[_selectedIndex] floatValue];
    }
    return _lineWidth;
}

- (void)setLineWidthArray:(NSArray *)lineWidthArray {
    _lineWidthArray = lineWidthArray;
    if (_lineWidthArray.count != 0 && _lineWidthArray.count == _itemCount) {
        _lineWidth = [_lineWidthArray[_selectedIndex] floatValue];
    }
    if (_selectedIndex < _itemCount) {
        [_itemButtonArray[_selectedIndex] setSelected:YES];
        _lineView.frame = CGRectMake(_selectedIndex * _titleWidth + _titleWidth/2 - _lineWidth/2, self.bounds.size.height - 2, _lineWidth, 2);
        _lineView.centerX = [((UIButton *)_itemButtonArray[_selectedIndex]) centerX];
    } else {
        [[_itemButtonArray firstObject] setSelected:YES];
        _lineView.frame = CGRectMake(0 * _titleWidth, self.bounds.size.height - 2, _lineWidth, 2);
        _lineView.centerX = [((UIButton *)_itemButtonArray.firstObject) centerX];
    }
    
    
}

- (NSArray *)itemArray {
    return _itemTitleArray.copy;
}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)addTarget:(id)target action:(SEL)action {
    _target = target;
    _action = action;
}
/**
 设置红点提示文本
 
 @param badgeValue 红点文本，无红点传入nil
 @param index 位置
 @param bgColor 背景颜色
 @param textColor 文本颜色
 */
- (void)setBadgeValue:(NSString * _Nullable)badgeValue index:(NSInteger)index bgColor:(UIColor * _Nullable)bgColor textColor:(UIColor * _Nullable)textColor {
    UIButton *badge = [self.itemButtonBadgeArray objectAtIndex:index];
    if (badgeValue) {
        if (badgeValue.length > 0) {
            badge.titleLabel.font = [UIFont systemFontOfSize:6];
            badge.size = CGSizeMake(MAX(badgeValue.length * 6, 8), 8);
        } else {
            badge.size = CGSizeMake(8, 8);
        }
        badge.hidden = NO;
        [badge setTitle:badgeValue forState:UIControlStateNormal];
        
    } else {
        badge.hidden = YES;
    }
}

@end
