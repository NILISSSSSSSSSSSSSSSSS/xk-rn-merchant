//
//  XKAreaPrizeTableViewCell.m
//  XKSquare
//
//  Created by Lin Li on 2018/11/2.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKAreaPrizeTableViewCell.h"
#import "VDFlashLabel.h"

@interface XKAreaPrizeTableViewCell ()
/**标题*/
@property(nonatomic, strong) UILabel *titleLabel;
/**背景视图*/
@property(nonatomic, strong) UIImageView *bgImageView;
/** 跑马灯 */
@property (nonatomic, strong) VDFlashLabel *flashLabel;
/**容器*/
@property(nonatomic, strong) UIView *myContentView;

@end

@implementation XKAreaPrizeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self craetUI];
    }
    return self;
}

- (void)craetUI {
    [self setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:self.myContentView];
    [self.myContentView addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.flashLabel];
    [self.bgImageView addSubview:self.titleLabel];
    
    [self.myContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.myContentView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(120);
    }];
    
    [self.flashLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(17);
    }];
}

- (UIView *)myContentView {
    if (!_myContentView) {
        _myContentView = [[UIView alloc]init];
        _myContentView.backgroundColor = [UIColor clearColor];
    }
    return _myContentView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.image = [UIImage imageNamed:@"xk_btn_mall_shop_firstView_bg"];
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.layer.cornerRadius = 8;
        _bgImageView.layer.masksToBounds = YES;
        _bgImageView.clipsToBounds = YES;
    }
    return _bgImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"活动商家";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = XKRegularFont(17);
    }
    return _titleLabel;
}

- (VDFlashLabel *)flashLabel {
    if (!_flashLabel) {
        _flashLabel = [VDFlashLabel new];
        _flashLabel.scrollDirection = VDFlashLabelScrollDirectionLeft;
        _flashLabel.backColor = [UIColor clearColor];
        _flashLabel.lineHeight = 18 * ScreenScale;
        _flashLabel.userScroolEnabled = NO;
        _flashLabel.hspace = 0;
        _flashLabel.textColor = [UIColor whiteColor];
        _flashLabel.stringArray = @[@"抽奖了，阳工电马儿大促销，满500减400",@"号外，号外，阳工店铺大促销，买就送妹子咯"];
        [_flashLabel showAndStartTextContentScroll];
        [_flashLabel continueAutoScroll];
    }
    return _flashLabel;
}

@end
