//
//  XKGrandPrizeShowOrderTableViewCell.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/1.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKGrandPrizeShowOrderTableViewCell.h"

@interface XKGrandPrizeShowOrderTableViewCell ()

@property (nonatomic, strong) UIView *imgsView;

@property (nonatomic, strong) NSMutableArray <UIImageView *>*imgViews;

@property (nonatomic, strong) UIButton *expandBtn;

@end

@implementation XKGrandPrizeShowOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.foldedNumOfLines = 3;
        self.expandedNumOfLines = 0;
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.containerView = [[UIView alloc] init];
        self.containerView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0));
        }];
        
        self.avatarImgView = [[UIImageView alloc] init];
        self.avatarImgView.image = kDefaultHeadImg;
        [self.containerView addSubview:self.avatarImgView];
        self.avatarImgView.layer.cornerRadius = 4.0;
        self.avatarImgView.layer.masksToBounds = YES;
        [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15.0);
            make.leading.mas_equalTo(15.0);
            make.width.height.mas_equalTo(46.0);
        }];
        
        self.nameLab = [[UILabel alloc] init];
        self.nameLab.text = @"名字";
        self.nameLab.font = XKRegularFont(14.0);
        self.nameLab.textColor = HEX_RGB(0x222222);
        [self.containerView addSubview:self.nameLab];
        [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.avatarImgView);
            make.left.mas_equalTo(self.avatarImgView.mas_right).offset(15.0);
            make.trailing.mas_equalTo(-15.0);
        }];
        
        self.timeLab = [[UILabel alloc] init];
        self.timeLab.text = @"中奖时间";
        self.timeLab.font = XKRegularFont(10.0);
        self.timeLab.textColor = HEX_RGB(0x999999);
        [self.containerView addSubview:self.timeLab];
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLab.mas_bottom).offset(5.0);
            make.leading.trailing.mas_equalTo(self.nameLab);
        }];
        
        self.contentLab = [[UILabel alloc] init];
        self.contentLab.text = @"内容";
        self.contentLab.font = XKRegularFont(12.0);
        self.contentLab.numberOfLines = self.foldedNumOfLines;
        self.contentLab.textColor = HEX_RGB(0x777777);
        [self.containerView addSubview:self.contentLab];
        [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImgView.mas_bottom).offset(-2.0);
            make.leading.trailing.mas_equalTo(self.timeLab);
        }];
        
        self.imgsView = [[UIView alloc] init];
        [self.containerView addSubview:self.imgsView];
        [self.imgsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentLab.mas_bottom).offset(8.0);
            make.leading.trailing.mas_equalTo(self.contentLab);
            make.height.mas_equalTo(0.0);
            make.bottom.mas_equalTo(-15.0);
        }];

        self.expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.expandBtn.titleLabel.font = XKRegularFont(10.0);
        [self.expandBtn setTitle:@"展开" forState:UIControlStateNormal];
        [self.expandBtn setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
        [self.imgsView addSubview:self.expandBtn];
        self.expandBtn.hidden = YES;
        [self.expandBtn addTarget:self action:@selector(expandBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.expandBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.trailing.mas_equalTo(self.imgsView);
            make.height.mas_equalTo(20.0);
        }];

        self.downLine = [[UILabel alloc] init];
        self.downLine.backgroundColor = XKSeparatorLineColor;
        [self.containerView addSubview:self.downLine];
        [self.downLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.bottom.trailing.mas_equalTo(self.containerView);
            make.height.mas_equalTo(1.0);
        }];
    }
    return self;
}

#pragma mark - privite method

- (void)expandBtnAction {
    if (self.expandBtnBlock) {
        self.expandBtnBlock();
    }
}

- (void)tapAction:(UIGestureRecognizer *) sender {
    
}

- (void)setImgs:(NSArray *)imgs {
    _imgs = imgs;
    [_imgViews removeAllObjects];
    [self layoutIfNeeded];
    for (UIView *temp in self.imgsView.subviews) {
        if ([temp isKindOfClass:[UIImageView class]]) {
            [temp removeFromSuperview];
        }
    }
    if (_imgs.count) {
        UIImageView *lastImgView;
        if (_imgs.count == 1) {
            UIImageView *imgView = [[UIImageView alloc] init];
            [imgView sd_setImageWithURL:[NSURL URLWithString:_imgs.firstObject] placeholderImage:kDefaultPlaceHolderImg];
            [self.imgsView addSubview:imgView];
            imgView.frame = CGRectMake(0.0, 0.0, 90.0, 120.0);
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            imgView.userInteractionEnabled = YES;
            [imgView addGestureRecognizer:tap];
            [self.imgViews addObject:imgView];
            lastImgView = imgView;
        } else {
            CGFloat imgWidth = (CGRectGetWidth(self.imgsView.frame) - CGRectGetWidth(self.expandBtn.frame) - 10.0 * 3) / 3.0;
            for (int index = 0; index < _imgs.count; index++) {
                NSString *imgStr = _imgs[index];
                UIImageView *imgView = [[UIImageView alloc] init];
                [imgView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:kDefaultPlaceHolderImg];
                [self.imgsView addSubview:imgView];
                if (index == 0) {
                    imgView.frame = CGRectMake(0.0, 0.0, imgWidth, imgWidth);
                } else {
                    if (index % 3 == 0) {
//                        换行
                        imgView.frame = CGRectMake(0.0, CGRectGetMaxY(lastImgView.frame) + 10.0, imgWidth, imgWidth);
                    } else {
                        imgView.frame = CGRectMake(CGRectGetMaxX(lastImgView.frame) + 10.0, CGRectGetMinY(lastImgView.frame), imgWidth, imgWidth);
                    }
                }
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                imgView.userInteractionEnabled = YES;
                [imgView addGestureRecognizer:tap];
                [self.imgViews addObject:imgView];
                lastImgView = imgView;
            }
        }
        self.expandBtn.hidden = _imgs.count <= 3;
    } else {
        self.expandBtn.hidden = YES;
        [self.imgsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.0);
        }];
    }
    self.isExpanded = NO;
}

- (void)setIsExpanded:(BOOL)isExpanded {
    _isExpanded = isExpanded;
    if (_isExpanded) {
        for (UIImageView *imgView in self.imgViews) {
            imgView.hidden = NO;
        }
        self.contentLab.numberOfLines = self.expandedNumOfLines;
        [self.expandBtn setTitle:@"收起" forState:UIControlStateNormal];
        [self.imgsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(CGRectGetMaxY(self.imgViews.lastObject.frame));
        }];
    } else {
        for (UIImageView *imgView in self.imgViews) {
            imgView.hidden = [self.imgViews indexOfObject:imgView] > 2;
        }
        self.contentLab.numberOfLines = self.foldedNumOfLines;
        [self.expandBtn setTitle:@"展开" forState:UIControlStateNormal];
        [self.imgsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(CGRectGetMaxY(self.imgViews.firstObject.frame));
        }];
    }
}

- (NSMutableArray <UIImageView *>*)imgViews {
    if (!_imgViews) {
        _imgViews = [NSMutableArray array];
    }
    return _imgViews;
}

@end
