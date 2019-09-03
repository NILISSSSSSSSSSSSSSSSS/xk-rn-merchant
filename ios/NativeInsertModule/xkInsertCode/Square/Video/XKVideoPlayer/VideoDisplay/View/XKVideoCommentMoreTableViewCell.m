//
//  XKVideoCommentMoreTableViewCell.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/18.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKVideoCommentMoreTableViewCell.h"

@interface XKVideoCommentMoreTableViewCell ()

@property (nonatomic, strong) UILabel *timeLine;

@property (nonatomic, strong) UIView *moreView;

@property (nonatomic, strong) UILabel *moreLab;

@property (nonatomic, strong) UIImageView *arrowImgView;

@end

@implementation XKVideoCommentMoreTableViewCell

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self initializeViews];
        [self updateViews];
    }
    return self;
}

- (void)initializeViews {
    [self.contentView addSubview:self.timeLine];
    [self.contentView addSubview:self.moreView];
    [self.moreView addSubview:self.moreLab];
    [self.moreView addSubview:self.arrowImgView];
}

- (void)updateViews {
    [self.timeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(57.0);
        make.width.mas_equalTo(1.0);
    }];
    
    [self.moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.timeLine.mas_right).offset(10.0);
    }];
    
    [self.moreLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.mas_equalTo(self.moreView);
    }];

    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.moreLab.mas_right).offset(7.0);
        make.centerY.mas_equalTo(self.moreView);
        make.size.mas_equalTo(self.arrowImgView.image.size);
        make.trailing.mas_equalTo(self.moreView);
    }];
}

#pragma mark - privite method

- (void)moreViewTapAction {
    if (self.moreViewBlock) {
        self.moreViewBlock();
    }
}

- (void)configMoreLabelWithCount:(NSUInteger)count {
    _moreLab.text = [NSString stringWithFormat:@"查看全部%tu条评论", count];
}

#pragma mark - getter setter

- (UILabel *)timeLine {
    if (!_timeLine) {
        _timeLine = [[UILabel alloc] init];
        _timeLine.backgroundColor = HEX_RGB(0x343434);
    }
    return _timeLine;
}

- (UIView *)moreView {
    if (!_moreView) {
        _moreView = [[UIView alloc] init];
        UITapGestureRecognizer *moreViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreViewTapAction)];
        [_moreView addGestureRecognizer:moreViewTap];
    }
    return _moreView;
}

- (UILabel *)moreLab {
    if (!_moreLab) {
        _moreLab = [[UILabel alloc] init];
        _moreLab.text = @"查看全部0条评论";
        _moreLab.font = XKRegularFont(12.0);
        _moreLab.textColor = HEX_RGB(0x999999);
    }
    return _moreLab;
}

- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] init];
        _arrowImgView.image = IMG_NAME(@"xk_ic_video_comment_more");
    }
    return _arrowImgView;
}

@end
