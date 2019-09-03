//
//  XKCityListTableViewCell.m
//  XKSquare
//
//  Created by Lin Li on 2018/8/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKCityListTableViewCell.h"
#import "XKCityCollectionViewCell.h"
#import "XKCityCollectionFlowLayout.h"
NSString * const XKCityTableViewCellDidChangeCityNotification = @"XKCityTableViewCellDidChangeCityNotification";
NSString * const XKCityTableViewLoctionCellDidChangeCityNotification = @"XKCityTableViewLoctionCellDidChangeCityNotification";

static NSString *ID = @"cityCollectionViewCell";

@interface XKCityListTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation XKCityListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[XKCityCollectionFlowLayout alloc] init]];
        [_collectionView registerClass:[XKCityCollectionViewCell class] forCellWithReuseIdentifier:ID];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = RGB(247, 247, 247);
    }
    return _collectionView;
}

- (void)setCityNameArray:(NSArray *)cityNameArray {
    _cityNameArray = cityNameArray;
    [_collectionView reloadData];
}

#pragma mark UICollectionViewDataSource 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _cityNameArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XKCityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    //如果需要显示定位图标并且是第一个cell才显示
    if (self.isShowLocation) {
        if (indexPath.row == 0) {
            cell.locationImageView.hidden = NO;
        }else{
            cell.locationImageView.hidden = YES;
        }
    }
    else{
        cell.locationImageView.hidden = YES;
    }
    DataItem *model = _cityNameArray[indexPath.row];
    //判断_cityNameArray是否含有currentCityName
     __block BOOL hasContainCurrentCityName = NO;
    [_cityNameArray enumerateObjectsUsingBlock:^(DataItem *Cmodel, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([Cmodel.name isEqualToString:self.currentCityName]) {
            hasContainCurrentCityName = YES;
            *stop = YES;
        }else{
            hasContainCurrentCityName = NO;
        }
    }];
    cell.title = model.name;
    if (self.isAllCityButton) {
        //如果包含currentCityName，设置选中状态
        if (hasContainCurrentCityName) {
            if ([model.name isEqualToString:self.currentCityName]) {
                [self buleBgcAndWhiteColorTextColorCell:cell];
            }else {
                [self whiteColorBgcAndTextColorCell:cell];
            }
        }else {
            //不包含默认设置第一个为选中状态
            if (indexPath.row == 0) {
                [self buleBgcAndWhiteColorTextColorCell:cell];
            }else {
                [self whiteColorBgcAndTextColorCell:cell];
            }
        }
    }else {
        [self whiteColorBgcAndTextColorCell:cell];
    }
    return cell;
}


- (void)buleBgcAndWhiteColorTextColorCell:(XKCityCollectionViewCell *)cell {
    cell.label.textColor = HEX_RGB(0xFFFFFF);
    cell.label.backgroundColor = XKMainTypeColor;
    cell.contentView.backgroundColor = XKMainTypeColor;
}

- (void)whiteColorBgcAndTextColorCell:(XKCityCollectionViewCell *)cell {
    cell.label.textColor = HEX_RGB(0x666666);
    cell.label.backgroundColor = HEX_RGB(0xFFFFFF);
    cell.contentView.backgroundColor = HEX_RGB(0xFFFFFF);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0 && self.isShowLocation) {
        DataItem *model = _cityNameArray[indexPath.row];
        NSDictionary *cityNameDic = @{@"model":model};
        [[NSNotificationCenter defaultCenter] postNotificationName:XKCityTableViewLoctionCellDidChangeCityNotification object:self userInfo:cityNameDic];
    }else{
        DataItem *model = _cityNameArray[indexPath.row];
        NSDictionary *cityNameDic = @{@"model":model};
        [[NSNotificationCenter defaultCenter] postNotificationName:XKCityTableViewCellDidChangeCityNotification object:self userInfo:cityNameDic];
    }
}
@end
