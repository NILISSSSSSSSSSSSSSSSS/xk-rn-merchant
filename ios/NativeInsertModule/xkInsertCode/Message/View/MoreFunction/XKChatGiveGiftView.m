//
//  XKChatGiveGiftView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKChatGiveGiftView.h"
#import "XKChatGiveGiftViewLayout.h"
#import "XKChatGiveGiftViewCell.h"
#import "UIView+XKCornerBorder.h"
#import "XKMenuView.h"

static NSString *redEnvelopId = @"redEnvelopId";

@interface XKChatGiveGiftView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *containerView;

// 类型
@property (nonatomic, assign) XKChatGiveGiftViewType type;
// 礼物数组
@property (nonatomic, copy) NSArray *gifts;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) XKChatGiveGiftViewLayout *layout;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *bottomView;
// 晓可币视图
@property (nonatomic, strong) UIView *xkCoinView;
// 晓可币图片
@property (nonatomic, strong) UIImageView *xkCoinImgView;
// 晓可币余额
@property (nonatomic, strong) UILabel *xkCoinLab;
// 数量视图
@property (nonatomic, strong) UIView *numView;
// 数量
@property (nonatomic, strong) UILabel *numLab;
// 向上箭头
@property (nonatomic, strong) UIImageView *upArrowImgView;
// 赠送视图
@property (nonatomic, strong) UIView *handselView;
// 赠送文字
@property (nonatomic, strong) UILabel *handselLab;

// 数量和赠送按钮的颜色
@property (nonatomic, strong) UIColor *operationViewColor;

@property (nonatomic, copy) NSArray *continuouslyGifts;

@property (nonatomic, assign) NSInteger selectedIndex;
@end
@implementation XKChatGiveGiftView

- (instancetype)initWithFrame:(CGRect)frame gifts:(NSArray *)gifts type:(XKChatGiveGiftViewType)type {
    self = [super initWithFrame:frame];
    if (self) {
        _selectedIndex = -1;
        _gifts = gifts;
        _type = type;
        [self addCustomSubviews];
        [self addUIContains];
        self.xk_radius = 6.f;
        self.xk_clipType = XKCornerClipTypeTopBoth;
        self.xk_openClip = YES;
        if (_type == XKChatGiveGiftViewTypeLittleVideo) {
            self.backgroundColor = HEX_RGB(0x0C0D13);
            self.lineView.backgroundColor = HEX_RGB(0x000000);
            self.bottomView.backgroundColor = HEX_RGB(0x000000);
            XKIMGiftModel *redEnvelope = [[XKIMGiftModel alloc] init];
            redEnvelope.giftId = redEnvelopId;
            redEnvelope.name = @"发红包";
            redEnvelope.smallPicture = @"xk_img_gift_redEnvelope";
            NSMutableArray *temp = [NSMutableArray arrayWithArray:_gifts];
            [temp insertObject:redEnvelope atIndex:temp.count >= 7 ? 7 : temp.count];
            _gifts = [temp copy];
        } else if (_type == XKChatGiveGiftViewTypeIM) {
            self.backgroundColor = HEX_RGB(0xffffff);
            self.lineView.backgroundColor = XKSeparatorLineColor;
            self.bottomView.backgroundColor = HEX_RGB(0xffffff);
        } else if (_type == XKChatGiveGiftViewTypeRedEnvelope) {
            self.backgroundColor = HEX_RGB(0xffffff);
        }
        self.pageControl.numberOfPages = _gifts.count % 8 == 0 ? _gifts.count / 8 : _gifts.count / 8 + 1;
        __weak typeof(self) weakSelf = self;
        [self.numView bk_whenTapped:^{
            NSMutableArray *imgs = [NSMutableArray array];
            NSMutableArray *titles = [NSMutableArray array];
            for (NSDictionary *dic in self.continuouslyGifts) {
                // 生成图片
                UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 32.0, 16.0)];
                UILabel *tempLab = [[UILabel alloc] init];
                tempLab.text = [NSString stringWithFormat:@"%@", dic[@"num"]];
                tempLab.font = XKRegularFont(10.0);
                tempLab.textColor = HEX_RGB(0xffffff);
                tempLab.textAlignment = NSTextAlignmentCenter;
                CGSize tempLabSize = [tempLab.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 16.0) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : tempLab.font} context:nil].size;
                tempLab.frame = CGRectMake(0.0, 0.0, tempLabSize.width + 2.0 > 16.0 ? tempLabSize.width + 2.0 : 16.0, 16.0);
                [tempView addSubview:tempLab];
                tempLab.backgroundColor = HEX_RGB(0xECC836);
                tempLab.xk_radius = 8.0;
                tempLab.xk_clipType = XKCornerClipTypeAllCorners;
                tempLab.xk_openClip = YES;
                UIGraphicsBeginImageContextWithOptions(tempView.bounds.size, NO, UIScreen.mainScreen.scale);
                [tempView.layer renderInContext:UIGraphicsGetCurrentContext()];
                UIImage *tempImg = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                [imgs addObject:tempImg];
                [titles addObject:dic[@"meaning"]];
            }
            XKMenuView *menuView = [XKMenuView menuWithTitles:titles images:imgs width:120.0 relyonView:weakSelf.numView clickBlock:^(NSInteger index, NSString *text) {
                NSDictionary *dic = weakSelf.continuouslyGifts[index];
                weakSelf.numLab.text = [NSString stringWithFormat:@"%@", dic[@"num"]];
            }];
            menuView.maxDisplayCount = 8;
            menuView.menuCellHeight = 30.0 * ScreenScale;
            menuView.menuColor = HEX_RGBA(0xffffff, 1);
            menuView.textFont = XKRegularFont(12.0);
            menuView.textColor = UIColorFromRGB(0x222222);
            menuView.separatorPadding = 5;
            menuView.separatorColor = XKSeparatorLineColor;
            menuView.textImgSpace = 10;
            
            [menuView show];
        }];
        
        [self.handselView bk_whenTapped:^{
            if (weakSelf.handselBtnBlock) {
                weakSelf.handselBtnBlock(weakSelf.gifts[self.selectedIndex], weakSelf.numLab.text.integerValue);
            }
        }];
    }
    return self;
}

