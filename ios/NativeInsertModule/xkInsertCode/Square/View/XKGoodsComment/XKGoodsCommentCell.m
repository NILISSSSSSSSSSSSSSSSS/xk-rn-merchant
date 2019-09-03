/*******************************************************************************
 # File        : XKGoodsCommentCell.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/18
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKGoodsCommentCell.h"

#define kImgViewTotalWidth  (SCREEN_WIDTH - 2 *self.cellMargin - 60 - 15  * 2 )
#define kLabelWidth  35
#define kImgContentWidth  (kImgViewTotalWidth - 25)
#define kMargin  8
#define kImgHeight ((kImgContentWidth - 3 * kMargin) / 3)

@interface XKGoodsCommentCell ()

/**分割线*/
@property(nonatomic, strong) UIView *btmLine;
/**图片父视图*/
@property(nonatomic, strong) UIView *imgsSuperView;
/**展开收起*/
@property(nonatomic, strong) UILabel *foldBtnLabel;

/**图片数目*/
@property(nonatomic, strong) NSArray <XKMediaInfoModel *>*imgsArray;

@end

@implementation XKGoodsCommentCell

#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 初始化默认数据
        [self createSuperDefaultData];
        // 初始化界面
        [self createSuperUI];
        // 布局界面
        [self createSuperConstraints];
        
        
    }
    return self;
}

#pragma mark - 初始化默认数据
- (void)createSuperDefaultData {
    
}

#pragma mark - 初始化界面
- (void)createSuperUI {
    self.contentView.backgroundColor = HEX_RGB(0xF6F6F6);
    _containView = [[UIView alloc] init];
    _containView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_containView];
    /**头像*/
    _headImageView = [[UIImageView alloc] init];
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.containView addSubview:_headImageView];
    _headImageView.userInteractionEnabled = YES;
    [_headImageView bk_whenTapped:^{
        if (self.userId && self.userId.length) {
            [XKGlobleCommonTool jumpUserInfoCenter:self.userId vc:nil];
        }
    }];
    /**名字*/
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = XKMainTypeColor;
    _nameLabel.font = XKRegularFont(14);
    [self.containView addSubview:_nameLabel];
    /**时间*/
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = HEX_RGB(0x999999);
    _timeLabel.font = XKRegularFont(12);
    [self.containView addSubview:_timeLabel];
    /**评论内容*/
    _desLabel = [[UILabel alloc] init];
    _desLabel.font = XKRegularFont(12);
    _desLabel.textColor = HEX_RGB(0x222222);
    _desLabel.numberOfLines = 3;
    [self.containView addSubview:_desLabel];
    
    _imgsSuperView = [[UIView alloc] init];
    [self.containView addSubview:_imgsSuperView];
}

#pragma mark - 布局界面
- (void)createSuperConstraints {
    
    [_containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    /**头像*/
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containView.mas_top).offset(20);
        make.left.equalTo(self.containView.mas_left).offset(9);
        make.size.mas_equalTo(CGSizeMake(46,46));
    }];
    _headImageView.layer.cornerRadius = 5;
    _headImageView.layer.masksToBounds = YES;
    /**名字*/
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(11);
        make.right.equalTo(self.containView.mas_right).offset(-20);
        make.top.equalTo(self.headImageView.mas_top).offset(1);
    }];
    
    /**时间*/
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.bottom.equalTo(self.headImageView.mas_bottom).offset(-2);
    }];;
    /**评论内容*/
    [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.headImageView.mas_bottom).offset(11);
        make.right.equalTo(self.containView.mas_right).offset(-15);
    }];
    
    [_imgsSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.desLabel.mas_bottom).priority(300);
        make.left.equalTo(self.desLabel);
        make.width.equalTo(self.desLabel);
        make.height.mas_equalTo(0);
        make.bottom.equalTo(self.containView.mas_bottom).offset(-15);
    }];
    
    _imgsSuperView.clipsToBounds = YES;
    __weak typeof(self) weakSelf = self;
    self.foldBtnLabel = [[UILabel alloc] init];
    self.foldBtnLabel.textColor = XKMainTypeColor;
    self.foldBtnLabel.font = XKRegularFont(11);
    self.foldBtnLabel.userInteractionEnabled = YES;
    self.foldBtnLabel.hidden = YES;
    [self.foldBtnLabel bk_whenTapped:^{
        weakSelf.model.showAllImg = !weakSelf.model.showAllImg;
        weakSelf.refreshBlock(weakSelf.indexPath);
    }];
    [_imgsSuperView addSubview:self.foldBtnLabel];
    [self.foldBtnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.imgsSuperView);
        make.right.equalTo(self.imgsSuperView.mas_right).offset(0);
        make.height.equalTo(@15);
    }];
    
    self.btmLine = [UIView new];
    [self.containView addSubview:self.btmLine];
    self.btmLine.backgroundColor = HEX_RGB(0xF6F6F6);
    [self.btmLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.containView);
        make.height.equalTo(@1);
    }];
}

