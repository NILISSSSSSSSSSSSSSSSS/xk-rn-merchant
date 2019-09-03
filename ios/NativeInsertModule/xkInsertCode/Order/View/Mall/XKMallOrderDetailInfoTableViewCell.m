//
//  XKMallOrderDetailTicketTableViewCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/11/21.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMallOrderDetailInfoTableViewCell.h"
#import "BigPhotoPreviewBaseController.h"
#import "PhotoPreviewModel.h"
@interface XKMallOrderDetailInfoTableViewCell ()

@property (nonatomic, strong) UIView  *topLineView;
@property (nonatomic, strong) UILabel *topInfoLabel;
@property (nonatomic, strong) UILabel *midInfoLabel;
@property (nonatomic, strong) UILabel *bottomInfoLabel;
@property (nonatomic, strong) UIButton *downLoadBtn;
@property (nonatomic, strong) XKMallOrderDetailViewModel  *model;
@end

@implementation XKMallOrderDetailInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {

        self.xk_openClip = YES;
        self.xk_radius = 6.f;
     
    }
    return self;
}

- (void)addCustomSubviews {

    [self.contentView addSubview:self.topLineView];
    [self.contentView addSubview:self.topInfoLabel];
    [self.contentView addSubview:self.midInfoLabel];
    [self.contentView addSubview:self.bottomInfoLabel];
    [self.contentView addSubview:self.downLoadBtn];
}

- (void)handleWaitPayOrderDetailModel:(XKMallOrderDetailViewModel *)model WithType:(NSInteger)type {
    _model = model;
    if (type == 0) {
        if (model.invoiceInfo.electInvoice) {
            _downLoadBtn.hidden = NO;
        } else {
            _downLoadBtn.hidden = YES;
        }
    self.xk_clipType = XKCornerClipTypeBottomBoth;
    NSString *ticketType = nil;
    if ([model.invoiceInfo.invoiceType isEqualToString:@"PERSONAL"]) {
        ticketType = @"个人";
    } else  if ([model.invoiceInfo.invoiceType isEqualToString:@"ENTERPRISE"]) {
        ticketType = @"企业发票";
    }
    
    NSString *ticketTypeStr = [NSString stringWithFormat:@"发票类型：%@",ticketType ? : @""];
    NSMutableAttributedString *ticketAttrString = [[NSMutableAttributedString alloc] initWithString:ticketTypeStr];
    [ticketAttrString addAttribute:NSFontAttributeName
                             value:XKRegularFont(12)
                             range:NSMakeRange(5, ticketTypeStr.length - 5)];
    _topInfoLabel.attributedText = ticketAttrString;
    
    NSString *header = model.invoiceInfo.head;
    NSString *headerStr = [NSString stringWithFormat:@"发票抬头：%@",header ? : @""];
    NSMutableAttributedString *headerString = [[NSMutableAttributedString alloc] initWithString:headerStr];
    [headerString addAttribute:NSFontAttributeName
                         value:XKRegularFont(12)
                         range:NSMakeRange(5, headerStr.length - 5)];
    _midInfoLabel.attributedText = headerString;
    
    NSString *content = model.invoiceInfo.invoiceContent;
    NSString *contentStr = [NSString stringWithFormat:@"发票内容：%@",content ? : @""];
    NSMutableAttributedString *detailString = [[NSMutableAttributedString alloc] initWithString:contentStr];
    [detailString addAttribute:NSFontAttributeName
                         value:XKRegularFont(12)
                         range:NSMakeRange(5, contentStr.length - 5)];
    _bottomInfoLabel.attributedText = detailString;
        
    } else if (type == 1) {
        _downLoadBtn.hidden = YES;
        self.xk_clipType = XKCornerClipTypeTopBoth;
        NSString *total = [NSString stringWithFormat:@"¥ %.2f",model.amountInfo.goodsMoney / 100];
        NSString *post;
        if (model.amountInfo.postFee == 0) {
            post = @"免运费";
        } else {
            post = [NSString stringWithFormat:@"¥ %.2f",model.amountInfo.postFee / 100];
        }

         NSString *discount;
        if (model.amountInfo.discountMoney == 0) {
            discount = @"无优惠";
        } else {
            discount = [NSString stringWithFormat:@"- ¥ %.2f",model.amountInfo.discountMoney / 100];
        }

        
        NSString *totalStr = [NSString stringWithFormat:@"商品总额：%@",total];
        NSMutableAttributedString *totalStrAttrString = [[NSMutableAttributedString alloc] initWithString:totalStr];
        [totalStrAttrString addAttribute:NSFontAttributeName
                                   value:XKRegularFont(12)
                                   range:NSMakeRange(5, totalStr.length - 5)];
        _topInfoLabel.attributedText = totalStrAttrString;
        
        NSString *postStr = [NSString stringWithFormat:@"运费：%@",post];
        NSMutableAttributedString *postAttrString = [[NSMutableAttributedString alloc] initWithString:postStr];
        [postAttrString addAttribute:NSFontAttributeName
                               value:XKRegularFont(12)
                               range:NSMakeRange(3, postStr.length - 3)];
        _midInfoLabel.attributedText = postAttrString;
        
        
        NSString *discountStr = [NSString stringWithFormat:@"优惠促销：%@",discount];
        NSMutableAttributedString *discountStrString = [[NSMutableAttributedString alloc] initWithString:discountStr];
        [discountStrString addAttribute:NSFontAttributeName
                                  value:XKRegularFont(12)
                                  range:NSMakeRange(5, discountStr.length - 5)];
        _bottomInfoLabel.attributedText = discountStrString;
    }


}

