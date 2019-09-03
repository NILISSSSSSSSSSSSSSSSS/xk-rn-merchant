//
//  XKAutoVerticalScrollBar.m
//  XKSquare
//
//  Created by hupan on 2018/8/6.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKAutoVerticalScrollBar.h"

@interface XKAutoVerticalScrollBar ()

@property (nonatomic, strong) UILabel    *scrollLabel;
@property (nonatomic, strong) NSTimer    *timer;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, assign) CGFloat    width;
@property (nonatomic, assign) CGFloat    height;

@end

@implementation XKAutoVerticalScrollBar




- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.width = frame.size.width;
        self.height = frame.size.height;
        self.timeInterval = 4;
        self.scrollTimeInterval = 0.4;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    self.clipsToBounds = YES;
    [self addSubview:self.scrollLabel];
}
// 开启定时器
- (void)startTimer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:_timeInterval target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

// 定时器方法
- (void)timerMethod {
    _count++;
    if (_count == _contents.count) {
        _count = 0;
    }
    // 两次动画实现类似UIScrollView的滚动效果，控制坐标和隐藏状态
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:self.scrollTimeInterval animations:^{
        weakSelf.scrollLabel.frame = CGRectMake(0, -weakSelf.height+10, weakSelf.width, weakSelf.height);
    } completion:^(BOOL finished) {
//        weakSelf.scrollLabel.hidden = YES;
        weakSelf.scrollLabel.frame = CGRectMake(0, weakSelf.height, weakSelf.width, weakSelf.height);
        weakSelf.scrollLabel.hidden = NO;
        [UIView animateWithDuration:weakSelf.scrollTimeInterval animations:^{
            weakSelf.scrollLabel.attributedText = [self getCurrentContent];
            weakSelf.scrollLabel.frame = CGRectMake(0, 0, weakSelf.width, weakSelf.height);
        } completion:^(BOOL finished) {
            
        }];
    }];
}
// 获取要展示的内容数组
- (void)setContents:(NSArray *)contents {
    // 判断是否要重新赋值
    if ([self array:contents isEqualTo:_contents]) {
        
        return;
    }
    _contents = contents;
    [self reset];
    if (!contents || contents.count == 0) {
        return;
    }
    [self startTimer];
}

// 重置初始状态
- (void)reset {
    
    _count = 0;
    self.scrollLabel.frame = CGRectMake(0, 0, self.width, self.height);
    self.scrollLabel.attributedText = [self getCurrentContent];
    [_timer invalidate];
    _timer = nil;
}
// 获取当前要展示的内容
- (NSAttributedString *)getCurrentContent {
    if (!_contents || _contents.count == 0) {
        return nil;
    }
    NSMutableAttributedString *atttributeStr = [[NSMutableAttributedString alloc] initWithString:_contents[_count]];
    NSDictionary *attributesDic1 = @{NSForegroundColorAttributeName:HEX_RGB(0x4A90FA)};
    NSDictionary *attributesDic2 = @{NSForegroundColorAttributeName:HEX_RGB(0xEE4A4A)};

    NSRange range0 = [_contents[_count] rangeOfString:@"恭喜"];
    NSRange range1 = [_contents[_count] rangeOfString:@"抽奖获得"];
    [atttributeStr addAttributes:attributesDic1 range:NSMakeRange(range0.location + range0.length, range1.location - range0.length)];
    [atttributeStr addAttributes:attributesDic2 range:NSMakeRange(range1.location + range1.length, atttributeStr.length - range1.length - range1.location)];
    return atttributeStr;
}
// 比较两个数组内容是否相同
- (BOOL)array:(NSArray *)array1 isEqualTo:(NSArray *)array2 {
    if (array1.count != array2.count) {
        return NO;
    }
    for (NSString *str in array1) {
        if (![array2 containsObject:str]) {
            return NO;
        }
    }
    return YES;
}
// 点击事件
- (void)clickAction {
    
    if (_delegate && [(id)_delegate respondsToSelector:@selector(noticeScrollDidClickAtIndex:content:)]) {
        [_delegate noticeScrollDidClickAtIndex:_count content:_contents[_count]];
    }
}




- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}



#pragma mark - lazy load

- (UILabel *)scrollLabel {
    
    if (!_scrollLabel) {
        
        _scrollLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _width, _height)];
        _scrollLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:12];
        _scrollLabel.textColor = HEX_RGB(0x777777);
        _scrollLabel.numberOfLines = 2;
        _scrollLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction)];
        [_scrollLabel addGestureRecognizer:tap];
    }
    
    return _scrollLabel;
    
}

@end
