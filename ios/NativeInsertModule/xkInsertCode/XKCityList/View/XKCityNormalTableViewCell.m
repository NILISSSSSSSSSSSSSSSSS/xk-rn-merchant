//
//  XKCityNormalTableViewCell.m
//  XKSquare
//
//  Created by Lin Li on 2018/8/27.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKCityNormalTableViewCell.h"

@implementation XKCityNormalTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor  = HEX_RGB(0x222222);
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:14];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(200);
            make.height.offset(20);
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(@(10));
        }];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = HEX_RGB(0xF2F2F2);
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@(0));
            make.height.equalTo(@1);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(1);
        }];
        self.cityTextLabel = label;
    }
    return self;
}
- (void)setModel:(XKCityListModel *)model {
//    self.cityTextLabel.text = model.name;
    self.model = model;
}
- (void)setFrame:(CGRect)frame {
     frame.size.width -= 20;
     frame.origin.x += 10;
    [super setFrame:frame];
}
@end
