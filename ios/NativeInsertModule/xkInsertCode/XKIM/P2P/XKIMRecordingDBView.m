//
//  XKIMRecordingDBView.m
//  XKSquare
//
//  Created by william on 2018/12/11.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKIMRecordingDBView.h"

@interface XKIMRecordingDBView()
@property(nonatomic,strong) UIView *fifthDBView;
@property(nonatomic,strong) UIView *forthDBView;
@property(nonatomic,strong) UIView *thirdDBView;
@property(nonatomic,strong) UIView *secondDBView;
@property(nonatomic,strong) UIView *firstDBView;

@end

@implementation XKIMRecordingDBView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initViews];
        [self layoutViews];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)initViews{
    [self addSubview:self.firstDBView];
    [self addSubview:self.secondDBView];
    [self addSubview:self.thirdDBView];
    [self addSubview:self.forthDBView];
    [self addSubview:self.fifthDBView];
}

-(void)layoutViews{
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    XKWeakSelf(weakSelf);
    [_firstDBView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(width / 5, height / 7));
    }];
    
    [_secondDBView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(weakSelf.firstDBView.mas_top).offset(- height / 22);
        make.size.mas_equalTo(CGSizeMake(2 * width / 5, height / 7));
    }];
    
    [_thirdDBView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(weakSelf.secondDBView.mas_top).offset(- height / 22);
        make.size.mas_equalTo(CGSizeMake( 3 * width / 5, height / 7));
    }];
    
    [_forthDBView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(weakSelf.thirdDBView.mas_top).offset(- height / 22);
        make.size.mas_equalTo(CGSizeMake(4 * width / 5, height / 7));
    }];
    
    [_fifthDBView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(weakSelf.forthDBView.mas_top).offset(- height / 22);
        make.size.mas_equalTo(CGSizeMake(width, height / 7));
    }];
}

-(UIView *)firstDBView{
    if (!_firstDBView) {
        _firstDBView = [[UIView alloc]init];
        _firstDBView.backgroundColor = [UIColor whiteColor];
    }
    return _firstDBView;
}

-(UIView *)secondDBView{
    if (!_secondDBView) {
        _secondDBView = [[UIView alloc]init];
        _secondDBView.backgroundColor = [UIColor whiteColor];
    }
    return _secondDBView;
}

-(UIView *)thirdDBView{
    if (!_thirdDBView) {
        _thirdDBView = [[UIView alloc]init];
        _thirdDBView.backgroundColor = [UIColor whiteColor];
    }
    return _thirdDBView;
}

-(UIView *)forthDBView{
    if (!_forthDBView) {
        _forthDBView = [[UIView alloc]init];
        _forthDBView.backgroundColor = [UIColor whiteColor];
    }
    return _forthDBView;
}

-(UIView *)fifthDBView{
    if (!_fifthDBView) {
        _fifthDBView = [[UIView alloc]init];
        _fifthDBView.backgroundColor = [UIColor whiteColor];
    }
    return _fifthDBView;
}

-(void)setDBValue:(int)DBValue{
    _DBValue = DBValue;
    NSLog(@"%d",DBValue);
    if (DBValue <= 65) {
        _fifthDBView.hidden = YES;
        _forthDBView.hidden = YES;
        _thirdDBView.hidden = YES;
        _secondDBView.hidden = YES;
        _firstDBView.hidden = NO;
    }else if (DBValue <= 72){
        _fifthDBView.hidden = YES;
        _forthDBView.hidden = YES;
        _thirdDBView.hidden = YES;
        _secondDBView.hidden = NO;
        _firstDBView.hidden = NO;
    }else if (DBValue <= 78){
        _fifthDBView.hidden = YES;
        _forthDBView.hidden = YES;
        _thirdDBView.hidden = NO;
        _secondDBView.hidden = NO;
        _firstDBView.hidden = NO;
    }else if (DBValue <= 85){
        _fifthDBView.hidden = YES;
        _forthDBView.hidden = NO;
        _thirdDBView.hidden = NO;
        _secondDBView.hidden = NO;
        _firstDBView.hidden = NO;
    }
    else{
        _fifthDBView.hidden = NO;
        _forthDBView.hidden = NO;
        _thirdDBView.hidden = NO;
        _secondDBView.hidden = NO;
        _firstDBView.hidden = NO;
    }
    
}
@end
