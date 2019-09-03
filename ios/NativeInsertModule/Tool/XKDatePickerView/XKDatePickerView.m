//
//  XKDatePickerView.m
//  XKSquare
//
//  Created by Lin Li on 2018/9/5.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKDatePickerView.h"
@interface XKDatePickerView () <UIPickerViewDelegate, UIPickerViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIPickerView *pickerView; // 选择器
@property (nonatomic, strong) UIView *toolView; // 工具条
@property (nonatomic, strong) UIView *toolBottomView; // 下面工具条
@property (nonatomic, strong) UIView *contentView;//视图
@property (nonatomic, strong) NSMutableArray *dataArray; // 数据源
@property (nonatomic, strong) NSMutableArray *yearArr; // 年数组
@property (nonatomic, strong) NSMutableArray *monthArr; // 月数组
@property (nonatomic, strong) NSMutableArray *dayArr; // 日数组
@property (nonatomic, strong) NSArray *timeArr; // 当前时间数组
@property (nonatomic, copy) NSString *year; // 选中年
@property (nonatomic, copy) NSString *month; //选中月
@property (nonatomic, copy) NSString *day; //选中日
@property (nonatomic, copy) NSString *selectStr; // 选中的时间
#define contentViewH  271 + kBottomSafeHeight
@end
@implementation XKDatePickerView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelBtnClick)];
        dismissTap.delegate = self;
        self.frame = [UIScreen mainScreen].bounds;
        [self addGestureRecognizer:dismissTap];
        self.timeArr = [NSArray array];
        self.dataArray = [NSMutableArray array];
        [self.dataArray addObject:self.yearArr];
        [self.dataArray addObject:self.monthArr];
        [self.dataArray addObject:self.dayArr];
        [self configData];
        [self configToolView];
        [self configBottomToolView];
        [self configPickerView];
    }
    return self;
}

- (void)configData {
    NSDate *date = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.CurrentDate = [dateFormatter stringFromDate:date];
}

// 配置工具条
- (void)configToolView {
    self.contentView = [[UIView alloc]init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@(contentViewH));
    }];
    
    self.toolView = [[UIView alloc] init];
    [self.contentView addSubview:self.toolView];
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.equalTo(@30);
    }];
    
    UIButton *saveBtn = [[UIButton alloc] init];
    [saveBtn setTitle:@"确定" forState:UIControlStateNormal];
    [saveBtn setTitleColor:HEX_RGB(0x4A90FA) forState:UIControlStateNormal];
    saveBtn.titleLabel.font = XKFont(XK_PingFangSC_Regular, 17);
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolView addSubview:saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-50));
        make.centerY.equalTo(self.toolView).offset(5);
        make.width.equalTo(@40);
        make.height.equalTo(@24);

    }];
    
}

- (void)configBottomToolView {
    self.toolBottomView = [[UIView alloc] init];
    [self.contentView addSubview:self.toolBottomView];
    [self.toolBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(- kBottomSafeHeight);
        make.height.equalTo(@50);
    }];
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = XKSeparatorLineColor;
    [self.toolBottomView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.toolBottomView);
        make.height.equalTo(@5);
    }];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:HEX_RGB(0x222222) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = XKFont(XK_PingFangSC_Regular, 17);
    [self.toolBottomView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.toolBottomView);
        make.width.equalTo(@34);
        make.height.equalTo(@16);
    }];
}

// 配置UIPickerView
- (void)configPickerView {
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.showsSelectionIndicator = YES;
    [self.contentView addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.toolView.mas_bottom);
        make.bottom.equalTo(self.toolBottomView.mas_top);
    }];
}

