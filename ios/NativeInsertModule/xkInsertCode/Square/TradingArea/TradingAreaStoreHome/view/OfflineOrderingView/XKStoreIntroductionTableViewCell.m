//
//  XKStoreIntroductionTableViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKStoreIntroductionTableViewCell.h"
#import "XKCommonStarView.h"
#import "XKAutoScrollView.h"
#import "BigPhotoPreviewBaseController.h"
#import "PhotoPreviewModel.h"
#import "XKTradingAreaShopInfoModel.h"

@interface XKStoreIntroductionTableViewCell ()<XKAutoScrollViewDelegate>

@property (nonatomic, strong) XKAutoScrollView  *loopView;
@property (nonatomic, strong) UILabel           *indexLable;

@property (nonatomic, strong) UILabel           *nameLabel;
@property (nonatomic, strong) XKCommonStarView  *starView;
@property (nonatomic, strong) UILabel           *decLable;
@property (nonatomic, strong) UIView            *lineView;

@property (nonatomic, strong) UIButton          *addressButton;

@property (nonatomic, strong) UIView            *reservationBackView;
@property (nonatomic, strong) UIButton          *reservationBtn;

@property (nonatomic, strong) XKTradingAreaShopInfoModel *model;


@end


@implementation XKStoreIntroductionTableViewCell

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
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    
    [self.contentView addSubview:self.loopView];
    [self.contentView addSubview:self.indexLable];
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.starView];
    [self.contentView addSubview:self.decLable];
    [self.contentView addSubview:self.lineView];
    
    [self.contentView addSubview:self.addressButton];

    [self.contentView addSubview:self.reservationBackView];
    [self.contentView addSubview:self.reservationBtn];

}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    
    [self.loopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@(ScreenScale*180));
    }];
    
    [self.indexLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.loopView).offset(-10);
        make.right.equalTo(self.loopView).offset(-8);
        make.width.equalTo(@35);
        make.height.equalTo(@18);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loopView.mas_bottom).offset(8);
        make.left.equalTo(self.contentView).offset(15);
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);
    }];
    
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.width.equalTo(@80);
        make.height.equalTo(@12);
    }];
    
    [self.decLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.starView.mas_right).offset(2);
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.starView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.starView.mas_bottom).offset(10);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    
    [self.addressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(10);
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.reservationBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressButton.mas_bottom).offset(10);
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@36);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [self.reservationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.reservationBackView);
    }];
}



#pragma mark - Setter

- (XKAutoScrollView *)loopView {
    if (!_loopView) {
        _loopView = [[XKAutoScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, ScreenScale*180) delegate:self isShowPageControl:NO isAuto:NO];
//        [_loopView setScrollViewItems:@[
//  @{@"link":@"123.com", @"image":@"http://pic25.photophoto.cn/20121016/0009021124976824_b.jpg"},
//  @{@"link":@"123.com", @"image":@"http://pic25.photophoto.cn/20121016/0009021124976824_b.jpg"},
//  @{@"link":@"123.com", @"image":@"http://pic25.photophoto.cn/20121016/0009021124976824_b.jpg"},
//  @{@"link":@"123.com", @"image":@"http://pic25.photophoto.cn/20121016/0009021124976824_b.jpg"},
//  @{@"link":@"123.com", @"image":@"http://pic25.photophoto.cn/20121016/0009021124976824_b.jpg"}]];
//        _loopView.backgroundColor = [UIColor redColor];
    }
    return _loopView;
}


- (UILabel *)indexLable {
    if (!_indexLable) {
        _indexLable = [[UILabel alloc] init];
        _indexLable.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12];
        _indexLable.textColor = [UIColor whiteColor];
        _indexLable.textAlignment = NSTextAlignmentCenter;
        _indexLable.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//        _indexLable.text = @"1/5";
        _indexLable.layer.masksToBounds = YES;
        _indexLable.layer.cornerRadius = 9;
    }
    return _indexLable;
}


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = XKRegularFont(17);
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
//        _nameLabel.text = @"测试火锅（时代中心店）";
    }
    return _nameLabel;
}


- (XKCommonStarView *)starView {
    if (!_starView) {
        _starView = [[XKCommonStarView alloc] initWithFrame:CGRectMake(0, 0, 80, 12)];
        _starView.backgroundColor = [UIColor whiteColor];
        _starView.allowIncompleteStar = YES;
//        [_starView setScorePercent:4.0/5];
        _starView.userInteractionEnabled = NO;
    }
    return _starView;
}


- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}

- (UILabel *)decLable {
    
    if (!_decLable) {
        _decLable = [[UILabel alloc] init];
        _decLable.textAlignment = NSTextAlignmentLeft;
//        _decLable.text = @"4.7分 | ￥59/人";
        _decLable.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _decLable.textColor = HEX_RGB(0x666666);
    }
    return _decLable;
}