- (void)downLoadBtnCLick:(UIButton *)sender {

    PhotoPreviewModel *model = [[PhotoPreviewModel alloc] init];
    model.imageURL = _model.invoiceInfo.electInvoice;
 
    BigPhotoPreviewBaseController *photoPreviewController = [[BigPhotoPreviewBaseController alloc] init];
    photoPreviewController.models = @[model].mutableCopy;
    photoPreviewController.isSupportLongPress = NO;
    photoPreviewController.isShowNav = YES;
    photoPreviewController.isShowTitle = YES;
    photoPreviewController.strNavTitle = @"发票详情";
    photoPreviewController.isShowStatusBar = YES;
    photoPreviewController.isHiddenIndex = YES;
    photoPreviewController.navColor = XKMainTypeColor;
    photoPreviewController.isSave = YES;
    [[self getCurrentUIVC] presentViewController:photoPreviewController animated:YES completion:nil];
}

- (void)addUIConstraint {

    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.contentView.mas_top);
        make.height.mas_equalTo(1);
    }];
    
    [self.topInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.topLineView.mas_bottom).offset(10);
    }];
    
    [self.midInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.topInfoLabel.mas_bottom).offset(5);
    }];
    
    [self.bottomInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.midInfoLabel.mas_bottom).offset(5);
    }];
    
    [self.downLoadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-40);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
}


- (UIView *)topLineView {
    if(!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = XKSeparatorLineColor;
    }
    return _topLineView;
}

- (UILabel *)topInfoLabel {
    if(!_topInfoLabel) {
        _topInfoLabel = [[UILabel alloc] init];
        _topInfoLabel.font = XKRegularFont(14);
        _topInfoLabel.textColor = UIColorFromRGB(0x555555);
    }
    return _topInfoLabel;
}

- (UILabel *)midInfoLabel {
    if(!_midInfoLabel) {
        _midInfoLabel = [[UILabel alloc] init];
        _midInfoLabel.font = XKRegularFont(14);
        _midInfoLabel.textColor = UIColorFromRGB(0x555555);
    }
    return _midInfoLabel;
}

- (UILabel *)bottomInfoLabel {
    if(!_bottomInfoLabel) {
        _bottomInfoLabel = [[UILabel alloc] init];
        _bottomInfoLabel.font = XKRegularFont(14);
        _bottomInfoLabel.textColor = UIColorFromRGB(0x555555);
    }
    return _bottomInfoLabel;
}

- (UIButton *)downLoadBtn {
    if(!_downLoadBtn) {
        _downLoadBtn = [[UIButton alloc] init];
        _downLoadBtn.layer.cornerRadius = 10.f;
        _downLoadBtn.layer.masksToBounds = YES;
        [_downLoadBtn setBackgroundColor:XKMainTypeColor];
        [_downLoadBtn setTitle:@"下载发票" forState:0];
        _downLoadBtn.titleLabel.font = XKRegularFont(12);
        [_downLoadBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_downLoadBtn addTarget:self action:@selector(downLoadBtnCLick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downLoadBtn;
}
@end
