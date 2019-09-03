//
//  XKTimeDurationPickerViewController.m
//  xkMerchant
//
//  Created by RyanYuan on 2018/12/26.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "XKTimeDurationPickerViewController.h"

static const CGFloat kXKTimeDurationPickerViewControllerContainerViewHeight = 300;
static const CGFloat kXKTimeDurationPickerViewControllerPickerViewHeight = 251;

@interface XKTimeDurationPickerViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *dayArr;
@property (nonatomic, strong) NSMutableArray *hourArr;
@property (nonatomic, strong) NSMutableArray *minuteArr;

@end

@implementation XKTimeDurationPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  [self initializeViews];
  [self initializeDataSource];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  if (self.pickerView) {
    if (self.selectedTimeArr) {
      NSDictionary *dayDict = self.selectedTimeArr[0];
      NSDictionary *hourDict = self.selectedTimeArr[1];
      NSDictionary *minuteDict = self.selectedTimeArr[2];
      
      NSInteger dayIndex = 0;
      for (NSInteger index = 0; index < self.dayArr.count; index++) {
        NSDictionary *tempDayDict = self.dayArr[index];
        if ([dayDict[@"title"] isEqualToString:tempDayDict[@"title"]]) {
          dayIndex = index;
        }
      }
      
      NSInteger hourIndex = 0;
      for (NSInteger index = 0; index < self.hourArr.count; index++) {
        NSDictionary *tempHourDict = self.hourArr[index];
        if ([hourDict[@"title"] isEqualToString:tempHourDict[@"title"]]) {
          hourIndex = index;
        }
      }
      
      NSInteger minuteIndex = 0;
      for (NSInteger index = 0; index < self.minuteArr.count; index++) {
        NSDictionary *tempMinuteDict = self.minuteArr[index];
        if ([minuteDict[@"title"] isEqualToString:tempMinuteDict[@"title"]]) {
          minuteIndex = index;
        }
      }
      [self.pickerView selectRow:dayIndex inComponent:0 animated:YES];
      [self.pickerView selectRow:hourIndex inComponent:1 animated:YES];
      [self.pickerView selectRow:minuteIndex inComponent:2 animated:YES];
    } else {
      [self.pickerView selectRow:5 inComponent:2 animated:YES];
    }
  }
}

#pragma mark - private methods

