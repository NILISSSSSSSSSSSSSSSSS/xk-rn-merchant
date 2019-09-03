//
//  XKGrandPrizeFeedBackViewController.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/29.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKGrandPrizeFeedBackViewController.h"
#import "XKPickImgCell.h"
#import "XKPhotoPickHelper.h"
#import <TZImagePickerController.h>
#import "XKUploadManager.h"
#import "XKAlertView.h"
#import "XKWelfareReceiveGoodSuccessViewController.h"
#import "XKUploadModel.h"

@interface XKGrandPrizeFeedBackViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UILabel *textViewPlaceholderLab;

@property (nonatomic, strong) UILabel *line;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, strong) UIButton *submitBtn;

@property (nonatomic, strong) XKPhotoPickHelper *bottomSheetView;

@end

@implementation XKGrandPrizeFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationView.backgroundColor = XKMainTypeColor;
    if (self.vcType == XKGrandPrizeFeedBackVCTypeFeedBack) {
        [self setNavTitle:@"意见反馈" WithColor:[UIColor whiteColor]];
    } else if (self.vcType == XKGrandPrizeFeedBackVCTypeShowOrder) {
        [self setNavTitle:@"晒单" WithColor:[UIColor whiteColor]];
    }
    [self initializeViews];
    [self updateViews];
}

- (void)initializeViews {
    [self.containView addSubview:self.contentView];
    [self.contentView addSubview:self.textView];
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:self.collectionView];
    [self.containView addSubview:self.submitBtn];
}

- (void)updateViews {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(10.0);
        make.top.mas_equalTo(10.0);
        make.trailing.mas_equalTo(-10.0);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(10);
        make.top.mas_equalTo(5.0);
        make.trailing.mas_equalTo(-10.0);
        make.height.mas_equalTo(150);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textView.mas_bottom).offset(5.0);
        make.leading.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(1.0);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line.mas_bottom).offset(5.0);
        make.leading.trailing.equalTo(self.contentView);
        make.height.mas_equalTo(80);
        make.bottom.mas_equalTo(self.contentView).offset(-5.0);
    }];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(10.0);
        make.top.mas_equalTo(self.contentView.mas_bottom).offset(10.0);
        make.trailing.mas_equalTo(-10.0);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark - privite method

- (void)submitBtnClick:(UIButton *)sender {
    if (!self.textView.hasText) {
        if (self.vcType == XKGrandPrizeFeedBackVCTypeFeedBack) {
            [XKHudView showErrorMessage:@"请填写反馈内容"];
        } else if (self.vcType == XKGrandPrizeFeedBackVCTypeShowOrder) {
            [XKHudView showErrorMessage:@"请填写晒单内容"];
        }
        return;
    }
    if (self.datas.count) {
        [self postUploadImgsOrVideos];
    } else {
        if (self.vcType == XKGrandPrizeFeedBackVCTypeFeedBack) {
            [self postAddFeedBack];
        } else if (self.vcType == XKGrandPrizeFeedBackVCTypeShowOrder) {
            [self postAddShowOrder];
        }
    }
}

#pragma mark - POST
// 添加意见反馈
- (void)postAddFeedBack {
    [XKHudView showLoadingTo:self.containView animated:YES];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [HTTPClient postEncryptRequestWithURLString:@"" timeoutInterval:20.0 parameters:para success:^(id responseObject) {
        [XKHudView hideHUDForView:self.containView animated:YES];
        [XKHudView showErrorMessage:@"反馈成功"];
        self.textView.text = nil;
        [self.datas removeAllObjects];
        [self.collectionView reloadData];
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.containView animated:YES];
        [XKHudView showErrorMessage:error.message];
    }];
}
// 添加晒单
- (void)postAddShowOrder {
    [XKHudView showLoadingTo:self.containView animated:YES];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [HTTPClient postEncryptRequestWithURLString:@"" timeoutInterval:20.0 parameters:para success:^(id responseObject) {
        [XKHudView hideHUDForView:self.containView animated:YES];
        [XKHudView showErrorMessage:@"晒单成功"];
        self.textView.text = nil;
        [self.datas removeAllObjects];
        [self.collectionView reloadData];
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.containView animated:YES];
        [XKHudView showErrorMessage:error.message];
    }];
}
// 上传所有的图片和视频
- (void)postUploadImgsOrVideos {
    [XKHudView showLoadingTo:self.containView animated:YES];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    for (XKUploadModel *uploadModel in self.datas) {
        if ((uploadModel.type == XKUploadModelTypeImg && uploadModel.imgUrl.length == 0) ||
            (uploadModel.type == XKUploadModelTypeVideo && uploadModel.videoUrl.length == 0)) {
            dispatch_group_enter(group);
            dispatch_group_async(group, queue, ^{
                NSString *key;
                if (self.vcType == XKGrandPrizeFeedBackVCTypeFeedBack) {
                    key = @"feedback";
                } else if (self.vcType == XKGrandPrizeFeedBackVCTypeShowOrder) {
                    key = @"showOrder";
                }
                if (uploadModel.type == XKUploadModelTypeImg) {
//                    图片
                    [[XKUploadManager shareManager] uploadImage:uploadModel.img withKey:key progress:nil success:^(NSString *key) {
                        uploadModel.imgUrl = kQNPrefix(key);
                        dispatch_group_leave(group);
                    } failure:^(NSString *error) {
                        dispatch_group_leave(group);
                    }];
                } else if (uploadModel.type == XKUploadModelTypeVideo) {
//                    视频
                    [[XKUploadManager shareManager] uploadVideoWithUrl:[NSURL URLWithString:uploadModel.videoPath] FirstImg:uploadModel.videoFirstImg WithKey:key  Progress:nil Success:^(NSString *videoKey, NSString *imgKey) {
                        uploadModel.videoUrl = kQNPrefix(videoKey);
                        uploadModel.videoFirstImgUrl = kQNPrefix(imgKey);
                        dispatch_group_leave(group);
                    } Failure:^(NSString *error) {
                        dispatch_group_leave(group);
                    }];
                }
            });
        }
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [XKHudView hideHUDForView:self.containView animated:YES];
        BOOL uploadFinished = YES;
        for (XKUploadModel *uploadModel in self.datas) {
            if ((uploadModel.type == XKUploadModelTypeImg && uploadModel.imgUrl.length == 0) ||
                (uploadModel.type == XKUploadModelTypeVideo && uploadModel.videoUrl.length == 0)) {
                uploadFinished = NO;
                break;
            }
        }
        if (uploadFinished) {
//            已全部上传成功
            if (self.vcType == XKGrandPrizeFeedBackVCTypeFeedBack) {
                [self postAddFeedBack];
            } else if (self.vcType == XKGrandPrizeFeedBackVCTypeShowOrder) {
                [self postAddShowOrder];
            }
        } else {
//            未全部上传成功
            [XKHudView showErrorMessage:@"上传失败，请重试"];
        }
    });
}

