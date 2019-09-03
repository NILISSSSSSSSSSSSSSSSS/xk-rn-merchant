//
//  XKSqureConsultLsitCell.m
//  XKSquare
//
//  Created by hupan on 2018/10/22.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSqureConsultLsitCell.h"
#import "XKSqureConsultModel.h"

@interface XKSqureConsultLsitCell ()

@property (nonatomic, strong) UILabel     *tipLabel;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UILabel     *decLable;
@property (nonatomic, strong) UIImageView *imgView;


@end

@implementation XKSqureConsultLsitCell

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
        self.contentView.backgroundColor = HEX_RGB(0xf6f6f6);
        [self initViews];
        [self layoutViews];
    }
    return self;
}

#pragma mark - Private

- (void)initViews {
    
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.tipLabel];
    [self.backView addSubview:self.nameLabel];
    [self.backView addSubview:self.decLable];
    [self.backView addSubview:self.imgView];

}


- (void)layoutViews {
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 10, 0, 10));
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.backView).offset(10);
        make.height.equalTo(@18);
        make.width.equalTo(@50);
    }];
    

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self.tipLabel.mas_right).offset(3);
        make.right.equalTo(self.backView).offset(-10);
        make.centerY.equalTo(self.tipLabel);
    }];

    [self.decLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabel.mas_bottom).offset(5);
        make.left.equalTo(self.backView).offset(10);
        make.right.equalTo(self.backView).offset(-10);
    }];

    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.decLable.mas_bottom).offset(5);
        make.left.equalTo(self.backView).offset(10);
        make.right.bottom.equalTo(self.backView).offset(-10);
        make.height.equalTo(@(140*ScreenScale));
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

- (UIImageView *)imgView {
    
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
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
        _decLable.numberOfLines = 5;
//        _decLable.text = @"石英表供商人处少发点福利卡，石英表供商人处少发点福利卡石英表供商人处少发点福利卡石英表供商人处少发点福利卡石英表供商人处少发点福利卡石英表供商人处少发点福利卡";
        _decLable.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _decLable.textColor = HEX_RGB(0x777777);
    }
    return _decLable;
}



- (UILabel *)tipLabel {
    
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.text = @"活动资讯";
        _tipLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10];
        _tipLabel.textColor = XKMainTypeColor;
        _tipLabel.layer.masksToBounds = YES;
        _tipLabel.layer.cornerRadius = 9;
        _tipLabel.layer.borderWidth = 1;
        _tipLabel.layer.borderColor = XKMainTypeColor.CGColor;
    }
    return _tipLabel;
}


- (void)setValueWithModel:(ConsultItemModel *)model {
    [self.imgView sd_setImageWithURL:kURL(model.image) placeholderImage:IMG_NAME(kDefaultPlaceHolderImgName)];
    self.nameLabel.text = model.title;
    self.decLable.text = model.content;
}

@end



