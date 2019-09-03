//
//  XKStoreEstimateSectionHeaderView.m
//  XKSquare
//
//  Created by hupan on 2018/9/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKStoreEstimateSectionHeaderView.h"
#import "XKHotspotButton.h"
#import "XKCommonStarView.h"
#import "XKTradingAreaCommentLabelsModel.h"


#define vertical_spacing  15
#define horizonal_spacing 15

@interface XKStoreEstimateSectionHeaderView ()

@property (nonatomic, strong) UILabel          *nameLabel;
@property (nonatomic, strong) XKCommonStarView *starView;
@property (nonatomic, strong) UILabel          *scoreLabel;
@property (nonatomic, strong) XKHotspotButton  *moreBtn;


@property (nonatomic, strong) UIView           *toolView;
//@property (nonatomic, strong) UIButton         *allButton;
//@property (nonatomic, strong) UIButton         *seversButton;
//@property (nonatomic, strong) UIButton         *goodsButton;

@property (nonatomic, strong) UIView                        *lineView;
@property (nonatomic, copy  ) NSArray                       *labelsArray;
@property (nonatomic, strong) NSMutableArray<UIButton *>    *labelsBtnArray;
@property (nonatomic, assign) CGFloat                       labelsViewH;



@end

@implementation XKStoreEstimateSectionHeaderView


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if ([super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = HEX_RGB(0xf6f6f6);
        [self initViews];
        [self layoutViews];
    }
    return self;
    
}


#pragma mark - Private


- (void)initViews {
    
    [self addSubview:self.backView];
    [self.backView addSubview:self.nameLabel];
    [self.backView addSubview:self.starView];
    [self.backView addSubview:self.scoreLabel];
    [self.backView addSubview:self.moreBtn];
    
    [self.backView addSubview:self.toolView];
//    [self.toolView addSubview:self.allButton];
//    [self.toolView addSubview:self.seversButton];
//    [self.toolView addSubview:self.goodsButton];

    [self.backView addSubview:self.lineView];
}

- (void)layoutViews {
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(15);
        make.right.equalTo(self.backView).offset(-10);
        make.width.equalTo(@7);
        make.height.equalTo(@10);
    }];
    
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moreBtn.mas_left).offset(-2);
        make.centerY.equalTo(self.moreBtn);
    }];
    
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.scoreLabel.mas_left);
        make.centerY.equalTo(self.moreBtn);
        make.width.equalTo(@80);
        make.height.equalTo(@10);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(15);
        make.right.lessThanOrEqualTo(self.starView.mas_left).offset(-10);
        make.centerY.equalTo(self.moreBtn);
    }];
    
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.backView);
        make.bottom.equalTo(self.backView).offset(-1);

//        make.height.equalTo(@36);
    }];
    
    /*[self.seversButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@60);
        make.height.equalTo(@22);
        make.top.equalTo(self.toolView).offset(2);
        make.centerX.equalTo(self.toolView);
    }];
    
    [self.allButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@60);
        make.height.equalTo(@22);
        make.right.equalTo(self.seversButton.mas_left).offset(-5);
        make.centerY.equalTo(self.seversButton);
    }];
    
    [self.goodsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@60);
        make.height.equalTo(@22);
        make.left.equalTo(self.seversButton.mas_right).offset(5);
        make.centerY.equalTo(self.seversButton);
    }];*/
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.backView);
        make.height.equalTo(@1);
    }];
}

#pragma mark - Setter

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (XKCommonStarView *)starView {
    if (!_starView) {
        _starView = [[XKCommonStarView alloc] initWithFrame:CGRectMake(0, 0, 80, 10)];
        _starView.backgroundColor = [UIColor whiteColor];
        _starView.allowIncompleteStar = YES;
//        [_starView setScorePercent:4.0/5];
        _starView.userInteractionEnabled = NO;
    }
    return _starView;
}

- (UILabel *)scoreLabel {
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.textColor = HEX_RGB(0xEE6161);
        _scoreLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
//        _scoreLabel.text = @"4分";
    }
    return _scoreLabel;
}


