/*******************************************************************************
 # File        : XKTimePickerView.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/12
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKTimePickerView.h"
#import "XKCommonSheetView.h"
#import "UIView+Border.h"

@interface  XKTimePickerView () {
    UILabel *_label;
}
/**<##>*/
@property(nonatomic, strong) XKCommonSheetView *sheetView;
/**<##>*/
@property(nonatomic, strong) UIDatePicker *datePicker;

/**<##>*/
@property(nonatomic, copy) void(^sureBlock)(NSDate *date);
@property(nonatomic, copy) void(^cancleBlock)(NSDate *date);
@end

@implementation XKTimePickerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216+ 45 + kBottomSafeHeight);
    _label = [[UILabel alloc] init];
    [_label showBorderSite:rzBorderSitePlaceBottom];
    
    [contentView addSubview:_label];
    _label.frame = CGRectMake(10, 0, SCREEN_WIDTH - 10, 45);
    _label.textColor = XKMainTypeColor;
    _label.text = [XKTimeSeparateHelper backYMDWeekHMStringByChineseSegmentWithDate: [NSDate date]];
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.titleLabel.font = XKRegularFont(16);
    [button setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
    button.frame = CGRectMake(SCREEN_WIDTH - 60, 0, 60, 45);
    [contentView addSubview:button];
    [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 216)];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.minimumDate = [NSDate date];
    [datePicker addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    [contentView addSubview:datePicker];
    self.datePicker = datePicker;
    __weak typeof(self) weakSelf = self;
    _sheetView = [[XKCommonSheetView alloc] init];
    _sheetView.animationWay = AnimationWay_bottomSheet;
    _sheetView.contentView = contentView;
    [_sheetView setDismissBlock:^{
        EXECUTE_BLOCK(weakSelf.cancleBlock,datePicker.date);
    }];
    [_sheetView addSubview:contentView];
}

- (void)setSureClick:(void(^)(NSDate *date))sure cancel:(void(^)(NSDate *date))cancel {
    _sureBlock = sure;
    _cancleBlock = cancel;
}

- (void)btnClick {
    [_sheetView dismiss];
    EXECUTE_BLOCK(self.sureBlock,self.datePicker.date);
}

- (void)show {
    [_sheetView show];
}

- (void)setDate:(NSDate *)date {
    [_datePicker setDate:date];
     _label.text = [XKTimeSeparateHelper backYMDWeekHMStringByChineseSegmentWithDate:_datePicker.date];
}

- (void)change:(UIDatePicker *)dataPicker {
    _label.text = [XKTimeSeparateHelper backYMDWeekHMStringByChineseSegmentWithDate:dataPicker.date];
    
}

- (void)dealloc {
    
}




@end
