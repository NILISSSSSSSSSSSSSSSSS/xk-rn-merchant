//
//  XKVidelSearchHotTopicsTableViewCell.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/12.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKVidelSearchHotTopicsTableViewCell.h"

@implementation XKVidelSearchHotTopicsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self initializeViews];
        [self updateViews];
    }
    return self;
}

- (void)initializeViews {
    [self.contentView addSubview:self.containerView];
}

- (void)updateViews {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0));
    }];
}

#pragma mark - getter setter

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}


@end