- (XKHotspotButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [[XKHotspotButton alloc] init];
        [_moreBtn setImage:[UIImage imageNamed:@"ic_btn_msg_circle_rightArrow"] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(lookMoreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}




- (UIView *)toolView {
    if (!_toolView) {
        _toolView = [[UIView alloc] init];
        _toolView.backgroundColor = [UIColor whiteColor];
    }
    return _toolView;
}
/*
- (UIButton *)allButton {
    if (!_allButton) {
        _allButton = [[UIButton alloc] init];
        _allButton.layer.masksToBounds = YES;
        _allButton.layer.cornerRadius = 11;
        _allButton.layer.borderColor = XKMainTypeColor.CGColor;
        _allButton.layer.borderWidth = 1;
        _allButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        [_allButton setTitle:@"全部" forState:UIControlStateNormal];
        _allButton.selected = YES;
        [_allButton setTitleColor:HEX_RGB(0x999999) forState:UIControlStateNormal];
        [_allButton setTitleColor:XKMainTypeColor forState:UIControlStateSelected];
        [_allButton addTarget:self action:@selector(toolButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allButton;
}

- (UIButton *)seversButton {
    if (!_seversButton) {
        _seversButton = [[UIButton alloc] init];
        _seversButton.layer.masksToBounds = YES;
        _seversButton.layer.cornerRadius = 11;
        _seversButton.layer.borderColor = HEX_RGB(0x999999).CGColor;
        _seversButton.layer.borderWidth = 1;
        _seversButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        [_seversButton setTitle:@"服务" forState:UIControlStateNormal];
        [_seversButton setTitleColor:HEX_RGB(0x999999) forState:UIControlStateNormal];
        [_seversButton setTitleColor:XKMainTypeColor forState:UIControlStateSelected];
        [_seversButton addTarget:self action:@selector(toolButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _seversButton;
}


- (UIButton *)goodsButton {
    if (!_goodsButton) {
        _goodsButton = [[UIButton alloc] init];
        _goodsButton.layer.masksToBounds = YES;
        _goodsButton.layer.cornerRadius = 11;
        _goodsButton.layer.borderColor = HEX_RGB(0x999999).CGColor;
        _goodsButton.layer.borderWidth = 1;
        _goodsButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        [_goodsButton setTitle:@"商品" forState:UIControlStateNormal];
        [_goodsButton setTitleColor:HEX_RGB(0x999999) forState:UIControlStateNormal];
        [_goodsButton setTitleColor:XKMainTypeColor forState:UIControlStateSelected];
        [_goodsButton addTarget:self action:@selector(toolButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _goodsButton;
}*/

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}




#pragma mark - events

- (void)lookMoreButtonClicked:(UIButton *)sender {
    if (self.moreBlock) {
        self.moreBlock();
    }
}

- (void)labelsItemClicked:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    
    if (self.labelsBlock) {
        self.labelsBlock(sender.tag);
    }
    
    sender.selected = YES;
    sender.layer.borderColor = XKMainTypeColor.CGColor;
    for (UIButton *btn in self.labelsBtnArray) {
        if (btn != sender) {
            btn.selected = NO;
            btn.layer.borderColor = HEX_RGB(0x999999).CGColor;
        }
    }
}

/*
- (void)toolButtonClicked:(UIButton *)sender {
    
    if (sender == self.allButton) {
        self.allButton.selected = YES;
        self.allButton.layer.borderColor = XKMainTypeColor.CGColor;
        self.seversButton.selected = NO;
        self.seversButton.layer.borderColor = HEX_RGB(0x999999).CGColor;
        self.goodsButton.selected = NO;
        self.goodsButton.layer.borderColor = HEX_RGB(0x999999).CGColor;
        
    } else if (sender == self.seversButton) {
        
        self.allButton.selected = NO;
        self.allButton.layer.borderColor = HEX_RGB(0x999999).CGColor;
        self.seversButton.selected = YES;
        self.seversButton.layer.borderColor = XKMainTypeColor.CGColor;
        self.goodsButton.selected = NO;
        self.goodsButton.layer.borderColor = HEX_RGB(0x999999).CGColor;
        
    } else if (sender == self.goodsButton) {
        self.allButton.selected = NO;
        self.allButton.layer.borderColor = HEX_RGB(0x999999).CGColor;
        self.seversButton.selected = NO;
        self.seversButton.layer.borderColor = HEX_RGB(0x999999).CGColor;
        self.goodsButton.selected = YES;
        self.goodsButton.layer.borderColor = XKMainTypeColor.CGColor;
    }
}
*/

