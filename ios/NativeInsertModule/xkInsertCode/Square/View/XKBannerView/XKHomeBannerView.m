//
//  XKHomeBannerView.m
//  Doctor
//
//  Created by 胡攀 on 2017/6/28.
//  Copyright © 2017年 MDKS. All rights reserved.
//

#import "XKHomeBannerView.h"
#import "iCarousel.h"
#import "XKCustomPageControl.h"
#import "XKSquareBannerModel.h"

@interface XKHomeBannerView() <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) iCarousel              *iCarousel;
@property (nonatomic, strong) XKCustomPageControl    *pageControl;
@property (nonatomic, strong) NSTimer                *timer;

@end

@implementation XKHomeBannerView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self addSubview:self.iCarousel];
        [self addSubview:self.pageControl];
        self.imageViewScaleType = UIViewContentModeScaleToFill;
        [self addTimer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.iCarousel];
        [self addSubview:self.pageControl];
        self.imageViewScaleType = UIViewContentModeScaleToFill;
        [self addTimer];
    }
    return self;
}
#pragma mark - setter && getter

- (iCarousel *)iCarousel {
    if (!_iCarousel) {
        _iCarousel = [[iCarousel alloc] init];
        _iCarousel.frame = self.bounds;
        _iCarousel.delegate = self;
        _iCarousel.dataSource = self;
        _iCarousel.type = iCarouselTypeRotary;
        _iCarousel.pagingEnabled = YES;
        _iCarousel.scrollSpeed = 8;
        _iCarousel.decelerationRate = 0.75;
    }
    return _iCarousel;
}


- (XKCustomPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[XKCustomPageControl alloc] initWithFrame:CGRectMake(self.frame.size.width/2-100, CGRectGetMaxY(_iCarousel.frame), 200, 20)];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.userInteractionEnabled = NO;

        _pageControl.inactiveImage = [UIImage imageNamed:@"xk_icon_Banner_normal"];
        _pageControl.inactiveImageSize = CGSizeMake(4, 4);
        _pageControl.currentImage = [UIImage imageNamed:@"xk_icon_Banner_current"];
        _pageControl.currentImageSize = CGSizeMake(12, 3);
        _pageControl.margin = 3;
        _pageControl.loopViewWith = SCREEN_WIDTH - 20;
        //去掉系统自带样式
        _pageControl.pageIndicatorTintColor = [UIColor clearColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor clearColor];
        
    }
    return _pageControl;
}



#pragma mark - public method
- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    [self.iCarousel setCurrentItemIndex:1];
    [self.iCarousel reloadData];
}

- (void)setPageContrllerNumberOfPages:(NSInteger)number hidden:(BOOL)hidden {
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = number;
    self.pageControl.hidden = hidden;
}

#pragma mark - private method
- (void)addTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                  target:self
                                                selector:@selector(nextImageView)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)nextImageView {
    NSInteger index = self.iCarousel.currentItemIndex + 1;
    if (index == self.dataArray.count) {
        index = 0;
    }
    [self.iCarousel scrollToItemAtIndex:index animated:YES];
}

- (void)removeTimer {
    [self.timer invalidate];
}

#pragma mark - iCarouselDataSource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return self.dataArray.count;
}

//item图片之间的间隔宽
- (CGFloat)carouselItemWidth:(iCarousel *)carousel {
    
    return 140;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view {

    if (!view) {
        view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH - 78, CGRectGetHeight(carousel.bounds));
        view.clipsToBounds = YES;
//        view.layer.masksToBounds = YES;
//        view.layer.cornerRadius = 5;
        view.xk_openClip = YES;
        view.xk_clipType = XKCornerClipTypeAllCorners;
        view.xk_radius = 5;
//        view.layer.shadowColor = [UIColor blackColor].CGColor;
//        view.layer.shadowOffset = CGSizeMake(2, 2);
//        view.layer.shadowRadius = 10;
//        view.layer.shadowOpacity = 0.5;
        return [XKGlobleCommonTool creatXKBannerView:view itemModel:self.dataArray[index] itemTarget:self action:@selector(itemClicked:)];
    }
    return view;
}

#pragma mark - iCarouselDelegate
- (void)carouselWillBeginDragging:(iCarousel *)carousel {
    [self removeTimer];
}

- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate {
    [self addTimer];
}

- (void)carouselDidScroll:(iCarousel *)carousel; {
    self.pageControl.currentPage = carousel.currentItemIndex;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    
//    if (self.tapBlock) {
//        self.tapBlock(index, self.dataArray);
//    }
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    if (option == iCarouselOptionSpacing) {
        return 3;
    }
    return value;
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
