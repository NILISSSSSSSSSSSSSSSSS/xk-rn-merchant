//
//  XKIMMessageBaseContentView.m
//  XKSquare
//
//  Created by xudehuai on 2019/4/22.
//  Copyright © 2019 xk. All rights reserved.
//

#import "XKIMMessageBaseContentView.h"
#import "XKSecretFrientManager.h"
#import "XKSecretMessageFireOtherModel.h"

@interface XKIMMessageBaseContentView ()

@property(nonatomic, strong) UIVisualEffectView *fireView;

@end

@implementation XKIMMessageBaseContentView

- (instancetype)initSessionMessageContentView {
    self = [super initSessionMessageContentView];
    if (self) {
    }
    return self;
}

#pragma mark - Public Methods

- (void)handleFireView {
    [self addSubview:self.fireView];
    [self.fireView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    self.fireView.hidden = YES;
    
    if (self.model.message.isOutgoingMsg) {
        // 发出的消息
    } else {
        // 收到的消息
        if ([XKSecretFrientManager receivedMessageShouldShowFireView:self.model.message]) {
            // 需要显示遮罩
            NSDictionary *messageLocalExt = self.model.message.localExt;
            BOOL isTaped = [messageLocalExt.allKeys containsObject:@"isTaped"] && [messageLocalExt[@"isTaped"] boolValue];
            
            if (isTaped) {
                self.fireView.hidden = YES;
                
            } else {
                self.fireView.hidden = NO;
            }
        } else {
            self.fireView.hidden = YES;
        }
    }
}

#pragma mark - Privite Methods

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
}

- (void)onTouchUpInside:(id)sender {
    [super onTouchUpInside:sender];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self cutCornerWithRadius:8 color:UIColorFromRGB(0xeceef1) lineWidth:0];
}

-(void)fireViewBeTaped:(UITapGestureRecognizer *)sender{
    self.fireView.hidden = YES;
    NSMutableDictionary *messageLocalExt = [NSMutableDictionary dictionaryWithDictionary:self.model.message.localExt];
    messageLocalExt[@"isTaped"] = @(YES);
    // 记录该消息已被点击
    self.model.message.localExt = [messageLocalExt copy];
    [[NIMSDK sharedSDK].conversationManager updateMessage:self.model.message forSession:self.model.message.session completion:^(NSError * _Nullable error) {
        if (!error) {
            if ([XKSecretFrientManager receivedMessageShouldDelete:self.model.message]) {
                // 消息需要删除，添加数据和定时器定时删除
                NSDictionary *dict = @{
                                       @"fireDate" : [NSDate date],
                                       @"message" : self.model.message
                                       };
                XKSecretMessageFireOtherModel *model = [XKSecretMessageFireOtherModel yy_modelWithDictionary:dict];
                [[XKSecretMessageFireManager sharedManager] addMessageToOtherFireMessageArr:@[model]];
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

#pragma mark - Getter Setter

-(UIVisualEffectView *)fireView{
    if (!_fireView) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
        _fireView = [[UIVisualEffectView alloc] initWithEffect:blur];
        _fireView.alpha = 0.96f;
        _fireView.xk_openClip = YES;
        _fireView.xk_radius = 8;
        _fireView.xk_clipType = XKCornerClipTypeAllCorners;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fireViewBeTaped:)];
        [_fireView addGestureRecognizer:tap];
    }
    return _fireView;
}



@end
