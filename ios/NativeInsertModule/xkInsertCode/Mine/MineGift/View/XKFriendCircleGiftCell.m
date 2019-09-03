/*******************************************************************************
 # File        : XKFriendCircleGiftCell.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/13
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKFriendCircleGiftCell.h"

#define kImgViewTotalWidth  (SCREEN_WIDTH - 10 * 2 - 15 - 46 - 15 - 10 - 29 - 10 - 15)
#define kLabelWidth  25
#define kImgContentWidth  (kImgViewTotalWidth - kLabelWidth - 20)
#define kMargin  5
#define kImgHeight ((kImgContentWidth - 3 * kMargin) / 3)

@interface XKFriendCircleGiftCell ()
/**containView*/
@property(nonatomic, strong) UIView *infoView;
/***/
/**图片父视图*/
@property(nonatomic, strong) UIView *imgsSuperView;
/**展开收起*/
@property(nonatomic, strong) UILabel *foldBtnLabel;

/**图片数目*/
@property(nonatomic, copy) NSArray *imgsArray;
/**是否折叠  0 折叠*/
@property(nonatomic, assign) BOOL imgsShowAllStatus;
@end

@implementation XKFriendCircleGiftCell

#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    _infoView = [[UIView alloc] init];
    _infoView.backgroundColor = HEX_RGB(0xF8F8F8);
    _infoView.layer.cornerRadius = 6;
    _infoView.clipsToBounds = YES;
    [self.containView addSubview:_infoView];
    /**头像*/
    _infoHeadImageView = [[UIImageView alloc] init];
    _infoHeadImageView.contentMode = UIViewContentModeScaleAspectFill;
    _infoHeadImageView.clipsToBounds = YES;
    _infoHeadImageView.layer.cornerRadius = 4;
    [_infoView addSubview:_infoHeadImageView];
    /**名字*/
    _infoNamelabel = [[UILabel alloc] init];
    _infoNamelabel.textColor = HEX_RGB(0x222222);
    _infoNamelabel.font = XKRegularFont(12);
    [_infoView addSubview:_infoNamelabel];
    /**评论内容*/
    _infoDesLabel = [[UILabel alloc] init];
    _infoDesLabel.font = XKRegularFont(10);
    _infoDesLabel.textColor = HEX_RGB(0x777777);
    _infoDesLabel.numberOfLines = 3;
    [_infoView addSubview:_infoDesLabel];
    
    __weak typeof(self) weakSelf = self;
    self.foldBtnLabel = [[UILabel alloc] init];
    self.foldBtnLabel.textColor = XKMainTypeColor;
    self.foldBtnLabel.font = XKRegularFont(11);
    self.foldBtnLabel.userInteractionEnabled = YES;
    self.foldBtnLabel.hidden = YES;
    [self.foldBtnLabel bk_whenTapped:^{
        EXECUTE_BLOCK(weakSelf.foldClick,weakSelf.indexPath);
    }];
    
    _imgsSuperView = [[UIView alloc] init];
    [self.containView addSubview:_imgsSuperView];
    
    self.headImageView.userInteractionEnabled = YES;
    [self.headImageView bk_whenTapped:^{
        [XKGlobleCommonTool jumpUserInfoCenter:weakSelf.topUser vc:nil];
    }];
    self.infoHeadImageView.userInteractionEnabled = YES;
    [self.infoHeadImageView bk_whenTapped:^{
        [XKGlobleCommonTool jumpUserInfoCenter:weakSelf.btmUser vc:nil];
    }];
    
    [self.infoView bk_whenTapped:^{
        EXECUTE_BLOCK(weakSelf.infoClick,weakSelf.indexPath);
    }];
}

#pragma mark - 布局界面
- (void)createConstraints {
    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.mas_bottom).offset(16);
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.equalTo(self.containView.mas_right).offset(-15);
        make.bottom.equalTo(self.containView.mas_bottom).offset(-15);
    }];
    
    [_infoHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView.mas_top).offset(10);
        make.left.equalTo(self.infoView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(29, 29));
    }];
    
    [_infoNamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoHeadImageView.mas_top).offset(2);
        make.left.equalTo(self.infoHeadImageView.mas_right).offset(9);
        make.right.equalTo(self.infoView.mas_right).offset(-10);
    }];
    
    [_infoDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoNamelabel);
        make.width.equalTo(self.infoNamelabel);
        make.top.equalTo(self.infoNamelabel.mas_bottom).offset(5);
    }];
    
    [_imgsSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoDesLabel.mas_bottom).priority(500);
        make.left.equalTo(self.infoDesLabel);
        make.width.equalTo(self.infoDesLabel);
        make.height.mas_equalTo(0);
        make.bottom.equalTo(self.infoView.mas_bottom).offset(-15);
    }];
    _imgsSuperView.clipsToBounds = YES;
    
    [_imgsSuperView addSubview:self.foldBtnLabel];
    [self.foldBtnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.imgsSuperView.mas_bottom);
        make.right.equalTo(self.imgsSuperView.mas_right).offset(0);
        make.height.equalTo(@17);
        make.width.mas_equalTo(30 * ScreenScale);
    }];
    
    [self setImgsShowAllStatus:NO];

}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)setImgsShowAllStatus:(BOOL)imgsShowAllStatus {
    _imgsShowAllStatus = imgsShowAllStatus; // 展示所有
    if (imgsShowAllStatus) { // 展示
        //        [_foldBtnLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        //            confer.text(@"收起");
        //        }];
        
    } else {
        [_foldBtnLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(@"展开");
        }];
    }
}

