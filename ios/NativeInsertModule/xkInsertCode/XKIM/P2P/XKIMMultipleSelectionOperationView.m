//
//  XKIMMultipleSelectionOperationView.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/14.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKIMMultipleSelectionOperationView.h"

@interface XKIMMultipleSelectionOperationView ()

@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation XKIMMultipleSelectionOperationView

- (instancetype)initWithFrame:(CGRect)frame {
    self =  [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = XKMainTypeColor;
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteBtn setImage:IMG_NAME(@"PhotoPreview.bundle/deleteMessage") forState:UIControlStateNormal];
        [self addSubview:self.deleteBtn];
        [self.deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    return self;
}

#pragma mark - public method

- (void)setOperationsEnabled:(BOOL)enabled {
    for (UIButton *btn in @[self.deleteBtn]) {
        btn.enabled = enabled;
    }
}

#pragma mark - privite method

- (void)deleteBtnAction:(UIButton *) sender {
    if (self.deleteBtnBlock) {
        self.deleteBtnBlock();
    }
}

@end
