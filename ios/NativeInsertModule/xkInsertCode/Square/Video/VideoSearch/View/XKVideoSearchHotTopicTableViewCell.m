
//  XKVideoSearchHotTopicTableViewCell.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/14.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKVideoSearchHotTopicTableViewCell.h"

#import "XKVideoSearchTopicModel.h"

@interface XKVideoSearchHotTopicTableViewCell ()

@property (nonatomic, strong) UILabel *topicLab;

@property (nonatomic, strong) UILabel *serialNumLab;

@property (nonatomic, strong) UIImageView *topicTypeImgView;

@property (nonatomic, strong) UILabel *topicHeatLab;

@end

@implementation XKVideoSearchHotTopicTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self initializeViews];
        [self updateViews];
    }
    return self;
}

- (void)initializeViews {
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.serialNumLab];
    [self.containerView addSubview:self.topicLab];
//    [self.containerView addSubview:self.topicTypeImgView];
    [self.containerView addSubview:self.topicHeatLab];
}

- (void)updateViews {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0));
    }];
    
    [self.serialNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.containerView);
        make.leading.mas_equalTo(15.0);
        make.width.mas_equalTo(28.0);
    }];
    
    [self.topicLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.containerView);
        make.left.mas_equalTo(self.serialNumLab.mas_right).offset(5.0);
        make.right.mas_equalTo(self.topicHeatLab.mas_right).offset(-5.0);
    }];
    
//    [self.topicTypeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.topicLab.mas_left).offset(5.0);
//        make.width.height.mas_equalTo(16.0);
//        make.centerY.mas_equalTo(self.containerView);
//        make.right.mas_greaterThanOrEqualTo(self.topicHeatLab.mas_left).offset(-5.0);
//    }];
    
    [self.topicHeatLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.containerView);
        make.trailing.mas_equalTo(-15.0);
        make.width.mas_equalTo(60.0);
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

- (UILabel *)serialNumLab {
    if (!_serialNumLab) {
        _serialNumLab = [[UILabel alloc] init];
        _serialNumLab.font = XKRegularFont(14.0);
        _serialNumLab.textColor = HEX_RGB(0x555555);
    }
    return _serialNumLab;
}

- (UILabel *)topicLab {
    if (!_topicLab) {
        _topicLab = [[UILabel alloc] init];
        _topicLab.font = XKRegularFont(14.0);
        _topicLab.textColor = HEX_RGB(0x555555);
    }
    return _topicLab;
}

- (UIImageView *)topicTypeImgView {
    if (!_topicTypeImgView) {
        _topicTypeImgView = [[UIImageView alloc] init];
        _topicTypeImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _topicTypeImgView;
}

- (UILabel *)topicHeatLab {
    if (!_topicHeatLab) {
        _topicHeatLab = [[UILabel alloc] init];
        _topicHeatLab.font = XKRegularFont(12.0);
        _topicHeatLab.textColor = HEX_RGB(0x999999);
        _topicHeatLab.textAlignment = NSTextAlignmentRight;
    }
    return _topicHeatLab;
}

- (void)setTopic:(XKVideoSearchTopicModel *)topic {
    _topic = topic;
    if (_topic.serialNum <= 3) {
        self.serialNumLab.textColor = HEX_RGB(0xee6161);
    } else {
        self.serialNumLab.textColor = HEX_RGB(0x555555);
    }
    self.serialNumLab.text = [NSString stringWithFormat:@"%tu.", _topic.serialNum];
    self.topicLab.text = _topic.topic_name;
    self.topicHeatLab.text = [NSString stringWithFormat:@"%tu", _topic.use_num];
}

@end