- (void)setImgControlModel:(XKWithImgBaseModel *)imgControlModel {
    _imgControlModel = imgControlModel;
    if (imgControlModel.imgsArray.count == 1 && imgControlModel.singleImgWidth == 0) {
        imgControlModel.singleImgWidth = kImgHeight;
        imgControlModel.singleImgheight = kImgHeight;
        UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:imgControlModel.imgsArray.firstObject];
        if (cacheImage) {
            [self restSingleImgSize:cacheImage];
        }
    }
    [self setImgsShowAllStatus:imgControlModel.showAllImg];
    [self setImgsArray:imgControlModel.imgsArray];
}


- (void)setImgsArray:(NSArray *)imgsArray {
    
    _imgsArray = imgsArray;
    if (imgsArray.count != 0) {
        
        [_imgsSuperView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                [obj removeFromSuperview];
            }
        }];
        CGFloat y = kMargin + 5;
        if (imgsArray.count == 1) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.clipsToBounds = YES;
            imageView.contentMode =  UIViewContentModeScaleAspectFill;
            [imageView sd_setImageWithURL:[NSURL URLWithString:imgsArray.firstObject] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (!error) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                        if (self.imgControlModel.singleImgWidth == kImgHeight && self.imgControlModel.singleImgheight == kImgHeight) {
                            [self restSingleImgSize:image];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                EXECUTE_BLOCK(self.refreshBlock,self.indexPath);
                            });
                        }
                    });
                }
            }];
            [_imgsSuperView addSubview:imageView];
            if ([self isVideo]) {
                [self addPlayBtn:imageView];
            } else {
//                [self addPlayBtn:imageView];
            }
            imageView.frame = CGRectMake(0, y, self.imgControlModel.singleImgWidth, self.imgControlModel.singleImgheight);
            [_imgsSuperView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self.imgControlModel.singleImgheight + y);
            }];
        } else {
            if (!self.imgsShowAllStatus) {
                
                [_imgsSuperView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(kMargin + 5 + kImgHeight);
                }];
                for (int i = 0; i < MIN(3, imgsArray.count); i ++) {
                    UIImageView *imageView = [[UIImageView alloc] init];
                    imageView.contentMode = UIViewContentModeScaleAspectFill;
                    imageView.layer.masksToBounds = YES;
                    imageView.layer.cornerRadius = 3;
                    [imageView sd_setImageWithURL:[NSURL URLWithString:imgsArray[i]] placeholderImage:kDefaultPlaceHolderImg];
                    imageView.frame = CGRectMake(i * (kImgHeight + kMargin), y, kImgHeight, kImgHeight);
                    [_imgsSuperView addSubview:imageView];
                }
            } else {
                CGFloat x = 0;
                CGFloat y = kMargin + 5;
                UIImageView *lastImg;
                for (int i = 1; i <= imgsArray.count; i ++) {
                    UIImageView *imageView = [[UIImageView alloc] init];
                    imageView.contentMode = UIViewContentModeScaleAspectFill;
                    imageView.layer.masksToBounds = YES;
                    imageView.layer.cornerRadius = 3;
                    [imageView sd_setImageWithURL:[NSURL URLWithString:imgsArray[i - 1]] placeholderImage:kDefaultPlaceHolderImg];
                    imageView.frame = CGRectMake(x, y, kImgHeight, kImgHeight);
                    [_imgsSuperView addSubview:imageView];
                    if (i % 3 == 0) {
                        y = y + kImgHeight + kMargin;
                        x = 0;
                    } else {
                        x = x + kImgHeight + kMargin;
                    }
                    lastImg = imageView;
                }
                [_imgsSuperView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(lastImg.bottom);
                }];
            }
            
        }
    } else {
        [_imgsSuperView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
}

- (void)addPlayBtn:(UIImageView *)imageView {
    UIButton *playBtn = [[UIButton alloc] init];
    [playBtn setBackgroundImage:IMG_NAME(@"xk_ic_middlePlay") forState:UIControlStateNormal];
    [imageView addSubview:playBtn];
    playBtn.userInteractionEnabled = NO;
    [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(imageView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void)restSingleImgSize:(UIImage *)image {
    CGFloat imgMaxHeight = kImgHeight * 2.2;
    CGFloat imgMaxWidth = kImgHeight * 2.2;
    float imgWHRatio = imgMaxWidth / imgMaxHeight;
    float netImgWHRatio = image.size.width / image.size.height;
    if (netImgWHRatio >= imgWHRatio) { // 宽高比超过最大限制图片比例 以宽度作为定边
        _imgControlModel.singleImgheight = imgMaxWidth / netImgWHRatio;
        _imgControlModel.singleImgWidth = imgMaxWidth;
    } else {
        _imgControlModel.singleImgheight = imgMaxHeight;
        _imgControlModel.singleImgWidth = imgMaxHeight * netImgWHRatio;
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.imgsShowAllStatus == NO && self.imgsArray.count > 3) {
        self.foldBtnLabel.hidden = NO;
    } else {
        self.foldBtnLabel.hidden = YES;
    }
}

@end
