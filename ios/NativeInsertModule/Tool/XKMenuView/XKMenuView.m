//
//  XKMenuView.m
//  Demo



#define kScreenWidth               [UIScreen mainScreen].bounds.size.width
#define kScreenHeight              [UIScreen mainScreen].bounds.size.height
#define kMainWindow                [UIApplication sharedApplication].keyWindow

#define kArrowWidth          15
#define kArrowHeight         10
#define kDefaultMargin       10
#define kAnimationTime       0.25

#import "XKMenuView.h"

@interface XKMenuCell : UITableViewCell
@property (nonatomic,assign) BOOL         isShowSeparator;
@property (nonatomic,assign) CGFloat      separatorPadding;
@property (nonatomic,strong) UIColor    * cellSeparatorColor;
@property(nonatomic, assign) BOOL hasRedPoint;
@property (nonatomic,strong) UIImageView    *redPoint;
@property (nonatomic,strong) UIView    *separateLine;
/***/
@property(nonatomic, strong) UIButton *btn;
@end
@implementation XKMenuCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _isShowSeparator = YES;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.btn = [[UIButton alloc] init];
    [self.contentView addSubview:self.btn];
    self.btn.userInteractionEnabled = NO;
    [self.btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.btn.titleLabel.font = XKRegularFont(15);
    self.btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView.mas_left).offset(5);
        make.centerX.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(0);
        make.top.bottom.equalTo(self.contentView);
    }];
  self.btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;

  _separateLine = [[UIView alloc] init];
  _separateLine.backgroundColor = [UIColor redColor];
  [self.contentView addSubview:_separateLine];
  [_separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(self.contentView.mas_bottom);
    make.centerX.equalTo(self.contentView);
    make.left.equalTo(self.contentView.mas_left).offset(self.separatorPadding);
    make.height.mas_equalTo(0.5);
  }];
}

- (void)setSeparatorPadding:(CGFloat)separatorPadding {
  _separatorPadding = separatorPadding;
  [_separateLine mas_updateConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.contentView.mas_left).offset(self.separatorPadding);
  }];
}

- (void)setHasRedPoint:(BOOL)hasRedPoint {
  _hasRedPoint = hasRedPoint;
  self.redPoint.hidden = !hasRedPoint;
}

- (void)setCellSeparatorColor:(UIColor *)separatorColor{
  _cellSeparatorColor = separatorColor;
  _separateLine.backgroundColor = separatorColor;
  //    [self setNeedsDisplay];
}

- (void)setIsShowSeparator:(BOOL)isShowSeparator{
  _isShowSeparator = isShowSeparator;
  _separateLine.hidden = !isShowSeparator;
  //    [self setNeedsDisplay];
}


- (UIImageView *)redPoint {
    if (!_redPoint) {
        _redPoint = [[UIImageView alloc] init];
        _redPoint.image = IMG_NAME(@"xk_ic_msg_tipRed");
        [self.contentView addSubview:_redPoint];
        if (self.btn.imageView.image) {
            [_redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.btn.imageView.mas_right);
                make.centerY.equalTo(self.btn.imageView.mas_top);
                make.size.mas_equalTo(CGSizeMake(6, 6));
            }];
        } else {
            
        }
    }
    return _redPoint;
}

//- (void)drawRect:(CGRect)rect{
//    if (!_isShowSeparator)return;
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(self.separatorPadding, rect.size.height - 0.5, rect.size.width - self.separatorPadding * 2, 0.5)];
//    [_separatorColor setFill];
//    [path fillWithBlendMode:kCGBlendModeNormal alpha:1.0f];
//    [path closePath];
//}
@end


@interface XKMenuAction ()
@property (nonatomic) NSString      *title;
@property (nonatomic) UIImage       *image;
@property (copy, nonatomic)void (^handler)(XKMenuAction *);
@end
@implementation XKMenuAction
+ (instancetype)actionWithTitle:(NSString *)title image:(UIImage *)image handler:(void (^)(XKMenuAction *))handler{
    XKMenuAction *action = [[XKMenuAction alloc] initWithTitle:title image:image handler:handler];
    return action;
}
- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image handler:(void (^)(XKMenuAction *))handler{
    if (self = [super init]) {
        _title = title;
        _image = image;
        _handler = [handler copy];
    }
    return self;
}
@end


