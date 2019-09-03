/*******************************************************************************
 # File        : XKCommentDetailInfoCell.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/12
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKCommentDetailInfoCell.h"
#import "XKCommonStarView.h"
#import "UIView+Border.h"
#import "XKGoodsView.h"
#import "XKCommentBaseInfo.h"

#define kImgViewTotalWidth  (SCREEN_WIDTH - 10 * 2 - 15 - 46 - 15 - 30)
#define kMargin  10
#define kImgHeight ((kImgViewTotalWidth - 3 * kMargin) / 3)

@interface XKCommentDetailInfoCell ()
/**starSuperView*/
@property(nonatomic, strong) UIView *starSuperView;
/**<##>*/
@property(nonatomic, strong) XKCommonStarView *starView;
/**商家回复view*/
@property(nonatomic, strong) UIView *shopCommentView;
/**图片父视图*/
@property(nonatomic, strong) UIView *imgsSuperView;
/**掌柜回复*/
@property(nonatomic, strong) UILabel *shopCommentLabel;
@property(nonatomic, strong) UIImageView *shopCommentImgView;
// 商家回复视图高度约束
/***/
@property(nonatomic, strong) MASConstraint *shopCommentHeightCons;

@end

@implementation XKCommentDetailInfoCell

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
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
    /**头像*/
    _headImageView = [[UIImageView alloc] init];
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_headImageView];
    /**名字*/
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = HEX_RGB(0x222222);
    _nameLabel.font = XKRegularFont(14);
    [self.contentView addSubview:_nameLabel];
    /**时间*/
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = HEX_RGB(0x999999);
    _timeLabel.font = XKRegularFont(10);
    [self.contentView addSubview:_timeLabel];
    
    _starSuperView = [[UIView alloc] init];
    [self.contentView addSubview:_starSuperView];
    
    UILabel *starLabel = [[UILabel alloc] init];
    starLabel.text = @"评分项";
    starLabel.textColor =  HEX_RGB(0x222222);
    starLabel.font = [UIFont systemFontOfSize:12];
    starLabel.frame = CGRectMake(0, 0, 38, 18);
    [_starSuperView addSubview:starLabel];
    _starView = [[XKCommonStarView alloc] initWithFrame:CGRectMake(starLabel.right + 8, 1, 130, 14) numberOfStars:5];
    _starView.userInteractionEnabled = NO;
    _starView.scorePercent = 0;
    [_starSuperView addSubview:_starView];
    
    
    /**评论内容*/
    _desLabel = [[UILabel alloc] init];
    _desLabel.font = XKRegularFont(12);
    _desLabel.textColor = HEX_RGB(0x777777);
    _desLabel.numberOfLines = 4;
    [self.contentView addSubview:_desLabel];
    
    _imgsSuperView = [[UIView alloc] init];
    [self.contentView addSubview:_imgsSuperView];
    
    /**商家回复视图*/
    _shopCommentView = [[UIView alloc] init];
    _shopCommentView.clipsToBounds = YES;
    [self.contentView addSubview:_shopCommentView];
    // 背景图片
    _shopCommentImgView = [[UIImageView alloc] init];
    UIImage *img = [[UIImage imageNamed:@"xk_ic_comment_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(40, 100, 20, 20) resizingMode:UIImageResizingModeStretch];
    _shopCommentImgView.image = img;
    [_shopCommentView addSubview:_shopCommentImgView];
    
    _shopCommentLabel = [[UILabel alloc] init];
    _shopCommentLabel.userInteractionEnabled = YES;
    _shopCommentLabel.numberOfLines = 0;
    _shopCommentLabel.textColor = RGBGRAY(51);
    _shopCommentLabel.font = XKRegularFont(12);
    [_shopCommentView addSubview:_shopCommentLabel];
    
    
    self.infoView = [[XKGoodsView alloc] init];
    self.infoView.nameLabel.font = XKRegularFont(12);
    self.infoView.infoLabel.font = XKRegularFont(12);
    self.infoView.backgroundColor = HEX_RGB(0xF8F8F8);
    self.infoView.layer.cornerRadius = 6;
    self.infoView.layer.masksToBounds = YES;
}

#pragma mark - 布局界面
- (void)createConstraints {
//    __weak typeof(self) weakSelf = self;
    /**头像*/
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(46 , 46));
    }];
    _headImageView.layer.cornerRadius = 46 / 2;
    _headImageView.layer.masksToBounds = YES;
    /**名字*/
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.top.equalTo(self.headImageView.mas_top).offset(-1);
    }];
    
    /**时间*/
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom);
    }];;

    [_starSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.headImageView.mas_bottom).offset(-3);
        make.width.equalTo(self.desLabel);
        make.height.equalTo(@17);
    }];
    
    /**评论内容*/
    [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.starSuperView.mas_bottom).offset(8);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
    }];
    
    [_imgsSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.desLabel.mas_bottom).priority(500);
        make.left.equalTo(self.desLabel);
        make.width.equalTo(self.desLabel);
    }];
    
    [self.shopCommentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgsSuperView.mas_bottom);
        make.left.right.equalTo(self.desLabel);
        self.shopCommentHeightCons = make.height.mas_equalTo(0);;
    }];
    [self.shopCommentHeightCons deactivate];
    
    [self.shopCommentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopCommentView.mas_left);
        make.right.equalTo(self.shopCommentView.mas_right);
        make.top.equalTo(self.shopCommentView.mas_top).offset(10).priority(200);
        make.bottom.equalTo(self.shopCommentView.mas_bottom);
    }];
    [self.shopCommentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopCommentView.mas_left).offset(10);
        make.right.equalTo(self.shopCommentView.mas_right).offset(-8);
        make.top.equalTo(self.shopCommentView.mas_top).offset(20);
        make.bottom.equalTo(self.shopCommentView.mas_bottom).offset(-8).priority(600);
    }];
    
    UIView *bottomView = [[UIView alloc] init];
    [bottomView showBorderSite:rzBorderSitePlaceTop];
    bottomView.topBorder.borderSize = 1;
    bottomView.topBorder.borderLine.backgroundColor = HEX_RGB(0xF1F1F1);
    [self.contentView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.top.equalTo(self.shopCommentView.mas_bottom).offset(10);
    }];
    [bottomView addSubview:self.infoView];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bottomView).insets(UIEdgeInsetsMake(15, 15, 15, 15));
    }];
}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)setImgsArray:(NSArray *)imgsArray {
    _imgsArray = imgsArray;
    __weak typeof(self) weakSelf = self;
    if (imgsArray.count != 0) {
        
        [_imgsSuperView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                [obj removeFromSuperview];
            }
        }];
        CGFloat x = 0;
        CGFloat y = kMargin;
        UIImageView *lastImg;
        for (int i = 1; i <= imgsArray.count; i ++) {
            XKMediaInfo *media = imgsArray[i - 1];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.masksToBounds = YES;
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
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
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
            if (info.isPic == YES) {
                [imgArr addObject:info.mainPic];
            }
        }
        NSInteger newIndex = [imgArr indexOfObject:currentInfo.mainPic];
        [XKGlobleCommonTool showBigImgWithImgsArr:imgArr defualtIndex:newIndex viewController:self.getCurrentUIVC];
    }
}

- (void)setShopComment:(NSString *)shopComment {
    _shopComment = shopComment;
    if (_shopComment.length == 0) {
        [self.shopCommentHeightCons activate];
        self.shopCommentLabel.text = nil;
    } else {
        [self.shopCommentHeightCons deactivate];
        self.shopCommentLabel.text = shopComment;
    }
}

- (void)setScore:(NSString *)score {
    _score = score;
    _starView.scorePercent = score.integerValue / 5.0;
}

- (void)hideStar {
    [_desLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.starSuperView.mas_bottom).offset(-17);
    }];
    _starSuperView.hidden = YES;
}

@end
