//
//  XKWelfareOpinionViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/16.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareOpinionViewController.h"
#import "XKPickImgCell.h"
#import "XKOrderEvaModel.h"
#import "XKMediaPickHelper.h"
#import "XKWelfareSubmitSuccessViewController.h"
#import "XKMallGoodsOponionResultViewController.h"
#define kOrderVideoTime 15
#define kOrderEvaCellMargin 10
#define kOrderEvaCellPadding 15

#define kOrderItemSize (int)((SCREEN_WIDTH - 2 * kOrderEvaCellMargin - 2 * kOrderEvaCellPadding) / 4)
static NSInteger const MAX_LIMIT_NUMS = 200;
@interface XKWelfareOpinionViewController () <UITextViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UITextView *inputTv;
@property (nonatomic, strong) UILabel  *tipLabel;
/**上传的图片视频collectionView视图*/
@property(nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) XKOrderEvaModel  *model;
@property (nonatomic, strong) XKMediaPickHelper  *bottomSheetView;
@end

@implementation XKWelfareOpinionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)handleData {
    [super handleData];
    _model = [[XKOrderEvaModel alloc] init];
}

- (void)addCustomSubviews {
    [self hideNavigation];
    XKWeakSelf(ws);
    XKCustomNavBar *navBar =  [[XKCustomNavBar alloc] init];
    if (self.reportType == XKReportTypeOpinion) {
         navBar.titleString = @"意见反馈";
    } else {
         navBar.titleString = @"货物报损";
    }
   
    [navBar customBaseNavigationBar];
    navBar.leftButtonBlock = ^{
        [ws.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:navBar];
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.inputTv];
    [self.bgView addSubview:self.tipLabel];
    [self.bgView addSubview:self.lineView];
    [self.view addSubview:self.submitBtn];
    [self.bgView addSubview:self.collectionView];

    [self addUIConstraint];
}

- (void)addUIConstraint {
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(self.view.mas_top).offset(10 + NavigationAndStatue_Height);
    }];
    
    [self.inputTv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.bgView);
        make.height.mas_equalTo(238 * ScreenScale);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.inputTv.mas_bottom);
    }];
    
    /**上传的图片视频collectionView视图*/
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(kOrderEvaCellPadding);
        make.right.equalTo(self.bgView.mas_right).offset(-kOrderEvaCellPadding);
        make.left.equalTo(self.bgView.mas_left).offset(kOrderEvaCellPadding);
        make.height.mas_equalTo(kOrderItemSize);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-kOrderEvaCellPadding);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputTv.mas_left).offset(15);
        make.top.equalTo(self.inputTv.mas_top).offset(15);
    }];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(25);
        make.right.equalTo(self.view.mas_right).offset(-25);
        make.top.equalTo(self.bgView.mas_bottom).offset(20);
        make.height.mas_equalTo(44);
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    if (caninputlen >= 0) {
        return YES;
    } else {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
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
    // FIXME: sy 字数限制
    NSInteger limitNum = 200;
    if (self.inputTv.text.length > limitNum) {
        self.inputTv.text = [self.inputTv.text substringToIndex:limitNum];
    }
    self.model.commentText = self.inputTv.text;
    
    if(textView.text.length == 0) {
        self.tipLabel.hidden = NO;
    } else {
        self.tipLabel.hidden = YES;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.tipLabel.hidden = YES;
    return YES;
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
      
    }
    [self.collectionView reloadData];
}

