//
//  XMScrollPageMenu.m
//  KuaiPin
//
//  Created by 21_xm on 16/5/10.
//  Copyright © 2016年 21_xm. All rights reserved.
//


#define View_W self.frame.size.width
#define View_H self.frame.size.height


#import "XKScrollPageMenuView.h"


@implementation XMTopButtonsView
#pragma mark - 懒加载
- (NSMutableArray *)btns
{
  if (_btns == nil) {
    _btns = [NSMutableArray array];
  }
  return _btns;
}
- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    
    self.height = 40;
    self.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
  }
  return self;
}
// 设置按钮上面的文字
- (void)setTitles:(NSArray *)titles
{
  _titles = titles;
  NSUInteger count = titles.count;
  
  for (int i = 0; i < count ; i++) {
    UIButton *btn = [self addBtnWithTitle:titles[i] WithIndex:i];
    btn.tag = i;
    
    if (i == 0) {
      [self orderChangeAction:btn];
    }
    [self.btns addObject:btn];
    [self.scrollView addSubview:btn];
    
  }
  UIView *slider = [[UIView alloc] init];
  
  slider.backgroundColor = [UIColor orangeColor];
  [self.scrollView addSubview:slider];
  self.slider = slider;
  
}
// 设置默认选择第几个按钮
- (void)setSelectedPageIndex:(NSInteger)selectedPageIndex
{
  _selectedPageIndex = selectedPageIndex;
  
  [self orderChangeAction:self.btns[selectedPageIndex]];
}
// 设置自身高度
- (CGFloat)height
{
  return CGRectGetHeight(self.frame);
}
// 文字设置
- (void)setTitleColor:(UIColor *)titleColor
{
  _titleColor = titleColor;
  for (UIButton *btn in self.btns) {
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
  }
}
- (void)setTitleSelectedColor:(UIColor *)titleSelectedColor
{
  _titleSelectedColor = titleSelectedColor;
  for (UIButton *btn in self.btns) {
    [btn setTitleColor:titleSelectedColor forState:UIControlStateSelected];
  }
}
- (void)setTitleFont:(UIFont *)titleFont
{
  _titleFont = titleFont;
  for (UIButton *btn in self.btns) {
    btn.titleLabel.font = titleFont;
    UIView *cycleView = [btn viewWithTag:1001];
    CGSize titleSize = [btn.currentTitle boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, self.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : XKRegularFont(17)} context:nil].size;
    [cycleView mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(btn.titleLabel.mas_centerX).offset(titleSize.width / 2);
      make.top.equalTo(btn.titleLabel.mas_centerY).offset(- titleSize.height / 2);
      make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
  }
}
- (void)setTitleSelectedFont:(UIFont *)titleSelectedFont
{
  _titleSelectedFont = titleSelectedFont;
  for (UIButton *btn in self.btns) {
    if (btn.selected == YES) {
      btn.titleLabel.font = titleSelectedFont;
    }
  }
}

// 滑块设置
- (void)setSliderColor:(UIColor *)sliderColor
{
  _sliderColor = sliderColor;
  self.slider.backgroundColor = sliderColor;
}

#pragma  mark - 私有方法
// 按钮点击
- (void)orderChangeAction:(UIButton *)btn
{
  self.selectedBtn.selected = NO;
  btn.selected = YES;
  self.selectedBtn = btn;
  
  
  // 设置滑块的位置
  if (self.sliderSize.height != 0) {
    CGFloat sliderX = btn.frame.origin.x + (btn.frame.size.width- self.sliderSize.width) * 0.5;
    CGFloat sliderY = self.height - self.sliderSize.height/2;
    CGFloat sliderW = self.sliderSize.width;
    CGFloat sliderH = self.sliderSize.height;
    self.slider.frame = CGRectMake(sliderX, sliderY, sliderW, sliderH);
  }
  else
  {
    self.slider.frame = CGRectMake(btn.frame.origin.x, CGRectGetMaxY(btn.frame) - 3 , btn.frame.size.width, 2);
  }
  
  // 设置文字和滑块滚动的位置x
  CGPoint point = CGPointMake(btn.frame.origin.x, 0);
  CGFloat btnMaxX = CGRectGetMaxX(btn.frame);//按钮最右边
  CGFloat btnMinX = CGRectGetMinX(btn.frame);//按钮最左边
  //    CGFloat maxX = (self.titles.count + 2) * btn.frame.size.width - View_W;//整个标题的最大长度 - 屏幕 = 超过屏幕的部分
  CGPoint offset = self.scrollView.contentOffset;
  //当按钮的最大位置超出了屏幕 并且按钮的最大位置偏移量大于屏幕 滚动的时候超过屏幕 或者点击的时候偏移量大于屏幕
  if ( (btnMaxX > View_W && self.type == 1) || ((point.x - offset.x) > View_W && self.type == 0)) {
    [self.scrollView setContentOffset:point animated:YES];
  }//在一个屏幕内
  else if (btnMinX < View_W)
  {
    [self.scrollView setContentOffset:CGPointZero animated:YES];
    
  }
  
  // 重新设置文字大小
  self.titleSelectedFont = self.titleSelectedFont;
  for (UIButton *btn in self.btns) {
    if (btn.selected == NO) {
      btn.titleLabel.font = self.titleFont;
    }
  }
  
  // 传递代理
  if ([self.delegate respondsToSelector:@selector(topView:didSelectedBtnAtIndex:)]) {
    [self.delegate topView:self didSelectedBtnAtIndex:btn.tag];
  }
}