- (void)setImgsShowAllStatus:(BOOL)imgsShowAllStatus {
    _imgsShowAllStatus = imgsShowAllStatus; // 展示所有
    if (imgsShowAllStatus) { // 展示
        [_foldBtnLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(@"收起");
        }];
        
    } else {
        [_foldBtnLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(@"展开");
//            confer.appendImage(IMG_NAME(@"xk_btn_mine_arrow_down"));
        }];
    }
}

- (void)setShowOperationBtn:(BOOL)showOperationBtn {
    _showOperationBtn = showOperationBtn;
    self.operationBtn.hidden = !showOperationBtn;
    [_imgsSuperView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.containView.mas_bottom).offset(showOperationBtn ? -50 : -15);
    }];
}

- (UIButton *)operationBtn {
    if (!_operationBtn) {
        __weak typeof(self) weakSelf = self;
        _operationBtn = [[UIButton alloc] init];
        [self.containView addSubview:_operationBtn];
        [_operationBtn setTitleColor:HEX_RGB(0x444444) forState:UIControlStateNormal];
        _operationBtn.titleLabel.font = XKNormalFont(13);
        [_operationBtn setImage:IMG_NAME(@"xk_btn_home_comment") forState:UIControlStateNormal];
        [_operationBtn setTitle:@" 评论" forState:UIControlStateNormal];
        [_operationBtn sizeToFit];
        [_operationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.containView.mas_bottom).offset(-9);
            make.right.equalTo(self.containView.mas_right).offset(-8);
            make.size.mas_equalTo(CGSizeMake(self->_operationBtn.width + 5, self->_operationBtn.height));
        }];
        [_operationBtn bk_addEventHandler:^(id sender) {
            EXECUTE_BLOCK(weakSelf.operationBtnClick,weakSelf.indexPath);
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _operationBtn;
}

- (void)setModel:(XKWithImgBaseModel *)model {
    _model = model;
    if (model.imgsArray.count == 1 && model.singleImgWidth == 0) {
        model.singleImgWidth = kImgHeight;
        model.singleImgheight = kImgHeight;
        XKMediaInfoModel *media = model.imgsArray.firstObject;
        UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:media.mainPic];
        if (cacheImage) {
            [self restSingleImgSize:cacheImage];
        }
    }
    [self setImgsShowAllStatus:model.showAllImg];
    self.imgsArray = model.imgsArray;
}

