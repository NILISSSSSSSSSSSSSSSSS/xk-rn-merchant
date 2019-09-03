//
//  XKIMMessageCustomTipAttachment.m
//  XKSquare
//
//  Created by xudehuai on 2019/1/8.
//  Copyright © 2019 xk. All rights reserved.
//

#import "XKIMMessageCustomTipAttachment.h"

@implementation XKIMMessageCustomTipAttachment

- (NSAttributedString *)tipStr {
    NSAttributedString *tipStr = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
        confer.text(self.msgContent).font(XKRegularFont(12.0)).textColor(HEX_RGB(0xFFFFFF));
    }];
    return tipStr;
}

@end
