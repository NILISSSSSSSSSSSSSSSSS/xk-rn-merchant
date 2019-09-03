//
//  XKComplaintsUpPictureTableViewCell.m
//  XKSquare
//
//  Created by Lin Li on 2018/9/5.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKComplaintsUpPictureTableViewCell.h"
#import "XKPickImgCell.h"
#import "XKMediaPickHelper.h"
#import "XKComplaintVideoImageModel.h"

@interface XKComplaintsUpPictureTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UILabel  *label;
@property (nonatomic, strong) UILabel  *countLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) XKMediaPickHelper *bottomSheetView;

@end
@implementation XKComplaintsUpPictureTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initViews];
        [self layouts];
    }
    return self;
}

- (void)initViews {
    [self.contentView addSubview:self.label];
    [self.contentView addSubview:self.countLabel];
    [self.contentView addSubview:self.addButton];
    [self.contentView addSubview:self.collectionView];
}

- (void)layouts {
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15 * ScreenScale));
        make.top.equalTo(@(12 * ScreenScale));
        make.width.equalTo(@(120 * ScreenScale));
        make.height.equalTo(@(20 * ScreenScale));
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10 * ScreenScale);
        make.bottom.mas_equalTo(-2 * ScreenScale);
        make.height.equalTo(@(17 * ScreenScale));
        make.width.equalTo(@(120 * ScreenScale));
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.label.mas_left);
        make.top.equalTo(self.label.mas_bottom).offset(10 * ScreenScale);
        make.width.equalTo(@(56 * ScreenScale));
        make.height.equalTo(@(56 * ScreenScale));
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addButton.mas_right).offset(10 * ScreenScale);
        make.top.equalTo(@(32 * ScreenScale));
        make.right.mas_equalTo(-10 *ScreenScale);
        make.height.equalTo(@(70 * ScreenScale));
    }];
}
- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.text = @"上传图片或视频";
        _label.textColor = HEX_RGB(0x222222);
        _label.font = XKFont(XK_PingFangSC_Regular, 14);
    }
    return _label;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc]init];
        _countLabel.text = @"最多三张（视频一个）";
        _countLabel.textColor = HEX_RGB(0x999999);
        _countLabel.font = XKFont(XK_PingFangSC_Regular, 12);
        _countLabel.textAlignment = NSTextAlignmentRight;
    }
    return _countLabel;
}

- (UICollectionView *)collectionView {
    if(!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[XKPickImgCell class] forCellWithReuseIdentifier:@"XKPickImgCell"];
    }
    return _collectionView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [[UIButton alloc]init];
        [_addButton setImage:[UIImage imageNamed:@"xk_btn_personal_uppicture"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addPictureAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}
- (XKMediaPickHelper *)bottomSheetView {
    if(!_bottomSheetView) {
        XKWeakSelf(ws);
        _bottomSheetView = [[XKMediaPickHelper alloc] init];
        _bottomSheetView.choseImageBlcok = ^(NSArray<UIImage *> * _Nullable images) {
                if (ws.dataArray.count >= 3) {
                    for (UIImage *image in images) {
                        NSLog(@"%@", image);
                        [ws.dataArray removeObjectAtIndex:0];
                    }
                }
            for (UIImage *image in images) {
                XKComplaintVideoImageModel *model = [XKComplaintVideoImageModel new];
                model.image = image;
                model.isVideo = NO;
                NSLog(@"%@", image);
                if (ws.dataArray.count >= 3) {
                    [ws.dataArray removeObjectAtIndex:0];
                }
                [ws.dataArray addObject:model];

            }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ws.collectionView reloadData];
                });
            
        };
        
        _bottomSheetView.choseVideoPathBlcok = ^(NSURL *videoURL, UIImage *coverImg) {
            NSArray *copyArray = [ws.dataArray copy];
            for (XKComplaintVideoImageModel *model in copyArray) {
                if (model.isVideo) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [XKHudView showErrorMessage:@"只能上传一个视频哦"];
                    });
                    return ;
                }
            }
            if (ws.dataArray.count >= 3) {
                [ws.dataArray removeObjectAtIndex:0];
            }
            XKComplaintVideoImageModel *model = [XKComplaintVideoImageModel new];
            model.coverImg = coverImg;
            model.isVideo = YES;
            model.videoUrl = videoURL;
            [ws.dataArray addObject:model];
            dispatch_async(dispatch_get_main_queue(), ^{
                [ws.collectionView reloadData];
            });
        };
    }
    if (_dataArray.count == 0) {
        _bottomSheetView.maxCount = 3;
        _bottomSheetView.canSelectVideo = YES;
    }else{
        _bottomSheetView.maxCount = 3 - _dataArray.count;
       __block BOOL isSelectVideo = NO;
        [_dataArray enumerateObjectsUsingBlock:^(XKComplaintVideoImageModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            if (model.isVideo) {
                isSelectVideo = NO;
                *stop = YES;
            }else{
                isSelectVideo = YES;
            }
        }];
        _bottomSheetView.canSelectVideo = isSelectVideo;
    }
    
    return _bottomSheetView;
}

- (void)addPictureAction:(UIButton *)sender {
    if (self.dataArray.count >= 3) {
        [XKHudView showTipMessage:@"已上传最大数量图片/视频" to:nil time:1.0 animated:YES completion:nil];
    }else{
        [self.bottomSheetView showView];
        if (self.block) {
            self.block();
        }
    }
}
#pragma mark collectionview代理 数据源
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XKPickImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKPickImgCell" forIndexPath:indexPath];
    XKComplaintVideoImageModel *model = self.dataArray[indexPath.row];
    if (model.isVideo) {
        cell.iconImgView.image = model.coverImg;
        cell.playBtn.hidden = NO;
    }else {
        cell.iconImgView.image = model.image;
        cell.playBtn.hidden = YES;
    }
    cell.deleteBtn.alpha = 1;
    cell.indexPath = indexPath;
    XKWeakSelf(ws);
    cell.deleteClick = ^(UIButton *sender,NSIndexPath *indexPath) {
        [ws.dataArray removeObjectAtIndex:indexPath.row];
        [ws.collectionView reloadData];
    };
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(65 * ScreenScale, 65 * ScreenScale);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if (self.selectBlock) {
        self.selectBlock(indexPath, collectionView);
    }
}

- (void)setFrame:(CGRect)frame {
    frame.size.width -= 20;
    frame.origin.x += 10;
    [super setFrame:frame];
}
@end