- (void)initializeViews {
  
  // 控制器根视图
  self.view.backgroundColor = [UIColor clearColor];
  
  // 标签选择容器
  UIView *containerView = [UIView new];
  containerView.backgroundColor = HEX_RGB(0xF6F6F6);
  [self.view addSubview:containerView];
  [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(self.view.mas_bottom).offset(-kBottomSafeHeight);
    make.width.equalTo(self.view.mas_width);
    make.height.offset(kXKTimeDurationPickerViewControllerContainerViewHeight);
  }];
  
  // 遮罩视图
  UIView *maskView = [UIView new];
  maskView.backgroundColor = [UIColor blackColor];
  maskView.alpha = 0.5;
  [self.view addSubview:maskView];
  [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.view.mas_top);
    make.bottom.equalTo(containerView.mas_top);
    make.width.equalTo(self.view.mas_width);
  }];
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMaskView:)];
  [maskView addGestureRecognizer:tap];
  
  // 滑动选择器
  UIPickerView *pickerView = [UIPickerView new];
  pickerView.delegate = self;
  pickerView.dataSource = self;
  pickerView.backgroundColor = [UIColor whiteColor];
  [containerView addSubview:pickerView];
  [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(containerView.mas_top);
    make.left.equalTo(containerView.mas_left);
    make.right.equalTo(containerView.mas_right);
    make.height.offset(kXKTimeDurationPickerViewControllerPickerViewHeight);
  }];
  self.pickerView = pickerView;
  
  // 取消接口
  UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
  cancelButton.backgroundColor = [UIColor whiteColor];
  [cancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
  cancelButton.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:15.0];
  [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
  [cancelButton addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
  [containerView addSubview:cancelButton];
  [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(pickerView.mas_bottom).offset(5);
    make.bottom.equalTo(containerView.mas_bottom);
    make.left.equalTo(containerView.mas_left);
    make.width.offset(SCREEN_WIDTH / 2);
  }];
  
  // 确定按钮
  UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
  confirmButton.backgroundColor = [UIColor whiteColor];
  [confirmButton setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
  confirmButton.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:15.0];
  [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
  [confirmButton addTarget:self action:@selector(clickConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
  [containerView addSubview:confirmButton];
  [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(pickerView.mas_bottom).offset(5);
    make.left.equalTo(cancelButton.mas_right).offset(1);
    make.bottom.equalTo(containerView.mas_bottom);
    make.right.equalTo(containerView.mas_right);
  }];
}

- (void)initializeDataSource {
  
  NSMutableArray *dayArr = @[].mutableCopy;
  for (NSInteger index = 0; index < 30; index++) {
    NSString *dayTitle = [NSString stringWithFormat:@"%@天", @(index)];
    NSNumber *dayNumber = @(index * 24 * 60 *60);
    NSDictionary *dayDict = @{@"title": dayTitle, @"number": dayNumber};
    [dayArr addObject:dayDict];
  }
  self.dayArr = dayArr;
  
  NSMutableArray *hourArr = @[].mutableCopy;
  for (NSInteger index = 0; index < 24; index++) {
    NSString *hourTitle = [NSString stringWithFormat:@"%@小时", @(index)];
    NSNumber *hourNumber = @(index * 60 *60);
    NSDictionary *hourDict = @{@"title": hourTitle, @"number": hourNumber};
    [hourArr addObject:hourDict];
  }
  self.hourArr = hourArr;
  
  NSMutableArray *minuteArr = @[].mutableCopy;
  for (NSInteger index = 0; index < 60; index++) {
    NSString *minuteTitle = [NSString stringWithFormat:@"%@分钟", @(index)];
    NSNumber *minuteNumber = @(index * 60);
    NSDictionary *minuteDict = @{@"title": minuteTitle, @"number": minuteNumber};
    [minuteArr addObject:minuteDict];
  }
  self.minuteArr = minuteArr;
  
  self.dataArr = @[dayArr, hourArr, minuteArr];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
  return self.dataArr.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
  NSArray *timeArr = self.dataArr[component];
  return timeArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
  
  NSArray *timeArr = self.dataArr[component];
  NSDictionary *timeDict = timeArr[row];
  NSString *timeString = timeDict[@"title"];
  return timeString;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
  
  if ([pickerView selectedRowInComponent:0] == 0 &&
      [pickerView selectedRowInComponent:1] == 0 &&
      [pickerView selectedRowInComponent:2] <= 4 ) {
    [pickerView selectRow:5 inComponent:2 animated:YES];
  }
}

- (void)clickMaskView:(UITapGestureRecognizer *)tapGestureRecognizer {
  [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)clickCancelButton:(UIControl *)sender {
  [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)clickConfirmButton:(UIControl *)sender {
  
  if ([self anySubViewScrolling:self.pickerView]) {
    return;
  }
  
  if ([self.delegate respondsToSelector:@selector(viewController:selectedTimeArr:)]) {
    
    NSInteger dayIndex = [self.pickerView selectedRowInComponent:0];
    NSInteger hourIndex = [self.pickerView selectedRowInComponent:1];
    NSInteger minuteIndex = [self.pickerView selectedRowInComponent:2];
    NSDictionary *dayDict = self.dayArr[dayIndex];
    NSDictionary *hourDict = self.hourArr[hourIndex];
    NSDictionary *minuteDict = self.minuteArr[minuteIndex];
    NSArray *timeArr = @[dayDict, hourDict, minuteDict];
    [self.delegate viewController:self selectedTimeArr:timeArr];
  }
  [self dismissViewControllerAnimated:NO completion:nil];
}

- (BOOL)anySubViewScrolling:(UIView *)view {
  
  if ([view isKindOfClass:[UIScrollView class]]) {
    UIScrollView *scrollView = (UIScrollView *)view;
    if (scrollView.dragging || scrollView.decelerating) {
      return YES;
    }
  }
  for (UIView *theSubView in view.subviews) {
    if ([self anySubViewScrolling:theSubView]) {
      return YES;
    }
  }
  return NO;
}

@end
