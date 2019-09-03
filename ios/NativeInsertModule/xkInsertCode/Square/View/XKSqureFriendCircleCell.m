//
//  XKSqureFriendCircleCell.m
//  XKSquare
//
//  Created by hupan on 2018/8/6.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSqureFriendCircleCell.h"
#import "XKStoreInfoCollectionCell.h"
#import "XKSquareFriendsCirclelModel.h"
#import "XKContactCacheManager.h"
#import "XKContactModel.h"
#import "XKSquareFriendsCricleTool.h"

#define imgMargin  5
#define itemWidth   (int)((SCREEN_WIDTH - 20 - 90 - 2*imgMargin) / 3)
#define itemHeight  itemWidth

static NSString *const collectionViewCellID = @"collectionViewCell";

@interface XKSqureFriendCircleCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIImageView       *headerImgView;
@property (nonatomic, strong) UILabel           *userNameLabel;
@property (nonatomic, strong) UILabel           *summaryLabel;
@property (nonatomic, strong) UIButton          *unfoldButton;
@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) UILabel           *timeLabel;
@property (nonatomic, strong) UIButton          *commentButton;
@property (nonatomic, strong) UIButton          *likeButton;
@property (nonatomic, strong) UIButton          *giftButton;
@property (nonatomic, strong) UIView            *lineView;

@property (nonatomic, copy  ) NSArray                *commentPicArr;
@property (nonatomic, strong) FriendsCirclelListItem *listItemModel;



@end

@implementation XKSqureFriendCircleCell

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

- (void)initViews {
    
    [self.contentView addSubview:self.headerImgView];
    [self.contentView addSubview:self.userNameLabel];
    [self.contentView addSubview:self.summaryLabel];
    [self.contentView addSubview:self.unfoldButton];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.likeButton];
    [self.contentView addSubview:self.commentButton];
    [self.contentView addSubview:self.giftButton];
    [self.contentView addSubview:self.lineView];

}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(10);
        make.width.equalTo(@50);
        make.height.equalTo(@50);

    }];

    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImgView.mas_top);
        make.left.equalTo(self.headerImgView.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-10);

    }];

    [self.summaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userNameLabel.mas_left);
        make.top.equalTo(self.userNameLabel.mas_bottom).offset(3);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [self.unfoldButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.userNameLabel.mas_left).offset(2);
        make.top.equalTo(self.summaryLabel.mas_bottom).offset(1);
        make.height.equalTo(@20);
        make.width.equalTo(@50);
    }];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.unfoldButton.mas_bottom).offset(2);
        make.left.equalTo(self.userNameLabel.mas_left);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.equalTo(@(itemHeight + 1));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userNameLabel.mas_left);
        make.right.lessThanOrEqualTo(self.giftButton.mas_left).offset(-5);
        make.top.equalTo(self.collectionView.mas_bottom).offset(5);
        make.width.equalTo(@100);
    }];

    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.timeLabel).offset(5);
        make.height.equalTo(@20);
        make.width.equalTo(@30);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
    
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.commentButton.mas_left).offset(-8);
        make.centerY.equalTo(self.commentButton);
        make.height.equalTo(@20);
        make.width.equalTo(@30);
    }];
    
    [self.giftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.likeButton.mas_left).offset(-8);
        make.centerY.equalTo(self.commentButton);
        make.height.equalTo(@20);
        make.width.equalTo(@30);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
}

/*
- (void)uploadViewsConstraint {
    
    if (self.unfoldButton.selected) {
        self.summaryLabel.numberOfLines = 0;
    } else {
        self.summaryLabel.numberOfLines = 2;
    }
    
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

    if (!self.unfoldButton) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    } else {
        [self.collectionView reloadData];
    }

}*/

#pragma mark - Setter


- (UIImageView *)headerImgView {
    
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
        _headerImgView.layer.masksToBounds = YES;
        _headerImgView.layer.cornerRadius = 5;
//        _headerImgView.backgroundColor = [UIColor yellowColor];
        _headerImgView.contentMode = UIViewContentModeScaleAspectFill;
//        [_headerImgView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1538047861638&di=868dd2f924e8f80a811ef302ad7722fd&imgtype=0&src=http%3A%2F%2Fpic33.photophoto.cn%2F20141028%2F0038038006886895_b.jpg"]];
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


- (UILabel *)summaryLabel {
    
    if (!_summaryLabel) {
        _summaryLabel = [[UILabel alloc] init];
        _summaryLabel.textAlignment = NSTextAlignmentLeft;
        _summaryLabel.numberOfLines = 2;
//        _summaryLabel.text = @"石英表供商人处少发点福利卡，石英表供商人处少发点福利卡石英表供商人处少发点福利卡石英表供商人处少发点福利卡石英表供商人处少发点福利卡石英表供商人处少发点福利卡";
        _summaryLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _summaryLabel.textColor = HEX_RGB(0x777777);
    }
    return _summaryLabel;
}

- (UIButton *)unfoldButton {
    if (!_unfoldButton) {
        _unfoldButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        _unfoldButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
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

- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.numberOfLines = 0;
        _timeLabel.text = @"2小时前\n成都时代中心";
        _timeLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10];
        _timeLabel.textColor = HEX_RGB(0xADADAD);
    }
    return _timeLabel;
}