- (void)setImgsArray:(NSArray <XKMediaInfoModel *>*)imgsArray {
    _imgsArray = imgsArray;
    __weak typeof(self) weakSelf = self;
    if (imgsArray.count != 0) {
        
        [_imgsSuperView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                [obj removeFromSuperview];
            }
        }];
        if (imgsArray.count == 1) { // 处理单张图的大小
            XKMediaInfoModel *media = imgsArray.firstObject;
            CGFloat y = kMargin + 5;
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.clipsToBounds = YES;
            imageView.contentMode =  UIViewContentModeScaleAspectFill;
            [imageView sd_setImageWithURL:[NSURL URLWithString:media.mainPic] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (!error) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                        if (self.model.singleImgWidth == kImgHeight && self.model.singleImgheight == kImgHeight) {
                            [self restSingleImgSize:image];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                EXECUTE_BLOCK(self.refreshBlock,self.indexPath);
                            });
                        }
                    });
                }
            }];
            [_imgsSuperView addSubview:imageView];
            imageView.frame = CGRectMake(0, y, self.model.singleImgWidth, self.model.singleImgheight);
            [_imgsSuperView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self.model.singleImgheight + y);
            }];
            if (media.isPic == NO) {
                [self addPlayBtn:imageView];
            }
            imageView.userInteractionEnabled = YES;
            [imageView bk_whenTapped:^{
                [weakSelf imageClick:0];
            }];
        } else {
        if (!self.imgsShowAllStatus) {
            [_imgsSuperView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(kMargin + kImgHeight);
            }];
            CGFloat y = kMargin;
            for (int i = 0; i < MIN(3, imgsArray.count); i ++) {
                XKMediaInfoModel *media = imgsArray[i];
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.layer.masksToBounds = YES;
                imageView.layer.cornerRadius = 3;
                [imageView sd_setImageWithURL:[NSURL URLWithString:media.mainPic] placeholderImage:kDefaultPlaceHolderImg];
                imageView.frame = CGRectMake(i * (kImgHeight + kMargin), y, kImgHeight, kImgHeight);
                [_imgsSuperView addSubview:imageView];
                if (media.isPic == NO) {
                    [self addPlayBtn:imageView];
                }
                imageView.userInteractionEnabled = YES;
                [imageView bk_whenTapped:^{
                    [weakSelf imageClick:i];
                }];
            }
        } else {
            CGFloat x = 0;
            CGFloat y = kMargin;
            UIImageView *lastImg;
            for (int i = 1; i <= imgsArray.count; i ++) {
                XKMediaInfoModel *media = imgsArray[i - 1];
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.layer.masksToBounds = YES;
                imageView.layer.cornerRadius = 3;
                [imageView sd_setImageWithURL:[NSURL URLWithString:media.mainPic] placeholderImage:kDefaultPlaceHolderImg];
                imageView.frame = CGRectMake(x, y, kImgHeight, kImgHeight);
                [_imgsSuperView addSubview:imageView];
                if (i % 3 == 0) {
                    y = y + kImgHeight + kMargin;
                    x = 0;
                } else {
                    x = x + kImgHeight + kMargin;
                }
                lastImg = imageView;
                if (media.isPic == NO) {
                    [self addPlayBtn:imageView];
                }
                imageView.userInteractionEnabled = YES;
                [imageView bk_whenTapped:^{
                    [weakSelf imageClick:i - 1];
                }];
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

- (void)restSingleImgSize:(UIImage *)image {
    CGFloat imgMaxHeight = kImgHeight * 2.2;
    CGFloat imgMaxWidth = kImgHeight * 2.2;
    float imgWHRatio = imgMaxWidth / imgMaxHeight;
    float netImgWHRatio = image.size.width / image.size.height;
    if (netImgWHRatio >= imgWHRatio) { // 宽高比超过最大限制图片比例 以宽度作为定边
        _model.singleImgheight = imgMaxWidth / netImgWHRatio;
        _model.singleImgWidth = imgMaxWidth;
    } else {
        _model.singleImgheight = imgMaxHeight;
        _model.singleImgWidth = imgMaxHeight * netImgWHRatio;
    }
}

- (void)addPlayBtn:(UIImageView *)imageView {
    UIButton *playBtn = [[UIButton alloc] init];
    [playBtn setBackgroundImage:IMG_NAME(@"xk_ic_middlePlay") forState:UIControlStateNormal];
    [imageView addSubview:playBtn];
    playBtn.userInteractionEnabled = NO;
    [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(imageView);
        make.size.mas_equalTo(CGSizeMake(XKViewSize(25), XKViewSize(25)));
    }];
}

#pragma mark - 图片点击
- (void)imageClick:(NSInteger)imgIndex {
    XKMediaInfoModel *info = _imgsArray[imgIndex];
    
    if (info.isPic == NO) {
        [XKGlobleCommonTool playVideoWithUrlStr:info.url];
    } else {
        XKMediaInfoModel *currentInfo = _imgsArray[imgIndex];
        NSMutableArray *imgArr = @[].mutableCopy;
        for (XKMediaInfoModel *info in _imgsArray) {
            if (info.isPic) {
                [imgArr addObject:info.mainPic];
            }
        }
        NSInteger newIndex = [imgArr indexOfObject:currentInfo.mainPic];
        [XKGlobleCommonTool showBigImgWithImgsArr:imgArr defualtIndex:newIndex viewController:self.getCurrentUIVC];
    }
}



- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.imgsArray.count > 3) {
        if (self.imgsShowAllStatus == NO) {
            self.foldBtnLabel.hidden = NO;
        } else {
           self.foldBtnLabel.hidden = NO;
        }
    } else {
        self.foldBtnLabel.hidden = YES;
    }
}

/**隐藏分割线*/
- (void)setHideSeperate:(BOOL)hideSeperate {
    self.btmLine.hidden = hideSeperate;
}

@end


@implementation XKMediaInfoModel

@end