// 添加一个按钮
- (UIButton *)addBtnWithTitle:(NSString *)title WithIndex:(NSInteger)index
{
  UIButton *btn = [[UIButton alloc] init];
  [btn setTitle:title forState:UIControlStateNormal];
  [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
  [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [btn setBackgroundColor:[UIColor clearColor]];
  btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
  btn.tag = index + 10000;
  btn.titleLabel.font = [UIFont systemFontOfSize:17];
  [btn addTarget:self action:@selector(orderChangeAction:) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:btn];
  
  CGSize titleSize = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, self.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : XKRegularFont(17)} context:nil].size;
  UIView *cycleView = [[UIView alloc] init];
  cycleView.tag = 1001;
  cycleView.layer.cornerRadius = 4.f;
  cycleView.backgroundColor = UIColorFromRGB(0xEE6161);
  [btn addSubview:cycleView];
  [cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(btn.titleLabel.mas_centerX).offset(titleSize.width / 2);
    make.top.equalTo(btn.titleLabel.mas_centerY).offset(- titleSize.height / 2);
    make.size.mas_equalTo(CGSizeMake(8, 8));
  }];
  cycleView.hidden = YES;
  return btn;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  NSUInteger count = self.btns.count;
  
  CGFloat btnW;
  NSUInteger numberOftitles = self.numberOfTitles;
  if (numberOftitles != 0) {
    btnW = View_W / numberOftitles;
  }
  else
  {
    if (count <= 5) {
      btnW = View_W / count;
    }
    else
    {
      btnW = View_W / 6 + 5;
    }
  }
  
  CGFloat sliderHeight = self.sliderSize.height;
  CGFloat sliderWidth = self.sliderSize.width;
  if (sliderHeight == 0) {
    sliderHeight = 2;
    
  }
  if (sliderWidth == 0) {
    sliderWidth = btnW;
  }
  
  self.slider.frame = CGRectMake((btnW - sliderWidth) * 0.5, self.height - sliderHeight/2, sliderWidth, sliderHeight);
  self.slider.layer.cornerRadius = sliderHeight/2;
  self.slider.layer.masksToBounds = YES;
  for (int i = 0; i < count ; i++) {
    UIButton *btn = self.btns[i];
    btn.frame = CGRectMake(btnW * i, 0, btnW, self.height);
  }
  
  self.scrollView.frame = CGRectMake(0, 0, View_W, self.height);
  self.scrollView.contentSize = CGSizeMake(btnW * count, 0);
  
  // 更新默认选择显示第几页时滑块的位置
  CGFloat sliderCenter_X = self.slider.center.x;
  CGFloat selectedBtnCenter_X = self.selectedBtn.center.x;
  if (sliderCenter_X != selectedBtnCenter_X) {
    self.slider.center = CGPointMake(selectedBtnCenter_X, self.slider.center.y);
  }
}
@end



//==========================================================================

@interface XKScrollPageMenuView ()<XMTopButtonsViewDelegate,UIScrollViewDelegate>



@end

@implementation XKScrollPageMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self setupUI];
  }
  return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
  [super setBackgroundColor:backgroundColor];
  _topView.backgroundColor = backgroundColor;
}

- (void)setupUI {
  
  XMTopButtonsView *topView = [[XMTopButtonsView alloc] initWithFrame:CGRectMake(0, 0, View_W, 40)];
  topView.delegate = self;
  topView.clipsToBounds = YES;
  topView.backgroundColor =  XKMainTypeColor ;
  [self addSubview:topView];
  self.topView = topView;
  
  UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, View_W, View_H - 40)];
  scrollView.delegate = self;
  scrollView.showsVerticalScrollIndicator = NO;
  scrollView.showsHorizontalScrollIndicator = NO;
  scrollView.pagingEnabled = YES;
  [self addSubview:scrollView];
  self.scrollView = scrollView;
  
}

