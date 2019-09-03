//
//  XKSqureCarouselAndToolCell.m
//  XKSquare
//
//  Created by hupan on 2018/8/3.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSqureCarouselAndToolCell.h"

@interface XKSqureCarouselAndToolCell ()

@property (nonatomic, strong) UILabel *emptyLabel;



@end

@implementation XKSqureCarouselAndToolCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = HEX_RGB(0xf6f6f6);
        
        [self initViews];
        [self layoutViews];
    }
    return self;
}



#pragma mark - Private

- (void)initViews {
    [self.contentView addSubview:self.emptyLabel];
}

- (void)layoutViews {
    
    [self.emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self.contentView);
    }];
}



#pragma mark - Setter

- (UILabel *)emptyLabel {
    if (!_emptyLabel) {
        _emptyLabel = [[UILabel alloc] init];
        _emptyLabel.font = [UIFont systemFontOfSize:10];
        _emptyLabel.text = @"123";
        _emptyLabel.hidden = YES;
    }
    return _emptyLabel;
}


@end






