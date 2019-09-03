//
//  XKTradingAreaOnlineChooseTimeView.m
//  XKSquare
//
//  Created by hupan on 2018/10/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaOnlineChooseTimeView.h"
#import "XKTradingAreaOnlineChooseTimeCollectionViewCell.h"

#define itemWidth  80
#define itemHeight 26

static NSString *const collectionViewCellID = @"CollectionViewCell";

@interface XKTradingAreaOnlineChooseTimeView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel          *nameLabel;
@property (nonatomic, strong) UIView           *lineView;

@property (nonatomic, strong) UILabel          *dateLabel;
@property (nonatomic, strong) UICollectionView *dateCollectionView;

@property (nonatomic, strong) UILabel          *timeLabel;
@property (nonatomic, strong) UICollectionView *timeCollectionView;

@property (nonatomic, strong) UIButton         *sureButton;

@property (nonatomic, strong) UIView           *bottomSafeView;
@property (nonatomic, strong) UIView           *bottomSafeLineView;

@property (nonatomic, assign) NSInteger        dateSelectedIndex;
@property (nonatomic, assign) NSInteger        timeSelectedIndex;

@property (nonatomic, strong) NSMutableArray   *dateDataMuArr;
@property (nonatomic, strong) NSMutableArray   *timeDataMuArr;


@end

@implementation XKTradingAreaOnlineChooseTimeView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self initViews];
        [self layoutViews];
    }
    return self;
    
}

#pragma mark - Private

- (void)initViews {
    
    self.dateSelectedIndex = 0;
    self.timeSelectedIndex = -1;
    
    self.dateDataMuArr = [NSMutableArray array];
    self.timeDataMuArr = [NSMutableArray array];
    
    int time = (int)[XKTimeSeparateHelper backHStringWithDate:[NSDate date]].integerValue;
    if (time >= 19) {//大于当天下午7点
        NSString *sub1 = [XKTimeSeparateHelper backNewDateWithDays:1 fromTimeString:[XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithDate:[NSDate date]]];
        NSString *str1 = [NSString stringWithFormat:@"明天%@", [sub1 substringFromIndex:5]];
        
        NSString *sub2 = [XKTimeSeparateHelper backNewDateWithDays:3 fromTimeString:[XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithDate:[NSDate date]]];
        NSString *str2 = [NSString stringWithFormat:@"后天%@", [sub2 substringFromIndex:5]];
        [self.dateDataMuArr addObject:str1];
        [self.dateDataMuArr addObject:str2];
        
        for (int j = 0; j < 2; j++) {
            NSMutableArray *subMuArr = [NSMutableArray array];
            for (int i = 9; i < 19; i++) {
                NSString *timeStr = [NSString stringWithFormat:@"%d:00-%d:00", i, i+1];
                [subMuArr addObject:timeStr];
            }
            [self.timeDataMuArr addObject:subMuArr];
        }
        
    } else {
        NSString *sub1 = [XKTimeSeparateHelper backNewDateWithDays:0 fromTimeString:[XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithDate:[NSDate date]]];
        NSString *str1 = [NSString stringWithFormat:@"今天%@", [sub1 substringFromIndex:5]];
        
        NSString *sub2 = [XKTimeSeparateHelper backNewDateWithDays:1 fromTimeString:[XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithDate:[NSDate date]]];
        NSString *str2 = [NSString stringWithFormat:@"明天%@", [sub2 substringFromIndex:5]];
        
        NSString *sub3 = [XKTimeSeparateHelper backNewDateWithDays:2 fromTimeString:[XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithDate:[NSDate date]]];
        NSString *str3 = [NSString stringWithFormat:@"后天%@", [sub3 substringFromIndex:5]];
        [self.dateDataMuArr addObject:str1];
        [self.dateDataMuArr addObject:str2];
        [self.dateDataMuArr addObject:str3];
        
        for (int j = 0; j < 3; j++) {
            
            NSMutableArray *subMuArr = [NSMutableArray array];
            
            if (j == 0) {
                for (int i = time; i < 19; i++) {
                    NSString *timeStr = [NSString stringWithFormat:@"%d:00-%d:00", i, i+1];
                    [subMuArr addObject:timeStr];
                }
            } else {
                for (int i = 9; i < 19; i++) {
                    NSString *timeStr = [NSString stringWithFormat:@"%d:00-%d:00", i, i+1];
                    [subMuArr addObject:timeStr];
                }
            }
            [self.timeDataMuArr addObject:subMuArr];
        }
    }
    

    [self addSubview:self.nameLabel];
    [self addSubview:self.lineView];
    [self addSubview:self.dateLabel];
    [self addSubview:self.dateCollectionView];
    [self addSubview:self.timeLabel];
    [self addSubview:self.timeCollectionView];
    [self addSubview:self.sureButton];
    [self addSubview:self.bottomSafeView];
    [self.bottomSafeView addSubview:self.bottomSafeLineView];
    
    
    
}

