/*******************************************************************************
 # File        : XKCommentCommonCell.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/11
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKCommentCommonCell.h"
#import "XKCommentBaseInfo.h"

#define kImgViewTotalWidth  (SCREEN_WIDTH - 10 * 2 - 15 - 46 - 15 - 15)
#define kLabelWidth  35
#define kImgContentWidth  (kImgViewTotalWidth - 35)
#define kMargin  10
#define kImgHeight ((kImgContentWidth - 3 * kMargin) / 3)

@interface XKCommentCommonCell ()

/**内容视图*/
@property(nonatomic, strong) UIView *diySuperView;
/**分割线*/
@property(nonatomic, strong) UIView *btmLine;
/**图片父视图*/
@property(nonatomic, strong) UIView *imgsSuperView;
/**展开收起*/
@property(nonatomic, strong) UILabel *foldBtnLabel;

@end

@implementation XKCommentCommonCell

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
    __weak typeof(self) weakSelf = self;
    self.contentView.backgroundColor = HEX_RGB(0xF6F6F6);
    _containView = [[UIView alloc] init];
    _containView.xk_openClip = YES;
    _containView.xk_radius = 6;
    _containView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_containView];
    /**头像*/
    _headImageView = [[UIImageView alloc] init];
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.containView addSubview:_headImageView];
    _headImageView.userInteractionEnabled = YES;
    [_headImageView bk_whenTapped:^{
        [weakSelf headImgClick];
    }];
    /**名字*/
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = HEX_RGB(0x222222);
    _nameLabel.font = XKRegularFont(14);
    [self.containView addSubview:_nameLabel];
    /**时间*/
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = HEX_RGB(0x999999);
    _timeLabel.font = XKRegularFont(10);
    [self.containView addSubview:_timeLabel];
    /**评论内容*/
    _desLabel = [[UILabel alloc] init];
    _desLabel.font = XKRegularFont(12);
    _desLabel.textColor = HEX_RGB(0x777777);
    _desLabel.numberOfLines = 3;
    [self.containView addSubview:_desLabel];
    
    _imgsSuperView = [[UIView alloc] init];
    [self.containView addSubview:_imgsSuperView];
    /**内容视图*/
    _diySuperView = [[UIView alloc] init];
    _diySuperView.backgroundColor = HEX_RGB(0xF8F8F8);
    _diySuperView.layer.cornerRadius = 6;
    _diySuperView.layer.masksToBounds = YES;
    [self.containView addSubview:_diySuperView];
}

#pragma mark - 布局界面
- (void)createSuperConstraints {

    [_containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    /**头像*/
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containView.mas_top).offset(20);
        make.left.equalTo(self.containView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(46,46));
    }];
    _headImageView.layer.cornerRadius = 46 / 2;
    _headImageView.layer.masksToBounds = YES;
    /**名字*/
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(15);
        make.right.equalTo(self.containView.mas_right).offset(-20);
        make.top.equalTo(self.headImageView.mas_top).offset(-1);
    }];

    /**时间*/
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom);
    }];;
    /**评论内容*/
    [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.headImageView.mas_bottom).offset(-3);
        make.right.equalTo(self.containView.mas_right).offset(-15);
    }];
    

    [_imgsSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.desLabel.mas_bottom).priority(300);
        make.left.equalTo(self.desLabel);
        make.width.equalTo(self.desLabel);
        make.height.mas_equalTo(0);
    }];
    _imgsSuperView.clipsToBounds = YES;
    __weak typeof(self) weakSelf = self;
    self.foldBtnLabel = [[UILabel alloc] init];
    self.foldBtnLabel.textColor = XKMainTypeColor;
    self.foldBtnLabel.font = XKRegularFont(11);
    self.foldBtnLabel.userInteractionEnabled = YES;
    self.foldBtnLabel.hidden = YES;
    [self.foldBtnLabel bk_whenTapped:^{
        EXECUTE_BLOCK(weakSelf.foldClick,weakSelf.indexPath);
    }];
    [_imgsSuperView addSubview:self.foldBtnLabel];
    [self.foldBtnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.imgsSuperView);
        make.right.equalTo(self.imgsSuperView.mas_right).offset(-5);
        make.height.equalTo(@13);
    }];
    
    self.btmLine = [UIView new];
    [self.containView addSubview:self.btmLine];
    self.btmLine.backgroundColor = HEX_RGB(0xF6F6F6);
    [self.btmLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.containView);
        make.height.equalTo(@1);
    }];
}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)setDiyView:(UIView *)view {
    _diyView = view;
    if (view == nil) {
        /**内容视图*/
        [_diySuperView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgsSuperView.mas_bottom).offset(8);
            make.left.equalTo(self.desLabel);
            make.width.equalTo(self.desLabel);
            make.height.mas_equalTo(0);
            make.bottom.equalTo(self.containView.mas_bottom).offset(-15);
        }];
    } else {
        [_diySuperView addSubview:view];
        [view bk_whenTapped:^{
            EXECUTE_BLOCK(self.diyViewClick, self.indexPath);
        }];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.diySuperView);
        }];
        [_diySuperView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgsSuperView.mas_bottom).offset(8);
            make.left.equalTo(self.desLabel);
            make.width.equalTo(self.desLabel);
            make.bottom.equalTo(self.containView.mas_bottom).offset(-15);
        }];
    }
}

