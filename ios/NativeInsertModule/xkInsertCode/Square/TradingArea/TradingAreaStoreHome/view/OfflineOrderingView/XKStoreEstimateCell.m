//
//  XKStoreEstimateCell.m
//  XKSquare
//
//  Created by hupan on 2018/8/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKStoreEstimateCell.h"
#import "XKCommonStarView.h"
#import "XKStoreInfoCollectionCell.h"
#import "XKTradingAreaCommentListModel.h"

#define itemWidth   (int)((SCREEN_WIDTH - 80 - 81) / 3)
#define itemHeight  itemWidth

static NSString *const collectionViewCellID = @"collectionViewCell";

@interface XKStoreEstimateCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIImageView       *headerImgView;
@property (nonatomic, strong) UILabel           *userNameLabel;
@property (nonatomic, strong) XKCommonStarView  *starView;
@property (nonatomic, strong) UILabel           *tipLabel;
@property (nonatomic, strong) UILabel           *timeLabel;

@property (nonatomic, strong) UILabel           *summaryLabel;
@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) UIButton          *unfoldButton;

@property (nonatomic, strong) UIView            *lineView;


@property (nonatomic, assign) NSArray           *commentPicArr;



@end

@implementation XKStoreEstimateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initViews];
        [self layoutViews];
    }
    return self;
}

#pragma mark - Private

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}

- (void)initViews {
    
    [self.contentView addSubview:self.headerImgView];
    [self.contentView addSubview:self.userNameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.starView];
    [self.contentView addSubview:self.tipLabel];
    [self.contentView addSubview:self.summaryLabel];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.unfoldButton];
    [self.contentView addSubview:self.lineView];
    
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(15);
        make.width.equalTo(@46);
        make.height.equalTo(@46);
    }];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImgView.mas_top).offset(-2);
        make.left.equalTo(self.headerImgView.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.timeLabel.mas_left).offset(-10);
        
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.userNameLabel);
    }];
    
    
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userNameLabel.mas_left).offset(-2);
        make.top.equalTo(self.userNameLabel.mas_bottom).offset(3);
        make.width.equalTo(@80);
        make.height.equalTo(@10);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userNameLabel.mas_left);
        make.top.equalTo(self.starView.mas_bottom).offset(2);
    }];
    
    [self.summaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userNameLabel.mas_left);
        make.top.equalTo(self.tipLabel.mas_bottom).offset(5);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.summaryLabel.mas_bottom).offset(8);
        make.left.equalTo(self.contentView).offset(71);
        make.right.equalTo(self.contentView).offset(-70);
        make.height.equalTo(@(itemHeight + 1));
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [self.unfoldButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.collectionView.mas_right).offset(10);
        make.bottom.equalTo(self.collectionView.mas_bottom);
        make.height.equalTo(@20);
        make.width.equalTo(@50);
    }];
    

    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
}



#pragma mark - Setter


- (UIImageView *)headerImgView {
    
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
        _headerImgView.layer.masksToBounds = YES;
        _headerImgView.layer.cornerRadius = 5;
        _headerImgView.contentMode = UIViewContentModeScaleAspectFill;
//        [_headerImgView sd_setImageWithURL:[NSURL URLWithString:@"http://pic25.photophoto.cn/20121016/0009021124976824_b.jpg"]];
    }
    return _headerImgView;
}


- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _userNameLabel.textColor = HEX_RGB(0x222222);
        _userNameLabel.textAlignment = NSTextAlignmentLeft;
//        _userNameLabel.text = @"刘德华的天空";
    }
    return _userNameLabel;
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

- (UILabel *)tipLabel {
    
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textAlignment = NSTextAlignmentLeft;
//        _tipLabel.text = @"成鱼落雁套餐";
        _tipLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _tipLabel.textColor = HEX_RGB(0x999999);
    }
    return _tipLabel;
}


- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentRight;
//        _timeLabel.text = @"2018-09-23";
        _timeLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _timeLabel.textColor = HEX_RGB(0x999999);
    }
    return _timeLabel;
}


- (UILabel *)summaryLabel {
    
    if (!_summaryLabel) {
        _summaryLabel = [[UILabel alloc] init];
        _summaryLabel.textAlignment = NSTextAlignmentLeft;
        _summaryLabel.numberOfLines = 2;
//        _summaryLabel.text = @"石英表供商人处少发点福利卡，石英表供商人处少发点福利卡石英表供商人处少发点福利卡石英表供商人处少发点福利卡石英表供商人处少发点福利卡石英表供商人处少发点福利卡";
        _summaryLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _summaryLabel.textColor = HEX_RGB(0x555555);
    }
    return _summaryLabel;
}