- (UIButton *)giftButton {
    if (!_giftButton) {
        _giftButton = [[UIButton alloc] init];
        _giftButton.hidden = YES;
        [_giftButton setImage:[UIImage imageNamed:@"xk_btn_squre_gift"] forState:UIControlStateNormal];
        [_giftButton addTarget:self action:@selector(giftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _giftButton;
}


- (UIButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [[UIButton alloc] init];
        _likeButton.hidden = YES;
        [_likeButton setImage:[UIImage imageNamed:@"ic_btn_msg_circle_noLike"] forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"ic_btn_msg_circle_Like"] forState:UIControlStateSelected];
        [_likeButton addTarget:self action:@selector(likeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeButton;
}

- (UIButton *)commentButton {
    if (!_commentButton) {
        _commentButton = [[UIButton alloc] init];
        _commentButton.hidden = YES;
        [_commentButton setImage:[UIImage imageNamed:@"xk_icon_squreConsult_comment_normal"] forState:UIControlStateNormal];
        [_commentButton addTarget:self action:@selector(commentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentButton;
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
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 5;
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
    [cell updataViewsWithNOMargin];
    FriendsCirclelPictureContentsItem *itemModel = self.commentPicArr[indexPath.section*3 + indexPath.row];
    [cell setImgViewWithImgUrl:itemModel.url];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(friendCircleCollectionView:didSelectItemAtIndexPath:imgUrlArr:)]) {
        
        NSMutableArray *urlArr = [NSMutableArray array];
        for (FriendsCirclelPictureContentsItem *itemModel in self.commentPicArr) {
            [urlArr addObject:itemModel.url];
        }
        [self.delegate friendCircleCollectionView:collectionView didSelectItemAtIndexPath:indexPath imgUrlArr:urlArr.copy];
    }
}



#pragma mark - Events

- (void)unfoldButtonClicked:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(unfoldButtonClick:index:)]) {
        [self.delegate unfoldButtonClick:self index:sender.tag];
    }
//    [self uploadViewsConstraint];
}

- (void)likeButtonClicked:(UIButton *)sender {
    
    [XKSquareFriendsCricleTool friendsCircleLikeWithParameters:@{@"did":self.listItemModel.did} success:^(NSInteger status) {
        sender.selected = status;
        if (self.delegate && [self.delegate respondsToSelector:@selector(likeBtnClicked:sender:)]) {
            [self.delegate likeBtnClicked:self sender:sender];
        }
    }];
}

- (void)commentButtonClicked:(UIButton *)sender {


}

- (void)giftButtonClicked:(UIButton *)sender {
    
    
}


- (void)setValueWithModel:(FriendsCirclelListItem *)model indexPath:(NSIndexPath *)indexPath {
    self.listItemModel = model;
    
    XKContactModel *userModel = [XKContactCacheManager queryContactWithUserId:model.userId];
    [self.headerImgView sd_setImageWithURL:kURL(userModel.avatar) placeholderImage:IMG_NAME(kDefaultHeadImgName)];
    
    if (userModel.friendRemark.length) {
        self.userNameLabel.text = userModel.friendRemark;
    } else {
        if (userModel.nickname.length) {
            self.userNameLabel.text = userModel.nickname;
        } else {
            self.userNameLabel.text = @"未知用户";
        }
    }
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@", [XKTimeSeparateHelper customTimeStyleWithTimestampString:model.createdAt]];
    self.likeButton.selected = model.isLike;
    self.unfoldButton.selected = model.unfold;
    self.unfoldButton.tag = indexPath.row;
    self.commentPicArr = model.pictureContents;
    
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
    
    CGSize size = [model.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]} context:nil].size;
    
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
        [self.summaryLabel setNumberOfLines:0];
    } else {
        [self.summaryLabel setNumberOfLines:2];
    }
    self.summaryLabel.text = model.content;
    
    [self.collectionView reloadData];
}


@end
