//
//  XKLotteryTicketChooseNumbersViewController.m
//  XKSquare
//
//  Created by xudehuai on 2018/12/3.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKLotteryTicketChooseNumbersViewController.h"
#import "UIView+XKCornerBorder.h"
#import "XKLotteryTicketChooseNumberCollectionViewCell.h"
#import "XKMenuView.h"
#import "XKLotteryTicketConfirmNumbersViewController.h"

@interface XKLotteryTicketChooseNumbersViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIButton *typeBtn;

@property (nonatomic, strong) UILabel *remarkLab;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *bottomView;
// 重选按钮
@property (nonatomic, strong) UIButton *rechooseBtn;
// 注数
@property (nonatomic, strong) UILabel *ticketNumLab;
// 数量视图
@property (nonatomic, strong) UIView *numView;
// 数量
@property (nonatomic, strong) UILabel *numLab;
// 向上箭头
@property (nonatomic, strong) UIImageView *upArrowImgView;
// 赠送视图
@property (nonatomic, strong) UIView *confirmView;
// 赠送文字
@property (nonatomic, strong) UILabel *confirmLab;

@property (nonatomic, strong) UIColor *confirmViewColor;

@property (nonatomic, strong) NSMutableArray <NSNumber *>*selectedRedNums;

@property (nonatomic, strong) NSMutableArray <NSNumber *>*selectedBlueNums;

@end

@implementation XKLotteryTicketChooseNumbersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.maxLotteryTicketCount = 5;
    
    [self setNavTitle:@"大乐透" WithColor:HEX_RGB(0xFFFFFF)];
    UIButton *ruleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ruleBtn.titleLabel.font = XKMediumFont(17.0);
    [ruleBtn setTitle:@"活动规则" forState:UIControlStateNormal];
    [ruleBtn setTitleColor:HEX_RGB(0xFFFFFF) forState:UIControlStateNormal];
    [ruleBtn sizeToFit];
    [self setRightView:ruleBtn withframe:CGRectMake(0.0, 0.0, CGRectGetWidth(ruleBtn.frame), CGRectGetHeight(ruleBtn.frame))];
    [self initializeViews];
    [self updateViews];
    [self refreshNumView];
    
    __weak typeof(self) weakSelf = self;
    [self.numView bk_whenTapped:^{
        NSMutableArray *titles = [NSMutableArray array];
        for (int i = 1; i <= weakSelf.maxLotteryTicketCount; i++) {
            [titles addObject:[NSString stringWithFormat:@"%tu 注", i]];
        }
        XKMenuView *menuView = [XKMenuView menuWithTitles:titles images:nil width:100.0 relyonView:weakSelf.numView clickBlock:^(NSInteger index, NSString *text) {
            weakSelf.numLab.text = [NSString stringWithFormat:@"%tu", index + 1];
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
    [self.confirmView bk_whenTapped:^{
        if (self.selectedRedNums.count != 5 || self.selectedBlueNums.count != 2) {
            [XKHudView showErrorMessage:@"最多选择5个红球，2个蓝球"];
            return ;
        }
        NSMutableArray *selectedNums = [NSMutableArray array];
        [selectedNums addObjectsFromArray:[self.selectedRedNums copy]];
        [selectedNums addObjectsFromArray:[self.selectedBlueNums copy]];
        XKLotteryTicketConfirmNumbersViewController *vc = [[XKLotteryTicketConfirmNumbersViewController alloc] init];
        vc.selectedNums = [selectedNums copy];
        vc.selectedLotteryTicketNum = self.numLab.text.integerValue;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)initializeViews {
    [self.containView addSubview:self.typeBtn];
    [self.containView addSubview:self.remarkLab];
    [self.containView addSubview:self.collectionView];
    [self.containView addSubview:self.bottomView];
    [self.bottomView addSubview:self.rechooseBtn];
    [self.bottomView addSubview:self.ticketNumLab];
    [self.bottomView addSubview:self.numView];
    [self.numView addSubview:self.numLab];
    [self.numView addSubview:self.upArrowImgView];
    [self.bottomView addSubview:self.confirmView];
    [self.confirmView addSubview:self.confirmLab];
}

- (void)updateViews {
    [self.typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(13.0);
        make.leading.mas_equalTo(12.0);
        make.width.mas_equalTo(85.0);
        make.height.mas_equalTo(24.0);
    }];
    
    [self.remarkLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.remarkLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-12.0);
        make.centerY.mas_equalTo(self.typeBtn);
    }];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    NSUInteger redNums = [self collectionView:self.collectionView numberOfItemsInSection:0];
    NSUInteger redNumLines = redNums % 7 == 0 ? redNums / 7 : redNums / 7 + 1;
    NSUInteger blueNums = [self collectionView:self.collectionView numberOfItemsInSection:1];
    NSUInteger blueNumLines = blueNums % 7 == 0 ? blueNums / 7 : blueNums / 7 + 1;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.typeBtn.mas_bottom).offset(13.0);
        make.leading.mas_equalTo(10.0);
        make.trailing.mas_equalTo(-10.0);
        make.height.mas_equalTo((layout.sectionInset.top + layout.itemSize.width * redNumLines + layout.minimumLineSpacing * (redNumLines - 1) + layout.sectionInset.bottom) + 1.0 + (layout.sectionInset.top + layout.itemSize.width * blueNumLines + layout.minimumLineSpacing * (blueNumLines - 1) + layout.sectionInset.bottom));
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-kBottomSafeHeight);
        make.leading.trailing.mas_equalTo(self.containView);
        make.height.mas_equalTo(50.0);
    }];
    
    [self.rechooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.bottomView);
        make.leading.mas_equalTo(15.0);
    }];
    
    [self.ticketNumLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.ticketNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.numView.mas_left).offset(-10.0);
        make.centerY.mas_equalTo(self.numView);
    }];
    
    [self.numView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.mas_equalTo(self.confirmView);
        make.right.mas_equalTo(self.confirmView.mas_left);
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
    
    [self.confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-15.0 * ScreenScale);
        make.centerY.mas_equalTo(self.bottomView);
        make.width.mas_equalTo(70.0 * ScreenScale);
        make.height.mas_equalTo(30.0 * ScreenScale);
    }];
    
    [self.confirmLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.confirmView);
    }];
    
}

