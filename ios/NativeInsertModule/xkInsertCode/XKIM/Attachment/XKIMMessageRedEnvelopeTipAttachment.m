//
//  XKIMMessageRedEnvelopeTipAttachment.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/16.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKIMMessageRedEnvelopeTipAttachment.h"
#import <NIMSDK/NIMSDK.h>
#import "NIMKitInfoFetchOption.h"

@implementation XKIMMessageRedEnvelopeTipAttachment

- (NSAttributedString *)tipStr {
    
    NSMutableAttributedString *tipStr;
    NSString *currentUserId = [[NIMSDK sharedSDK].loginManager currentAccount];
    // 领取别人的红包
    NIMKitInfoFetchOption *option = [[NIMKitInfoFetchOption alloc] init];
    if ([currentUserId isEqualToString:self.redEnvelopeSenderId] && [currentUserId isEqualToString:self.redEnvelopeReceiverId]) {
        // 自己发，自己抢
        if (self.isLastReceived) {
            tipStr = [[NSMutableAttributedString alloc] initWithString:@"我领取了自己的红包，我的红包已被领完"];
            [tipStr addAttribute:NSFontAttributeName value:XKRegularFont(12.0) range:NSMakeRange(0, tipStr.length)];
            [tipStr addAttribute:NSForegroundColorAttributeName value:HEX_RGB(0xffffff) range:NSMakeRange(0, tipStr.length)];
            [tipStr addAttribute:NSForegroundColorAttributeName value:XKMainRedColor range:NSMakeRange(7, 2)];
        } else {
            tipStr = [[NSMutableAttributedString alloc] initWithString:@"我领取了自己的红包"];
            [tipStr addAttribute:NSFontAttributeName value:XKRegularFont(12.0) range:NSMakeRange(0, tipStr.length)];
            [tipStr addAttribute:NSForegroundColorAttributeName value:HEX_RGB(0xffffff) range:NSMakeRange(0, tipStr.length)];
            [tipStr addAttribute:NSForegroundColorAttributeName value:XKMainRedColor range:NSMakeRange(tipStr.length - 2, 2)];
        }
    } else if ([currentUserId isEqualToString:self.redEnvelopeReceiverId]) {
        // 自己抢
        NIMKitInfo * sendUserInfo = [[NIMKit sharedKit] infoByUser:self.redEnvelopeSenderId option:option];
        NSString * name = sendUserInfo.showName;
        tipStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"我领取了%@的红包", name]];
        [tipStr addAttribute:NSFontAttributeName value:XKRegularFont(12.0) range:NSMakeRange(0, tipStr.length)];
        [tipStr addAttribute:NSForegroundColorAttributeName value:HEX_RGB(0xffffff) range:NSMakeRange(0, tipStr.length)];
        [tipStr addAttribute:NSForegroundColorAttributeName value:XKMainRedColor range:NSMakeRange(tipStr.length - 2, 2)];
    }
    else if ([currentUserId isEqualToString:self.redEnvelopeSenderId]) {
        // 别人抢
        NIMKitInfo * openUserInfo = [[NIMKit sharedKit] infoByUser:self.redEnvelopeReceiverId option:option];
        NSString * name = openUserInfo.showName;
        if (self.isLastReceived) {
            tipStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@领取了你的红包，你的红包已被领完", name]];
            [tipStr addAttribute:NSFontAttributeName value:XKRegularFont(12.0) range:NSMakeRange(0, tipStr.length)];
            [tipStr addAttribute:NSForegroundColorAttributeName value:HEX_RGB(0xffffff) range:NSMakeRange(0, tipStr.length)];
            [tipStr addAttribute:NSForegroundColorAttributeName value:XKMainRedColor range:NSMakeRange(name.length + 5, 2)];
        } else {
            tipStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@领取了你的红包", name]];
            [tipStr addAttribute:NSFontAttributeName value:XKRegularFont(12.0) range:NSMakeRange(0, tipStr.length)];
            [tipStr addAttribute:NSForegroundColorAttributeName value:HEX_RGB(0xffffff) range:NSMakeRange(0, tipStr.length)];
            [tipStr addAttribute:NSForegroundColorAttributeName value:XKMainRedColor range:NSMakeRange(name.length + 5, 2)];
        }
    }
    return tipStr && tipStr.length ? tipStr : [[NSMutableAttributedString alloc] initWithString:@""];
}

@end