#pragma mark collectionview代理 数据源
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count == 9 ? 9 :  self.datas.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XKPickImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKPickImgCell" forIndexPath:indexPath];
    if((self.datas.count == 0) || (self.datas.count < 9 && indexPath.row == self.datas.count)) {
        cell.iconImgView.image = [UIImage imageNamed:@"xk_btn_order_addImg"];
        cell.deleteBtn.alpha = 0;
    } else {
        cell.deleteBtn.alpha = 1;
        XKUploadModel *uploadModel = self.datas[indexPath.row];
        if(uploadModel.type == XKUploadModelTypeImg) {
            cell.iconImgView.image = uploadModel.img;
        } else {
            cell.iconImgView.image = uploadModel.videoFirstImg;
        }
    }
    __weak typeof(self) weakSelf = self;
    cell.indexPath = indexPath;
    cell.deleteClick = ^(UIButton *sender,NSIndexPath *indexPath) {
        [weakSelf.datas removeObjectAtIndex:indexPath.row];
        [weakSelf.collectionView reloadData];
    };
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 80);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if((self.datas.count == 0) || (self.datas.count < 9 && indexPath.row == self.datas.count)) {
        [self.bottomSheetView showView];
    } else {
        
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark  getter setter

- (UIView *)contentView {
    if(!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 6.f;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UITextView *)textView {
    if(!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.font = XKRegularFont(14.0);
        _textView.backgroundColor = [UIColor whiteColor];
        // _placeholderLabel
        UILabel *placeHolderLabel = [[UILabel alloc] init];
        if (_vcType == XKGrandPrizeFeedBackVCTypeFeedBack) {
            placeHolderLabel.text = @"反馈描述";
        } else if (_vcType == XKGrandPrizeFeedBackVCTypeShowOrder) {
            placeHolderLabel.text = @"晒单描述";
        }
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.font = XKRegularFont(14.0);
        placeHolderLabel.textColor = [UIColor lightGrayColor];
        [placeHolderLabel sizeToFit];
        [_textView addSubview:placeHolderLabel];
        [_textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    }
    return _textView;
}

- (UILabel *)line {
    if (!_line) {
        _line = [[UILabel alloc] init];
        _line.backgroundColor = HEX_RGB(0xe5e5e5);
    }
    return _line;
}

- (UICollectionView *)collectionView {
    if(!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[XKPickImgCell class] forCellWithReuseIdentifier:NSStringFromClass([XKPickImgCell class])];
    }
    return _collectionView;
}

- (UIButton *)submitBtn {
    if(!_submitBtn) {
        _submitBtn = [[UIButton alloc] init];
        _submitBtn.layer.cornerRadius = 4;
        _submitBtn.layer.masksToBounds = YES;
        _submitBtn.titleLabel.font = XKRegularFont(17.0);
        [_submitBtn setTitle:@"确认提交" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn setBackgroundColor:XKMainTypeColor];
        [_submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

- (XKPhotoPickHelper *)bottomSheetView {
    if(!_bottomSheetView) {
        __weak typeof(self) weakSelf = self;
        _bottomSheetView = [[XKPhotoPickHelper alloc] init];
        _bottomSheetView.choseImageBlcok = ^(NSArray<UIImage *> * _Nullable images) {
            if (images.count) {
                for (UIImage *img in images) {
                    XKUploadModel *uploadModel = [[XKUploadModel alloc] init];
                    uploadModel.type = XKUploadModelTypeImg;
                    uploadModel.img = img;
                    [weakSelf.datas addObject:uploadModel];
                }
                [weakSelf.collectionView reloadData];
            }
        };
        _bottomSheetView.choseVideoPathBlcok = ^(NSString *videoPath, UIImage *coverImg) {
            XKUploadModel *uploadModel = [[XKUploadModel alloc] init];
            uploadModel.type = XKUploadModelTypeVideo;
            uploadModel.videoPath = videoPath;
            uploadModel.videoFirstImg = coverImg;
            [weakSelf.datas addObject:uploadModel];
            [weakSelf.collectionView reloadData];
        };
    }
    _bottomSheetView.maxCount = 9 - _datas.count;
    return _bottomSheetView;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

@end
