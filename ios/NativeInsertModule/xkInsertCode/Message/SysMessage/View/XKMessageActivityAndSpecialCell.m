//
//  XKMessageActivityAndSpecialCell.m
//  XKSquare
//
//  Created by Lin Li on 2018/11/20.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMessageActivityAndSpecialCell.h"

@interface XKMessageActivityAndSpecialCell()
/**背景视图*/
@property(nonatomic, strong) UIView *bigContentView;
/**描述视图*/
@property(nonatomic, strong) UILabel *desLabel;
/**时间*/
@property(nonatomic, strong) UILabel *timeLabel;
/**商品视图*/
@property(nonatomic, strong) UIView *goodsContentView;
/**图片视图*/
@property(nonatomic, strong) UIImageView *imageV;
/**删除按钮*/
@property(nonatomic, strong) UIButton *delButton;
/**点击查看*/
@property(nonatomic, strong) UILabel *seeLabel;
/**线*/
@property(nonatomic, strong) UIView  *line;
@end

@implementation XKMessageActivityAndSpecialCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self creatUI];
        [self layout];
    }
    return self;
}

- (void)setModel:(XKSysDetailMessageModelDataItem *)model {
    _model = model;
    _desLabel.text = model.msgContent;
    _timeLabel.text = [XKTimeSeparateHelper customTimeStyleWithTimestampString:model.createdAt];
}

- (void)creatUI {
    
    [self.contentView addSubview:self.bigContentView];
    
    [self.bigContentView addSubview:self.desLabel];
    [self.bigContentView addSubview:self.timeLabel];
    [self.bigContentView addSubview:self.goodsContentView];
    [self.goodsContentView addSubview:self.imageV];
    
    [self.bigContentView addSubview:self.delButton];
    [self.bigContentView addSubview:self.seeLabel];
    [self.bigContentView addSubview:self.line];
}

- (void)layout {
    [self.bigContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.delButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(28);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(15);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(20);
        make.right.equalTo(self.timeLabel.mas_left).offset(-10);
    }];
    
    [self.goodsContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.equalTo(self.desLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(-10);
        make.bottom.equalTo(self.delButton.mas_top).offset(-26);
    }];
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.goodsContentView);
    }];
    
    [self.seeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.equalTo(self.delButton.mas_bottom);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(100);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bigContentView).offset(-10);
        make.left.equalTo(self.bigContentView).offset(10);
        make.top.equalTo(self.goodsContentView.mas_bottom).offset(10);
        make.height.mas_offset(1);
    }];
}


- (UIView *)bigContentView {
    if (!_bigContentView) {
        _bigContentView = [[UIView alloc]init];
        _bigContentView.backgroundColor = [UIColor whiteColor];
        _bigContentView.xk_openClip = YES;
        _bigContentView.xk_radius = 5;
        _bigContentView.xk_clipType = XKCornerClipTypeAllCorners;
    }
    return _bigContentView;
}


- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[UILabel alloc]init];
        _desLabel.text = @"细数晓可商城十大值得买的配饰";
        _desLabel.textColor = HEX_RGB(0x222222);
        _desLabel.font = XKRegularFont(14);
        _desLabel.numberOfLines = 1;
    }
    return _desLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel ) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = XKRegularFont(14);
        _timeLabel.textColor = HEX_RGB(0xBBBBBB);
        _timeLabel.text = @"刚刚";
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

- (UIView *)goodsContentView {
    if (!_goodsContentView) {
        _goodsContentView = [[UIView alloc]init];
        _goodsContentView.xk_openClip = YES;
        _goodsContentView.xk_radius = 1;
        _goodsContentView.xk_clipType = XKCornerClipTypeAllCorners;
    }
    return _goodsContentView;
}

- (UIImageView *)imageV {
    if (!_imageV) {
        _imageV = [[UIImageView alloc]init];

        _imageV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageV;
}

- (UIButton *)delButton {
    if (!_delButton) {
        _delButton = [[UIButton alloc]init];
        [_delButton setTitle:@"删除" forState:0];
        [_delButton setTitleColor:HEX_RGB(0x8FB8F8) forState:0];
        _delButton.titleLabel.font = XKRegularFont(14);
        [_delButton addTarget:self action:@selector(delButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delButton;
}

- (UILabel *)seeLabel {
    if (!_seeLabel) {
        _seeLabel = [[UILabel alloc]init];
        _seeLabel.text = @"点击查看";
        _seeLabel.textColor = HEX_RGB(0x7777777);
        _seeLabel.font = XKRegularFont(14);
        _seeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _seeLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = XKSeparatorLineColor;
    }
    return _line;
}
- (void)delButtonAction:(UIButton *)sender {
    if (self.delBlock) {
        self.delBlock();
    }
}

- (void)setFrame:(CGRect)frame {
    frame.size.width -= 20;
    frame.origin.x += 10;
    [super setFrame:frame];
}
@end