- (UIButton *)addressButton {
    if (!_addressButton) {
        _addressButton = [[UIButton alloc] init];
        _addressButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        NSString *str = @"武侯区-周达到1993号xxxxx | 距您187m";
//        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
//        NSDictionary *dic1 = @{NSFontAttributeName:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12], NSForegroundColorAttributeName:HEX_RGB(0x333333)};
//        NSRange range = [str rangeOfString:@"| 距您"];
//        [attributeStr addAttributes:dic1 range:NSMakeRange(0, range.location + 1)];
//
//        NSDictionary *dic2 = @{NSFontAttributeName:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12], NSForegroundColorAttributeName:HEX_RGB(0x666666)};
//        [attributeStr addAttributes:dic2 range:NSMakeRange(range.location, str.length - range.location)];
//
//        [_addressButton setAttributedTitle:attributeStr forState:UIControlStateNormal];
        [_addressButton setImage:[UIImage imageNamed:@"xk_icon_store_address"] forState:UIControlStateNormal];
        [_addressButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        
        [_addressButton addTarget:self action:@selector(addressButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _addressButton;
}



- (UIView *)reservationBackView {
    
    if (!_reservationBackView) {
        _reservationBackView = [[UIView alloc] init];
        _reservationBackView.layer.masksToBounds = YES;
        _reservationBackView.layer.cornerRadius = 5;
        _reservationBackView.backgroundColor = HEX_RGB(0xf6f6f6);
    }
    return _reservationBackView;
}

- (UIButton *)reservationBtn {
    if (!_reservationBtn) {
        _reservationBtn = [[UIButton alloc] init];
        _reservationBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    }
    return _reservationBtn;
}

- (void)setValueWithModel:(XKTradingAreaShopInfoModel *)model {
    
    self.model = model;
    
    NSMutableArray *picArr = [NSMutableArray array];
    for (NSString *imgUrl in model.mShop.pictures) {
        NSDictionary *dic = @{@"image":imgUrl ? imgUrl : @""};
        [picArr addObject:dic];
    }
    if (!picArr.count) {
        [picArr addObject:@{@"image":model.mShop.cover ? model.mShop.cover : @""}];
    }
    [self.loopView setScrollViewItems:picArr.copy];
    
    self.indexLable.text = [NSString stringWithFormat:@"1/%d", (int)picArr.count];
    
    self.nameLabel.text = model.mShop.name;
    
    [self.starView setScorePercent:model.mShop.level / 5];
    
    self.decLable.text = [NSString stringWithFormat:@"%.1f分 | ￥%.2f/人", model.mShop.level / 5.0, model.mShop.avgConsumption / 100.0];
    
    
    NSString *str = [NSString stringWithFormat:@"%@ | 距您%@Km", model.mShop.address, model.distance];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSDictionary *dic1 = @{NSFontAttributeName:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12], NSForegroundColorAttributeName:HEX_RGB(0x333333)};
    NSRange range = [str rangeOfString:@"| 距您"];
    [attributeStr addAttributes:dic1 range:NSMakeRange(0, range.location + 1)];
    NSDictionary *dic2 = @{NSFontAttributeName:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12], NSForegroundColorAttributeName:HEX_RGB(0x666666)};
    [attributeStr addAttributes:dic2 range:NSMakeRange(range.location, str.length - range.location)];
    [self.addressButton setAttributedTitle:attributeStr forState:UIControlStateNormal];
    
}


#pragma mark - Events

- (void)setIntroductionTableViewCelltype:(IntroductionCellType)cellType {
    self.cellType = cellType;
    
    /*if (cellType == IntroductionCellType_offlineOrdering) {
        
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:@"订座（已订1050）"];
        NSDictionary *dic1 = @{NSFontAttributeName:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:14], NSForegroundColorAttributeName:HEX_RGB(0x222222)};
        [attributeStr addAttributes:dic1 range:NSMakeRange(0, 2)];
        NSDictionary *dic2 = @{NSFontAttributeName:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12], NSForegroundColorAttributeName:HEX_RGB(0x999999)};
        [attributeStr addAttributes:dic2 range:NSMakeRange(2, attributeStr.length - 2)];
        
        [self.reservationBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
        
    } else if (cellType == IntroductionCellType_serviceBook) {*/
        
        [self.reservationBtn setTitle:@"预定" forState:UIControlStateNormal];
        [self.reservationBtn setTitleColor:HEX_RGB(0x222222) forState:UIControlStateNormal];
//    }
    [self.reservationBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.reservationBtn setImage:[UIImage imageNamed:@"xk_icon_Store_ phone"] forState:UIControlStateNormal];
    [self.reservationBtn addTarget:self action:@selector(reservationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addressButtonClicked:(UIButton *)sender {
    if (self.addresBtnBlock) {
        self.addresBtnBlock(sender);
    }
}

- (void)reservationButtonClicked:(UIButton *)sender {
    if (self.reservationBtnBlock) {
        self.reservationBtnBlock(sender, self.model.mShop.contactPhones, self.cellType);
    }
}


#pragma mark - XKAutoScrollViewDelegate

- (void)autoScrollView:(XKAutoScrollView *)autoScrollView didSelectItem:(XKAutoScrollImageItem *)item index:(NSInteger)index {
    
    if (self.coverItemBlock) {
        self.coverItemBlock(autoScrollView, item, index);
    }
}

- (void)autoScrollView:(XKAutoScrollView *)autoScrollView didScrollIndex:(NSInteger)index {
    
    self.indexLable.text = [NSString stringWithFormat:@"%d/%d",(int)index, (int)self.model.mShop.pictures.count];
}



@end


