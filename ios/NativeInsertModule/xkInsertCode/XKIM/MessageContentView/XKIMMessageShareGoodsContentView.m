//
//  XKIMMessageShareGoodsContentView.m
//  XKSquare
//
//  Created by william on 2018/11/9.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKIMMessageShareGoodsContentView.h"
#import "XKIMMessageShareGoodsAttachment.h"
#import "XKMallGoodsDetailViewController.h"
#import "XKSecretMessageFireOtherModel.h"
#import "XKSecretFrientManager.h"
#import "xkMerchantEmitterModule.h"
NSString *const NIMMessageShareGoodsContentView = @"NIMMessageShareGoodsContentView";

@interface XKIMMessageShareGoodsContentView()

@end

@implementation XKIMMessageShareGoodsContentView

- (instancetype)initSessionMessageContentView{
    self = [super initSessionMessageContentView];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        self.bubbleImageView.hidden = YES;
        [self addSubview:self.headerImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.despLabel];
        [self addSubview:self.priceLabel];
        [self addSubview:self.fromLabel];
        [self addSubview:self.midLine];
    }
    return self;
}

- (void)refresh:(NIMMessageModel*)data{
    //务必调用super方法
    [super refresh:data];
    NIMCustomObject *object = data.message.messageObject;
    XKIMMessageShareGoodsAttachment *attachment = object.attachment;
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:attachment.commodityIconUrl]];
    self.titleLabel.text = attachment.commodityName;
    self.despLabel.text = attachment.commoditySpecification;
    [self.priceLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
//        confer.text(@"价格: ").textColor(UIColorFromRGB(0x777777));
        confer.text([NSString stringWithFormat:@"¥%.2f",attachment.commodityPrice / 100.0]).textColor([UIColor redColor]);
    }];
    if (data.message.isOutgoingMsg) {
        self.fromLabel.text = @"我的分享";
    } else {
        self.fromLabel.text = @"可友分享";
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self cutCornerWithRadius:8 color:UIColorFromRGB(0xffffff) lineWidth:0];
    XKWeakSelf(weakSelf);
    
    [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10 * ScreenScale);
        make.left.mas_equalTo(self.mas_left).offset(10 * ScreenScale);
        make.size.mas_equalTo(CGSizeMake(60 * ScreenScale, 60 * ScreenScale));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.headerImageView.mas_right).offset(7 * ScreenScale);
        make.right.mas_equalTo(weakSelf.mas_right).offset(-10 * ScreenScale);
        make.bottom.mas_equalTo(weakSelf.headerImageView.mas_centerY);
        make.top.mas_equalTo(weakSelf.headerImageView.mas_top);
    }];
    
    [_despLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(weakSelf.titleLabel);
        make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom).offset(3 * ScreenScale);
        make.height.mas_equalTo(15 * ScreenScale);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.despLabel.mas_bottom).offset(3 * ScreenScale);
        make.left.and.right.mas_equalTo(weakSelf.despLabel);
        make.height.mas_equalTo(15 * ScreenScale);
    }];
    
    [_fromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.headerImageView.mas_left);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(20 * ScreenScale);
    }];
    
    [_midLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self);
        make.bottom.mas_equalTo(weakSelf.fromLabel.mas_top);
        make.height.mas_equalTo(1);
    }];
    
    [self handleFireView];
}

-(void)onTouchUpInside:(id)sender{
    NIMCustomObject *obj = self.model.message.messageObject;
    XKIMMessageShareGoodsAttachment *goods = obj.attachment;
//    XKMallGoodsDetailViewController *vc = [[XKMallGoodsDetailViewController alloc] init];
//    vc.goodsId = goods.commodityId;
//    vc.type = XKMallGoodsDetailViewControllerTypeSoldByXiaoke;
//    [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    [xkMerchantEmitterModule RNJumpToGoodsDetailWithGoodsId: goods.commodityId];
}

#pragma mark -- getter and setter

-(UIImageView *)headerImageView{
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc]init];
        _headerImageView.xk_openClip = YES;
        _headerImageView.xk_radius = 8;
        _headerImageView.xk_clipType = XKCornerClipTypeAllCorners;
    }
    return _headerImageView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(12) textColor:UIColorFromRGB(0x222222) backgroundColor:[UIColor whiteColor]];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

-(UILabel *)despLabel{
    if (!_despLabel) {
        _despLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(10) textColor:UIColorFromRGB(0x777777) backgroundColor:[UIColor whiteColor]];
    }
    return _despLabel;
}

-(UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(10) textColor:UIColorFromRGB(0x777777) backgroundColor:[UIColor whiteColor]];
        _priceLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _priceLabel;
}

-(UILabel *)fromLabel{
    if (!_fromLabel) {
        _fromLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(10) textColor:UIColorFromRGB(0x999999) backgroundColor:[UIColor whiteColor]];
        _fromLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _fromLabel;
}

-(UIView *)midLine{
    if (!_midLine) {
        _midLine = [[UIView alloc]init];
        _midLine.backgroundColor = UIColorFromRGB(0xf1f1f1);
    }
    return _midLine;
}

@end