- (void)addCustomSubviews {

    [self addSubview:self.containerView];
    [self.containerView addSubview:self.collectionView];
    [self.containerView addSubview:self.pageControl];
    if (self.type != XKChatGiveGiftViewTypeRedEnvelope) {
        [self.containerView addSubview:self.lineView];
        [self.containerView addSubview:self.bottomView];
        [self.bottomView addSubview:self.xkCoinView];
        [self.xkCoinView addSubview:self.xkCoinImgView];
        [self.xkCoinView addSubview:self.xkCoinLab];
        [self.bottomView addSubview:self.numView];
        [self.numView addSubview:self.numLab];
        [self.numView addSubview:self.upArrowImgView];
        [self.bottomView addSubview:self.handselView];
        [self.handselView addSubview:self.handselLab];
    }
}

- (void)addUIContains {
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0.0, 0.0, kBottomSafeHeight, 0.0));
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5.0 * ScreenScale);
        make.leading.trailing.mas_equalTo(self.containerView);
        make.height.mas_equalTo(220.0 * ScreenScale);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.collectionView.mas_bottom);
        make.leading.trailing.mas_equalTo(self.containerView);
        make.height.mas_equalTo(25.0 * ScreenScale);
        if (self.type == XKChatGiveGiftViewTypeRedEnvelope) {
            make.bottom.mas_equalTo(self.containerView);
        }
    }];
    
    if (self.type != XKChatGiveGiftViewTypeRedEnvelope) {
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.pageControl);
            make.leading.trailing.mas_equalTo(self.containerView);
            make.height.mas_equalTo(1.0);
        }];
        
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.lineView.mas_bottom);
            make.leading.bottom.trailing.mas_equalTo(self.containerView);
        }];
        
        [self.xkCoinView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(15.0 * ScreenScale);
            make.centerY.mas_equalTo(self.bottomView);
            make.width.mas_equalTo(75.0 * ScreenScale);
            make.height.mas_equalTo(25.0 * ScreenScale);
        }];
        
        [self.xkCoinImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(10.0 * ScreenScale);
            make.centerY.mas_equalTo(self.xkCoinView);
            make.width.mas_equalTo(15.0 * ScreenScale);
            make.height.mas_equalTo(17.0 * ScreenScale);
        }];
        
        [self.xkCoinLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.xkCoinView);
            make.left.mas_equalTo(self.xkCoinImgView.mas_right);
            make.trailing.mas_equalTo(-10.0 * ScreenScale);
        }];
        
        [self.numView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.width.mas_equalTo(self.handselView);
            make.right.mas_equalTo(self.handselView.mas_left);
        }];
        
        [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(10.0 * ScreenScale);
            make.top.bottom.mas_equalTo(self.numView);
            make.right.mas_equalTo(self.upArrowImgView.mas_left);
        }];
        
        [self.upArrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(-10.0 * ScreenScale);
            make.centerY.mas_equalTo(self.numView);
            make.width.mas_equalTo(8.0 * ScreenScale);
            make.height.mas_equalTo(6.0 * ScreenScale);
        }];
        
        [self.handselView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(-15.0 * ScreenScale);
            make.centerY.mas_equalTo(self.bottomView);
            make.width.mas_equalTo(70.0 * ScreenScale);
            make.height.mas_equalTo(30.0 * ScreenScale);
        }];
        
        [self.handselLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.handselView);
        }];
    }
}