- (void)refreshNumView {
//    self.numLab.text = @"1";
//    if (self.selectedRedNums.count == 5 && self.selectedBlueNums.count == 2) {
        // 可以选择
        self.numView.xk_borderColor = self.confirmViewColor;
        [self.numView layoutSubviews];
        self.numView.userInteractionEnabled = self.maxLotteryTicketCount > 1;
        self.upArrowImgView.hidden = self.maxLotteryTicketCount == 1;

        self.confirmView.xk_borderColor = self.confirmViewColor;
        [self.confirmView layoutSubviews];
        self.confirmView.backgroundColor = self.confirmViewColor;
        self.confirmView.userInteractionEnabled = YES;
//    } else {
//        // 不可选择
//        self.numView.xk_borderColor = self.confirmViewColor;
//        [self.numView layoutSubviews];
//        self.numView.userInteractionEnabled = NO;
//        self.upArrowImgView.hidden = YES;
//
//        self.confirmView.xk_borderColor = self.confirmViewColor;
//        [self.confirmView layoutSubviews];
//        self.confirmView.backgroundColor = self.confirmViewColor;
//        self.confirmView.userInteractionEnabled = NO;
//    }
}

#pragma mark - Events

- (void)typeBtnAction:(UIButton *)sender {
    
}

- (void)rechooseBtnAction:(UIButton *)sender {
    [self.selectedRedNums removeAllObjects];
    [self.selectedBlueNums removeAllObjects];
    [self.collectionView reloadData];
    [self refreshNumView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 35;
    } else {
        return 12;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return nil;
    } else {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionReusableView class]) forIndexPath:indexPath];
        header.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(collectionView.frame), 1.0);
        header.backgroundColor = XKSeparatorLineColor;
        return header;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XKLotteryTicketChooseNumberCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XKLotteryTicketChooseNumberCollectionViewCell class]) forIndexPath:indexPath];
    [cell configCellWithNumber:indexPath.row + 1];
    if (indexPath.section == 0) {
        [cell setCellSelected:[self.selectedRedNums containsObject:[NSNumber numberWithUnsignedInteger:indexPath.row + 1]] tintColor:XKMainRedColor];
    } else {
        [cell setCellSelected:[self.selectedBlueNums containsObject:[NSNumber numberWithUnsignedInteger:indexPath.row + 1]] tintColor:XKMainTypeColor];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if ([self.selectedRedNums containsObject:[NSNumber numberWithUnsignedInteger:indexPath.row + 1]]) {
            [self.selectedRedNums removeObject:[NSNumber numberWithUnsignedInteger:indexPath.row + 1]];
        } else {
            if (self.selectedRedNums.count == 5) {
                [XKHudView showTipMessage:@"最多选择5个红球"];
                return;
            }
            [self.selectedRedNums addObject:[NSNumber numberWithUnsignedInteger:indexPath.row + 1]];
        }
        [self.selectedRedNums sortUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
            return obj1.unsignedIntegerValue > obj2.unsignedIntegerValue;
        }];
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    } else {
        if ([self.selectedBlueNums containsObject:[NSNumber numberWithUnsignedInteger:indexPath.row + 1]]) {
            [self.selectedBlueNums removeObject:[NSNumber numberWithUnsignedInteger:indexPath.row + 1]];
        } else {
            if (self.selectedBlueNums.count == 2) {
                [XKHudView showTipMessage:@"最多选择2个蓝球"];
                return;
            }
            [self.selectedBlueNums addObject:[NSNumber numberWithUnsignedInteger:indexPath.row + 1]];
        }
        [self.selectedBlueNums sortUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
            return obj1.unsignedIntegerValue > obj2.unsignedIntegerValue;
        }];
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
//    [self refreshNumView];
}

