//
//  XKSotreInfoTableViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSotreInfoTableViewCell.h"
#import "XKStoreInfoCollectionCell.h"
#import "XKTradingAreaShopInfoModel.h"

#define itemWidth   (int)((SCREEN_WIDTH - 20 - 20) / 4)
#define itemHeight  itemWidth

static NSString *const collectionViewCellID = @"collectionViewCell";

@interface XKSotreInfoTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel           *timeNamelabel;
@property (nonatomic, strong) UILabel           *timeLabel;
@property (nonatomic, strong) UILabel           *introductionLabel;
@property (nonatomic, strong) UILabel           *decLable;
@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) ATMShop           *model;
@property (nonatomic, copy  ) NSArray           *dataArr;



@end


@implementation XKSotreInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initViews];
        [self layoutViews];
    }
    return self;
}

#pragma mark - Private

- (void)initViews {
    
    [self.contentView addSubview:self.timeNamelabel];
    [self.contentView addSubview:self.timeLabel];
    
    [self.contentView addSubview:self.introductionLabel];
    [self.contentView addSubview:self.decLable];
    [self.contentView addSubview:self.collectionView];

    
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {

    
    [self.timeNamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.left.equalTo(self.contentView).offset(15);
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeNamelabel.mas_bottom).offset(2);
        make.left.equalTo(self.timeNamelabel.mas_left);
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);

    }];
    
    [self.introductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(8);
        make.left.equalTo(self.timeNamelabel.mas_left);
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);
    }];
    
    [self.decLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.introductionLabel.mas_bottom).offset(2);
        make.left.equalTo(self.timeNamelabel.mas_left);
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.decLable.mas_bottom).offset(0);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.equalTo(@(itemHeight + 1));
        make.bottom.equalTo(self.contentView).offset(-10);
    }];

}



#pragma mark - Setter


- (UILabel *)timeNamelabel {
    if (!_timeNamelabel) {
        _timeNamelabel = [[UILabel alloc] init];
        _timeNamelabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14];
        _timeNamelabel.textColor = HEX_RGB(0x222222);
        _timeNamelabel.textAlignment = NSTextAlignmentLeft;
        _timeNamelabel.text = @"营业时间";
    }
    return _timeNamelabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.numberOfLines = 0;
        _timeLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12];
        _timeLabel.textColor = HEX_RGB(0x999999);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
//        _timeLabel.text = @"周一到周日 10:00 - 23:00";
    }
    return _timeLabel;
}


- (UILabel *)introductionLabel {
    if (!_introductionLabel) {
        _introductionLabel = [[UILabel alloc] init];
        _introductionLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14];
        _introductionLabel.textColor = HEX_RGB(0x222222);
        _introductionLabel.textAlignment = NSTextAlignmentLeft;
        _introductionLabel.text = @"简介";
    }
    return _introductionLabel;
}


- (UILabel *)decLable {
    if (!_decLable) {
        _decLable = [[UILabel alloc] init];
        _decLable.numberOfLines = 0;
        _decLable.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12];
        _decLable.textColor = HEX_RGB(0x999999);
        _decLable.textAlignment = NSTextAlignmentLeft;
//        _decLable.text = @"超大幅度订单到达对方地方发放，电费案件搜房文件夹偶是东方。我放弃减肥阿斯蒂芬奇偶发安顺开发区开发批发商法跑，是的发放订单的的 的解放军的发送福利卡士大夫的发的说法都是范德萨范德萨";
    }
    return _decLable;
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
        flowLayout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[XKStoreInfoCollectionCell class] forCellWithReuseIdentifier:collectionViewCellID];
    }
    return _collectionView;
}


- (void)setValueWithModel:(ATMShop *)model {
    self.model = model;
    self.dataArr = model.pictures;
    NSMutableString *muStr = [NSMutableString string];
    
    
    if (model.businessTime.mon && model.businessTime.mon.startAt && model.businessTime.mon.endAt) {
        [muStr appendString:[NSString stringWithFormat:@"星期一 %@-%@", model.businessTime.mon.startAt, model.businessTime.mon.endAt]];
    }
    if (model.businessTime.tue && model.businessTime.tue.startAt && model.businessTime.tue.endAt) {
        [muStr appendString:[NSString stringWithFormat:@"\n星期二 %@-%@", model.businessTime.tue.startAt, model.businessTime.tue.endAt]];
    }
    if (model.businessTime.wed && model.businessTime.wed.startAt && model.businessTime.wed.endAt) {
        [muStr appendString:[NSString stringWithFormat:@"\n星期三 %@-%@", model.businessTime.wed.startAt, model.businessTime.wed.endAt]];
    }
    if (model.businessTime.thu && model.businessTime.thu.startAt && model.businessTime.thu.endAt) {
        [muStr appendString:[NSString stringWithFormat:@"\n星期四 %@-%@", model.businessTime.thu.startAt, model.businessTime.thu.endAt]];
    }
    if (model.businessTime.fri && model.businessTime.fri.startAt && model.businessTime.fri.endAt) {
        [muStr appendString:[NSString stringWithFormat:@"\n星期五 %@-%@", model.businessTime.fri.startAt, model.businessTime.fri.endAt]];
    }
    if (model.businessTime.sat && model.businessTime.sat.startAt && model.businessTime.sat.endAt) {
        [muStr appendString:[NSString stringWithFormat:@"\n星期六 %@-%@", model.businessTime.sat.startAt, model.businessTime.sat.endAt]];
    }
    if (model.businessTime.sun && model.businessTime.sun.startAt && model.businessTime.sun.endAt) {
        [muStr appendString:[NSString stringWithFormat:@"\n星期日 %@-%@", model.businessTime.sun.startAt, model.businessTime.sun.endAt]];
    }
    
    self.timeLabel.text = muStr;
    self.decLable.text = model.descriptionStr;
    
    if (self.dataArr.count) {
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(itemHeight + 1));
        }];
    } else {
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XKStoreInfoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
    [cell setImgViewWithImgUrl:self.dataArr[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(storeImgCollectionView:didSelectItemAtIndexPath:imgArr:)]) {
        [self.delegate storeImgCollectionView:collectionView didSelectItemAtIndexPath:indexPath imgArr:self.dataArr];
    }
}



@end
