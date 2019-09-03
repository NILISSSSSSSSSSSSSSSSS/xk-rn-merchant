//
//  XKVideoSearchTopicTableViewCell.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/14.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKVideoSearchTopicTableViewCell.h"

#import "XKVideoSearchTopicModel.h"

@interface XKVideoSearchTopicTableViewCell ()

@property (nonatomic, strong) UIImageView *searchImgView;

@property (nonatomic, strong) UILabel *topicLab;

@end

@implementation XKVideoSearchTopicTableViewCell

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
    [self.containerView addSubview:self.searchImgView];
    [self.containerView addSubview:self.topicLab];
}

- (void)updateViews {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0));
    }];
    
    [self.searchImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16.0);
        make.centerY.mas_equalTo(self.containerView);
        make.size.mas_equalTo(self.searchImgView.image.size);
    }];
    
    [self.topicLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.containerView);
        make.left.mas_equalTo(self.searchImgView.mas_right).offset(9.0);
        make.trailing.mas_equalTo(-9.0);
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

- (UIImageView *)searchImgView {
    if (!_searchImgView) {
        _searchImgView = [[UIImageView alloc] init];
        _searchImgView.image = IMG_NAME(@"xk_ic_video_search");
    }
    return _searchImgView;
}

- (UILabel *)topicLab {
    if (!_topicLab) {
        _topicLab = [[UILabel alloc] init];
    }
    return _topicLab;
}

- (void)setSearchImgHidden:(BOOL)hidden {
    if (hidden) {
        self.searchImgView.hidden = YES;
        [self.topicLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.containerView);
            make.left.mas_equalTo(self.searchImgView);
            make.trailing.mas_equalTo(-9.0);
        }];
    } else {
        self.searchImgView.hidden = NO;
        [self.topicLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.containerView);
            make.left.mas_equalTo(self.searchImgView.mas_right).offset(9.0);
            make.trailing.mas_equalTo(-9.0);
        }];
    }
}

- (void)setTopic:(XKVideoSearchTopicModel *)topic {
    _topic = topic;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_topic.topic_name];
    [str addAttribute:NSFontAttributeName value:XKRegularFont(14.0) range:NSMakeRange(0, str.length)];
    [str addAttribute:NSForegroundColorAttributeName value:HEX_RGB(0x777777) range:NSMakeRange(0, str.length)];
    if (_topic.searchKeyword) {
        [str addAttribute:NSForegroundColorAttributeName value:XKMainTypeColor range:[_topic.topic_name rangeOfString:_topic.searchKeyword]];
    }
    self.topicLab.attributedText = str;
}

@end
