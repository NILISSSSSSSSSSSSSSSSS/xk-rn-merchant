/*******************************************************************************
 # File        : XKOrderEvalutionCell.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/5
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKOrderEvalutionCell.h"
#import <RZColorful.h>
#import "XKOrderEvaStarView.h"
#import "XKPickImgCell.h"
#import "XKOrderEvaModel.h"
#import "XKMediaPickHelper.h"
#import "XKBusinessAreaOrderListModel.h"
#import "XKMallOrderDetailViewModel.h"
#import "XKBusinessAreaOrderListModel.h"
#import "XKMallOrderViewModel.h"
#define kOrderVideoTime 15
#define kOrderEvaCellMargin 10
#define kOrderEvaCellPadding 15

#define kOrderItemSize (int)((SCREEN_WIDTH - 2 * kOrderEvaCellMargin - 2 * kOrderEvaCellPadding) / 4)

@interface XKOrderEvalutionCell () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextViewDelegate>
/**内容视图*/
@property(nonatomic, strong) UIView *whiteView;
/**图片*/
@property(nonatomic, strong) UIImageView *imgView;
/**商品名字*/
@property(nonatomic, strong) UILabel *nameLabel;
/**规格*/
@property(nonatomic, strong) UILabel *infoLabel;
/**评分父view*/
@property(nonatomic, strong) UIView *evalutionView;

/**评价textView*/
@property(nonatomic, strong) UITextView *textView;
/**上传的图片视频collectionView视图*/
@property(nonatomic, strong) UICollectionView *collectionView;
/**<##>*/
@property(nonatomic, strong) XKMediaPickHelper *bottomSheetView;
@end

@implementation XKOrderEvalutionCell

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
    self.contentView.backgroundColor = HEX_RGB(0xF6F6F6);
    /**内容视图*/
    _whiteView = [[UIView alloc] init];
    _whiteView.backgroundColor = [UIColor whiteColor];
    _whiteView.layer.cornerRadius = 8;
    _whiteView.layer.masksToBounds = YES;
    [_whiteView drawCommonShadowUselayer];
    [self.contentView addSubview:_whiteView];
    /**图片*/
    _imgView = [[UIImageView alloc] init];
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
    _imgView.layer.cornerRadius = 10;
    _imgView.layer.borderColor = HEX_RGB(0xE7E7E7).CGColor;
    _imgView.layer.borderWidth = 1;
    _imgView.layer.masksToBounds = YES;
    [_whiteView addSubview:_imgView];
    /**商品名字*/
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = XKRegularFont(12);
    _nameLabel.numberOfLines = 0;
    _nameLabel.textColor = HEX_RGB(0x222222);
    [_whiteView addSubview:_nameLabel];
    /**规格*/
    _infoLabel = [[UILabel alloc] init];
    _infoLabel.numberOfLines = 0;
    _infoLabel.textColor = HEX_RGB(0x999999);
    _infoLabel.font = XKRegularFont(12);
    [_whiteView addSubview:_infoLabel];
    /**评分父view*/
    _evalutionView = [[UIView alloc] init];
    [_whiteView addSubview:_evalutionView];
    /**评价textView*/
    _textView = [[UITextView alloc] init];
    _textView.layer.cornerRadius = 1;
    _textView.backgroundColor = HEX_RGB(0xF6F6F6);
    _textView.zw_placeHolder = @"评价文字至少大于5个字";
    _textView.delegate = self;
    [_whiteView addSubview:_textView];
    /**上传的图片视频collectionView视图*/
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(kOrderItemSize, kOrderItemSize);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.scrollEnabled = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[XKPickImgCell class] forCellWithReuseIdentifier:@"cell"];
    [_whiteView addSubview:_collectionView];
}