- (void)submitBtnClick:(UIButton *)sender {
    if (self.model.commentText.length < 1) {
        [XKHudView showErrorMessage:@"请输入反馈内容"];
        return;
    }
    [XKHudView showLoadingTo:self.view animated:YES];
    XKWeakSelf(ws);
    BOOL chose = NO;
    for (XKUploadMediaInfo *info in _model.mediaInfoArr) {
        if (!info.isAdd) {
            chose = YES;
        }
    }
    if (_model.mediaInfoArr.count > 0 && chose) {
        [XKUploadMediaInfo uploadMediaWithMediaArr:_model.mediaInfoArr Complete:^(NSString *error, id data) {
            BOOL finish =  [XKUploadMediaInfo checkMediaAllUploadWithMediaArr:ws.model.mediaInfoArr];
            if (!finish) {
                [XKHudView hideAllHud];
                [XKAlertView showCommonAlertViewWithTitle:@"图片上传失败，是否重新开始上传" leftText:@"取消" rightText:@"重试" leftBlock:^{
                    
                } rightBlock:^{
                    [ws commitClick:sender];
                }];
            } else {
                [ws commitClick:sender];
            }
        }];
    } else {
         [ws commitClick:sender];
    }
}

- (void)commitClick:(UIButton *)sender {
    sender.enabled = NO;
    [XKHudView showLoadingTo:self.view animated:YES];
  
    NSMutableArray *picArr = [NSMutableArray array];
    for (XKUploadMediaInfo *info in _model.mediaInfoArr) {
        if (!info.isAdd) {
           
            if (!info.isVideo) {
                [picArr addObject:@{@"pic" : info.imageNetAddr}];
     
            } else {
                [picArr addObject:@{@"video" : info.videoNetAddr,
                                    @"pic"   : info.videoFirstImgNetAddr
                                    }];
            };
        }
        
    }
    
   
    if (self.reportType == XKReportTypeOpinion) {
        NSDictionary *dic = @{
                              @"goodsId"   : _goodsId,
                              @"goodsName" : _goodsName,
                              @"content"   : self.model.commentText ?:@"",
                              @"videos"    : picArr
                              };
        [XKOrderEvaModel submitGoodsOpinionWithParm:dic Success:^(id data) {
            XKMallGoodsOponionResultViewController *result = [XKMallGoodsOponionResultViewController new];
            [self.navigationController pushViewController:result animated:YES];
            
        } failed:^(NSString *failedReason, NSInteger code) {
            [XKHudView showErrorMessage:failedReason];
        }];
    } else if (self.reportType == XKReportTypeChangeGoods) {
        NSDictionary *dic = @{
                              @"orderId"   : _orderId,
                              @"explainUrls" : picArr,
                              @"reason"   : self.model.commentText ?:@"",
                              };
        [XKOrderEvaModel submitGoodsChangeWithParm:dic Success:^(id data) {
            XKWelfareSubmitSuccessViewController *result = [XKWelfareSubmitSuccessViewController new];
            [self.navigationController pushViewController:result animated:YES];
            
        } failed:^(NSString *failedReason, NSInteger code) {
            [XKHudView showErrorMessage:failedReason];
        }];
    }


}

#pragma mark - collectionView代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.mediaInfoArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XKPickImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    XKUploadMediaInfo *mediaInfo = self.model.mediaInfoArr[indexPath.row];
    if(mediaInfo.isAdd) {
        cell.iconImgView.image = [UIImage imageNamed:@"xk_btn_order_addImg"];
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


#pragma mark 懒加载
- (UIView *)bgView {
    if(!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 8.f;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIView *)lineView {
    if(!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    }
    return _lineView;
}

- (UITextView *)inputTv {
    if(!_inputTv) {
        _inputTv = [[UITextView alloc] init];
        _inputTv.delegate = self;
        _inputTv.backgroundColor = [UIColor whiteColor];
        _inputTv.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    }
    return _inputTv;
}

- (UILabel *)tipLabel {
    if(!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textColor = UIColorFromRGB(0x999999);
        _tipLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _tipLabel.text = @"损坏描述...";
    }
    return _tipLabel;
}

- (UIButton *)submitBtn {
    if(!_submitBtn) {
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn setTitle:@"确认提交" forState:0];
        _submitBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:16];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_submitBtn setBackgroundColor:XKMainTypeColor];
        _submitBtn.layer.cornerRadius = 3.f;
        [_submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _submitBtn.layer.masksToBounds = YES;
    }
    return _submitBtn;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
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
    }
    return _collectionView;
}
@end
