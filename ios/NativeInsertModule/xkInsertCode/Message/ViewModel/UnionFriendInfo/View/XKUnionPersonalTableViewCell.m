//
//  XKUnionPersonalTableViewCell.m
//  XKSquare
//
//  Created by Lin Li on 2019/5/6.
//  Copyright © 2019 xk. All rights reserved.
//

#import "XKUnionPersonalTableViewCell.h"

@implementation XKUnionPersonalTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    self.myContentView = [[UIView alloc]init];
    [self.contentView addSubview:self.myContentView];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.myContentView.backgroundColor = [UIColor whiteColor];
    [self.myContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = XKRegularFont(15);
    titleLabel.textColor = HEX_RGB(0x222222);
    [self.myContentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.centerY.equalTo(self.myContentView);
        make.height.mas_equalTo(15);
    }];
    self.titleLabel = titleLabel;
    
    UILabel *ortherLabel = [[UILabel alloc]init];
    ortherLabel.font = XKRegularFont(15);
    ortherLabel.textColor = HEX_RGB(0x222222);
    [self.myContentView addSubview:ortherLabel];
    [ortherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-25);
        make.centerY.equalTo(self.myContentView);
        make.height.mas_equalTo(15);
    }];
    self.rightTitlelabel = ortherLabel;
    
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = HEX_RGB(0xF1F1F1);
    [self.myContentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.myContentView);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.height.equalTo(@1);
    }];
}
@end
