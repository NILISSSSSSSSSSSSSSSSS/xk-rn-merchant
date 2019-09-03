//
//  XKIMMessageCustomerSerOrderContentView.m
//  XKSquare
//
//  Created by william on 2018/9/6.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKIMMessageCustomerSerOrderContentView.h"
#import "XKIMMessageCustomerSerOrderAttachment.h"
#import "XKMallOrderDetailViewModel.h"
#import "XKWelfareOrderDetailViewModel.h"
#import "XKMallOrderDetailWaitPayViewController.h"
#import "XKMallOrderDetailWaitSendViewController.h"
#import "XKMallOrderDetailWaitAcceptViewController.h"
#import "XKMallOrderDetailWaitEvaluateViewController.h"
#import "XKMallOrderDetailFinishViewController.h"
#import "XKWelfareOrderDetailWaitOpenViewController.h"
#import "XKWelfareOrderDetailWaitSendViewController.h"
#import "XKWelfareOrderDetailWaitAcceptViewController.h"
#import "XKWelfareOrderDetailWaitShareViewController.h"
#import "XKWelfareOrderDetailFinishViewController.h"
NSString *const NIMMessageCustomerSerOrder = @"NIMMessageCustomerSerOrder";

@interface XKIMMessageCustomerSerOrderContentView ()

@property (nonatomic, strong) NIMMessageModel *data;

@end

@implementation XKIMMessageCustomerSerOrderContentView

- (instancetype)initSessionMessageContentView{
    self = [super initSessionMessageContentView];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xEDF4FF);
        self.bubbleImageView.hidden = YES;
        [self addSubview:self.orderImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.detailLabel];
        [self addSubview:self.orderIdLabel];
    }
    return self;
}

- (void)refresh:(NIMMessageModel*)data{
    //务必调用super方法
    [super refresh:data];
    self.data = data;
    NIMCustomObject *object = data.message.messageObject;
    XKIMMessageCustomerSerOrderAttachment *attachment = object.attachment;
    if (attachment.orderIconUrl && attachment.orderIconUrl.length) {
        [self.orderImageView sd_setImageWithURL:[NSURL URLWithString:attachment.orderIconUrl] placeholderImage:kDefaultPlaceHolderImg];
    } else {
        self.orderImageView.image = kDefaultPlaceHolderImg;
    }
    self.titleLabel.text = attachment.commodityName;
    if (attachment.orderType == 1) {
        // 福利订单
        self.detailLabel.text = @"";
        self.detailLabel.hidden = YES;
    } else {
        // 自营订单
        if (attachment.orderCommodityCount == 1) {
            self.detailLabel.text = [NSString stringWithFormat:@"产品规格：%@", attachment.commoditySpecification];
        } else {
            self.detailLabel.text = [NSString stringWithFormat:@"商品总额：¥%.2f", attachment.orderTotalAmount];
        }
    }
    self.orderIdLabel.text = [NSString stringWithFormat:@"订单号：%@", attachment.orderId];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self cutCornerWithRadius:8 color:UIColorFromRGB(0xeceef1) lineWidth:0];

    [_orderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(3 * ScreenScale);
        make.size.mas_equalTo(CGSizeMake(59 * ScreenScale, 59 * ScreenScale));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self->_orderImageView.mas_top);
        make.left.mas_equalTo(self->_orderImageView.mas_right).offset(5 * ScreenScale);
        make.bottom.mas_equalTo(self->_orderImageView.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-3 * ScreenScale);
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self->_orderImageView.mas_right).offset(5 * ScreenScale);
        make.top.mas_equalTo(self->_titleLabel.mas_bottom);
        make.right.mas_equalTo(self->_titleLabel.mas_right);
        make.height.mas_equalTo(12 * ScreenScale);
    }];
    
    [_orderIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self->_orderImageView.mas_right).offset(5 * ScreenScale);
        make.top.mas_equalTo(self->_detailLabel.mas_bottom);
        make.right.mas_equalTo(self->_titleLabel.mas_right);
        make.height.mas_equalTo(12 * ScreenScale);
    }];
}
#pragma mark - Events
//orderCell点击事件
- (void)onTouchDown:(id)sender{
    NSLog(@"订单cell被点击");
}

#pragma mark – Getters and Setters


-(UIImageView *)orderImageView{
    if (!_orderImageView) {
        _orderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 59 * ScreenScale, 59 * ScreenScale)];
        [_orderImageView cutCornerWithRadius:5 color:[UIColor whiteColor] lineWidth:0];
    }
    return _orderImageView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(10) textColor:UIColorFromRGB(0x222222) backgroundColor:[UIColor clearColor]];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

-(UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(10) textColor:UIColorFromRGB(0x777777) backgroundColor:[UIColor clearColor]];
        _detailLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _detailLabel;
}

-(UILabel *)orderIdLabel{
    if (!_orderIdLabel) {
        _orderIdLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(10) textColor:UIColorFromRGB(0x777777) backgroundColor:[UIColor clearColor]];
        _orderIdLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _orderIdLabel;
}
@end
