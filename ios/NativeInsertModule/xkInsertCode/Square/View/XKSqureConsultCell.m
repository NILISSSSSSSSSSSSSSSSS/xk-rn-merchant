//
//  XKSqureConsultCell.m
//  XKSquare
//
//  Created by hupan on 2018/8/6.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSqureConsultCell.h"
#import "XKSqureConsultModel.h"

@interface XKSqureConsultCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UILabel     *decLable;
@property (nonatomic, strong) UILabel     *timeLabel;
@property (nonatomic, strong) UIButton    *commentButton;
@property (nonatomic, strong) UIButton    *shareButton;
@property (nonatomic, strong) UIView      *lineView;


@end

@implementation XKSqureConsultCell

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
    
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.decLable];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.shareButton];
    [self.contentView addSubview:self.commentButton];
    [self.contentView addSubview:self.lineView];

}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    
    
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(10);
        make.height.equalTo(@(80*ScreenScale));
        make.width.equalTo(self.imgView.mas_height);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_top).offset(5);
        make.left.equalTo(self.imgView.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-50);
//        make.height.equalTo(@25);
    }];

    [self.decLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(3);
        make.right.equalTo(self.contentView).offset(-10);
    }];

    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.bottom.equalTo(self.imgView.mas_bottom).offset(-2);
        make.width.equalTo(@100);
    }];

    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-5);
        make.centerY.equalTo(self.timeLabel);
        make.height.equalTo(@30);
        make.width.equalTo(@30);

    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.commentButton.mas_left).offset(-5);
        make.centerY.equalTo(self.timeLabel);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
}

#pragma mark - Setter


- (UIImageView *)imgView {
    
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.layer.masksToBounds = YES;
        _imgView.layer.cornerRadius = 5;
//        _imgView.backgroundColor = [UIColor yellowColor];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
//        [_imgView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1538047861638&di=868dd2f924e8f80a811ef302ad7722fd&imgtype=0&src=http%3A%2F%2Fpic33.photophoto.cn%2F20141028%2F0038038006886895_b.jpg"]];
    }
    return _imgView;
}


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
//        _nameLabel.text = @"天府时间石英表";
    }
    return _nameLabel;
}


- (UILabel *)decLable {
    
    if (!_decLable) {
        _decLable = [[UILabel alloc] init];
        _decLable.textAlignment = NSTextAlignmentLeft;
        _decLable.numberOfLines = 2;
//        _decLable.text = @"石英表供商人处少发点福利卡，石英表供商人处少发点福利卡石英表供商人处少发点福利卡石英表供商人处少发点福利卡石英表供商人处少发点福利卡石英表供商人处少发点福利卡";
        _decLable.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10];
        _decLable.textColor = HEX_RGB(0x777777);
    }
    return _decLable;
}



- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
//        _timeLabel.text = @"2018.09.18";
        _timeLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10];
        _timeLabel.textColor = HEX_RGB(0x999999);
    }
    return _timeLabel;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [[UIButton alloc] init];
        _shareButton.hidden = YES;
//        [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
        [_shareButton setImage:[UIImage imageNamed:@"xk_btn_home_share"] forState:UIControlStateNormal];
    }
    return _shareButton;
}

- (UIButton *)commentButton {
    if (!_commentButton) {
        _commentButton = [[UIButton alloc] init];
        _commentButton.hidden = YES;
//        [_commentButton setTitle:@"评论" forState:UIControlStateNormal];
        [_commentButton setImage:[UIImage imageNamed:@"xk_icon_squreConsult_comment_normal"] forState:UIControlStateNormal];

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

- (void)setValueWithModel:(ConsultItemModel *)model {
    [self.imgView sd_setImageWithURL:kURL(model.image) placeholderImage:IMG_NAME(kDefaultPlaceHolderImgName)];
    self.nameLabel.text = model.title;
    self.decLable.text = model.content;
    self.timeLabel.text = [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:model.updatedAt];
}

@end




