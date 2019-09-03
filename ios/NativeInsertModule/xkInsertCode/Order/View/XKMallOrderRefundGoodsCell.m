//
//  XKMallOrderRefundGoodsCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/11/7.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMallOrderRefundGoodsCell.h"
#import <RZColorful.h>
#import "XKOrderEvaStarView.h"
#import "XKPickImgCell.h"
#import "XKMediaPickHelper.h"
#import "XKUploadMediaInfo.h"
#define kOrderVideoTime 15
#define kOrderEvaCellMargin 10
#define kOrderEvaCellPadding 15

#define kOrderItemSize (int)((SCREEN_WIDTH - 2 * kOrderEvaCellMargin - 2 * kOrderEvaCellPadding) / 4)
@interface XKMallOrderRefundGoodsCell () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextViewDelegate>
/**内容视图*/

@property (nonatomic, strong) UILabel  *topLabel;

/**上传的图片视频collectionView视图*/
@property (nonatomic, strong) UICollectionView *collectionView;
/**<##>*/
@property (nonatomic, strong) XKMediaPickHelper *bottomSheetView;
@end

@implementation XKMallOrderRefundGoodsCell

#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 初始化默认数据
        [self createDefaultData];
        // 初始化界面
        [self createUI];
        // 布局界面
        [self createConstraints];
        self.xk_openClip = YES;
        self.xk_radius = 6.f;
        self.xk_openClip = XKCornerClipTypeAllCorners;
    }
    return self;
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
    
}

#pragma mark - 初始化界面
- (void)createUI {
    self.contentView.backgroundColor = [UIColor whiteColor];

    _topLabel = [[UILabel alloc] init];
    _topLabel.font = XKRegularFont(14);
    _topLabel.textColor = UIColorFromRGB(0x222222);
    _topLabel.text = @"上传凭证（最多九张图片）";
    [self.contentView addSubview:_topLabel];
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
    [self.contentView addSubview:_collectionView];
}

#pragma mark - 布局界面
- (void)createConstraints {
    //    __weak typeof(self) weakSelf = self;
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kOrderEvaCellPadding);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];


    /**上传的图片视频collectionView视图*/
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(kOrderItemSize);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)setPicModel:(XKFriendCirclePublishViewModel *)picModel {
    _picModel = picModel;
  
}

- (void)setEntryType:(NSInteger)entryType {
    _entryType = entryType;
    self.topLabel.text = @"退款凭证";
//    [self.topLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView.mas_left).offset(kOrderEvaCellPadding);
//        make.top.equalTo(self.contentView.mas_top).offset(0.01);
//    }];
    [_collectionView reloadData];
}
#pragma mark - 重设数据源 处理add选项
- (void)resetMedioArr {
    if (_picModel.mediaInfoArr.count > 9) {
        [_picModel.mediaInfoArr removeLastObject];
    } else { // 小于9个肯定要加上add
        BOOL hasAdd = NO;
        for (XKUploadMediaInfo *info in _picModel.mediaInfoArr) {
            if (info.isAdd) {
                hasAdd = YES;
            }
        }
        if (hasAdd == NO) {
            XKUploadMediaInfo *add = [XKUploadMediaInfo new];
            add.isAdd = YES;
            [_picModel.mediaInfoArr addObject:add];
        }
    }
    NSInteger lines = ceil(_picModel.mediaInfoArr.count / 4.0);
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
    return _picModel.mediaInfoArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XKPickImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    XKUploadMediaInfo *mediaInfo = _picModel.mediaInfoArr[indexPath.row];
    if (self.entryType == 1) {
        cell.deleteBtn.alpha = 0;
        if (mediaInfo.isVideo) {
            [cell.iconImgView sd_setImageWithURL:[NSURL URLWithString:mediaInfo.videoFirstImgNetAddr] placeholderImage:kDefaultPlaceHolderImg];
            cell.playBtn.hidden = NO;
        } else {
            [cell.iconImgView sd_setImageWithURL:[NSURL URLWithString:mediaInfo.imageNetAddr] placeholderImage:kDefaultPlaceHolderImg];
            cell.playBtn.hidden = YES;
        }
    } else {
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
            [ws.picModel.mediaInfoArr removeObjectAtIndex:indexPath.row];
            [ws resetMedioArr];
        };
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    XKUploadMediaInfo *mediaInfo = self.picModel.mediaInfoArr[indexPath.row];
    if(mediaInfo.isAdd) {
        [self.bottomSheetView showView];
    } else {
        [self imageClick:indexPath.row];
    }
}

#pragma mark - 图片点击
- (void)imageClick:(NSInteger)imgIndex {
    XKUploadMediaInfo *info = self.picModel.mediaInfoArr[imgIndex];
    if (info.isVideo == YES) {
        if (self.entryType == 1) {
              [XKGlobleCommonTool playVideoWithUrl:[NSURL URLWithString:info.videoNetAddr]];
        } else {
             [XKGlobleCommonTool playVideoWithUrl:info.videolocalURL];
        }
       
    } else {
        if (self.entryType == 1) {
            XKUploadMediaInfo *currentInfo = info;
            NSMutableArray *imgArr = @[].mutableCopy;
            for (XKUploadMediaInfo *info in self.picModel.mediaInfoArr) {
                if (info.isVideo == NO && info.isAdd == NO) {
                    [imgArr addObject:info.imageNetAddr];
                }
            }
            NSInteger newIndex = [imgArr indexOfObject:currentInfo.imageNetAddr];
            [XKGlobleCommonTool showBigImgWithImgsArr:imgArr defualtIndex:newIndex viewController:self.getCurrentUIVC];
        } else {
            XKUploadMediaInfo *currentInfo = info;
            NSMutableArray *imgArr = @[].mutableCopy;
            for (XKUploadMediaInfo *info in self.picModel.mediaInfoArr) {
                if (info.isVideo == NO && info.isAdd == NO) {
                    [imgArr addObject:info.image];
                }
            }
            NSInteger newIndex = [imgArr indexOfObject:currentInfo.image];
            [XKGlobleCommonTool showBigImgWithImgsArr:imgArr defualtIndex:newIndex viewController:self.getCurrentUIVC];
        }

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
                [ws.picModel.mediaInfoArr insertObject:info atIndex:ws.picModel.mediaInfoArr.count - 1];
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
                        [ws.picModel.mediaInfoArr insertObject:info atIndex:ws.picModel.mediaInfoArr.count - 1];
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
    _bottomSheetView.maxCount = 9 - self.picModel.mediaInfoArr.count + 1;
    BOOL noVideo = YES;
    for (XKUploadMediaInfo * info in self.picModel.mediaInfoArr) {
        if (!info.isAdd && info.isVideo) {
            noVideo = NO;
        }
    }
    _bottomSheetView.canSelectVideo = noVideo;
    return _bottomSheetView;
}


@end
