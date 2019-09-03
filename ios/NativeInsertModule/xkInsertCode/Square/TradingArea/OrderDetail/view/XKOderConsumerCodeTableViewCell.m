//
//  XKOderConsumerCodeTableViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/8/28.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKOderConsumerCodeTableViewCell.h"
#import "XKQRCodeView.h"

@interface XKOderConsumerCodeTableViewCell ()

@property (nonatomic, strong) XKQRCodeView  *codeView;
@property (nonatomic, strong) UILabel       *codeLabel;

@end

@implementation XKOderConsumerCodeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initViews];
        [self layoutViews];
    }
    return self;
}

#pragma mark - Private

- (void)initViews {
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    [self.contentView addSubview:self.codeView];
    [self.contentView addSubview:self.codeLabel];

}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeView.mas_bottom).offset(10);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
}

- (void)setValueWithQRStr:(NSString *)QRString consumeCode:(NSString *)consumeCode {
    
    [self.codeView createQRImageWithQRString:QRString];
    
    NSMutableArray *muArr = [NSMutableArray array];
    for (int i = 0; i < consumeCode.length; i+=3) {
        if (consumeCode.length >= i + 3) {
            NSString *str = [consumeCode substringWithRange:NSMakeRange(i, 3)];
            [muArr addObject:str];
        } else {
            NSString *str = [consumeCode substringWithRange:NSMakeRange(i, consumeCode.length - i)];
            [muArr addObject:str];
        }
    }
    NSString *codeNum = [muArr componentsJoinedByString:@" "];
    [self.codeLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.paragraphStyle.alignment(NSTextAlignmentCenter).lineSpacing(4);
        confer.text(codeNum).textColor(HEX_RGB(0x222222)).font([UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14]);
        confer.text(@"\n");
        confer.text(@"凭此消费码到店消费").textColor(HEX_RGB(0x777777)).font([UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]);
    }];
}

#pragma mark - Setter

- (XKQRCodeView *)codeView {
    if (!_codeView) {
        _codeView = [[XKQRCodeView alloc] initWithFrame:CGRectMake(0, 0, 105*ScreenScale, 105*ScreenScale)];
        [_codeView createQRImageWithQRString:@"test://qrImage"];
    }
    return _codeView;
}

- (UILabel *)codeLabel {
    if (!_codeLabel) {
        _codeLabel = [[UILabel alloc] init];
        _codeLabel.numberOfLines = 0;
        [_codeLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.paragraphStyle.alignment(NSTextAlignmentCenter).lineSpacing(4);
            confer.text(@"123 333 124 647").textColor(HEX_RGB(0x222222)).font([UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14]);
            confer.text(@"\n");
            confer.text(@"凭此消费码到店消费").textColor(HEX_RGB(0x777777)).font([UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]);
        }];
    }
    return _codeLabel;
}


@end