@interface XKMenuView()<UITableViewDelegate,UITableViewDataSource>
{
    CGPoint          _refPoint;
    UIView          *_refView;
    CGFloat          _menuWidth;
    
    CGFloat         _arrowPosition; // 三角底部的起始点x
    CGFloat         _topMargin;
    BOOL            _isReverse; // 是否反向
    BOOL            _needReload; //是否需要刷新
}
@property(nonatomic,copy) NSArray<XKMenuAction *>   *actions;
@property(nonatomic,strong)UIView                   *contentView;
@property(nonatomic,strong)UIView                   *bgView;

@end

static NSString *const menuCellID = @"XKMenuCell";
@implementation XKMenuView

// 从关联点创建
+ (instancetype)menuWithTitles:(NSArray<NSString *> *)titles images:(nullable NSArray<UIImage *> *)images width:(CGFloat)width atPoint:(CGPoint)point clickBlock:(void(^)(NSInteger index, NSString *text))click {
    int i = 0;
    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *title in titles) {
        UIImage *image;
        if (images.count == titles.count) {
            image = images[i];
        }
        XKMenuAction *action = [XKMenuAction actionWithTitle:title image:image handler:^(XKMenuAction *action) {
            click(i,title);
        }];
        i ++;
        [arr addObject:action];
    }
   return [self menuWithActions:arr width:width atPoint:point];
    
}
// 从关联视图创建（可以是UIView和UIBarButtonItem）
+ (instancetype)menuWithTitles:(NSArray<NSString *> *)titles images:(nullable NSArray<UIImage *> *)images width:(CGFloat)width relyonView:(id)view clickBlock:(void(^)(NSInteger index, NSString *text))click {
    int i = 0;
    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *title in titles) {
        UIImage *image;
        if (images.count == titles.count) {
            image = images[i];
        }
        XKMenuAction *action = [XKMenuAction actionWithTitle:title image:image handler:^(XKMenuAction *action) {
            click(i,title);
        }];
        i ++;
        [arr addObject:action];
    }
    return [self menuWithActions:arr width:width relyonView:view];
}

+ (instancetype)menuWithActions:(NSArray<XKMenuAction *> *)actions width:(CGFloat)width atPoint:(CGPoint)point{
    NSAssert(width>0.0f, @"width要大于0");
    XKMenuView *menu = [[XKMenuView alloc] initWithActions:actions width:width atPoint:point];
    return menu;
}
+ (instancetype)menuWithActions:(NSArray<XKMenuAction *> *)actions width:(CGFloat)width relyonView:(id)view{
    NSAssert(width>0.0f, @"width要大于0");
    NSAssert([view isKindOfClass:[UIView class]]||[view isKindOfClass:[UIBarButtonItem class]], @"relyonView必须是UIView或UIBarButtonItem");
    XKMenuView *menu = [[XKMenuView alloc] initWithActions:actions width:width relyonView:view];
    return menu;
}

- (instancetype)initWithActions:(NSArray<XKMenuAction *> *)actions width:(CGFloat)width atPoint:(CGPoint)point{
    if (self = [super init]) {
        _actions = [actions copy];
        _refPoint = point;
        _menuWidth = width;
        [self defaultConfiguration];
        [self setupSubView];
    }
    return self;
}

- (instancetype)initWithActions:(NSArray<XKMenuAction *> *)actions width:(CGFloat)width relyonView:(id)view{
    if (self = [super init]) {
        // 针对UIBarButtonItem做的处理
        if ([view isKindOfClass:[UIBarButtonItem class]]) {
            UIView *bgView = [view valueForKey:@"_view"];
            _refView = bgView;
        }else{
            _refView = view;
        }
        _actions = [actions copy];
        _menuWidth = width;
        [self defaultConfiguration];
        [self setupSubView];
    }
    return self;
}

- (void)defaultConfiguration{
    self.alpha = 0.0f;
    [self setDefaultShadow];
    
    _cornerRaius = 5.0f;
    _separatorColor = [UIColor blackColor];
    _menuColor = [UIColor whiteColor];
    _menuCellHeight = 44.0f;
    _maxDisplayCount = 6;
    _textImgSpace = 8;
    _isShowShadow = YES;
    _dismissOnselected = YES;
    _dismissOnTouchOutside = YES;
    
    _textColor = [UIColor blackColor];
    _textFont = [UIFont systemFontOfSize:15.0f];
    _offset = 0.0f;
}