#pragma mark - getter setter

- (UIButton *)typeBtn {
    if (!_typeBtn) {
        _typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _typeBtn.titleLabel.font = XKRegularFont(14.0);
        [_typeBtn setTitle:@"普通投注" forState:UIControlStateNormal];
        [_typeBtn setTitleColor:HEX_RGB(0x8E796C) forState:UIControlStateNormal];
        [_typeBtn setBackgroundImage:IMG_NAME(@"xk_ic_lotteryTicket_type") forState:UIControlStateNormal];
        [_typeBtn addTarget:self action:@selector(typeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _typeBtn;
}

- (UILabel *)remarkLab {
    if (!_remarkLab) {
        _remarkLab = [[UILabel alloc] init];
        _remarkLab.text = @"请选择5个红球，2个蓝球";
        _remarkLab.font = XKRegularFont(14.0);
        _remarkLab.textColor = HEX_RGB(0x555555);
    }
    return _remarkLab;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((SCREEN_WIDTH - 10.0 * 2 - 15.0 * ScreenScale * 2 - 14.5 * ScreenScale * 6) / 7.0, (SCREEN_WIDTH - 10.0 * 2 - 15.0 * ScreenScale * 2.0 - 14.5 * ScreenScale * 6) / 7.0);
        layout.minimumLineSpacing = 10.0;
        layout.minimumInteritemSpacing = 14.5 * ScreenScale - 1.0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(15.0 * ScreenScale, 15.0 * ScreenScale, 15.0 * ScreenScale, 15.0 * ScreenScale);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[XKLotteryTicketChooseNumberCollectionViewCell class]
            forCellWithReuseIdentifier:NSStringFromClass([XKLotteryTicketChooseNumberCollectionViewCell class])];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.layer.cornerRadius = 8.0;
        _collectionView.layer.masksToBounds = YES;
        _collectionView.clipsToBounds = YES;
    }
    return _collectionView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = HEX_RGB(0xFFFFFF);
    }
    return _bottomView;
}

