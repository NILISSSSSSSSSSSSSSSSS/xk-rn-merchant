//
//  XKWelfareGoodsDestoryReportViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/30.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareGoodsDestoryReportViewController.h"
#import "XKPickImgCell.h"
#import "XKPhotoPickHelper.h"
#import <TZImagePickerController.h>
#import "XKUploadManager.h"
#import "XKAlertView.h"
#import "XKWelfareReceiveGoodSuccessViewController.h"
@interface XKWelfareGoodsDestoryReportViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>
@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)UIButton *submitBtn;
@property (nonatomic, strong)UITextView *inputTv;
@property (nonatomic, copy)NSString *placeHolderStr;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray *imgArr;
@property (nonatomic, strong)UIImage *uploadVideoImg;
@property (nonatomic, strong)XKPhotoPickHelper *bottomSheetView;
@end

@implementation XKWelfareGoodsDestoryReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)handleData {
    [super handleData];
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6);
    _placeHolderStr = @"损坏描述…";
    _imgArr = [NSMutableArray array];

}

- (void)addCustomSubviews {
    [self hideNavigation];
    XKWeakSelf(ws);
    XKCustomNavBar *navBar =  [[XKCustomNavBar alloc] init];
    navBar.titleString = @"货物报损";
    [navBar customBaseNavigationBar];
    navBar.leftButtonBlock = ^{
        [ws.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:navBar];
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.submitBtn];
    
    [self.bgView addSubview:self.inputTv];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 159, SCREEN_WIDTH - 20, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    [self.bgView addSubview:lineView];
    [self.bgView addSubview:self.collectionView];
    
    [self addUIContains];
}

- (void)addUIContains {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10 );
        make.top.equalTo(self.view.mas_top).offset(10 + kIphoneXNavi(64));
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(240);
    }];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.top.equalTo(self.bgView.mas_bottom).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(44);
    }];
    
    [self.inputTv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.top.equalTo(self.bgView.mas_top).offset(5);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(150);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.bgView);
        make.height.mas_equalTo(80);
    }];
}

- (void)submitBtnClick:(UIButton *)sender {
    XKWelfareReceiveGoodSuccessViewController *success = [XKWelfareReceiveGoodSuccessViewController new];
    [self.navigationController pushViewController:success animated:YES];
 /*
    __block NSMutableArray *uploadImgArr = [NSMutableArray array];
    __block NSString *uploadVideoPath = nil;
    [_imgArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[UIImage class]]) {
            [uploadImgArr addObject:obj];
        } else if ([obj isKindOfClass:[NSString class]]) {
            uploadVideoPath = obj;
        }
    }];
    
    if(_imgArr.count > 0) {
        [[XKUploadManager shareManager] uploadImagesWithImagesArray:uploadImgArr AtIndex:0 Progress:^(CGFloat progress) {
            [SVProgressHUD showProgress:progress status:@"upload"];
        } Success:^(NSArray *keyArray) {
            [SVProgressHUD dismiss];
            if(uploadVideoPath) {
                [[XKUploadManager shareManager] uploadFileWithFilePath:uploadVideoPath WithKey:nil Progress:nil Success:^(NSString *key, NSString *hash) {
                    [XKHudView showSuccessMessage:@"上传成功"];
                } Failure:^(id data) {
                    [XKHudView showSuccessMessage:@"视频上传失败"];
                }];
            }
            NSLog(@"%@",keyArray);
        } Failure:^(NSString *error) {
            [SVProgressHUD dismiss];
            [XKHudView showErrorMessage:error];
        }];
    }
  */
    

}

#pragma mark collectionview代理 数据源
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imgArr.count == 9 ? 9 :  _imgArr.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XKPickImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKPickImgCell" forIndexPath:indexPath];
    if((_imgArr.count == 0) || (_imgArr.count < 9 && indexPath.row == _imgArr.count)) {
        cell.iconImgView.image = [UIImage imageNamed:@"xk_btn_order_addImg"];
        cell.deleteBtn.alpha = 0;
    } else {
        cell.deleteBtn.alpha = 1;
        if([_imgArr[indexPath.row] isKindOfClass:[NSString class]]) {//视频路径
            cell.iconImgView.image = _uploadVideoImg;
        } else {
            cell.iconImgView.image = _imgArr[indexPath.row];
        }
       
    }
    XKWeakSelf(ws);
    cell.indexPath = indexPath;
    cell.deleteClick = ^(UIButton *sender,NSIndexPath *indexPath) {
        [ws.imgArr removeObjectAtIndex:indexPath.row];
        [ws.collectionView reloadData];
    };
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 80);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if((_imgArr.count == 0) || (_imgArr.count < 9 && indexPath.row == _imgArr.count)) {
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

#pragma mark  懒加载
- (UICollectionView *)collectionView {
    if(!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH - 20, 80) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
       [_collectionView registerClass:[XKPickImgCell class] forCellWithReuseIdentifier:@"XKPickImgCell"];
//        [_collectionView registerClass:[XKWelfareListDoubleCell class] forCellWithReuseIdentifier:@"XKWelfareListDoubleCell"];
        
    }
    return _collectionView;
}

- (UIView *)bgView {
    if(!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 236)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 6.f;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIButton *)submitBtn {
    if(!_submitBtn) {
        _submitBtn = [[UIButton alloc] init];
        _submitBtn.layer.cornerRadius = 4;
        _submitBtn.layer.masksToBounds = YES;
        _submitBtn.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:17];
        [_submitBtn setTitle:@"确认提交" forState:0];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_submitBtn setBackgroundColor:XKMainTypeColor];
        [_submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

- (UITextView *)inputTv {
    if(!_inputTv) {
       _inputTv = [[UITextView alloc] init];
       [_inputTv setBackgroundColor:[UIColor clearColor]];
        // _placeholderLabel
        UILabel *placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.text = _placeHolderStr;
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.textColor = [UIColor lightGrayColor];
        [placeHolderLabel sizeToFit];
        [_inputTv addSubview:placeHolderLabel];
        // same font
        _inputTv.font = [UIFont systemFontOfSize:14.f];
        placeHolderLabel.font = [UIFont systemFontOfSize:14.f];
        [_inputTv setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    }
    return _inputTv;
}

- (XKPhotoPickHelper *)bottomSheetView {
    if(!_bottomSheetView) {
        XKWeakSelf(ws);
        _bottomSheetView = [[XKPhotoPickHelper alloc] init];
        _bottomSheetView.choseImageBlcok = ^(NSArray<UIImage *> * _Nullable images) {
            [ws.imgArr addObjectsFromArray:images];
            [ws.collectionView reloadData];
        };
        
        _bottomSheetView.choseVideoPathBlcok = ^(NSString *videoPath, UIImage *coverImg) {
            [ws.imgArr addObject:videoPath];
            ws.uploadVideoImg = coverImg;
            [ws.collectionView reloadData];
        };
    }
    _bottomSheetView.maxCount = 9 - _imgArr.count;
    return _bottomSheetView;
}

@end
