//
//  XKSubscriptionTableViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/8/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSubscriptionTableViewCell.h"
#import "XKSubscriptionCellModel.h"

@interface XKSubscriptionTableViewCell ()


@property (nonatomic, strong) UIImageView *selectImgView;
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UIButton    *sortButton;
@property (nonatomic, strong) UIImageView *sortImg;
@property (nonatomic, strong) UIView      *lineView;

@end

@implementation XKSubscriptionTableViewCell

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
    
    [self.contentView addSubview:self.selectImgView];
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.sortButton];
    [self.contentView addSubview:self.sortImg];
    [self.contentView addSubview:self.lineView];

}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    
    
    
    [self.selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(25);
        make.width.height.equalTo(@16);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectImgView.mas_right).offset(15);
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(@36);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(10);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@150);
    }];
    
    [self.sortButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@40);
        make.height.equalTo(@25);
    }];
    
    [self.sortImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@20);
        make.height.equalTo(@10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
}

#pragma mark - Setter


- (UIImageView *)selectImgView {
    
    if (!_selectImgView) {
        _selectImgView = [[UIImageView alloc] init];
//        _selectImgView.backgroundColor = [UIColor yellowColor];
    }
    return _selectImgView;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
//        _iconImgView.backgroundColor = [UIColor greenColor];
    }
    return _iconImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}



- (UIButton *)sortButton {
    if (!_sortButton) {
        _sortButton = [[UIButton alloc] init];
//        [_sortButton setImage:[UIImage imageNamed:@"xk_btn_subscription_move"] forState:UIControlStateNormal];
        [_sortButton addTarget:self action:@selector(sortButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sortButton;
}

- (UIImageView *)sortImg {
    if (!_sortImg) {
        _sortImg = [[UIImageView alloc] init];
        _sortImg.image = [UIImage imageNamed:@"xk_btn_subscription_move"];
    }
    return _sortImg;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}

- (void)hiddenLine:(BOOL)hidden {
    self.lineView.hidden = hidden;
}

- (void)setValuesWithModel:(XKSubscriptionCellModel *)model indexPath:(NSIndexPath *)indexPath {
    
    self.nameLabel.text = model.titleName;
    self.selectImgView.image = model.selected ? [UIImage imageNamed:@"xk_btn_subscription_delete"] : [UIImage imageNamed:@"xk_btn_subscription_add"];
    self.iconImgView.image = model.selected ? [UIImage imageNamed:model.selectImgName] : [UIImage imageNamed:model.normalImgName];
}

#pragma mark - Events

- (void)sortButtonClicked:(UIButton *)sender {
    if (self.sortBtnBlock) {
        self.sortBtnBlock(sender);
    }
}



@end