- (void)setImgsShowAllStatus:(BOOL)imgsShowAllStatus {
    _imgsShowAllStatus = imgsShowAllStatus; // 展示所有
    if (imgsShowAllStatus) { // 展示
//        [_foldBtnLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
//            confer.text(@"收起");
//        }];

    } else {
        [_foldBtnLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(@"展开");
            confer.appendImage(IMG_NAME(@"xk_btn_mine_arrow_down"));
        }];
    }
}

- (void)setImgsArray:(NSArray *)imgsArray {
    __weak typeof(self) weakSelf = self;
    _imgsArray = imgsArray;
    if (imgsArray.count != 0) {
        [_imgsSuperView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIImageView class]]) {
               [obj removeFromSuperview];
            }
        }];
        if (!self.imgsShowAllStatus) {
            [_imgsSuperView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(kMargin + kImgHeight);
            }];
            CGFloat y = kMargin;
            for (int i = 0; i < MIN(3, imgsArray.count); i ++) {
                XKMediaInfo *media = imgsArray[i];
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.layer.masksToBounds = YES;
                imageView.layer.cornerRadius = 3;
                [imageView sd_setImageWithURL:kURL(media.mainPic) placeholderImage:kDefaultPlaceHolderImg];
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
                XKMediaInfo *media = imgsArray[i - 1];
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
    } else {
        [_imgsSuperView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
}

#pragma mark - 图片点击
- (void)imageClick:(NSInteger)imgIndex {
    XKMediaInfo *info = _imgsArray[imgIndex];
    
    if (info.isPic == NO) {
        [XKGlobleCommonTool playVideoWithUrlStr:info.url];
    } else {
        XKMediaInfo *currentInfo = _imgsArray[imgIndex];
        NSMutableArray *imgArr = @[].mutableCopy;
        for (XKMediaInfo *info in _imgsArray) {
            if (info.isPic) {
                [imgArr addObject:info.mainPic];
            }
        }
        NSInteger newIndex = [imgArr indexOfObject:currentInfo.mainPic];
        [XKGlobleCommonTool showBigImgWithImgsArr:imgArr defualtIndex:newIndex viewController:self.getCurrentUIVC];
    }
}

#pragma mark - 头像点击
- (void)headImgClick {
    [XKGlobleCommonTool jumpUserInfoCenter:self.userId vc:self.getCurrentUIVC];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.containView setNeedsLayout];
    [self.containView layoutIfNeeded];
    if (self.imgsShowAllStatus == NO && self.imgsArray.count > 3) {
        self.foldBtnLabel.hidden = NO;
    } else {
        self.foldBtnLabel.hidden = YES;
    }
}

/**隐藏分割线*/
- (void)setHideSeperate:(BOOL)hideSeperate {
    self.btmLine.hidden = hideSeperate;
}

- (void)addPlayBtn:(UIImageView *)imageView {
    UIButton *playBtn = [[UIButton alloc] init];
    [playBtn setBackgroundImage:IMG_NAME(@"xk_ic_middlePlay") forState:UIControlStateNormal];
    [imageView addSubview:playBtn];
    playBtn.userInteractionEnabled = NO;
    [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(imageView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

@end
