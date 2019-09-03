//
//  XKIMEmojiKeyBoard.h
//  XKSquare
//
//  Created by william on 2018/9/27.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XKEmojiKeyboardViewDelegate;

@interface XKIMEmojiKeyBoard : UIView

@property (nonatomic, weak) id<XKEmojiKeyboardViewDelegate> delegate;

/**是否禁用发送按钮*/
@property(nonatomic, assign) BOOL enableSend;
@property(nonatomic, copy) NSString *sendBtnText;

@end

@protocol XKEmojiKeyboardViewDelegate <NSObject>

//点击了表情
- (void)xkEmojiKeyBoardView:(XKIMEmojiKeyBoard *)emojiKeyBoardView
              didUseEmoji:(NSString *)emoji;

//点击了删除按钮
- (void)xkEmojiKeyBoardViewDidPressBackSpace:(XKIMEmojiKeyBoard *)emojiKeyBoardView;

//点击了发送按钮
-(void)xkEmojiKeyBoardPressSendButton:(XKIMEmojiKeyBoard *)emojiKeyBoardView;
@end