- (void)setupSubView{
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *guassView = [[UIVisualEffectView alloc] initWithEffect:blur];
    guassView.alpha = 0.98f;
    [self addSubview:guassView];
    [guassView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self calculateArrowAndFrame];
    [self setupMaskLayer];
    [self addSubview:self.contentView];
}

- (void)reloadData{
    [self.contentView removeFromSuperview];
    [self.tableView removeFromSuperview];
    self.contentView = nil;
    self.tableView = nil;
    [self setupSubView];
}

- (CGPoint)getRefPoint{
    CGRect absoluteRect = [_refView convertRect:_refView.bounds toView:kMainWindow];
    CGPoint refPoint;
    if (self.forceStyle == 0) {
        if (absoluteRect.origin.y + absoluteRect.size.height + _actions.count * _menuCellHeight > kScreenHeight - 10) {
            refPoint = CGPointMake(absoluteRect.origin.x + absoluteRect.size.width / 2, absoluteRect.origin.y);
            _isReverse = YES;
        }else{
            refPoint = CGPointMake(absoluteRect.origin.x + absoluteRect.size.width / 2, absoluteRect.origin.y + absoluteRect.size.height);
            _isReverse = NO;
        }
    } else if (self.forceStyle == 1) {
        refPoint = CGPointMake(absoluteRect.origin.x + absoluteRect.size.width / 2, absoluteRect.origin.y);
        _isReverse = YES;
    } else {
        refPoint = CGPointMake(absoluteRect.origin.x + absoluteRect.size.width / 2, absoluteRect.origin.y + absoluteRect.size.height);
        _isReverse = NO;
    }

    return refPoint;
}

- (void)show{
    // 自定义设置统一在这边刷新一次
    if (_needReload) [self reloadData];
    
    [kMainWindow addSubview: self.bgView];
    [kMainWindow addSubview: self];
    self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration: kAnimationTime animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1.0f;
        self.bgView.alpha = 1.0f;
    }];
}

- (void)dismiss{
    if (!_dismissOnTouchOutside) return;
    [UIView animateWithDuration: kAnimationTime animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0.0f;
        self.bgView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.bgView removeFromSuperview];
    }];
}

#pragma mark - Private
- (void)setupMaskLayer{
    CAShapeLayer *layer = [self drawMaskLayer];
    self.layer.mask = layer;
}

- (void)calculateArrowAndFrame{
    if (_refView) {
        _refPoint = [self getRefPoint];
    }
    
    CGFloat originX;
    CGFloat originY;
    CGFloat width;
    CGFloat height;
    
    width = _menuWidth;
    height = (_actions.count > _maxDisplayCount) ? _maxDisplayCount * _menuCellHeight + kArrowHeight: _actions.count * _menuCellHeight + kArrowHeight;
    // 默认在中间
    _arrowPosition = 0.5 * width - 0.5 * kArrowWidth;
    
    // 设置出menu的x和y（默认情况）
    originX = _refPoint.x - _arrowPosition - 0.5 * kArrowWidth;
    originY = _refPoint.y;
    
    // 考虑向左右展示不全的情况，需要反向展示
    if (originX + width > kScreenWidth - 10) {
        originX = kScreenWidth - kDefaultMargin - width;
    }else if (originX < 10) {
        //向上的情况间距也至少是kDefaultMargin
        originX = kDefaultMargin;
    }
    
    //设置三角形的起始点
    if ((_refPoint.x <= originX + width - _cornerRaius) && (_refPoint.x >= originX + _cornerRaius)) {
        _arrowPosition = _refPoint.x - originX - 0.5 * kArrowWidth;
    }else if (_refPoint.x < originX + _cornerRaius) {
        _arrowPosition = _cornerRaius;
    }else {
        _arrowPosition = width - _cornerRaius - kArrowWidth;
    }
    
    //如果不是根据关联视图，得算一次是否反向
    if (!_refView) {
        if (self.forceStyle == 0) {
           _isReverse = (originY + height > kScreenHeight - kDefaultMargin)?YES:NO;
        } else if (self.forceStyle == 1) {
           _isReverse = YES;
        } else {
           _isReverse = NO;
        }
    }
    
    CGPoint  anchorPoint;
    if (_isReverse) {
        originY = _refPoint.y - height;
        anchorPoint = CGPointMake(fabs(_arrowPosition) / width, 1);
        _topMargin = 0;
    }else{
        anchorPoint = CGPointMake(fabs(_arrowPosition) / width, 0);
        _topMargin = kArrowHeight;
    }
    originY += originY >= _refPoint.y ? _offset : -_offset;
    
    //保存原来的frame，防止设置锚点后偏移
    self.layer.anchorPoint = anchorPoint;
    self.frame = CGRectMake(originX, originY, width, height);
}

