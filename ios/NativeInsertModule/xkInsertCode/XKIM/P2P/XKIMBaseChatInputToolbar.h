//
//  XKIMBaseChatInputToolbar.h
//  XKSquare
//
//  Created by william on 2018/8/29.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,XKIMInputStatus)
{
    XKIMInputStatusText,
    XKIMInputStatusAudio,
    XKIMInputStatusEmoticon,
    XKIMInputStatusMore
};

@protocol XKIMBaseChatInputToolBarDelegate <NSObject>

@optional

- (BOOL)textViewShouldBeginEditing;

- (void)textViewDidEndEditing;

- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)replacementText;

- (void)textViewDidChange;

- (void)toolBarWillChangeHeight:(CGFloat)height;

- (void)toolBarDidChangeHeight:(CGFloat)height;

@end

@interface XKIMBaseChatInputToolbar : UIView
@property (nonatomic,strong) UIButton    *voiceButton;

@property (nonatomic,strong) UIButton    *emoticonBtn;

@property (nonatomic,strong) UIButton    *moreMediaBtn;

@property (nonatomic,strong) UIButton    *recordButton;

@property (nonatomic,strong) UIImageView *inputTextBkgImage;

@property (nonatomic,strong) UIView *bottomSep;

@property (nonatomic,copy) NSString *contentText;

@property (nonatomic,weak) id<XKIMBaseChatInputToolBarDelegate> delegate;

@property (nonatomic,assign) BOOL showsKeyboard;

@property (nonatomic,assign) NSArray *inputBarItemTypes;

@property (nonatomic,assign) NSInteger maxNumberOfInputLines;

- (void)update:(XKIMInputStatus)status;

@end

@interface XKIMBaseChatInputToolbar(InputText)

- (NSRange)selectedRange;

- (void)setPlaceHolder:(NSString *)placeHolder;

- (void)insertText:(NSString *)text;

- (void)deleteText:(NSRange)range;

@end