- (void)hiddenLineView:(BOOL)hidden {
    self.lineView.hidden = hidden;
}

- (void)hiddenToolView:(BOOL)hidden {
    self.toolView.hidden = hidden;
    if (hidden) {
        [self.toolView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    } else {
        [self.toolView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@36);
        }];
    }
}

- (void)setTitleName:(NSString *)name titleColor:(UIColor *)color titleFont:(UIFont *)font {
    self.nameLabel.text = name;
    self.nameLabel.textColor = color;
    self.nameLabel.font = font;

}

- (void)setStarViewValue:(NSInteger)grade {
    [self.starView setScorePercent:grade / 5];
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld分", (long)grade];
}

- (CGFloat)configLabelsWithDataSource:(NSArray *)array type:(EstimateHeaderType)type {
    if (!array.count) {
        return 0;
    }
    if (self.labelsViewH) {
        return self.labelsViewH;
    }
    
    if (!self.labelsBtnArray) {
        self.labelsBtnArray = [NSMutableArray array];
    }
    self.labelsArray = array;
    [self.labelsBtnArray removeAllObjects];
    [self.toolView.subviews respondsToSelector:@selector(removeFromSuperview)];
    
    //创建关键字
    UIButton *tempButton = nil;
    CGRect buttonRect = CGRectMake(0, 0, 0, 22);
    
    for (NSInteger i = 0; i < array.count; i++) {
        XKTradingAreaCommentLabelsModel *model = array[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        
        if (type == EstimateHeaderType_goods) {
            NSString *titleStr = [NSString stringWithFormat:@" %@(%ld) ", model.displayName, (long)model.count];
            [button setTitle:titleStr forState:UIControlStateNormal];
        } else if (type == EstimateHeaderType_shop) {
            NSString *titleStr = [NSString stringWithFormat:@"   %@   ", model.name];
            [button setTitle:titleStr forState:UIControlStateNormal];
        }
        
        [button setTitleColor:HEX_RGB(0x999999) forState:UIControlStateNormal];
        [button setTitleColor:XKMainTypeColor forState:UIControlStateSelected];

        button.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 11;
        button.layer.borderColor = HEX_RGB(0x999999).CGColor;
        button.layer.borderWidth = 1;
        if (i == 0) {
            button.selected = YES;
            button.layer.borderColor = XKMainTypeColor.CGColor;
        }
        
        if (!tempButton) {
            buttonRect = CGRectMake(horizonal_spacing, 0, 0, 22);
        } else {
            buttonRect = CGRectMake(CGRectGetMaxX(tempButton.frame) + horizonal_spacing, buttonRect.origin.y, buttonRect.size.width,buttonRect.size.height);
        }
        CGSize buttonTitleSize = [button.titleLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:13]} context:nil].size;
        buttonRect = CGRectMake(buttonRect.origin.x, buttonRect.origin.y, buttonTitleSize.width, buttonRect.size.height);
        if (CGRectGetMaxX(buttonRect) > SCREEN_WIDTH) {
            
            buttonRect = CGRectMake(horizonal_spacing, buttonRect.origin.y, buttonTitleSize.width, buttonRect.size.height);
            buttonRect = CGRectMake(buttonRect.origin.x, CGRectGetMaxY(buttonRect) + vertical_spacing, buttonTitleSize.width, buttonRect.size.height);
        }
        button.frame = buttonRect;
        tempButton = button;
        button.tag = i;
        [button addTarget:self action:@selector(labelsItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.labelsBtnArray addObject:button];
        [self.toolView addSubview:button];
    }

    self.labelsViewH = CGRectGetMaxY(tempButton.frame) + vertical_spacing;
    return self.labelsViewH;
}


@end






