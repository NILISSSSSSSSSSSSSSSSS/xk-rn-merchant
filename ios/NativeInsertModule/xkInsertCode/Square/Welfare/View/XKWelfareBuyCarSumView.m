//
//  XKWelfareBuyCarSumView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareBuyCarSumView.h"
@interface XKWelfareBuyCarSumView () <UITextFieldDelegate>

@property (nonatomic, strong)UIView *segmentViewLeft;
@property (nonatomic, strong)UIView *segmentViewRight;
@end

@implementation XKWelfareBuyCarSumView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}

- (void)addCustomSubviews {
    [self addSubview:self.addBtn];
    [self addSubview:self.subBtn];
    [self addSubview:self.inputTf];
    [self addSubview:self.segmentViewLeft];
    [self addSubview:self.segmentViewRight];
    
    self.layer.cornerRadius = 3.f;
    self.layer.borderWidth = 1.f;
    self.layer.borderColor = UIColorFromRGB(0xe6e6e6).CGColor;
    self.layer.masksToBounds = YES;
}

- (void)addUIConstraint {
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self);
        make.width.mas_equalTo(20);
    }];
    
    [self.inputTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.right.equalTo(self.addBtn.mas_left);
        make.width.mas_equalTo(40);
    }];
    
    [self.subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.mas_equalTo(20);
    }];
    
    [self.segmentViewRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addBtn.mas_left);
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(1);
    }];
    
    [self.segmentViewLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.inputTf.mas_left);
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(1);
    }];
}

- (UIButton *)addBtn {
    if(!_addBtn) {
        _addBtn = [[UIButton alloc] init];
        [_addBtn setTitle:@"＋" forState:0];
        [_addBtn setTitleColor:UIColorFromRGB(0x999999) forState:0];
        [_addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

- (UIButton *)subBtn {
    if(!_subBtn) {
        _subBtn = [[UIButton alloc] init];
        [_subBtn setTitle:@"－" forState:0];
        [_subBtn setTitleColor:UIColorFromRGB(0x999999) forState:0];
        [_subBtn addTarget:self action:@selector(subBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subBtn;
}

- (UITextField *)inputTf {
    if(!_inputTf) {
        _inputTf = [[UITextField alloc] init];
        _inputTf.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:12];
        _inputTf.textColor = UIColorFromRGB(0x999999);
        _inputTf.delegate = self;
        _inputTf.textAlignment = NSTextAlignmentCenter;
        [_inputTf addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        _inputTf.text = @"1";
    }
    return _inputTf;
}

- (UIView *)segmentViewLeft {
    if(!_segmentViewLeft) {
        _segmentViewLeft = [[UIView alloc] init];
        _segmentViewLeft.backgroundColor = UIColorFromRGB(0xe6e6e6);
    }
    return _segmentViewLeft;
}

- (UIView *)segmentViewRight {
    if(!_segmentViewRight) {
        _segmentViewRight = [[UIView alloc] init];
        _segmentViewRight.backgroundColor = UIColorFromRGB(0xe6e6e6);
    }
    return _segmentViewRight;
}


- (void)addBtnClick:(UIButton *)sender {
    if(self.addBlock) {
        self.addBlock(sender);
    }
}

- (void)subBtnClick:(UIButton *)sender {
    if(self.subBlock) {
        self.subBlock(sender);
    }
}

#pragma mark - 代理
- (void)textFieldChanged:(UITextField *)textField {
    if (textField.text.integerValue > 999) {
        textField.text = @"999";
    }
    
    if (textField.text.integerValue == 0 && textField.text.length > 0) {
        textField.text = @"1";
    }
    
    if(self.textFieldChangeBlock) {
        self.textFieldChangeBlock(textField.text);
    }
}

// textField代理方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if(textField.text.integerValue == 0) {
        textField.text = @"1";
        self.model.quantity = 1;
        if(self.textFieldChangeBlock) {
            self.textFieldChangeBlock(textField.text);
        }
    }
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
@end