- (UIButton *)rechooseBtn {
    if (!_rechooseBtn) {
        _rechooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rechooseBtn.titleLabel.font = XKRegularFont(17.0);
        [_rechooseBtn setTitle:@"重选" forState:UIControlStateNormal];
        [_rechooseBtn setTitleColor:HEX_RGB(0x222222) forState:UIControlStateNormal];
        [_rechooseBtn addTarget:self action:@selector(rechooseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rechooseBtn;
}

- (UILabel *)ticketNumLab {
    if (!_ticketNumLab) {
        _ticketNumLab = [[UILabel alloc] init];
        _ticketNumLab.text = @"可选注数:";
        _ticketNumLab.font = XKRegularFont(14.0);
        _ticketNumLab.textColor = HEX_RGB(0x777777);
    }
    return _ticketNumLab;
}

- (UIView *)numView {
    if (!_numView) {
        _numView = [[UIView alloc] init];
        _numView.backgroundColor = HEX_RGB(0xffffff);
        _numView.userInteractionEnabled = NO;
        _numView.xk_radius = 15.0 * ScreenScale;
        _numView.xk_clipType = XKCornerClipTypeTopLeft | XKCornerClipTypeBottomLeft;
        _numView.xk_openClip = YES;
        _numView.xk_borderRadius = 15.0 * ScreenScale;
        _numView.xk_borderType = (XKBorderTypeTopLeft | XKBorderTypeBottomLeft);
        _numView.xk_borderWidth = 1.0;
        _numView.xk_borderColor = self.confirmViewColor;
        _numView.xk_openBorder = YES;
    }
    return _numView;
}

- (UILabel *)numLab {
    if (!_numLab) {
        _numLab = [[UILabel alloc] init];
        _numLab.text = @"1";
        _numLab.font = XKRegularFont(14.0);
        _numLab.textColor = HEX_RGB(0x555555);
        _numLab.textAlignment = NSTextAlignmentCenter;
    }
    return _numLab;
}

- (UIImageView *)upArrowImgView {
    if (!_upArrowImgView) {
        _upArrowImgView = [[UIImageView alloc] init];
        _upArrowImgView.image = IMG_NAME(@"xk_img_gift_IM");
        _upArrowImgView.hidden = YES;
    }
    return _upArrowImgView;
}

- (UIView *)confirmView {
    if (!_confirmView) {
        _confirmView = [[UIView alloc] init];
        _confirmView.backgroundColor = self.confirmViewColor;
        _confirmView.xk_radius = 15.0 * ScreenScale;
        _confirmView.xk_clipType = XKCornerClipTypeTopRight | XKCornerClipTypeBottomRight;
        _confirmView.xk_openClip = YES;
        _confirmView.xk_borderRadius = 15.0 * ScreenScale;
        _confirmView.xk_borderType = (XKBorderTypeTopRight | XKBorderTypeBottomRight);
        _confirmView.xk_borderWidth = 1.0;
        _confirmView.xk_borderColor = self.confirmViewColor;
        _confirmView.xk_openBorder = YES;
    }
    return _confirmView;
}

- (UILabel *)confirmLab {
    if (!_confirmLab) {
        _confirmLab = [[UILabel alloc] init];
        _confirmLab.text = @"确定";
        _confirmLab.font = XKRegularFont(12.0);
        _confirmLab.textColor = HEX_RGB(0xFFFFFF);
        _confirmLab.textAlignment = NSTextAlignmentCenter;
    }
    return _confirmLab;
}

- (UIColor *)confirmViewColor {
//    if (self.selectedRedNums.count == 5 && self.selectedBlueNums.count == 2) {
//        // 可点击状态
        return XKMainTypeColor;
//    } else {
//        // 不可点击状态
//        return HEX_RGB(0x999999);
//    }
}

- (NSMutableArray<NSNumber *> *)selectedRedNums {
    if (!_selectedRedNums) {
        _selectedRedNums = [NSMutableArray array];
    }
    return _selectedRedNums;
}

- (NSMutableArray<NSNumber *> *)selectedBlueNums {
    if (!_selectedBlueNums) {
        _selectedBlueNums = [NSMutableArray array];
    }
    return _selectedBlueNums;
}

@end
