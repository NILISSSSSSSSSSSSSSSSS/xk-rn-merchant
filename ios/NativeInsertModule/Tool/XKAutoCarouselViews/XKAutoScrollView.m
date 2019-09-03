//
//  XKAutoScrollView.m
//  XKSquare
//
//  Created by hupan on 2018/8/7.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKAutoScrollView.h"
#import <objc/runtime.h>
#import "XKAutoScrollImageItem.h"
#import "XKGlobleCommonTool.h"

#define ITEM_WIDTH   self.scrollView.width

static CGFloat SWITCH_FOCUS_PICTURE_INTERVAL = 5.0;

@interface XKAutoScrollView ()<UIGestureRecognizerDelegate, UIScrollViewDelegate> {
    BOOL    _isAutoPlay;
    BOOL    _isShowPageControl;
    NSArray *_itemsArray;
    NSTimer *_timer;
}
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end



@implementation XKAutoScrollView

#pragma mark - Lazy load

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.scrollsToTop = NO;
        /*
         _scrollView.layer.cornerRadius = 10;
         _scrollView.layer.borderWidth = 1 ;
         _scrollView.layer.borderColor = [[UIColor lightGrayColor ] CGColor];
         */
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        
        UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
        tapGestureRecognize.delegate = self;
        tapGestureRecognize.numberOfTapsRequired = 1;
        [_scrollView addGestureRecognizer:tapGestureRecognize];
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 25, ITEM_WIDTH, 10)];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.userInteractionEnabled = NO;
        
        if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 6) {
            _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
            _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        }
    }
    return _pageControl;
}


#pragma mark - 初始化


- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id<XKAutoScrollViewDelegate>)delegate
            isShowPageControl:(BOOL)isShowPageControl
                       isAuto:(BOOL)isAuto {
    
    if (self = [super initWithFrame:frame]){
        
        _isAutoPlay = isAuto;
        _isShowPageControl = isShowPageControl;
        [self setDelegate:delegate];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id<XKAutoScrollViewDelegate>)delegate
                   imageItems:(NSArray *)items
            isShowPageControl:(BOOL)isShowPageControl
                       isAuto:(BOOL)isAuto {
    
    
    if (self = [super initWithFrame:frame]){
        
        _isAutoPlay = isAuto;
        _isShowPageControl = isShowPageControl;
        [self setDelegate:delegate];
        [self setupViews:items];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id<XKAutoScrollViewDelegate>)delegate
                   imageItems:(NSArray *)items
            isShowPageControl:(BOOL)isShowPageControl {
    
    return [self initWithFrame:frame delegate:delegate imageItems:items isShowPageControl:isShowPageControl isAuto:YES];
}


- (void)setScrollViewItems:(NSArray *)items {
    [self setupViews:items];
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}


#pragma mark - private methods

- (void)startTimer {
    if (!_timer) {
//        _timer = [NSTimer scheduledTimerWithTimeInterval:SWITCH_FOCUS_PICTURE_INTERVAL target:self selector:@selector(switchFocusImageItems) userInfo:nil repeats:YES];
        _timer = [NSTimer timerWithTimeInterval:SWITCH_FOCUS_PICTURE_INTERVAL target:self selector:@selector(switchFocusImageItems) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}
- (void)setupViews:(NSArray *)items {
    if (items.count == 0) {
        return;
    }
    NSInteger length = items.count;
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length + 2];
    
    if (_isAutoPlay) {
        //添加最后一张图 用于循环
        if (length > 1){
            id dict = items.lastObject;
            XKAutoScrollImageItem *item = [[XKAutoScrollImageItem alloc] initWithDict:dict tag:-1];
            [itemArray addObject:item];
        }
    }
    
    for (int i = 0; i < length; i++){
        id dict = [items objectAtIndex:i];
        XKAutoScrollImageItem *item = [[XKAutoScrollImageItem alloc] initWithDict:dict tag:i];
        [itemArray addObject:item];
    }
    
    if (_isAutoPlay) {
        //添加第一张图 用于循环
        if (length > 1){
            id dict = items.firstObject;
            XKAutoScrollImageItem *item = [[XKAutoScrollImageItem alloc] initWithDict:dict tag:length];
            [itemArray addObject:item];
        }
    }

    _itemsArray = [itemArray copy];
    NSArray *imageItems = _itemsArray;
    [self addSubview:self.scrollView];
    
    if (_isShowPageControl) {
        if (_isAutoPlay) {
            self.pageControl.numberOfPages = imageItems.count > 1 ? imageItems.count - 2 : imageItems.count;
        } else {
            self.pageControl.numberOfPages = imageItems.count;
        }
        self.pageControl.currentPage = 0;
        [self addSubview:self.pageControl];
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * imageItems.count, self.scrollView.frame.size.height);
    
    for (int i = 0; i < imageItems.count; i++) {

        if ([items[0] isKindOfClass:[NSDictionary class]]) {
            
            XKAutoScrollImageItem *item = [imageItems objectAtIndex:i];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * ITEM_WIDTH, 0, ITEM_WIDTH, self.scrollView.height)];
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.userInteractionEnabled = YES;
            [imageView sd_setImageWithURL:[NSURL URLWithString:item.image] placeholderImage:[UIImage imageNamed:@""]];
            
            if (item.title) {
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.frame.size.height - 28, 280.0, 20)];
                titleLabel.textColor = [UIColor whiteColor];
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.font = [UIFont boldSystemFontOfSize:20];
                titleLabel.minimumScaleFactor = 0.7;
                titleLabel.adjustsFontSizeToFitWidth = YES;
                titleLabel.text = item.title;
                [imageView addSubview:titleLabel];
            }
            [self.scrollView addSubview:imageView];

        } else {
        
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * ITEM_WIDTH, 0, ITEM_WIDTH, self.scrollView.height)];
            view.clipsToBounds = YES;
            if (self.customCornerRadius > 0) {
                view.layer.masksToBounds = YES;
                view.layer.cornerRadius = self.customCornerRadius;
            }
    
            if (_isAutoPlay) {
                //第一个和最后一个是重复的
                if (i == 0) {
                    view = [XKGlobleCommonTool creatXKBannerView:view itemModel:items[items.count-1] itemTarget:self action:@selector(itemClicked:)];
                } else if (i == imageItems.count - 1) {
                    view = [XKGlobleCommonTool creatXKBannerView:view itemModel:items[0] itemTarget:self action:@selector(itemClicked:)];
                } else {
                    view = [XKGlobleCommonTool creatXKBannerView:view itemModel:items[i-1] itemTarget:self action:@selector(itemClicked:)];
                }
            } else {
                view = [XKGlobleCommonTool creatXKBannerView:view itemModel:items[i] itemTarget:self action:@selector(itemClicked:)];
            }
            
            [self.scrollView addSubview:view];
        }
    }
    
    if (_isAutoPlay) {
        if ([imageItems count] > 1)  {
            [self.scrollView setContentOffset:CGPointMake(ITEM_WIDTH, 0) animated:NO] ;
            [self startTimer];
        }
    }
}