#pragma mark event

- (void)refreshNumView {
    self.numLab.text = @"1";
    if (self.selectedIndex == -1) {
        self.numView.xk_borderColor = self.operationViewColor;
        [self.numView layoutSubviews];
        self.numView.userInteractionEnabled = NO;
        self.upArrowImgView.hidden = YES;
        
        self.handselView.xk_borderColor = self.operationViewColor;
        [self.handselView layoutSubviews];
        self.handselView.backgroundColor = self.operationViewColor;
        self.handselView.userInteractionEnabled = NO;
    } else {
        XKIMGiftModel *gift = self.gifts[self.selectedIndex];
        self.numView.xk_borderColor = self.operationViewColor;
        [self.numView layoutSubviews];
        self.numView.userInteractionEnabled = gift.allowSelectNumber;
        self.upArrowImgView.hidden = !gift.allowSelectNumber;
        
        self.handselView.xk_borderColor = self.operationViewColor;
        [self.handselView layoutSubviews];
        self.handselView.backgroundColor = self.operationViewColor;
        self.handselView.userInteractionEnabled = YES;
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.gifts.count % 8 == 0 ? self.gifts.count / 8 : self.gifts.count / 8 + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section * 8 + indexPath.row + 1 > self.gifts.count) {
        // 占位空白CELL
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
        cell.hidden = YES;
        return cell;
    }
    XKChatGiveGiftViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKChatGiveGiftViewCell" forIndexPath:indexPath];
    XKIMGiftModel *gift = self.gifts[indexPath.section * 8 + indexPath.row];
    if (gift.smallPicture && gift.smallPicture.length) {
        if ([gift.giftId isEqualToString:redEnvelopId]) {
            // 小视频发红包
            cell.iconImgView.image = IMG_NAME(gift.smallPicture);
        } else {
            [cell.iconImgView sd_setImageWithURL:[NSURL URLWithString:gift.smallPicture]];
        }
    } else {
        cell.iconImgView.image = kDefaultPlaceHolderImg;
    }
    if (_type == XKChatGiveGiftViewTypeLittleVideo) {
        cell.titleLabel.textColor = HEX_RGB(0xffffff);
    } else if (_type == XKChatGiveGiftViewTypeIM || _type == XKChatGiveGiftViewTypeRedEnvelope) {
        cell.titleLabel.textColor = HEX_RGB(0x222222);
    }
    cell.titleLabel.text = gift.name;
    if ([gift.giftId isEqualToString:redEnvelopId]) {
        // 小视频发红包
        cell.priceLabel.text = @"";
    } else {
        cell.priceLabel.text = [NSString stringWithFormat:@"%tu晓可币", gift.price];
    }
    if (indexPath.section * 8 + indexPath.row == _selectedIndex) {
        [cell selectedStatus:YES];
    } else {
        [cell selectedStatus:NO];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    XKIMGiftModel *gift = self.gifts[indexPath.section * 8 + indexPath.row];
    if ([gift.giftId isEqualToString:redEnvelopId]) {
        // 小视频发红包
        if (self.sendRedEnvelopeBlock) {
            self.sendRedEnvelopeBlock();
        }
        return;
    }
    if (indexPath.section * 8 + indexPath.row == self.selectedIndex) {
        self.selectedIndex = -1;
    } else {
        self.selectedIndex = indexPath.section * 8 + indexPath.row;
    }
    [self refreshNumView];
    [self.collectionView reloadData];
    if (self.cellSelectedBlock) {
        self.cellSelectedBlock(gift);
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREEN_WIDTH - 10 * ScreenScale) / 4, 95.0 * ScreenScale);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.pageControl.currentPage = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
}

