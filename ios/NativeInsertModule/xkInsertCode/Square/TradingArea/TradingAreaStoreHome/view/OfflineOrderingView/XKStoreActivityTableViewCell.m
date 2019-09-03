//
//  XKStoreActivityTableViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKStoreActivityTableViewCell.h"
#import "XKTradingAreaShopInfoModel.h"

@interface XKStoreActivityTableViewCell ()

@property (nonatomic, strong) UILabel           *nameLabel;
@property (nonatomic, strong) UILabel           *infoLabel;
@property (nonatomic, strong) UIImageView       *imgView;


@end

@implementation XKStoreActivityTableViewCell

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
    
    [self.contentView addSubview:self.infoLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.imgView];
    
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(18);
        make.left.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView).offset(-18);
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(15);
        make.right.lessThanOrEqualTo(self.contentView).offset(-35);
        make.centerY.equalTo(self.nameLabel);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.nameLabel);
        make.width.equalTo(@7);
        make.height.equalTo(@12);
    }];
    
}



#pragma mark - Setter


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14];
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.text = @"店铺活动";
    }
    return _nameLabel;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14];
        _infoLabel.textColor = XKMainTypeColor;
        _infoLabel.textAlignment = NSTextAlignmentLeft;
//        _infoLabel.text = @"满200减20，满500减100";
    }
    return _infoLabel;
}




- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"ic_btn_msg_circle_rightArrow"];
    }
    return _imgView;
}


- (void)setValueWithModelArr:(NSArray<ATCouponsItem *> *)arr {
    
    NSMutableString *muStr = [NSMutableString string];
    for (ATCouponsItem *item in arr) {
        if ([arr indexOfObject:item] > 1) {
            break;
        }
        if (item.couponName) {
            [muStr appendString:item.couponName];
            if ([arr indexOfObject:item] == 0) {
                [muStr appendString:@"，"];
            }
        }
    }
    if (muStr.length == 0) {
        self.infoLabel.text = @"暂无活动";
    } else {
        self.infoLabel.text = muStr;
    }
}

@end
