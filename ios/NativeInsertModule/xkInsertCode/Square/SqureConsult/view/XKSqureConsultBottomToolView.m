
//
//  XKSqureConsultBottomToolView.m
//  XKSquare
//
//  Created by hupan on 2018/8/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSqureConsultBottomToolView.h"

@interface XKSqureConsultBottomToolView ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton    *commnetButton;
@property (nonatomic, strong) UIButton    *collectButton;
@property (nonatomic, strong) UIButton    *starButton;
@property (nonatomic, strong) UIButton    *sendButton;
@end

@implementation XKSqureConsultBottomToolView


- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initViews];
        [self layoutViews];
    }
    return self;
}


#pragma mark - Private

- (void)initViews {
    
    [self addSubview:self.textField];
    [self addSubview:self.commnetButton];
    [self addSubview:self.collectButton];
    [self addSubview:self.starButton];
    [self addSubview:self.sendButton];
}



- (void)layoutViews {
    
    
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-155);
        make.height.equalTo(@30);
    }];
    
    [self.commnetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.collectButton.mas_left);
        make.centerY.equalTo(self);
        make.width.equalTo(@40);
        make.height.equalTo(@50);
    }];
    
    [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.starButton.mas_left);
        make.centerY.equalTo(self);
        make.width.equalTo(@40);
        make.height.equalTo(@50);
    }];
    
    [self.starButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.width.equalTo(@40);
        make.height.equalTo(@50);
    }];
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.width.equalTo(@40).priorityHigh();
        make.height.equalTo(@26);
    }];
}


- (void)setValuesWithDictionary:(NSDictionary *)dic {
    [self.starButton setImageAtTopAndTitleAtBottomWithSpace:2];
    [self.collectButton setImageAtTopAndTitleAtBottomWithSpace:2];
    [self.commnetButton setImageAtTopAndTitleAtBottomWithSpace:2];
}

#pragma mark - Setter

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        _textField.backgroundColor = HEX_RGB(0xf1f1f1);
        _textField.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:12];
        _textField.returnKeyType = UIReturnKeySend;
        _textField.layer.masksToBounds = YES;
        _textField.layer.cornerRadius = 5;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xk_icon_squreConsult_write_normal"]];
        imageView.frame = CGRectMake(0, 0, 15, 15);
        _textField.leftView = imageView;
        _textField.placeholder = @"我也有话说";
        _textField.delegate = self;
    }
    return _textField;
}


- (UIButton *)commnetButton {
    if (!_commnetButton) {
        _commnetButton = [[UIButton alloc] init];
        [_commnetButton setTitle:@"89" forState:UIControlStateNormal];
        _commnetButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:10];
        [_commnetButton setImage:[UIImage imageNamed:@"xk_icon_squreConsult_comment_normal"] forState:UIControlStateNormal];
        [_commnetButton setTitleColor:HEX_RGB(0x999999) forState:UIControlStateNormal];
    }
    return _commnetButton;
}


- (UIButton *)collectButton {
    if (!_collectButton) {
        _collectButton = [[UIButton alloc] init];
        [_collectButton setTitle:@"收藏" forState:UIControlStateNormal];
        _collectButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:10];
        [_collectButton setImage:[UIImage imageNamed:@"xk_icon_squreConsult_collect_normal"] forState:UIControlStateNormal];
        [_collectButton setImage:[UIImage imageNamed:@"xk_icon_squreConsult_collect_heighlight"] forState:UIControlStateSelected];
        [_collectButton setTitleColor:HEX_RGB(0x999999) forState:UIControlStateNormal];
        [_collectButton addTarget:self action:@selector(collectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _collectButton;
}

- (UIButton *)starButton {
    if (!_starButton) {
        _starButton = [[UIButton alloc] init];
        [_starButton setTitle:@"59" forState:UIControlStateNormal];
        _starButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:10];
        [_starButton setImage:[UIImage imageNamed:@"xk_icon_squreConsult_praise_normal"] forState:UIControlStateNormal];
        [_starButton setImage:[UIImage imageNamed:@"xk_icon_squreConsult_praise_heighlight"] forState:UIControlStateSelected];
        [_starButton setTitleColor:HEX_RGB(0x999999) forState:UIControlStateNormal];
        [_starButton addTarget:self action:@selector(starButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _starButton;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [[UIButton alloc] init];
        _sendButton.hidden = YES;
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:10];
        _sendButton.layer.masksToBounds = YES;
        _sendButton.layer.cornerRadius = 5;
        _sendButton.backgroundColor = XKMainTypeColor;
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(senderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

#pragma mark - UITextFieldView

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-70);
    }];
    self.sendButton.hidden = NO;
    self.collectButton.hidden = YES;
    self.commnetButton.hidden = YES;
    self.starButton.hidden = YES;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-155);
    }];
    self.sendButton.hidden = YES;
    self.collectButton.hidden = NO;
    self.commnetButton.hidden = NO;
    self.starButton.hidden = NO;
}

#pragma mark - Events

- (void)collectButtonClicked:(UIButton *)sender {
    
    
}


- (void)starButtonClicked:(UIButton *)sender {
    
    
}


- (void)senderButtonClicked:(UIButton *)sender {
    
    
}


@end