- (void)show {
    self.year = [NSString stringWithFormat:@"%ld年", [self.timeArr[0] integerValue]];
    self.month = [NSString stringWithFormat:@"%ld月", [self.timeArr[1] integerValue]];
    self.day = [NSString stringWithFormat:@"%ld日", [self.timeArr[2] integerValue]];
    NSString *myYear = [self.year substringWithRange:NSMakeRange(0, self.year.length - 1)];
    if ([myYear integerValue] > [self getCurrentYear]) {
        self.year = [NSString stringWithFormat:@"%ld年", [self getCurrentYear] ];
    }
    [self.pickerView selectRow:[self.yearArr indexOfObject:self.year] inComponent:0 animated:YES];
    /// 重新格式化转一下，是因为如果是09月/日/时，数据源是9月/日/时,就会出现崩溃
    [self.pickerView selectRow:[self.monthArr indexOfObject:self.month] inComponent:1 animated:YES];
    [self.pickerView selectRow:[self.dayArr indexOfObject:self.day] inComponent:2 animated:YES];
    /// 刷新日
    [self refreshDay];
    [self refreshMonth];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(contentViewH);
    }];
    [self layoutIfNeeded];
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
    }];
    self.backgroundColor = RGBA(0, 0, 0, 0.5);
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
        [self.superview layoutIfNeeded];
    }];
}

- (void)setCurrentDate:(NSString *)CurrentDate {
    _CurrentDate = CurrentDate;
    
    NSString *newDate = [[CurrentDate stringByReplacingOccurrencesOfString:@"-" withString:@" "] stringByReplacingOccurrencesOfString:@":" withString:@" "];
    NSMutableArray *timerArray = [NSMutableArray arrayWithArray:[newDate componentsSeparatedByString:@" "]];
    [timerArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@年", timerArray[0]]];
    [timerArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@月", timerArray[1]]];
    [timerArray replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@日", timerArray[2]]];
    self.timeArr = timerArray;
}

// 保存按钮点击方法
- (void)saveBtnClick {
    NSLog(@"点击了保存");
    NSString *month = self.month.length == 3 ? [NSString stringWithFormat:@"%ld", self.month.integerValue] : [NSString stringWithFormat:@"0%ld", self.month.integerValue];
    NSString *day = self.day.length == 3 ? [NSString stringWithFormat:@"%ld", self.day.integerValue] : [NSString stringWithFormat:@"0%ld", self.day.integerValue];
    self.selectStr = [NSString stringWithFormat:@"%ld-%@-%@", [self.year integerValue], month, day];
    if ([self.delegate respondsToSelector:@selector(datePickerViewSaveBtnClickDelegate:)]) {
        [self.delegate datePickerViewSaveBtnClickDelegate:self.selectStr];
    }
    [self cancelBtnClick];
}

// 取消按钮点击方法
- (void)cancelBtnClick {
    NSLog(@"点击了取消");
    if ([self.delegate respondsToSelector:@selector(datePickerViewCancelBtnClickDelegate)]) {
        [self.delegate datePickerViewCancelBtnClickDelegate];
    }
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0);
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).offset(contentViewH);
            make.height.equalTo(@(contentViewH));
        }];
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UIPickerViewDelegate and UIPickerViewDataSource
// UIPickerView返回多少组
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.dataArray.count;
}

// UIPickerView返回每组多少条数据
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return  [self.dataArray[component] count] ;
}

// UIPickerView选择哪一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0: { // 年
            NSString *year_integerValue = self.yearArr[row%[self.dataArray[component] count]];
            self.year = year_integerValue;
            [self refreshMonth];
            [self refreshDay];
        } break;
        case 1: { // 月
            
            NSString *month_value = self.monthArr[row%[self.dataArray[component] count]];
                self.month = month_value;
                /// 刷新日
                [self refreshDay];
        } break;
        case 2: { // 日
            // 如果选择年大于当前年 就直接赋值日
            NSString *day_value = self.dayArr[row%[self.dataArray[component] count]];
            self.day = day_value;
        } break;
        default: break;
    }
    
}
// UIPickerView返回每一行数据
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return  [self.dataArray[component] objectAtIndex:row%[self.dataArray[component] count]];
}
// UIPickerView返回每一行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}
// UIPickerView返回每一行的View
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *titleLbl;
    if (!view) {
        titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, 40)];
        titleLbl.font = [UIFont systemFontOfSize:17];
        titleLbl.textAlignment = NSTextAlignmentCenter;
    } else {
        titleLbl = (UILabel *)view;
    }
    titleLbl.text = [self.dataArray[component] objectAtIndex:row%[self.dataArray[component] count]];
    return titleLbl;
}


