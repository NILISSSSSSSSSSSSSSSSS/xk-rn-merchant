//
//  XKRecommendGamesTableViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKRecommendGamesTableViewCell.h"
#import "XKCommonStarView.h"

@interface XKRecommendGamesTableViewCell ()

@property (nonatomic, strong) UIImageView       *imgView;
@property (nonatomic, copy  ) UILabel           *nameLabel;
@property (nonatomic, copy  ) UILabel           *scoreLabel;
@property (nonatomic, strong) XKCommonStarView  *starView;
@property (nonatomic, copy  ) UILabel           *decLabel;
@property (nonatomic, strong) UIView            *lineView;



@end


@implementation XKRecommendGamesTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
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


- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}


- (void)initViews {
    
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.scoreLabel];
    [self.contentView addSubview:self.starView];
    [self.contentView addSubview:self.decLabel];
    [self.contentView addSubview:self.lineView];

}



- (void)layoutViews {
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(15);
        make.width.height.equalTo(@(76*ScreenScale));
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_top);
        make.left.equalTo(self.imgView.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];
  
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(6);
        make.left.equalTo(self.imgView.mas_right).offset(10);
    }];
    
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scoreLabel.mas_right);
        make.centerY.equalTo(self.scoreLabel);
        make.width.equalTo(@80);
        make.height.equalTo(@10);
    }];
    
    [self.decLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scoreLabel.mas_bottom).offset(3);
        make.left.equalTo(self.imgView.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.equalTo(self.contentView).offset(-5);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
}


- (void)hiddenLineView:(BOOL)hidden {
    self.lineView.hidden = hidden;
}

#pragma mark - Setter

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.layer.masksToBounds = YES;
        _imgView.layer.cornerRadius = 5;
        [_imgView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1538047861638&di=868dd2f924e8f80a811ef302ad7722fd&imgtype=0&src=http%3A%2F%2Fpic33.photophoto.cn%2F20141028%2F0038038006886895_b.jpg"]];
    }
    return _imgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.text = @"坦克大战";
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _nameLabel.textColor = HEX_RGB(0x222222);
    }
    return _nameLabel;
    
}


- (UILabel *)scoreLabel {
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.textAlignment = NSTextAlignmentLeft;
        _scoreLabel.text = @"人气指数：";
        _scoreLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _scoreLabel.textColor = HEX_RGB(0x555555);
    }
    return _scoreLabel;
    
}

- (XKCommonStarView *)starView {
    if (!_starView) {
        _starView = [[XKCommonStarView alloc] initWithFrame:CGRectMake(0, 0, 80, 10)];
        _starView.allowIncompleteStar = YES;
        [_starView setScorePercent:4.7 / 5];
        _starView.userInteractionEnabled = NO;
        
    }
    return _starView;
}

- (UILabel *)decLabel {
    if (!_decLabel) {
        _decLabel = [[UILabel alloc] init];
        _decLabel.numberOfLines = 2;
        _decLabel.textAlignment = NSTextAlignmentLeft;
        _decLabel.text = @"中短发的方法去潍坊钱未付钱未付钱未付，中短发的方法去潍坊钱未付钱未付钱未付，中短发的方法去潍坊钱未付钱未付钱未付";
        _decLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10];
        _decLabel.textColor = HEX_RGB(0x555555);
    }
    return _decLabel;
    
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}



@end