//是否显示/隐藏红点
- (void)operationRedTipForIndex:(NSInteger)index isHidden:(BOOL)hidden {
  if (self.topView.btns.count > 0 ) {
    UIButton *btn = self.topView.btns[index];
    if (btn) {
      UIView *redView = [btn viewWithTag:1001];
      redView.hidden = hidden;
    }
  }
  
}
#pragma mark - 重写属性方法
- (void)setTopBgColor:(UIColor *)topBgColor {
  _topBgColor = topBgColor;
  self.topView.backgroundColor = topBgColor;
}
/**
 *  整体设置
 */
// 设置下面的子View的数组
- (void)setChildViews:(NSArray *)childViews
{
  _childViews = childViews;
  
  NSInteger count = childViews.count;
  self.scrollView.contentSize = CGSizeMake(View_W * count, 0);
  
  for (int i = 0; i < count; i++) {
    UIViewController *childVc = childViews[i];
    [self.scrollView addSubview:childVc.view];
    //        childVc.view.backgroundColor = [UIColor clearColor];
    childVc.view.frame = CGRectMake(View_W * i, 0, View_W, View_H - 40);
    
  }
  
}
// 设置默认选择的按钮
- (void)setSelectedPageIndex:(NSInteger)selectedPageIndex
{
  if (!selectedPageIndex) return;
  _selectedPageIndex = selectedPageIndex;
  self.topView.selectedPageIndex = selectedPageIndex;
  [self topView:self.topView didSelectedBtnAtIndex:selectedPageIndex];
}

// 设置上面按钮的文字数组
- (void)setTitles:(NSArray *)titles
{
  if (!titles) return;
  _titles = titles;
  self.topView.titles = titles;
}
// 设置上面滚动条的高度
- (void)setTitleBarHeight:(CGFloat)titleBarHeight
{
  if (!titleBarHeight) return;
  _titleBarHeight = titleBarHeight;
  self.topView.frame = CGRectMake(0, 0, View_W, titleBarHeight);
  CGFloat topViewMaxY = CGRectGetMaxY(self.topView.frame);
  self.scrollView.frame = CGRectMake(0, topViewMaxY, View_W, View_H - topViewMaxY);
}
// 设置上面可以显示的按钮个数
- (void)setNumberOfTitles:(NSInteger)numberOfTitles
{
  if (!numberOfTitles) return;
  _numberOfTitles = numberOfTitles;
  self.topView.numberOfTitles = numberOfTitles;
}

/**
 *  具体文字设置
 */
// 文字未选中时的颜色
- (void)setTitleColor:(UIColor *)titleColor
{
  if (!titleColor) return;
  _titleColor = titleColor;
  self.topView.titleColor = titleColor;
}
// 文字选中时的颜色
- (void)setTitleSelectedColor:(UIColor *)titleSelectedColor
{
  if (!titleSelectedColor) return;
  _titleSelectedColor = titleSelectedColor;
  self.topView.titleSelectedColor = titleSelectedColor;
}

// 未选中文字的大小
- (void)setTitleFont:(UIFont *)titleFont
{
  if (!titleFont) return;
  _titleFont = titleFont;
  self.topView.titleFont = titleFont;
}
// 选中文字的大小
- (void)setTitleSelectedFont:(UIFont *)titleSelectedFont
{
  if (!titleSelectedFont) return;
  _titleSelectedFont = titleSelectedFont;
  self.topView.titleSelectedFont = titleSelectedFont;
}

/**
 *  滑块的具体设置
 */
// 滑块的颜色
- (void)setSliderColor:(UIColor *)sliderColor
{
  if (!sliderColor) return;
  _sliderColor = sliderColor;
  self.topView.sliderColor = sliderColor;
}
// 滑块的高度
- (void)setSliderSize:(CGSize)sliderSize
{
  if (!sliderSize.width) return;
  _sliderSize = sliderSize;
  self.topView.sliderSize = sliderSize;
}

#pragma mark - 私有方法
// 滚动的时候上面的按钮跟着变换
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  NSUInteger currentPage = scrollView.contentOffset.x / View_W;
  
  // 根据滚动的位置切换被选中的按钮
  self.topView.type = 1;
  self.topView.selectedPageIndex = currentPage;
  NSLog(@"%zd",self.topView.selectedPageIndex);
  if(self.selectedBlock) {
    self.selectedBlock(currentPage);
  };
}
// 点击按钮下面的View跟着滚动
- (void)topView:(XMTopButtonsView *)topView didSelectedBtnAtIndex:(NSInteger)index
{
  CGPoint point = CGPointMake(View_W * index, 0);
  self.topView.type = 0;
  [self.scrollView setContentOffset:point animated:NO];
  if(self.selectedBlock) {
    self.selectedBlock(index);
  };
  
}


@end
