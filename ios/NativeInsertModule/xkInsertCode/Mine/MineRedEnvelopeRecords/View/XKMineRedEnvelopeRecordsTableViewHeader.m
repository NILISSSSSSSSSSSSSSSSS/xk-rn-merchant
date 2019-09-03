//
//  XKMineRedEnvelopeRecordsTableViewHeader.m
//  XKSquare
//
//  Created by RyanYuan on 2018/11/5.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineRedEnvelopeRecordsTableViewHeader.h"

CGFloat const kMineRedEnvelopeRecordsTableViewHeaderContainerOneViewHeight = 44.0;

@interface XKMineRedEnvelopeRecordsTableViewHeader ()

@property (nonatomic, strong) NSArray *categorys;
@property (nonatomic, assign) NSInteger currentCategoryIndex;
@property (nonatomic, strong) UIButton *categaryBtn;
@property (nonatomic, strong) UILabel *dateLabel;

@end

@implementation XKMineRedEnvelopeRecordsTableViewHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self initializeViews];
    }
    return self;
}

- (void)configHeaderViewWithTitleArray:(NSArray *)titleArr currentCategoryIndex:(NSInteger)index {
    
    self.categorys = titleArr;
    self.currentCategoryIndex = index;
    
    NSString *titleString;
    if (self.currentCategoryIndex < 0) {
        titleString = @"分类";
    } else {
        titleString = self.categorys[self.currentCategoryIndex];
    }
    [self.categaryBtn setTitle:titleString forState:UIControlStateNormal];
}

- (void)configHeaderViewWithDateString:(NSString *)dateString {
    self.dateLabel.text = dateString;
}

/** 点击分类按钮 */
- (void)categaryButtonAction:(UIButton *)sender {
    [self.delegate headerView:self categaryButtonAction:sender];
}

/** 点击时间按钮 */
- (void)dateButtonAction:(UIButton *)sender {
    [self.delegate headerView:self dateButtonAction:sender];
}

- (void)initializeViews {
    
    UIView *containerViewOne = [UIView new];
    containerViewOne.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:containerViewOne];
    [containerViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.offset(kMineRedEnvelopeRecordsTableViewHeaderContainerOneViewHeight);
    }];
    containerViewOne.xk_openClip = YES;
    containerViewOne.xk_radius = 8;
    containerViewOne.xk_clipType = XKCornerClipTypeTopBoth;
    
    UIButton *categaryBtn = [BaseViewFactory buttonWithFrame:CGRectMake(0, 0, 0, 0) font:XKRegularFont(14) title:@"" titleColor:UIColorFromRGB(0x222222) backColor:[UIColor clearColor]];
    [containerViewOne addSubview:categaryBtn];
    [categaryBtn addTarget:self action:@selector(categaryButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [categaryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(containerViewOne);
        make.leading.mas_equalTo(14.0);
    }];
    self.categaryBtn = categaryBtn;
    
    UIImageView *buttonImgView = [[UIImageView alloc] init];
    buttonImgView.image = IMG_NAME(@"xk_bg_Mine_ConsumeCoupon_ButtonDown");
    [containerViewOne addSubview:buttonImgView];
    [buttonImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(containerViewOne);
        make.left.mas_equalTo(categaryBtn.mas_right).offset(4);
        make.width.height.mas_equalTo(5.0);
    }];
    
    UIView *containerViewTwo = [UIView new];
    containerViewTwo.backgroundColor = HEX_RGBA(0xCFE1FC, 0.3);
    [self.contentView addSubview:containerViewTwo];
    [containerViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerViewOne.mas_bottom);
        make.left.equalTo(containerViewOne.mas_left);
        make.right.equalTo(containerViewOne.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    UILabel *dateLabel = [UILabel new];
    dateLabel.text = @"本月";
    dateLabel.textAlignment = NSTextAlignmentLeft;
    dateLabel.font = XKRegularFont(14.0);
    [containerViewTwo addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(containerViewTwo);
        make.leading.mas_equalTo(14.0);
    }];
    self.dateLabel = dateLabel;
    
    UIButton *dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dateBtn setImage:IMG_NAME(@"xk_bg_Mine_ConsumeCoupon_Calendar") forState:UIControlStateNormal];
    [containerViewTwo addSubview:dateBtn];
    [dateBtn addTarget:self action:@selector(dateButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [dateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(containerViewTwo);
        make.trailing.mas_equalTo(-14.0);
        make.width.height.mas_equalTo(20.0);
    }];
}

@end