- (CAShapeLayer *)drawMaskLayer{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    CGFloat bottomMargin = !_isReverse?0 :kArrowHeight;
    
    // 定出四个转角点
    CGPoint topRightArcCenter = CGPointMake(self.width - _cornerRaius, _topMargin + _cornerRaius);
    CGPoint topLeftArcCenter = CGPointMake(_cornerRaius, _topMargin + _cornerRaius);
    CGPoint bottomRightArcCenter = CGPointMake(self.width - _cornerRaius, self.height - bottomMargin - _cornerRaius);
    CGPoint bottomLeftArcCenter = CGPointMake(_cornerRaius, self.height - bottomMargin - _cornerRaius);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    // 从左上倒角的下边开始画
    [path moveToPoint: CGPointMake(0, _topMargin + _cornerRaius)];
    [path addLineToPoint: CGPointMake(0, bottomLeftArcCenter.y)];
    [path addArcWithCenter: bottomLeftArcCenter radius: _cornerRaius startAngle: -M_PI endAngle: -M_PI-M_PI_2 clockwise: NO];
    
    if (_isReverse) {
        [path addLineToPoint: CGPointMake(_arrowPosition, self.height - kArrowHeight)];
        [path addLineToPoint: CGPointMake(_arrowPosition + 0.5*kArrowWidth, self.height)];
        [path addLineToPoint: CGPointMake(_arrowPosition + kArrowWidth, self.height - kArrowHeight)];
    }
    [path addLineToPoint: CGPointMake(self.width - _cornerRaius, self.height - bottomMargin)];
    [path addArcWithCenter: bottomRightArcCenter radius: _cornerRaius startAngle: -M_PI-M_PI_2 endAngle: -M_PI*2 clockwise: NO];
    [path addLineToPoint: CGPointMake(self.width, self.height - bottomMargin + _cornerRaius)];
    [path addArcWithCenter: topRightArcCenter radius: _cornerRaius startAngle: 0 endAngle: -M_PI_2 clockwise: NO];
    
    if (!_isReverse) {
        [path addLineToPoint: CGPointMake(_arrowPosition + kArrowWidth, _topMargin)];
        [path addLineToPoint: CGPointMake(_arrowPosition + 0.5 * kArrowWidth, 0)];
        [path addLineToPoint: CGPointMake(_arrowPosition, _topMargin)];
    }
    
    [path addLineToPoint: CGPointMake(_cornerRaius, _topMargin)];
    [path addArcWithCenter: topLeftArcCenter radius: _cornerRaius startAngle: -M_PI_2 endAngle: -M_PI clockwise: NO];
    [path closePath];
    
    maskLayer.path = path.CGPath;
    return maskLayer;
}
- (void)setDefaultShadow{
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 5.0;
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _actions.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XKMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellID forIndexPath:indexPath];
    XKMenuAction *action = _actions[indexPath.row];
  cell.backgroundColor = [UIColor clearColor];
  [cell.btn setTitle:action.title forState:UIControlStateNormal];
  [cell.btn setTitleColor:_textColor forState:UIControlStateNormal];
  [cell.btn setImage:action.image?action.image:nil forState:UIControlStateNormal];
  cell.separatorPadding = self.separatorPadding;
  cell.cellSeparatorColor = self.separatorColor;
  if (self.contentPadding) {
    [cell.btn mas_updateConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(cell.btn.superview).mas_offset(self.contentPadding);
      make.right.equalTo(cell.btn.superview).mas_offset(-self.contentPadding);
    }];
  }
  cell.btn.titleLabel.font = self.textFont;
  [cell setHasRedPoint:[self hasRedPoint:indexPath]];
  if (action.image) {
    [cell.btn setTitleEdgeInsets:UIEdgeInsetsMake(0, self.textImgSpace / 2.0, 0, 0)];
    [cell.btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, self.textImgSpace/2.0)];
  } else {
    [cell.btn setTitleEdgeInsets:UIEdgeInsetsZero];
    [cell.btn setImageEdgeInsets:UIEdgeInsetsZero];
  }
  cell.btn.contentHorizontalAlignment = self.contentAlignment;
    if (indexPath.row == _actions.count - 1) {
        cell.isShowSeparator = NO;
    }
    return cell;
}