- (void)layoutViews {
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.centerX.equalTo(self);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
        make.height.equalTo(@1);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self.lineView.mas_bottom).offset(15);
    }];
    
    [self.dateCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self.dateLabel.mas_bottom).offset(10);
        make.height.equalTo(@30);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self.dateCollectionView.mas_bottom).offset(10);
    }];
    
    [self.timeCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.sureButton.mas_top);
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.bottomSafeView.mas_top);
        make.height.equalTo(@44);
    }];
    
    [self.bottomSafeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(@kBottomSafeHeight);
    }];
    
    [self.bottomSafeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.bottomSafeView);
        make.height.equalTo(@(kBottomSafeHeight ? 1 : 0));
    }];
}




#pragma mark - Events
- (void)sureBtnClicked:(UIButton *)sender {
    if (self.dateSelectedIndex < 0) {
        [XKHudView showErrorMessage:@"请选择日期"];
        return;
    }
    if (self.timeSelectedIndex < 0) {
        [XKHudView showErrorMessage:@"请选择时间"];
        return;
    }
    if (self.sureBlock) {
        self.sureBlock(self.dateDataMuArr[self.dateSelectedIndex], self.timeDataMuArr[self.dateSelectedIndex][self.timeSelectedIndex]);
    }
}



#pragma mark - getter && setter


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"预定时间";
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
    }
    return _nameLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}


- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.text = @"日期";
        _dateLabel.textColor = HEX_RGB(0x222222);
        _dateLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    }
    return _dateLabel;
}

- (UICollectionView *)dateCollectionView {
    if (!_dateCollectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
        flowLayout.minimumLineSpacing = 5.0f;
        _dateCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _dateCollectionView.showsHorizontalScrollIndicator = NO;
        _dateCollectionView.showsVerticalScrollIndicator = NO;
        _dateCollectionView.bounces = NO;
        _dateCollectionView.dataSource = self;
        _dateCollectionView.delegate = self;
        _dateCollectionView.backgroundColor = [UIColor whiteColor];
        [_dateCollectionView registerClass:[XKTradingAreaOnlineChooseTimeCollectionViewCell class] forCellWithReuseIdentifier:collectionViewCellID];
    }
    return _dateCollectionView;
}


- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"时间";
        _timeLabel.textColor = HEX_RGB(0x222222);
        _timeLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    }
    return _timeLabel;
}

- (UICollectionView *)timeCollectionView {
    if (!_timeCollectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
        flowLayout.minimumLineSpacing = 8.0f;
        flowLayout.minimumInteritemSpacing = .0f;
        _timeCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _timeCollectionView.showsHorizontalScrollIndicator = NO;
        _timeCollectionView.showsVerticalScrollIndicator = NO;
        _timeCollectionView.bounces = NO;
        _timeCollectionView.dataSource = self;
        _timeCollectionView.delegate = self;
        _timeCollectionView.backgroundColor = [UIColor whiteColor];
        [_timeCollectionView registerClass:[XKTradingAreaOnlineChooseTimeCollectionViewCell class] forCellWithReuseIdentifier:collectionViewCellID];
    }
    return _timeCollectionView;
}
        
- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [[UIButton alloc] init];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
        _sureButton.backgroundColor = XKMainTypeColor;
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(sureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (UIView *)bottomSafeView {
    if (!_bottomSafeView) {
        _bottomSafeView = [[UIView alloc] init];
        _bottomSafeView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomSafeView;
}

- (UIView *)bottomSafeLineView {
    if (!_bottomSafeLineView) {
        _bottomSafeLineView = [[UIView alloc] init];
        _bottomSafeLineView.backgroundColor = XKSeparatorLineColor;
    }
    return _bottomSafeLineView;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.dateCollectionView) {
        return self.dateDataMuArr.count;
    } else {
        if (self.timeDataMuArr.count > self.dateSelectedIndex && self.dateSelectedIndex >= 0) {
            NSArray *arr = self.timeDataMuArr[self.dateSelectedIndex];
            return arr.count;
        }
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XKTradingAreaOnlineChooseTimeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
    
    if (collectionView == self.dateCollectionView) {
        [cell itemSeleced:self.dateSelectedIndex == indexPath.row ? YES : NO];
        [cell setTitleName:self.dateDataMuArr[indexPath.row]];
    } else {
        NSString *name = @"";
        if (self.timeDataMuArr.count > self.dateSelectedIndex && self.dateSelectedIndex >= 0) {
            NSArray *arr = self.timeDataMuArr[self.dateSelectedIndex];
            name = arr[indexPath.row];
        }
        [cell itemSeleced:self.timeSelectedIndex == indexPath.row ? YES : NO];
        [cell setTitleName:name];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.dateCollectionView) {
        
        if (self.dateSelectedIndex == indexPath.row) {
            return;
        }
        //刷上面
        self.dateSelectedIndex = indexPath.row;
        [self.dateCollectionView reloadData];
        //刷下面
        self.timeSelectedIndex = -1;
        [self.timeCollectionView reloadData];

    } else {
        
        if (self.timeSelectedIndex == indexPath.row) {
            return;
        }
        self.timeSelectedIndex = indexPath.row;
        [self.timeCollectionView reloadData];
    }
}

@end