- (void)pickerViewLoaded:(NSInteger)component row:(NSInteger)row{
    NSUInteger max = 16384;
    NSUInteger base10 = (max/2)-(max/2)%row;
    [self.pickerView selectRow:[self.pickerView selectedRowInComponent:component] % row + base10 inComponent:component animated:NO];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 100;
}
#pragma mark - Getter

/// 获取年份
- (NSMutableArray *)yearArr {
    if (!_yearArr) {
        _yearArr = [NSMutableArray array];
        for (int i = 1970; i < [self getCurrentYear] + 1; i ++) {
            [_yearArr addObject:[NSString stringWithFormat:@"%d年", i]];
        }
    }
    return _yearArr;
}

/// 获取月份
- (NSMutableArray *)monthArr {
    if (!_monthArr) {
        _monthArr = [NSMutableArray array];
        for (int i = 1; i <= 12; i ++) {
            [_monthArr addObject:[NSString stringWithFormat:@"%d月", i]];
        }
    }
    return _monthArr;
}

/// 获取当前月的天数
- (NSMutableArray *)dayArr {
    if (!_dayArr) {
        _dayArr = [NSMutableArray array];
        for (int i = 1; i <= 31; i ++) {
            [_dayArr addObject:[NSString stringWithFormat:@"%d日", i]];
        }
    }
    return _dayArr;
}
- (void)refreshMonth {
    NSMutableArray *arr = [NSMutableArray array];
    int monthL = 12;
    if (self.year.integerValue == [self getCurrentYear]) {
        monthL = (int)[self getCurrentMonth];
    }
    for (int i = 1; i < monthL + 1; i ++) {
        [arr addObject:[NSString stringWithFormat:@"%d月", i]];
    }
    
    [self.dataArray replaceObjectAtIndex:1 withObject:arr];
    [self.pickerView reloadComponent:1];
}

- (void)refreshDay {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 1; i < [self getDayNumber:self.year.integerValue month:self.month.integerValue].integerValue + 1; i ++) {
        [arr addObject:[NSString stringWithFormat:@"%d日", i]];
    }
    
    [self.dataArray replaceObjectAtIndex:2 withObject:arr];
    [self.pickerView reloadComponent:2];
}

- (NSString *)getDayNumber:(NSInteger)year month:(NSInteger)month{
    NSArray *days = @[@"31", @"28", @"31", @"30", @"31", @"30", @"31", @"31", @"30", @"31", @"30", @"31"];
    if (month == [self getCurrentMonth] && year == [self getCurrentYear]) {
        return [NSString stringWithFormat:@"%ld",(long)[self getCurrentDay]];
    }
    if (2 == month && 0 == (year % 4) && (0 != (year % 100) || 0 == (year % 400))) {
        return @"29";
    }
    return days[month - 1];
}
- (NSDateComponents *)getCurrentYearMonthDay:(unsigned int)calendarUnit {
    NSDate *date = [NSDate date];//这个是NSDate类型的日期，所要获取的年月日都放在这里；
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    //这句是说你要获取日期的元素有哪些。获取年就要写NSYearCalendarUnit，获取小时就要写NSHourCalendarUnit，中间用|隔开；
    unsigned int unitFlags = calendarUnit;
    //把要从date中获取的unitFlags标示的日期元素存放在NSDateComponents类型的d里面；
    NSDateComponents *d = [cal components:unitFlags fromDate:date];
    return d;
}

- (NSInteger)getCurrentYear {
    return [[self getCurrentYearMonthDay:NSCalendarUnitYear]year];
}
- (NSInteger)getCurrentMonth {
    return [[self getCurrentYearMonthDay:NSCalendarUnitMonth]month];
}
- (NSInteger)getCurrentDay {
    return [[self getCurrentYearMonthDay:NSCalendarUnitDay]day];
}
@end
