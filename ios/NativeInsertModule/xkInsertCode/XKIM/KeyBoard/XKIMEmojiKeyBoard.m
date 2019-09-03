//
//  XKIMEmojiKeyBoard.m
//  XKSquare
//
//  Created by william on 2018/9/27.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKIMEmojiKeyBoard.h"
#import "AGEmojiKeyBoardView.h"
#import "XKEmotionKeyBoradManager.h"
#import "AGEmojiPageView.h"
@interface XKIMEmojiKeyBoard()<XKEmojiKeyboardViewDelegate,UIScrollViewDelegate,AGEmojiPageViewDelegate>

@property (nonatomic ,strong)UIView * sendBar;
@property (nonatomic ,strong)UIButton * sendBtn;

@property (nonatomic ,strong)NSMutableArray *pageViews;

@property (nonatomic ,strong)UIScrollView *emotionScrollView;

@property (nonatomic ,strong)UIPageControl *pageControl;

@end

@implementation XKIMEmojiKeyBoard

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorFromRGB(0xf5f5f7);
        [self initViews];
        [self layoutViews];
        [self loadConfig];
    }
    return self;
}

-(void)initViews{
    [self addSubview:self.sendBar];
    [self addSubview:self.emotionScrollView];
    [self addSubview:self.pageControl];
}

-(void)layoutViews{
    [_sendBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.and.right.mas_equalTo(self);
        make.height.mas_equalTo(40 * ScreenScale);
    }];
    
    [_emotionScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.mas_equalTo(self);
        make.height.mas_equalTo(150);
    }];
    
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.emotionScrollView.mas_bottom);
        make.bottom.mas_equalTo(self.sendBar.mas_top);
        make.width.mas_equalTo(50);
    }];
}

-(void)loadConfig{
    _pageViews = [NSMutableArray array];
    NSArray *emotionArr =  [XKEmotionKeyBoradManager sharedInstance].allStickers;
    
    NSInteger pages = (emotionArr.count % (3 * 8 - 1)) > 0 ? (emotionArr.count / (3 * 8 - 1))+1 : emotionArr.count / (3 * 8 - 1);
    
    for (int i = 0; i < pages; i++) {
        NSString *path = [NSBundle.mainBundle pathForResource:@"XKEmotionResource" ofType:@"bundle"];

        
        
        AGEmojiPageView *pageView = [[AGEmojiPageView alloc] initWithFrame: CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, 150)
                                                          backSpaceButtonImage:[UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:@"删除表情icon"]]
                                                                    buttonSize:CGSizeMake(30, 30)
                                                                          rows:3
                                                                       columns:8];
        NSRange range;
        if ((i + 1) == pages) {
            range = NSMakeRange(i * 23, emotionArr.count - i * 23);
        }else{
            range =NSMakeRange(i * 23, 23);
        }
        [pageView setButtonImages:[emotionArr subarrayWithRange:range]];
        pageView.delegate = self;
        [self.pageViews addObject:pageView];
        [self.emotionScrollView addSubview:pageView];
    }
    
    [_emotionScrollView setContentSize:CGSizeMake(SCREEN_WIDTH * pages, 0)];
    [_pageControl setNumberOfPages:pages];

}
//- (void)emojiKeyBoardView:(AGEmojiKeyboardView *)emojiKeyBoardView didUseEmoji:(NSString *)emoji {
////    self.textView.text = [self.textView.text stringByAppendingString:emoji];
//        [self.delegate xkEmojiKeyBoardView:self didUseEmoji:emoji];
//}
//
//- (void)emojiKeyBoardViewDidPressBackSpace:(AGEmojiKeyboardView *)emojiKeyBoardView {
//        [self.delegate xkEmojiKeyBoardViewDidPressBackSpace:self];
//}
//点击了表情
- (void)xkEmojiKeyBoardView:(XKIMEmojiKeyBoard *)emojiKeyBoardView
                didUseEmoji:(NSString *)emoji{
    
}

//点击了删除按钮
- (void)xkEmojiKeyBoardViewDidPressBackSpace:(XKIMEmojiKeyBoard *)emojiKeyBoardView{
    
}

- (void)setSendBtnText:(NSString *)sendBtnText {
    _sendBtnText = sendBtnText;
    [_sendBtn setTitle:sendBtnText forState:UIControlStateNormal];
}

#pragma mark -- getter and setter

-(UIView *)sendBar{
    if (!_sendBar) {
        _sendBar = [[UIView alloc]init];
        _sendBar.backgroundColor = [UIColor whiteColor];
        UIButton *sendButton = [BaseViewFactory buttonWithFrame:CGRectMake(0, 0, 0, 0) font:XKMediumFont(14) title:@"发送" titleColor:[UIColor whiteColor] backColor:XKMainTypeColor];
        [sendButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        [_sendBar addSubview:sendButton];
        _sendBtn = sendButton;
        XKWeakSelf(weakSelf);
        [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.right.and.bottom.mas_equalTo(weakSelf.sendBar);
            make.width.mas_equalTo(90 * ScreenScale);
        }];
    }
    return _sendBar;
}

- (void)setEnableSend:(BOOL)enableSend {
    _enableSend = enableSend;
    if (!enableSend) {
        _sendBtn.backgroundColor = RGBGRAY(220);
        _sendBtn.userInteractionEnabled = NO;
    } else {
        _sendBtn.backgroundColor = XKMainTypeColor;
        _sendBtn.userInteractionEnabled = YES;
    }
}

-(UIScrollView *)emotionScrollView{
    if (!_emotionScrollView) {
        _emotionScrollView = [[UIScrollView alloc]init];
        //    设置分页,否则滚动效果很糟糕
        [_emotionScrollView setPagingEnabled:YES];
        //    去掉弹性
        [_emotionScrollView setBounces:NO];
        //    去掉滚动条
        [_emotionScrollView setShowsHorizontalScrollIndicator:NO];
        [_emotionScrollView setShowsVerticalScrollIndicator:NO];
        _emotionScrollView.delegate = self;


    }
    return _emotionScrollView;
}

-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl=[[UIPageControl alloc] init];
        //    设置页数
        [_pageControl setPageIndicatorTintColor:[UIColor grayColor]];
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor orangeColor]];
    }
    return _pageControl;
}

#pragma mark scrollView的代理方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index=scrollView.contentOffset.x/scrollView.bounds.size.width;
    [_pageControl setCurrentPage:index];
}

-(void)emojiPageView:(AGEmojiPageView *)emojiPageView didUseEmoji:(int)emotionIndex{
    NSArray *emotionArr =  [XKEmotionKeyBoradManager sharedInstance].allStickers;
    int index = emotionIndex - 200;
    XKSticker *sticker = emotionArr[index];
    NSString *desc = sticker.Desc;
    [self.delegate xkEmojiKeyBoardView:self didUseEmoji:desc];
}

-(void)emojiPageViewDidPressBackSpace:(AGEmojiPageView *)emojiPageView{
    [self.delegate xkEmojiKeyBoardViewDidPressBackSpace:self];
}

-(void)sendMessage:(UIButton *)sender{
    [self.delegate xkEmojiKeyBoardPressSendButton:self];
}
@end