#pragma mark set/get/lazy

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        [_collectionView registerClass:[XKChatGiveGiftViewCell class] forCellWithReuseIdentifier:@"XKChatGiveGiftViewCell"];
    }
    return _collectionView;
}

- (XKChatGiveGiftViewLayout *)layout {
    if (!_layout) {
        _layout = [[XKChatGiveGiftViewLayout alloc] init];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.itemCountPerRow = 4;
        _layout.rowCount = 2;
        _layout.sectionInset = UIEdgeInsetsMake(10.0 * ScreenScale, 5 * ScreenScale, 10.0 * ScreenScale, 5.0 * ScreenScale);
    }
    return _layout;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 30 - 100)/2, CGRectGetMaxY(self.collectionView.frame) - 15 * SCREEN_HEIGHT / 667, 100, 5)];
        _pageControl.currentPage = 0;
        if (_type == XKChatGiveGiftViewTypeLittleVideo) {
            _pageControl.currentPageIndicatorTintColor = HEX_RGB(0xffffff);
            _pageControl.pageIndicatorTintColor = HEX_RGB(0x8e8e8e);
        } else if (_type == XKChatGiveGiftViewTypeIM || _type == XKChatGiveGiftViewTypeRedEnvelope) {
            _pageControl.currentPageIndicatorTintColor = HEX_RGB(0x8e8e8e);
            _pageControl.pageIndicatorTintColor = HEX_RGBA(0x8e8e8e, 0.5);
        }
    }
    return _pageControl;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HEX_RGB(0x000000);
    }
    return _lineView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor blackColor];
    }
    return _bottomView;
}

- (UIView *)xkCoinView {
    if (!_xkCoinView) {
        _xkCoinView = [[UIView alloc] init];
        if (_type == XKChatGiveGiftViewTypeLittleVideo) {
            _xkCoinView.backgroundColor =  HEX_RGB(0x4B4525);
        } else if (_type == XKChatGiveGiftViewTypeIM || _type == XKChatGiveGiftViewTypeRedEnvelope) {
            _xkCoinView.backgroundColor =  HEX_RGB(0xFCE76C);
        }
        _xkCoinView.layer.cornerRadius = 12.5 * ScreenScale;
        _xkCoinView.layer.masksToBounds = YES;
    }
    return _xkCoinView;
}

- (UIImageView *)xkCoinImgView {
    if (!_xkCoinImgView) {
        _xkCoinImgView = [[UIImageView alloc] init];
        _xkCoinImgView.image = IMG_NAME(@"xk_img_gift_xkCoin");
    }
    return _xkCoinImgView;
}

- (UILabel *)xkCoinLab {
    if (!_xkCoinLab) {
        _xkCoinLab = [[UILabel alloc] init];
        _xkCoinLab.text = @"0";
        _xkCoinLab.font = XKRegularFont(14.0);
        if (_type == XKChatGiveGiftViewTypeLittleVideo) {
            _xkCoinLab.textColor = HEX_RGB(0xffffff);
        } else if (_type == XKChatGiveGiftViewTypeIM || _type == XKChatGiveGiftViewTypeRedEnvelope) {
            _xkCoinLab.textColor = HEX_RGB(0x222222);
        }
        _xkCoinLab.textAlignment = NSTextAlignmentCenter;
    }
    return _xkCoinLab;
}

