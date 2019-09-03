//
//  XKPersonDetailInfoBottomToolBar.m
//  XKSquare
//
//  Created by Jamesholy on 2018/9/18.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKPersonDetailInfoBottomToolBar.h"
@interface XKPersonDetailInfoBottomToolBar ()

/**<##>*/
@property(nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton      *attentionButton;

@property (nonatomic, strong) UIButton      *addXKFriendButton;

@property (nonatomic, strong) UIButton      *addSecretFriendButton;

@property (nonatomic, strong) UIButton      *sendMessageButton;
@property (nonatomic, strong) UIButton      *acceptApplyButton;

@end

@implementation XKPersonDetailInfoBottomToolBar


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}
#pragma mark – Private Methods
-(void)initViews{
    self.backgroundColor = [UIColor whiteColor];
    UIView *topLine = [[UIView alloc]init];
    topLine.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    _contentView = [[UIView alloc] init];
    [self addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - 更新UI
- (void)updateUI {
    NSMutableArray * btns = [self getBtnsWithStatus].mutableCopy;
  
  // fix 商户端没有关注 就搞掉他
  [btns removeObject:self.attentionButton];
  
    // 布局
    [_contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    CGFloat width = SCREEN_WIDTH / btns.count;
    for (int i = 0; i < btns.count; i ++) {
        UIButton *btn = btns[i];
        [_contentView addSubview:btn];
        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.height.equalTo(@50);
            make.width.mas_equalTo(width);
            make.left.equalTo(self.contentView.mas_left).offset(width * i);
        }];
        if (i == btns.count - 1) {
            btn.rightBorder.borderLine.hidden = YES;
        } else {
            btn.rightBorder.borderLine.hidden = NO;
        }
    }
}

#pragma mark - 根据状态获取按钮
- (NSArray *)getBtnsWithStatus {
    if (self.toolStatus == XKPersonDetailInfoBottomToolIsFriendApply) {
        return @[self.attentionButton,self.acceptApplyButton];
    } else {
        if (self.secret) { // 密友
            NSMutableArray *mArr = @[].mutableCopy;
            [mArr addObject:self.attentionButton];

            if (self.secretRelation == XKRelationNoting || ![self.info.secretId isEqualToString:self.secretId]) { // 不是密友 或者 密友圈所属不一致
                [mArr addObject:self.addSecretFriendButton];
            } else {
              if (self.friendRelation == XKRelationNoting) { // 不是好友的情况
                [mArr addObject:self.addXKFriendButton];
              }
                [mArr addObject:self.sendMessageButton];
            }
            return mArr;
        } else {
            NSMutableArray *mArr = @[].mutableCopy;
            [mArr addObject:self.attentionButton];
            if (self.friendRelation == XKRelationNoting) { // 不是可友
                [mArr addObject:self.addXKFriendButton];
            } else {
                [mArr addObject:self.sendMessageButton];
            }
            return mArr;
        }
    }
}

#pragma mark - Events

#pragma mark - 关注按钮点击
- (void)attentionButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(attentionButtonClick)]) {
        [self.delegate attentionButtonClick];
    }
}

#pragma mark - 添加可友点击
- (void)addXKFriendButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(addXKFriendButtonClick)]) {
        [self.delegate addXKFriendButtonClick];
    }
}

#pragma mark - 添加密友点击
- (void)addSecretFriendButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(addSecretFriendButtonClick)]) {
        [self.delegate addSecretFriendButtonClick];
    }
}

#pragma mark - 发送消息点击
- (void)sendMessageButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(sendMessageButtonClick)]) {
        [self.delegate sendMessageButtonClick];
    }
}

#pragma mark - 接收申请点击
- (void)acceptApplyButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(acceptApplyButtonClick)]) {
        [self.delegate acceptApplyButtonClick];
    }
}

#pragma mark – Getters and Setters

-(UIButton *)attentionButton{
    if (!_attentionButton) {
        _attentionButton = [BaseViewFactory buttonWithFrame:CGRectMake(0, 0, 0, 0) font:XKRegularFont(14) title:@"+ 关注" titleColor:XKMainTypeColor backColor:[UIColor clearColor]];
        [_attentionButton setTitle:@"+ 关注" forState:UIControlStateNormal];
        [_attentionButton setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
        [_attentionButton setTitle:@"取消关注" forState:UIControlStateSelected];
        [_attentionButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateSelected];
        [_attentionButton addTarget:self action:@selector(attentionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addRightBorder:_attentionButton];
    }
    if (self.followRelation == XKRelationNoting) {
        _attentionButton.selected = NO;
    } else {
        _attentionButton.selected = YES;
    }
    return _attentionButton;
}

-(UIButton *)addXKFriendButton{
    if (!_addXKFriendButton) {
        _addXKFriendButton = [BaseViewFactory buttonWithFrame:CGRectMake(0, 0, 0, 0) font:XKRegularFont(14) title:@"+ 好友" titleColor:UIColorFromRGB(0xee6161) backColor:[UIColor clearColor]];
        [_addXKFriendButton addTarget:self action:@selector(addXKFriendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addRightBorder:_addXKFriendButton];
    }
    if (self.secret) {
        [_addXKFriendButton setTitle:@"+ 可友" forState:UIControlStateNormal];
    } else {
        [_addXKFriendButton setTitle:@"+ 好友" forState:UIControlStateNormal];
    }
    return _addXKFriendButton;
}

-(UIButton *)addSecretFriendButton{
    if (!_addSecretFriendButton) {
        _addSecretFriendButton = [BaseViewFactory buttonWithFrame:CGRectMake(0, 0, 0, 0) font:XKRegularFont(14) title:@"+ 密友" titleColor:UIColorFromRGB(0xee6161) backColor:[UIColor clearColor]];
        [self addRightBorder:_addSecretFriendButton];
        [_addSecretFriendButton addTarget:self action:@selector(addSecretFriendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addSecretFriendButton;
}

-(UIButton *)sendMessageButton{
    if (!_sendMessageButton) {
        _sendMessageButton = [BaseViewFactory buttonWithFrame:CGRectMake(0, 0, 0, 0) font:XKRegularFont(14) title:@"发消息" titleColor:UIColorFromRGB(0x222222) backColor:[UIColor clearColor]];
        [_sendMessageButton addTarget:self action:@selector(sendMessageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addRightBorder:_sendMessageButton];
    }
    return _sendMessageButton;
}

-(UIButton *)acceptApplyButton {
    if (!_acceptApplyButton) {
        _acceptApplyButton = [BaseViewFactory buttonWithFrame:CGRectMake(0, 0, 0, 0) font:XKRegularFont(14) title:@"接受申请" titleColor:[UIColor redColor] backColor:[UIColor clearColor]];
        [self addRightBorder:_acceptApplyButton];
         [_acceptApplyButton addTarget:self action:@selector(acceptApplyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _acceptApplyButton;
}

- (void)addRightBorder:(UIButton *)btn {
    [btn showBorderSite:rzBorderSitePlaceRight];
    btn.rightBorder.borderLine.backgroundColor = XKSeparatorLineColor;
    btn.rightBorder.topMargin = 8;
    btn.rightBorder.bottomMargin = 8;
}

@end
