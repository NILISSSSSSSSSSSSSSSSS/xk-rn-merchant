//
//  XKIMMessageCustomerSerKnowledgeContentView.m
//  XKSquare
//
//  Created by william on 2018/10/25.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKIMMessageCustomerSerKnowledgeContentView.h"
#import "XKIMMessageCustomerSerKnowledgeAttachment.h"
#import "XKJumpWebViewController.h"

@implementation XKIMMessageCustomerSerKnowledgeContentView

- (instancetype)initSessionMessageContentView
{
    if (self = [super initSessionMessageContentView]) {
        self.bubbleImageView.hidden = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.textLabel];
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data{
    [super refresh:data];
    
    NIMCustomObject *object = data.message.messageObject;
    XKIMMessageCustomerSerKnowledgeAttachment *attachment = object.attachment;
    NSString *text = attachment.msgContent;
    
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:text attributes:attribtDic];
    
    self.textLabel.attributedText  = attribtStr;
    
    if (self.model.message.isOutgoingMsg) {
        self.backgroundColor = UIColorFromRGB(0xedf4ff);
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self cutCornerWithRadius:8 color:UIColorFromRGB(0xeceef1) lineWidth:0];

    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(10 * ScreenScale);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10 * ScreenScale);
        make.right.mas_equalTo(self.mas_right).offset(-10 * ScreenScale);
        make.top.mas_equalTo(self.mas_top).offset(10 * ScreenScale);
    }];
}

-(void)onTouchUpInside:(id)sender{
    NIMCustomObject *object = self.model.message.messageObject;
    XKIMMessageCustomerSerKnowledgeAttachment *attachment = object.attachment;
    XKJumpWebViewController *vc = [[XKJumpWebViewController alloc]init];
    vc.url = attachment.knowledgeUrl;
    [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}

-(UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.numberOfLines = 0;
        _textLabel.font = XKRegularFont(14);
        _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.textColor = XKMainTypeColor;
    }
    return _textLabel;
}

@end