- (UIButton *)unfoldButton {
    if (!_unfoldButton) {
        _unfoldButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        _unfoldButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10];
        _unfoldButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_unfoldButton setTitle:@"展开" forState:UIControlStateNormal];
        [_unfoldButton setTitle:@"收起" forState:UIControlStateSelected];
        [_unfoldButton setImage:[UIImage imageNamed:@"xk_ic_login_up_arrow"] forState:UIControlStateSelected];
        [_unfoldButton setImage:[UIImage imageNamed:@"xk_ic_login_down_arrow"] forState:UIControlStateNormal];
        [_unfoldButton setTitleColor:HEX_RGB(0x555555) forState:UIControlStateNormal];
        [_unfoldButton setTitleColor:HEX_RGB(0x555555) forState:UIControlStateSelected];
        [_unfoldButton setImageAtRightAndTitleAtLeftWithSpace:3];
        [_unfoldButton addTarget:self action:@selector(unfoldButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _unfoldButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[XKStoreInfoCollectionCell class] forCellWithReuseIdentifier:collectionViewCellID];
    }
    return _collectionView;
}


#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.commentPicArr.count) {
        NSInteger line = self.commentPicArr.count % 3 ? (self.commentPicArr.count / 3 + 1) : (self.commentPicArr.count / 3);
        if (self.unfoldButton.selected) {
            return line;
        } else {
            return 1;
        }
    } else {
        return 0;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.commentPicArr.count) {
        if (self.commentPicArr.count <= 3) {
            return self.commentPicArr.count;
            
        } else if (self.commentPicArr.count <= 6) {
            if (section == 0) {
                return 3;
            } else {
                return self.commentPicArr.count - 3;
            }
            
        } else {
            if (section == 0 || section == 1) {
                return 3;
            } else {
                return self.commentPicArr.count - 6;
            }
        }
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XKStoreInfoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
    NSString *imgurl = self.commentPicArr[indexPath.section*3 + indexPath.row];
    [cell setImgViewWithImgUrl:imgurl];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(estimateCollectionView:didSelectItemAtIndexPath:imgArr:)]) {
        [self.delegate estimateCollectionView:collectionView didSelectItemAtIndexPath:indexPath imgArr:self.commentPicArr];
    }
}



#pragma mark - Events

- (void)unfoldButtonClicked:(UIButton *)sender {
    
    sender.selected = !sender.selected;

    if (self.delegate && [self.delegate respondsToSelector:@selector(unfoldButtonClick:)]) {
        [self.delegate unfoldButtonClick:self];
    }
}

- (void)setValueWithModel:(CommentListItem *)model {
    
    [self.headerImgView sd_setImageWithURL:kURL(model.commenter.avatar) placeholderImage:IMG_NAME(kDefaultHeadImgName)];
    self.userNameLabel.text = model.commenter.nickName;
    [self.starView setScorePercent:model.score/5];
    self.tipLabel.text = model.goods.name;
    self.timeLabel.text = [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:model.createdAt];
    self.summaryLabel.text = model.content;
    
    self.commentPicArr = model.pictures;
    
    
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.commentPicArr.count) {
            NSInteger line = self.commentPicArr.count % 3 ? (self.commentPicArr.count / 3 + 1) : (self.commentPicArr.count / 3);
            if (self.unfoldButton.selected) {
                make.height.equalTo(@(itemHeight * line + 1));
            } else {
                make.height.equalTo(@(itemHeight + 1));
            }
        } else {
            make.height.equalTo(@(0));
        }
    }];
    
    CGSize size = [self.summaryLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]} context:nil].size;
    
    [self.unfoldButton mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.commentPicArr.count > 3 || size.height > 30) {
            make.height.equalTo(@20);
            self.unfoldButton.hidden = NO;
        } else {
            make.height.equalTo(@0);
            self.unfoldButton.hidden = YES;
        }
    }];
    
    if (self.unfoldButton.selected) {
        self.summaryLabel.numberOfLines = 0;
    } else {
        self.summaryLabel.numberOfLines = 2;
    }
    
    [self.collectionView reloadData];
    
}

- (void)hiddenLine:(BOOL)hidden {
    self.lineView.hidden = hidden;
}


@end



