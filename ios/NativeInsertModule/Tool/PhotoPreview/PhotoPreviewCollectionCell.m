/*******************************************************************************
 # File        : PhotoPreviewCollectionCell.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/20
 # Corporation : 水木科技
 # Description :
 浏览大图的基类 需要其他功能的时候需要继承然后定制
 ******************************************************************************/

#import "PhotoPreviewCollectionCell.h"
#import "PhotoPreviewModel.h"
#import "XKBottomAlertSheetView.h"

@implementation PhotoPreviewCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.previewView = [[PhotoPreviewView alloc] initWithFrame:self.bounds];
        __weak typeof(self) weakSelf = self;
        [self.previewView setSingleTapGestureBlock:^{
            if (weakSelf.singleTapGestureBlock) {
                weakSelf.singleTapGestureBlock();
            }
        }];
        [self.previewView setSendImageToFriendBlock:^(PhotoPreviewModel *model){
            if (weakSelf.sendImageToFriendBlock) {
                weakSelf.sendImageToFriendBlock(model);
            }
        }];
        [self addSubview:self.previewView];
    }
    return self;
}

- (void)setIsSupportLongPress:(BOOL)isSupportLongPress {
	_isSupportLongPress = isSupportLongPress;
	self.previewView.isSupportLongPress = _isSupportLongPress;
}

- (void)setLongPressOptions:(NSArray *)longPressOptions {
    _longPressOptions = longPressOptions;
    self.previewView.longPressOptions = _longPressOptions;
}

- (void)setModel:(PhotoPreviewModel *)model {
    _model = model;
    _previewView.model = model;
}

- (void)recoverSubviews {
    [_previewView recoverSubviews];
}

@end

@interface PhotoPreviewView ()<UIScrollViewDelegate>

@end

@implementation PhotoPreviewView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(10, 0, self.width - 20, self.height);
        _scrollView.bouncesZoom = YES;
        _scrollView.maximumZoomScale = 2.5;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
        [self addSubview:_scrollView];
        
        _imageContainerView = [[UIView alloc] init];
        _imageContainerView.clipsToBounds = YES;
        _imageContainerView.contentMode = UIViewContentModeScaleAspectFill;
        [_scrollView addSubview:_imageContainerView];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [_imageContainerView addSubview:_imageView];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        tap2.numberOfTapsRequired = 2;
        [tap1 requireGestureRecognizerToFail:tap2];
        [self addGestureRecognizer:tap2];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
        longPress.minimumPressDuration = 0.5;
        [self addGestureRecognizer:longPress];
    }
    return self;
}


- (void)setModel:(PhotoPreviewModel *)model {
    _model = model;
    [_scrollView setZoomScale:1.0 animated:NO];
    [self getPhoto:_model];
}

- (void)getPhoto:(PhotoPreviewModel *)model {
    __weak typeof(self) weakSelf = self;
    [model originalImage:^(UIImage *image) {
        weakSelf.imageView.image = image;
        [weakSelf resizeSubviews];
    }];
}

- (void)recoverSubviews {
    [_scrollView setZoomScale:1.0 animated:NO];
    [self resizeSubviews];
}

- (void)resizeSubviews {
    _imageContainerView.origin = CGPointZero;
    _imageContainerView.width = self.scrollView.width;
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.height / self.scrollView.width) {
        _imageContainerView.height = floor(image.size.height / (image.size.width / self.scrollView.width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.scrollView.width;
        if (height < 1 || isnan(height)) height = self.height;
        height = floor(height);
        _imageContainerView.height = height;
        _imageContainerView.centerY = self.height / 2;
    }
    if (_imageContainerView.height > self.height && _imageContainerView.height - self.height <= 1) {
        _imageContainerView.height = self.height;
    }
    CGFloat contentSizeH = MAX(_imageContainerView.height, self.height);
    _scrollView.contentSize = CGSizeMake(self.scrollView.width, contentSizeH);
    [_scrollView scrollRectToVisible:self.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageContainerView.height <= self.height ? NO : YES;
    _imageView.frame = _imageContainerView.bounds;
}

#pragma mark - UITapGestureRecognizer Event
- (void)longPressGesture:(UILongPressGestureRecognizer *)longPress {

	if (!_isSupportLongPress) { // 不支持
		return;
	}
    if (_longPressOptions.count == 0) {
        return;
    }
    if (longPress.state == UIGestureRecognizerStateBegan) {
        __weak typeof(self) weakSelf = self;
        NSMutableArray *options = [NSMutableArray arrayWithArray:_longPressOptions];
        [options addObject:@"取消"];
        XKBottomAlertSheetView *view = [[XKBottomAlertSheetView  alloc] initWithBottomSheetViewWithDataSource:options firstTitleColor:nil choseBlock:^(NSInteger index, NSString *choseTitle) {
            NSString *title = weakSelf.longPressOptions[index];
            if ([title isEqualToString:kLongPressOptionsSendFriend]) {
                !weakSelf.sendImageToFriendBlock?:weakSelf.sendImageToFriendBlock(weakSelf.model);
            } else if ([title isEqualToString:kLongPressOptionsSavePhoto]) {
                [XKHudView showLoadingMessage:@"保存中" to:nil animated:YES];
                UIImageWriteToSavedPhotosAlbum(weakSelf.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            }
        }];
        [view show];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [XKHudView hideHUDForView:nil];
    if(error) {
        [XKHudView showWarnMessage:@"保存图片失败"];
    } else {
        [XKHudView showSuccessMessage:@"已保存到相册"];
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > 1.0) {
        _scrollView.contentInset = UIEdgeInsetsZero;
        [_scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.singleTapGestureBlock) {
        self.singleTapGestureBlock();
    }
}

#pragma mark - UIScrollViewDelegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageContainerView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self refreshImageContainerViewCenter];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
}

#pragma mark - Private
- (void)refreshImageContainerViewCenter {
    CGFloat offsetX = (_scrollView.width > _scrollView.contentSize.width) ? ((_scrollView.width - _scrollView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (_scrollView.height > _scrollView.contentSize.height) ? ((_scrollView.height - _scrollView.contentSize.height) * 0.5) : 0.0;
    self.imageContainerView.center = CGPointMake(_scrollView.contentSize.width * 0.5 + offsetX, _scrollView.contentSize.height * 0.5 + offsetY);
}

@end
