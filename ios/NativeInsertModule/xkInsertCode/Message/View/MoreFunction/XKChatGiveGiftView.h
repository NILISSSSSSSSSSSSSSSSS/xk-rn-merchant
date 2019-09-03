//
//  XKChatGiveGiftView.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKIMGiftModel.h"

typedef NS_OPTIONS(NSUInteger, XKChatGiveGiftViewType) {
    XKChatGiveGiftViewTypeLittleVideo   = 1 << 0, // 小视频
    XKChatGiveGiftViewTypeIM            = 1 << 1, // 可友聊天
    XKChatGiveGiftViewTypeRedEnvelope   = 1 << 2, // 红包
};

@interface XKChatGiveGiftView : UIView
// 发红包CELL点击事件
@property (nonatomic, copy) void (^sendRedEnvelopeBlock)(void);
// 普通CELL点击事件
@property (nonatomic, copy) void (^cellSelectedBlock)(XKIMGiftModel *gift);
// 赠送按钮点击事件
@property (nonatomic, copy) void (^handselBtnBlock)(XKIMGiftModel *gift, NSInteger num);

- (instancetype)initWithFrame:(CGRect)frame gifts:(NSArray *) gifts type:(XKChatGiveGiftViewType) type;

@end