- (void)switchFocusImageItems {
    
    int page = (int)(self.scrollView.contentOffset.x / self.scrollView.frame.size.width);
    if (page == _itemsArray.count - 1) {
        page = 1;
    } else {
        page++;
    }
    
    [self moveToTargetPosition:page *ITEM_WIDTH];

}

- (void)singleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    
    int page = (int)(self.scrollView.contentOffset.x / self.scrollView.frame.size.width);
    if (page > -1 && page < _itemsArray.count) {
        XKAutoScrollImageItem *item = [_itemsArray objectAtIndex:page];
        if ([self.delegate respondsToSelector:@selector(autoScrollView:didSelectItem:index:)]) {
            [self.delegate autoScrollView:self didSelectItem:item index:page];
        }
    }
}

- (void)moveToTargetPosition:(CGFloat)targetX {
    [self.scrollView setContentOffset:CGPointMake(targetX, 0) animated:YES];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([self.delegate respondsToSelector:@selector(autoScrollView:didScrollIndex:)]) {
        NSInteger page = (self.scrollView.contentOffset.x + ITEM_WIDTH / 2.0) / ITEM_WIDTH;
        [self.delegate autoScrollView:self didScrollIndex:page+1];
    }
    
    if (_isAutoPlay) {
        float targetX = scrollView.contentOffset.x;
        if (_itemsArray.count >= 3) {
            if (targetX >= ITEM_WIDTH * (_itemsArray.count - 1)) {
                targetX = ITEM_WIDTH;
                [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
            } else if(targetX <= 0) {
                targetX = ITEM_WIDTH * (_itemsArray.count - 2);
                [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
            }
        }
    }
    
    if (_isShowPageControl) {
        NSInteger page = (self.scrollView.contentOffset.x + ITEM_WIDTH / 2.0) / ITEM_WIDTH;

        if (_isAutoPlay) {
            if ([_itemsArray count] > 3) {
                if (page >= self.pageControl.numberOfPages) {
                    page = 0;
                } else if(page < 0) {
                    page = self.pageControl.numberOfPages -1;
                }
            }
        }
        self.pageControl.currentPage = page;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_isAutoPlay) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_isAutoPlay) {
        [self startTimer];
    }
}

- (void)itemClicked:(UIButton *)sender {
    NSArray *arr = [sender.titleLabel.text componentsSeparatedByString:@"+"];
    if (arr.count == 2) {
        NSInteger type = [arr[0] integerValue];
        if (self.tapBlock) {
            self.tapBlock(type, arr[1]);
        }
    } else if (arr.count > 2) {
        NSString *text = sender.titleLabel.text;
        if (text.length >= 3) {
            if (self.tapBlock) {
                NSInteger type = [[text substringToIndex:1] integerValue];
                self.tapBlock(type, [text substringFromIndex:2]);
            }
        }
    }
}

@end
