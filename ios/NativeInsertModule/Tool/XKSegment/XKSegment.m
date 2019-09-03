/*******************************************************************************
 # File        : XKSegment.m
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

#import "XKSegment.h"
#import "XKButton.h"

@interface XKSegment ()

/**<##>*/
@property(nonatomic, copy) NSArray *titleArray;

/**btnArray*/
@property(nonatomic, strong) NSMutableArray <UIButton *>*btnsArray;
@property(nonatomic, strong) UIView *sliderView;

/**<##>*/
@property(nonatomic, strong) UIColor *selectedColor;
@property(nonatomic, strong) UIColor *normalColor;


@end

@implementation XKSegment

- (instancetype)initWithTitleArray:(NSArray<NSString *> *)titleArray {
  return [self initWithTitleArray:titleArray selectColor:XKMainTypeColor normalColor:HEX_RGB(0x777777)];
}

- (instancetype)initWithTitleArray:(NSArray<NSString *> *)titleArray selectColor:(UIColor *)selectColor normalColor:(UIColor *)normalColor {
  self = [self initWithFrame:CGRectZero];
  if (self) {
    _selectedColor = selectColor;
    _normalColor = normalColor;
    _titleArray = titleArray;
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];
    // 布局界面
    [self createConstraints];
  }
  return self;
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
  _btnsArray = @[].mutableCopy;
}

#pragma mark - 初始化界面
- (void)createUI {
  self.backgroundColor = [UIColor whiteColor];
  UIView *tmpView;
  for (int i = 0; i < _titleArray.count; i ++) {
    NSString *str = _titleArray[i];
    UIView *view = [self getSegmentView:str index:i];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.bottom.equalTo(self);
      if (tmpView) {
        make.left.equalTo(tmpView.mas_right);
      } else {
        make.left.equalTo(self.mas_left);
      }
      make.width.equalTo(self.mas_width).multipliedBy(1.0/self.titleArray.count);
    }];
    tmpView = view;
    if (i != _titleArray.count - 1) {
      [view showBorderSite:rzBorderSitePlaceRight];
      view.rightBorder.borderLine.backgroundColor = HEX_RGB(0xF0F0F0);
      view.rightBorder.topMargin = 12;
      view.rightBorder.bottomMargin = 12;
    }
  }
  _sliderView = [[UIView alloc] init];
  _sliderView.backgroundColor = _selectedColor;
  self.clipsToBounds = YES;
  [self addSubview:_sliderView];
  [_sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.mas_bottom);
    make.height.equalTo(@8);
    make.centerX.equalTo(self.btnsArray[0]);
    make.width.equalTo(self.btnsArray[0].mas_width).multipliedBy(1.1);
  }];
  _sliderView.xk_openClip = YES;
  _sliderView.xk_radius = 6;
  _sliderView.xk_clipType = XKCornerClipTypeTopBoth;
  [self setSelectIndex:0];
}

- (void)setSelectIndex:(NSInteger)selectIndex {
  _selectIndex = selectIndex;
  [_btnsArray enumerateObjectsUsingBlock:^(UIButton   * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    obj.selected = NO;
  }];
  UIButton *btn = _btnsArray[selectIndex];
  btn.selected = YES;
  [self sliderViewScroll:selectIndex];
  EXECUTE_BLOCK(self.segmentChange,_selectIndex);
}

- (void)btnClick:(UIButton *)btn {
  [self setSelectIndex:btn.tag];
}

- (void)sliderViewScroll:(NSInteger)selectIndex  {
  [_sliderView mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.btnsArray[selectIndex]);
    make.width.equalTo(self.btnsArray[selectIndex].mas_width).multipliedBy(1.1);
    make.centerY.equalTo(self.mas_bottom);
    make.height.equalTo(@8);
  }];
}

- (UIView *)getSegmentView:(NSString *)str index:(NSInteger)index {
  UIView *view = [[UIView alloc] init];
  UIButton *btn = [[XKButton alloc] init];
  [btn setTitle:str forState:UIControlStateNormal];
  btn.tag = index;
  btn.titleLabel.font = XKRegularFont(14);
  [btn setTitleColor:_normalColor forState:UIControlStateNormal];
  [btn setTitleColor:_selectedColor forState:UIControlStateSelected];
  [btn sizeToFit];
  [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
  [_btnsArray addObject:btn];
  [view addSubview:btn];
  [btn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.equalTo(view);
    make.size.mas_equalTo(btn.size);
  }];
  return view;
}

#pragma mark - 布局界面
- (void)createConstraints {
  
}

#pragma mark ----------------------------- 公用方法 ------------------------------


@end