#pragma mark - 布局界面
- (void)createConstraints {
//    __weak typeof(self) weakSelf = self;
    /**内容视图*/
    [_whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(kOrderEvaCellMargin, kOrderEvaCellMargin, 0, kOrderEvaCellMargin));
    }];
    /**图片*/
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whiteView.mas_top).offset(kOrderEvaCellPadding);
        make.left.equalTo(self.whiteView.mas_left).offset(kOrderEvaCellPadding);
        make.size.mas_equalTo(CGSizeMake(80 *ScreenScale, 80*ScreenScale));
    }];;
    /**商品名字*/
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_top).offset(2);
        make.left.equalTo(self.imgView.mas_right).offset(kOrderEvaCellPadding);
        make.right.equalTo(self.whiteView.mas_right).offset(-kOrderEvaCellPadding);
    }];;
    /**规格*/
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.imgView.mas_bottom);
        make.left.equalTo(self.nameLabel);
    }];;
    /**评分父view*/
    [_evalutionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView.mas_left);
        make.top.equalTo(self.imgView.mas_bottom).offset(20);
        make.right.equalTo(self.whiteView.mas_right).offset(-kOrderEvaCellMargin);
        make.height.equalTo(@0);
    }];
    /**评价textView*/
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView);
        make.top.equalTo(self.evalutionView.mas_bottom).offset(10).priority(200);
        make.right.equalTo(self.whiteView.mas_right).offset(-kOrderEvaCellPadding);
        make.height.mas_equalTo(104*ScreenScale);
    }];
    /**上传的图片视频collectionView视图*/
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(kOrderEvaCellPadding);
        make.right.equalTo(self.whiteView.mas_right).offset(-kOrderEvaCellPadding);
        make.left.equalTo(self.whiteView.mas_left).offset(kOrderEvaCellPadding);
        make.height.mas_equalTo(kOrderItemSize);
        make.bottom.equalTo(self.whiteView.mas_bottom).offset(-kOrderEvaCellPadding);
    }];
}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)setModel:(XKOrderEvaModel *)model {
    _model = model;
    if ([model.goodsInfo isKindOfClass:[MallOrderListObj class]]) {
        MallOrderListObj *obj = model.goodsInfo;
        self.nameLabel.text = obj.goodsName;
        NSString *price = @(obj.price / 100).stringValue;
        
        [_imgView sd_setImageWithURL:[NSURL URLWithString:obj.goodsPic] placeholderImage:kDefaultPlaceHolderImg];
        _nameLabel.text = obj.goodsName;
        [_infoLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.paragraphStyle.lineSpacing(3);
            confer.text([NSString stringWithFormat:@"规格参数：%@  x%zd",obj.goodsShowAttr,obj.num]);
            confer.text(@"\n");
            confer.text(@"价格：");
            confer.text([NSString stringWithFormat:@"¥%@",price]).textColor(XKMainRedColor);
        }];
    } else if ([model.goodsInfo isKindOfClass:[XKMallOrderDetailGoodsItem class]]) {
        XKOrderDetailGoodsItem *obj = model.goodsInfo;
        self.nameLabel.text = obj.name;
        NSString *price = @(obj.platformPrice.floatValue / 100).stringValue;
        
        [_imgView sd_setImageWithURL:[NSURL URLWithString:obj.skuUrl] placeholderImage:kDefaultPlaceHolderImg];
     
        [_infoLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.paragraphStyle.lineSpacing(3);
            confer.text([NSString stringWithFormat:@"规格参数：%@  x%zd",obj.skuName,obj.purchaseNum]);
            confer.text(@"\n");
            confer.text(@"价格：");
            confer.text([NSString stringWithFormat:@"¥%@",price]).textColor(XKMainRedColor);
        }];
    } else if ([model.goodsInfo isKindOfClass:[XKMallOrderDetailGoodsItem class]]) {
        XKMallOrderDetailGoodsItem *obj = model.goodsInfo;
        self.nameLabel.text = obj.goodsName;
        NSString *price = @(obj.goodsPrice / 100.f).stringValue;
        
        [_imgView sd_setImageWithURL:[NSURL URLWithString:obj.goodsPic] placeholderImage:kDefaultPlaceHolderImg];
        
        [_infoLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.paragraphStyle.lineSpacing(3);
            confer.text([NSString stringWithFormat:@"规格参数：%@  x%zd",obj.goodsAttr,obj.goodsNum]);
            confer.text(@"\n");
            confer.text(@"价格：");
            confer.text([NSString stringWithFormat:@"¥%@",price]).textColor(XKMainRedColor);
        }];
    }

    [self addStar:model];
}

- (void)addStar:(XKOrderEvaModel *)model  {
    // 评分视图逻辑
    [_evalutionView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    NSMutableArray *starViews = @[].mutableCopy;
    for (XKOrderEvaStarInfo *starInfo in model.evaStarArr) {
        // 创建评分项
        XKOrderEvaStarView *starView = [[XKOrderEvaStarView alloc] init];
        starView.title = starInfo.title;
        starView.starNum = starInfo.starNum;
        starView.des = starInfo.des;
        [starView setStarChange:^(NSInteger starNum) {
            starInfo.starNum = starNum;
        }];
        [starViews addObject:starView];
    }
    CGFloat starHeight = 30;
    int i = 0;
    for (UIView *starView in starViews) {
        starView.frame = CGRectMake(0, i * starHeight, SCREEN_WIDTH - 2 * kOrderEvaCellMargin - 2 * kOrderEvaCellPadding, 30);
        [_evalutionView addSubview:starView];
        i ++;
    }
    [_evalutionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(starViews.count * starHeight);
    }];
}

- (void)textViewDidChange:(UITextView *)textView {
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 有高亮选择的字
        if (position) {
            return;
        }
    }

    NSInteger limitNum = 200;
    if (self.textView.text.length > limitNum) {
        self.textView.text = [self.textView.text substringToIndex:limitNum];
    }
    self.model.commentText = self.textView.text;
}