- (UIView *)numView {
    if (!_numView) {
        _numView = [[UIView alloc] init];
        if (_type == XKChatGiveGiftViewTypeLittleVideo) {
            _numView.backgroundColor = HEX_RGB(0x000000);
        } else if (_type == XKChatGiveGiftViewTypeIM || _type == XKChatGiveGiftViewTypeRedEnvelope) {
            _numView.backgroundColor = HEX_RGB(0xffffff);
        }
        _numView.userInteractionEnabled = NO;
        _numView.xk_radius = 15.0 * ScreenScale;
        _numView.xk_clipType = XKCornerClipTypeTopLeft | XKCornerClipTypeBottomLeft;
        _numView.xk_openClip = YES;
        _numView.xk_borderRadius = 15.0 * ScreenScale;
        _numView.xk_borderType = (XKBorderTypeTopLeft | XKBorderTypeBottomLeft);
        _numView.xk_borderWidth = 1.0;
        _numView.xk_borderColor = self.operationViewColor;
        _numView.xk_openBorder = YES;
    }
    return _numView;
}

- (UILabel *)numLab {
    if (!_numLab) {
        _numLab = [[UILabel alloc] init];
        _numLab.text = @"1";
        _numLab.font = XKRegularFont(14.0);
        if (_type == XKChatGiveGiftViewTypeLittleVideo) {
            _numLab.textColor = HEX_RGB(0xffffff);
        } else if (_type == XKChatGiveGiftViewTypeIM || _type == XKChatGiveGiftViewTypeRedEnvelope) {
            _numLab.textColor = HEX_RGB(0x000000);
        }
        _numLab.textAlignment = NSTextAlignmentCenter;
    }
    return _numLab;
}

- (UIImageView *)upArrowImgView {
    if (!_upArrowImgView) {
        _upArrowImgView = [[UIImageView alloc] init];
        if (_type == XKChatGiveGiftViewTypeLittleVideo) {
            _upArrowImgView.image = IMG_NAME(@"xk_img_gift_littleVideo");
        } else if (_type == XKChatGiveGiftViewTypeIM || _type == XKChatGiveGiftViewTypeRedEnvelope) {
            _upArrowImgView.image = IMG_NAME(@"xk_img_gift_IM");
        }
        _upArrowImgView.hidden = YES;
    }
    return _upArrowImgView;
}

- (UIView *)handselView {
    if (!_handselView) {
        _handselView = [[UIView alloc] init];
        _handselView.backgroundColor = self.operationViewColor;
        _handselView.xk_radius = 15.0 * ScreenScale;
        _handselView.xk_clipType = XKCornerClipTypeTopRight | XKCornerClipTypeBottomRight;
        _handselView.xk_openClip = YES;
        _handselView.xk_borderRadius = 15.0 * ScreenScale;
        _handselView.xk_borderType = (XKBorderTypeTopRight | XKBorderTypeBottomRight);
        _handselView.xk_borderWidth = 1.0;
        _handselView.xk_borderColor = self.operationViewColor;
        _handselView.xk_openBorder = YES;
    }
    return _handselView;
}

- (UILabel *)handselLab {
    if (!_handselLab) {
        _handselLab = [[UILabel alloc] init];
        _handselLab.text = @"赠送";
        _handselLab.font = XKRegularFont(12.0);
        _handselLab.textColor = HEX_RGB(0x222222);
        _handselLab.textAlignment = NSTextAlignmentCenter;
    }
    return _handselLab;
}

- (UIColor *)operationViewColor {
    if (self.selectedIndex < 0) {
        // 不可点击状态
        if (self.type == XKChatGiveGiftViewTypeLittleVideo) {
            return HEX_RGB(0x777777);
        } else if (self.type == XKChatGiveGiftViewTypeIM || _type == XKChatGiveGiftViewTypeRedEnvelope) {
            return HEX_RGB(0x999999);
        } else {
            return [UIColor clearColor];
        }
    } else {
        // 可点击状态
        return HEX_RGB(0xFCE76C);
    }
}

- (NSArray *)continuouslyGifts {
    return @[
             @{
                 @"num" : @(1),
                 @"meaning" : @"一心一意",
                 },
             @{
                 @"num" : @(10),
                 @"meaning" : @"十全十美",
                 },
             @{
                 @"num" : @(30),
                 @"meaning" : @"想你      ",
                 },
             @{
                 @"num" : @(66),
                 @"meaning" : @"一切顺利",
                 },
             @{
                 @"num" : @(188),
                 @"meaning" : @"要抱抱   ",
                 },
             @{
                 @"num" : @(520),
                 @"meaning" : @"我爱你   ",
                 },
             @{
                 @"num" : @(1314),
                 @"meaning" : @"一生一世",
                 },
             ];
}

@end
