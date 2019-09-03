//
//  YYLabel+xkEmoji.h
//  XKSquare
//
//  Created by Jamesholy on 2018/12/11.
//  Copyright © 2018 xk. All rights reserved.
//

#import "YYLabel.h"

@interface YYLabel (xkEmoji)

/**获取供YYLabel显示emoji富文本*/
- (NSAttributedString *)getEmojiAttriStr:(NSString *)text;

@end

