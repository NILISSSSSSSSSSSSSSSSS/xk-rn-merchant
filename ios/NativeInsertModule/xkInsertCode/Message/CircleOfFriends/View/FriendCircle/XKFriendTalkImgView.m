/*******************************************************************************
 # File        : XKFriendTalkImgView.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/17
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKFriendTalkImgView.h"
#define kFTopMargin 10
#define kFImgMargin 8
#define kFImgSize ((self.initWidth - 2 * kFImgMargin - 28) / 3)

@interface XKFriendTalkImgView ()
/**图片父视图*/
@property(nonatomic, strong) UIView *imgSuperView;
/**宽度*/
@property(nonatomic, assign) CGFloat initWidth;
/**<##>*/
@property(nonatomic, strong) MASConstraint *diyHeightCons;
@end

@implementation XKFriendTalkImgView

#pragma mark - 初始化
- (instancetype)initWithWidth:(CGFloat)width {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.initWidth = width;
        self.backgroundColor = [UIColor whiteColor];
        // 初始化默认数据
        [self createDefaultData];
        // 初始化界面
        [self createUI];
        // 布局界面
        [self createConstraints];
    }
    return self;
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
    
}

#pragma mark - 初始化界面
- (void)createUI {
    _imgSuperView = [[UIView alloc] init];
    [self addSubview:_imgSuperView];
}

#pragma mark - 布局界面
- (void)createConstraints {
    [_imgSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
        self.diyHeightCons =  make.height.equalTo(@0);
    }];
    [self.diyHeightCons activate];
}

#pragma mark - 图片点击
- (void)imageClick:(NSInteger)imgIndex {
    if ([self.model.detailType isEqualToString:@"video"]) {
        [XKGlobleCommonTool playVideoWithUrlStr:self.model.videoContents.firstObject.url];
    } else if ([self.model.detailType isEqualToString:@"picture"]) {
        NSMutableArray *imgArr = @[].mutableCopy;
        for (FriendsCirclelPictureContentsItem *item in self.model.pictureContents) {
            [imgArr addObject:item.url];
        }
        [XKGlobleCommonTool showBigImgWithImgsArr:imgArr defualtIndex:imgIndex viewController:self.getCurrentUIVC];
    }
}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)setModel:(XKFriendTalkModel *)model {
    _model = model;
    if (model.pics.count == 0) {
        [self.diyHeightCons activate];
        return;
    }
    [self.diyHeightCons deactivate];
    [self resetHeight:model];
    [self removeImgsViews];
    [self addImg:model];
}

- (void)resetHeight:(XKFriendTalkModel *)model {
    if (model.pics.count == 1 && model.singleImgWidth == 0) {
        model.singleImgWidth = kFImgSize;
        model.singleImgheight = kFImgSize;
        UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:model.pics.firstObject];
        if (cacheImage) {
            [self restSingleImgSize:cacheImage];
        }
    }
    NSInteger imgNum = model.pics.count;
    if (imgNum == 1) {
        [_imgSuperView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(model.singleImgheight + kFTopMargin);
        }];
    } else if (imgNum <= 3) {
        [_imgSuperView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kFImgSize + kFTopMargin);
        }];
    } else if (imgNum <= 6) {
        [_imgSuperView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kFImgSize * 2 + kFImgMargin + kFTopMargin);
        }];
    } else {
        [_imgSuperView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kFImgSize * 3 + kFImgMargin * 2 + kFTopMargin);
        }];
    }
}

- (void)removeImgsViews {
    NSArray<UIView *> *imgsArray = [_imgSuperView subviews];
    [imgsArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
}

- (void)addImg:(XKFriendTalkModel *)model {
    __weak typeof(self) weakSelf = self;
    NSArray *arr = model.pics;
    CGFloat x = 0;
    CGFloat y = kFTopMargin;
    if (arr.count == 1) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.clipsToBounds = YES;
        imageView.contentMode =  UIViewContentModeScaleAspectFill;
        if ([model.detailType isEqualToString:@"video"]) {
            UIButton *playBtn = [[UIButton alloc] init];
            [playBtn setBackgroundImage:IMG_NAME(@"xk_ic_middlePlay") forState:UIControlStateNormal];
            [imageView addSubview:playBtn];
            playBtn.userInteractionEnabled = NO;
            [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(imageView);
                make.size.mas_equalTo(CGSizeMake(30, 30));
            }];
        }
        [imageView sd_setImageWithURL:[NSURL URLWithString:arr.firstObject] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (!error) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                    if (model.singleImgWidth == kFImgSize && model.singleImgheight == kFImgSize) {
                        [self restSingleImgSize:image];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.refreshBlock(self.indexPath);
                        });
                    }
                });
            }
        }];
        [_imgSuperView addSubview:imageView];
        imageView.frame = CGRectMake(x, y, model.singleImgWidth, model.singleImgheight);
        imageView.userInteractionEnabled = YES;
        [imageView bk_whenTapped:^{
            [weakSelf imageClick:0];
        }];
    } else if (arr.count == 4) {
        for (int i = 1; i < arr.count + 1; i ++) {
            NSString *url = arr[i-1];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.clipsToBounds = YES;
            imageView.contentMode =  UIViewContentModeScaleAspectFill;
            [imageView sd_setImageWithURL:kURL(url) placeholderImage:kDefaultPlaceHolderImg];
            [_imgSuperView addSubview:imageView];
            imageView.frame = CGRectMake(x, y, kFImgSize, kFImgSize);
            imageView.userInteractionEnabled = YES;
            [imageView bk_whenTapped:^{
                [weakSelf imageClick:i - 1];
            }];
            if (i != 1 && i % 2 == 0) {
                x = 0;
                y = y + kFImgSize + kFImgMargin;
            } else {
                x = x + kFImgSize + kFImgMargin;
            }
        }
    } else {
        for (int i = 1; i < arr.count + 1; i ++) {
            NSString *url = arr[i-1];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.clipsToBounds = YES;
            imageView.contentMode =  UIViewContentModeScaleAspectFill;
            [imageView sd_setImageWithURL:kURL(url) placeholderImage:kDefaultPlaceHolderImg];
            [_imgSuperView addSubview:imageView];
            imageView.userInteractionEnabled = YES;
            [imageView bk_whenTapped:^{
                [weakSelf imageClick:i-1];
            }];
            imageView.frame = CGRectMake(x, y, kFImgSize, kFImgSize);
            if (i != 1 && i % 3 == 0) {
                x = 0;
                y = y + kFImgSize + kFImgMargin;
            } else {
                x = x + kFImgSize + kFImgMargin;
            }
        }
    }
}

- (void)restSingleImgSize:(UIImage *)image {
  CGFloat imgMaxHeight = kFImgSize * 2.2;
  CGFloat imgMaxWidth = kFImgSize * 2.2;
  float imgWHRatio = imgMaxWidth / imgMaxHeight;
  float netImgWHRatio = image.size.width / image.size.height;
  if (netImgWHRatio > 0.95 && netImgWHRatio < 1.05) {
    _model.singleImgWidth = 150;
    _model.singleImgheight = 150;
    return;
  }
  
  if (netImgWHRatio >= imgWHRatio) { // 宽高比超过最大限制图片比例 以宽度作为定边
    _model.singleImgheight = imgMaxWidth / netImgWHRatio;
    _model.singleImgWidth = imgMaxWidth;
  } else {
    _model.singleImgheight = imgMaxHeight;
    _model.singleImgWidth = imgMaxHeight * netImgWHRatio;
  }
}

@end