#pragma mark - 重设数据源 处理add选项
- (void)resetMedioArr {
    if (_model.mediaInfoArr.count > 9) {
        [_model.mediaInfoArr removeLastObject];
    } else { // 小于9个肯定要加上add
        BOOL hasAdd = NO;
        for (XKUploadMediaInfo *info in _model.mediaInfoArr) {
            if (info.isAdd) {
                hasAdd = YES;
            }
        }
        if (hasAdd == NO) {
            XKUploadMediaInfo *add = [XKUploadMediaInfo new];
            add.isAdd = YES;
            [_model.mediaInfoArr addObject:add];
        }
    }
    NSInteger lines = ceil(_model.mediaInfoArr.count / 4.0);
    CGFloat newHeight = lines * kOrderItemSize;
    if (_collectionView.height != newHeight) {
        [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(newHeight);
        }];
        EXECUTE_BLOCK(self.refreshTableView);
    }
    [self.collectionView reloadData];
}

#pragma mark - collectionView代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.mediaInfoArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XKPickImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    XKUploadMediaInfo *mediaInfo = self.model.mediaInfoArr[indexPath.row];
    if(mediaInfo.isAdd) {
        cell.iconImgView.image = [UIImage imageNamed:@"xk_ic_order_addImg"];
        cell.deleteBtn.alpha = 0;
        cell.playBtn.hidden = YES;
    } else {
        cell.deleteBtn.alpha = 1;
        cell.iconImgView.image = mediaInfo.image;
        if (mediaInfo.isVideo) {
            cell.playBtn.hidden = NO;
        } else {
            cell.playBtn.hidden = YES;
        }
    }
    XKWeakSelf(ws);
    cell.indexPath = indexPath;
    cell.deleteClick = ^(UIButton *sender,NSIndexPath *indexPath) {
        [ws.model.mediaInfoArr removeObjectAtIndex:indexPath.row];
        [ws resetMedioArr];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    XKUploadMediaInfo *mediaInfo = self.model.mediaInfoArr[indexPath.row];
    if(mediaInfo.isAdd) {
        [self.bottomSheetView showView];
    } else {
        [self imageClick:indexPath.row];
    }
}

#pragma mark - 图片点击
- (void)imageClick:(NSInteger)imgIndex {
    XKUploadMediaInfo *info = self.model.mediaInfoArr[imgIndex];
    if (info.isVideo == YES) {
        [XKGlobleCommonTool playVideoWithUrl:info.videolocalURL];
    } else {
        XKUploadMediaInfo *currentInfo = info;
        NSMutableArray *imgArr = @[].mutableCopy;
        for (XKUploadMediaInfo *info in self.model.mediaInfoArr) {
            if (info.isVideo == NO && info.isAdd == NO) {
                [imgArr addObject:info.image];
            }
        }
        NSInteger newIndex = [imgArr indexOfObject:currentInfo.image];
        [XKGlobleCommonTool showBigImgWithImgsArr:imgArr defualtIndex:newIndex viewController:self.getCurrentUIVC];
    }
}

- (XKMediaPickHelper *)bottomSheetView {
    if(!_bottomSheetView) {
        XKWeakSelf(ws);
        _bottomSheetView = [[XKMediaPickHelper alloc] init];
        _bottomSheetView.videoMaxSecond = kOrderVideoTime;
        _bottomSheetView.choseImageBlcok = ^(NSArray<UIImage *> * _Nullable images) {
            for (UIImage *image in images) {
                XKUploadMediaInfo *info = [XKUploadMediaInfo new];
                info.isVideo = NO;
                info.image = image;
                [ws.model.mediaInfoArr insertObject:info atIndex:ws.model.mediaInfoArr.count - 1];
                [XKUploadMediaInfo uploadMediainfoWithModel:info Complete:^(NSString *error, id data) {
                    
                }];
            }
            [ws resetMedioArr];
        };
        [_bottomSheetView setChoseVideoPathBlcok:^(NSURL *videoURL, UIImage *coverImg) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                NSInteger time = [XKGlobleCommonTool calculateVideoTime:videoURL];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (time <= kOrderVideoTime) {
                        XKUploadMediaInfo *info = [XKUploadMediaInfo new];
                        info.isVideo = YES;
                        info.image = coverImg;
                        info.videolocalURL = videoURL;
                        [ws.model.mediaInfoArr insertObject:info atIndex:ws.model.mediaInfoArr.count - 1];
                        [ws resetMedioArr];
                        [XKUploadMediaInfo uploadMediainfoWithModel:info Complete:^(NSString *error, id data) {
                            
                        }];
                    } else {
                        [XKAlertView showCommonAlertViewWithTitle:[NSString stringWithFormat:@"视频时长过长,请限制%ds之内",kOrderVideoTime]];
                    }
                });
            });

        }];
    }
    _bottomSheetView.maxCount = 9 - self.model.mediaInfoArr.count + 1;
    BOOL noVideo = YES;
    for (XKUploadMediaInfo * info in self.model.mediaInfoArr) {
        if (!info.isAdd && info.isVideo) {
            noVideo = NO;
        }
    }
    _bottomSheetView.canSelectVideo = noVideo;
    return _bottomSheetView;
}

@end
