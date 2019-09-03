//
//  XKWelfareShareViewInfoCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/27.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareShareViewInfoCell.h"
#import "XKQRCodeView.h"
@interface XKWelfareShareViewInfoCell ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *describeLabel;
@property (nonatomic, strong) UIButton *ticketBtn;
@property (nonatomic, strong) XKQRCodeView *qrCodeView;
@property (nonatomic, strong) UIImageView *urlImgView;
@end
@implementation XKWelfareShareViewInfoCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}

- (void)updateInfoWithItem:(XKGoodsShareModel *)model {
    
    NSString *dataString = [NSString stringWithFormat:@"xkgc://commodity_detail?commodity_id=%@&userId=%@",model.param.base.ID,[XKUserInfo getCurrentUserId]] ;
    [self.qrCodeView createShareQRImageWithQRString:dataString correctionLevel:@"L"];
    self.nameLabel.text = model.param.base.name;
    self.describeLabel.text = model.param.base.defaultSku.name;
    [self.ticketBtn setTitle:[NSString stringWithFormat:@"¥%.2f",model.param.base.defaultSku.price / 100] forState:0];
    [self.urlImgView sd_setImageWithURL:[NSURL URLWithString:model.param.base.defaultSku.url] placeholderImage:kDefaultPlaceHolderImg];
    
}

- (void)updateWelfareInfoWithItem:(XKWelfareShareModel *)model {
    
    NSString *dataString = [NSString stringWithFormat:@"xkgc://commodity_detail?commodity_id=%@&userId=%@&periods_id=%@",model.param.sequence.goods.ID,[XKUserInfo getCurrentUserId],model.param.sequence.ID] ;
    [self.qrCodeView createShareQRImageWithQRString:dataString correctionLevel:@"L"];
    self.nameLabel.text = model.param.sequence.goods.name;
    self.describeLabel.text = model.param.sequence.goods.atrrName;
    [self.ticketBtn setTitle:[NSString stringWithFormat:@"¥%.2ld",model.param.sequence.lotteryWay.eachNotePrice / 100] forState:0];
    [self.urlImgView sd_setImageWithURL:[NSURL URLWithString:model.param.sequence.goods.mainPic] placeholderImage:kDefaultPlaceHolderImg];
    
}


- (void)addCustomSubviews {
     self.qrCodeView = [[XKQRCodeView alloc] initWithFrame:CGRectMake(0, 0, 66,66)];
    
     [self.contentView addSubview:self.nameLabel];
     [self.contentView addSubview:self.describeLabel];
     [self.contentView addSubview:self.ticketBtn];
     [self.contentView addSubview:self.qrCodeView];
//     [self.qrCodeView addSubview:self.urlImgView];
}

- (void)addUIConstraint {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.right.lessThanOrEqualTo(self.qrCodeView.mas_left).offset(-10);
    }];
    
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.right.greaterThanOrEqualTo(self.qrCodeView.mas_left).offset(-10);
    }];
    
    [self.ticketBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.describeLabel.mas_bottom).offset(5);
        make.size.mas_offset(CGSizeMake(88, 18));
    }];
    
    [self.qrCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.nameLabel);
        make.size.mas_offset(CGSizeMake(66, 66));
    }];
    
//    [self.urlImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.qrCodeView.mas_centerY);
//        make.centerX.equalTo(self.qrCodeView.mas_centerX);
//        make.size.mas_equalTo(CGSizeMake(20, 20));
//    }];
    
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = UIColorFromRGB(0x222222);
        _nameLabel.font =  [UIFont fontWithName:XK_PingFangSC_Medium size:14];

    }
    return _nameLabel;
}

- (UIButton *)ticketBtn {
    if(!_ticketBtn) {
        _ticketBtn = [[UIButton alloc] init];
        [_ticketBtn setTitleColor:[UIColor whiteColor] forState:0];
        _ticketBtn.titleLabel.font =  [UIFont fontWithName:XK_PingFangSC_Regular size:12];
     
        [_ticketBtn setBackgroundColor:UIColorFromRGB(0xFF545B)];
        _ticketBtn.layer.cornerRadius = 9;
        _ticketBtn.layer.masksToBounds = YES;
    }
    return _ticketBtn;
}

- (UILabel *)describeLabel {
    if(!_describeLabel) {
        _describeLabel = [[UILabel alloc] init];
        _describeLabel.textColor = UIColorFromRGB(0x777777);
        _describeLabel.font =  [UIFont fontWithName:XK_PingFangSC_Regular size:12];
      
    }
    return _describeLabel;
}

- (UIImageView *)urlImgView {
    if (!_urlImgView) {
        _urlImgView = [[UIImageView alloc] init];
        
        _urlImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _urlImgView;
}

@end