- (BOOL)hasRedPoint:(NSIndexPath *)indexPath {
    for (NSNumber *index in self.redPointArray) {
        if (index.integerValue == indexPath.row) {
            return YES;
        }
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_dismissOnselected) [self dismiss];
    XKMenuAction *action = _actions[indexPath.row];
    if (action.handler) {
        action.handler(action);
    }
}

#pragma mark - Setting&&Getting
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _topMargin, self.width, self.height - kArrowHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = _actions.count > _maxDisplayCount? YES : NO;
        _tableView.rowHeight = _menuCellHeight;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[XKMenuCell class] forCellReuseIdentifier:menuCellID];
    }
    return _tableView;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.05];
        _bgView.alpha = 0.0f;
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
        _contentView.backgroundColor = _menuColor;
        _contentView.layer.masksToBounds = YES;
        [_contentView addSubview:self.tableView];
    }
    return _contentView;
}
#pragma mark - 设置属性
- (void)setCornerRaius:(CGFloat)cornerRaius{
    if (_cornerRaius == cornerRaius)return;
    _cornerRaius = cornerRaius;
    self.contentView.layer.mask = [self drawMaskLayer];
}
- (void)setMenuColor:(UIColor *)menuColor{
    if ([_menuColor isEqual:menuColor]) return;
    _menuColor = menuColor;
    self.contentView.backgroundColor = menuColor;
}
- (void)setBackgroundColor:(UIColor *)backgroundColor{
    if ([_menuColor isEqual:backgroundColor]) return;
    _menuColor = backgroundColor;
    self.contentView.backgroundColor = _menuColor;
}
- (void)setSeparatorColor:(UIColor *)separatorColor{
    if ([_separatorColor isEqual:separatorColor]) return;
    _separatorColor = separatorColor;
    [self.tableView reloadData];
}
- (void)setMenuCellHeight:(CGFloat)menuCellHeight{
    if (_menuCellHeight == menuCellHeight)return;
    _menuCellHeight = menuCellHeight;
    _needReload = YES;
}
- (void)setMaxDisplayCount:(NSInteger)maxDisplayCount{
    if (_maxDisplayCount == maxDisplayCount)return;
    _maxDisplayCount = maxDisplayCount;
    _needReload = YES;
}
- (void)setForceStyle:(NSInteger)forceStyle {
    if (_forceStyle == forceStyle)return;
    _forceStyle = forceStyle;
    _needReload = YES;
}
- (void)setIsShowShadow:(BOOL)isShowShadow{
    if (_isShowShadow == isShowShadow)return;
    _isShowShadow = isShowShadow;
    if (!_isShowShadow) {
        self.layer.shadowOpacity = 0.0;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 0.0;
    }else{
        [self setDefaultShadow];
    }
}

- (void)setRedPointArray:(NSArray<NSNumber *> *)redPointArray {
    _redPointArray = redPointArray;
    _needReload = YES;
}

- (void)setTextFont:(UIFont *)textFont{
    if ([_textFont isEqual:textFont]) return;
    _textFont = textFont;
    [self.tableView reloadData];
}
- (void)setTextColor:(UIColor *)textColor{
    if ([_textColor isEqual:textColor]) return;
    _textColor = textColor;
    [self.tableView reloadData];
}
- (void)setOffset:(CGFloat)offset{
    if (offset == offset) return;
    _offset = offset;
    if (offset < 0.0f) {
        offset = 0.0f;
    }
    self.y += self.y >= _refPoint.y ? offset : -offset;
}
@end
