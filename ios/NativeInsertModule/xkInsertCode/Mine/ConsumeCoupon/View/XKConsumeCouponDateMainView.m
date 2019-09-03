//
//  XKConsumeCouponDateMainView.m
//  XKSquare
//
//  Created by william on 2018/9/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKConsumeCouponDateMainView.h"
#import "XKTransactionDetailTimeChooseView.h"
#import "XKCommonSheetView.h"
@interface XKConsumeCouponDateMainView()

@property(nonatomic, strong) UIView     *backgroundView;
@property(nonatomic, strong) UILabel    *dateLabel;     //日期Label
@property(nonatomic, strong) UILabel    *detailLabel;
@property(nonatomic, strong) UIButton   *dataButton;
@property (nonatomic, strong) XKTransactionDetailTimeChooseView   *timeChooseView;
@property (nonatomic, strong) XKCommonSheetView  *timeChooseSheetView;

@end

@implementation XKConsumeCouponDateMainView

#pragma mark – Life Cycle

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self initViews];
        [self autoLayout];
    }
    return self;
}

#pragma mark – Private Methods
-(void)initViews{
    [self addSubview:self.backgroundView];
    [self addSubview:self.dateLabel];
    [self addSubview:self.detailLabel];
    [self addSubview:self.dataButton];
}

-(void)autoLayout{
    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self.mas_left).offset(10 * ScreenScale);
        make.right.mas_equalTo(self.mas_right).offset(-10 * ScreenScale);
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self->_backgroundView.mas_left).offset(15 * ScreenScale);
        make.height.mas_equalTo(28 * ScreenScale);
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self->_dateLabel.mas_left);
        make.height.mas_equalTo(14 * ScreenScale);
    }];
    
    [_dataButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self->_backgroundView.mas_right).offset(-15 * ScreenScale);
        make.size.mas_equalTo(CGSizeMake(20 * ScreenScale, 20 * ScreenScale));
    }];
}

-(void)setDataDic:(NSMutableDictionary *)dataDic{
    _dataDic = dataDic;
    _dateLabel.text = @"本月";
    _detailLabel.text = [NSString stringWithFormat:@"支出：¥%@  收入：¥%@",dataDic[@"monPay"]?dataDic[@"monPay"]:@"0",dataDic[@"monIncome"]?dataDic[@"monIncome"]:@"0"];
}
#pragma mark - Events

-(void)dateButtonClicked:(UIButton *)sender{
    [self.timeChooseSheetView show];
}

#pragma mark - Custom Delegates

#pragma mark – Getters and Setters

-(UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc]init];
        _backgroundView.backgroundColor = UIColorFromRGB(0xcfe1fc);
    }
    return _backgroundView;
}

-(UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(14) textColor:UIColorFromRGB(0x555555) backgroundColor:[UIColor clearColor]];
        _dateLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _dateLabel;
}

-(UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(10) textColor:UIColorFromRGB(0x777777) backgroundColor:[UIColor clearColor]];
    }
    return _detailLabel;
}

-(UIButton *)dataButton{
    if (!_dataButton) {
        _dataButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dataButton setBackgroundImage:[UIImage imageNamed:@"xk_bg_Mine_ConsumeCoupon_Calendar"] forState:UIControlStateNormal];
        [_dataButton addTarget:self action:@selector(dateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dataButton;
}

- (XKTransactionDetailTimeChooseView *)timeChooseView {
    if (!_timeChooseView) {
        _timeChooseView = [[XKTransactionDetailTimeChooseView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 330)];
        XKWeakSelf(weakSelf);
        _timeChooseView.cancelBlock = ^{
            [weakSelf.timeChooseSheetView dismiss];
        };
        _timeChooseView.sureBlock = ^(NSString *time1, NSString *time2, NSString *time3, NSInteger way) {
//            [weakSelf refreshDataListWithTime1:time1 time2:time2 time3:time3 way:way];
            NSLog(@"%@--%@--%@ :%ld",time1,time2,time3,(long)way);
            if (weakSelf.backBlock) {
                NSString *string = @"";
                if (way == 0) {
                    NSRange startRange = [time1 rangeOfString:@"-"];
                    string = [time1 substringFromIndex:startRange.location + 1];//截取掉下标3之后的字符串
                    
                }
                else{
                    if (time3) {
                        NSRange range = NSMakeRange(5,2);
                        string = [time3 substringWithRange:range];
                    }
                    
                }
                weakSelf.backBlock(string);
            }
            [weakSelf.timeChooseSheetView dismiss];
        };
    }
    return _timeChooseView;
}

- (XKCommonSheetView *)timeChooseSheetView {
    
    if (!_timeChooseSheetView) {
        _timeChooseSheetView = [[XKCommonSheetView alloc] init];
        _timeChooseSheetView.contentView = self.timeChooseView;
        [_timeChooseSheetView addSubview:self.timeChooseView];
    }
    return _timeChooseSheetView;
}

@end
