/*******************************************************************************
 # File        : XKFriendCirclePublishController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/8
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKFriendCirclePublishController.h"
#import "XKSectionHeaderArrowView.h"
#import "XKChooseMediaCell.h"
#import "XKUploadMediaInfo.h"
#import "XKMediaPickHelper.h"
#import "BigPhotoPerviewHeader.h"
#import "UIImage+Reduce.h"
#import "XKFriendCirclePublishViewModel.h"
#import "XKVisibleAuthorityController.h"
#import <IQKeyboardManager.h>
#import "XKEmojiTextView.h"

#define kItemSpace 5

#define kItemWidth  ((int)((SCREEN_WIDTH + 5 - 20 - 15 * 2 - kItemSpace * 2) / 3))

@interface XKFriendCirclePublishController () <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, UITextViewDelegate> {
}
/**输入框*/
@property(nonatomic, strong) XKEmojiTextView *textView;
/**collectionView*/
@property(nonatomic, strong) UICollectionView *collectionView;
/**设置view*/
@property(nonatomic, strong) XKSectionHeaderArrowView *settingView;

/**<##>*/
@property(nonatomic, strong) XKMediaPickHelper *bottomSheetView;
/**<##>*/
@property(nonatomic, strong) XKFriendCirclePublishViewModel *viewModel;
/**<##>*/
@property(nonatomic, strong) UIButton *publishBtn;
@end

@implementation XKFriendCirclePublishController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
  [super viewDidLoad];
  // 初始化默认数据
  [self createDefaultData];
  // 初始化界面
  [self createUI];
  [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
  [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
}

- (void)dealloc {
  NSLog(@"=====%@被销毁了=====", [self class]);
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
  _viewModel = [[XKFriendCirclePublishViewModel alloc] init];
}

#pragma mark - 初始化界面
- (void)createUI {
  _publishBtn  = [UIButton new];
  _publishBtn.frame = CGRectMake(0, 0, XKViewSize(40), 40);
  [_publishBtn setTitle:@"发表" forState:UIControlStateNormal];
  [_publishBtn setTitleColor:RGBGRAY(220) forState:UIControlStateDisabled];
  _publishBtn.titleLabel.font = XKMediumFont(17);
  [_publishBtn sizeToFit];
  [_publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [_publishBtn addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside];
  _publishBtn.enabled = NO;
  [self setRightView:_publishBtn withframe:_publishBtn.frame];
  [self createContent];
}

- (void)createContent {
  UIView *contentView = [[UIView alloc] init];
  contentView.backgroundColor = [UIColor whiteColor];
  [self.containView addSubview:contentView];
  contentView.layer.cornerRadius = 5;
  
  [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.containView.mas_top).offset(10);
    make.left.equalTo(self.containView.mas_left).offset(10);
    make.right.equalTo(self.containView.mas_right).offset(-10);
  }];
  
  // 添加textView
  _textView = [[XKEmojiTextView alloc] init];
  [contentView addSubview:_textView];
  _textView.font = XKRegularFont(14);
  _textView.delegate = self;
  _textView.textColor = HEX_RGB(0x555555);
  [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(contentView.mas_top).offset(10);
    make.left.equalTo(contentView.mas_left).offset(15);
    make.right.equalTo(contentView.mas_right).offset(-15);
    make.height.equalTo(@120);
  }];
  [_textView becomeFirstResponder];
  
  // 添加照片选择
  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  
  layout.itemSize = CGSizeMake(kItemWidth, kItemWidth);
  layout.minimumLineSpacing = kItemSpace;
  layout.minimumInteritemSpacing = kItemSpace;
  _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
  [contentView addSubview:_collectionView];
  _collectionView.delegate = self;
  _collectionView.dataSource = self;
  _collectionView.backgroundColor = [UIColor whiteColor];
  [_collectionView registerClass:[XKChooseMediaCell class] forCellWithReuseIdentifier:@"cell"];
  
  [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.textView.mas_bottom).offset(15);
    make.left.equalTo(contentView.mas_left).offset(15);
    make.right.equalTo(contentView.mas_right).offset(-10);
    make.height.equalTo(@kItemWidth);
  }];
  __weak typeof(self) weakSelf = self;
  UIView *line = [[UIView alloc] init];
  line.backgroundColor = HEX_RGB(0xF1F1F1);
  [contentView addSubview:line];
  [line mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.equalTo(contentView);
    make.top.equalTo(self.collectionView.mas_bottom).offset(20);
    make.height.equalTo(@1);
  }];
  
  _settingView = [XKSectionHeaderArrowView new];
  [_settingView.titleLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
    confer.appendImage(IMG_NAME(@"ic_btn_msg_circle_eye")).bounds(CGRectMake(0, -3, 16, 16));
    ;
    confer.text(@" 设置可见");
  }];
  _settingView.detailLabel.text = @"公开";
  [_settingView.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.settingView.mas_centerY).offset(-4);
  }];
  [_settingView.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.settingView).offset(1.5);
  }];
  [contentView addSubview:_settingView];
  [_settingView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(line.mas_bottom).offset(3);
    make.left.right.equalTo(contentView);
    make.height.equalTo(@50);
    make.bottom.equalTo(contentView.mas_bottom).offset(-5);
  }];
  
  [_settingView bk_whenTapped:^{
    [weakSelf setVisual];
  }];
}

#pragma mark - 设置可见
- (void)setVisual {
  XKVisibleAuthorityController *vc = [[XKVisibleAuthorityController alloc] init];
  vc.result = self.viewModel.dynamicAuthResult;
  __weak typeof(self) weakSelf = self;
  [vc setResultBlock:^(XKVisiblelAuthorityResult *result) {
    weakSelf.viewModel.dynamicAuthResult = result;
    weakSelf.settingView.detailLabel.text = [result getDynamicDisplayInfo];
  }];
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 发表事件
- (void)publish {
  [self.view endEditing:YES];
  if (![self checkData]) {
    [XKHudView showTipMessage:@"发布内容不能为空哦"];
    return;
  }
  __weak typeof(self) weakSelf = self;
  [XKHudView showLoadingTo:self.containView animated:YES];
  self.publishBtn.userInteractionEnabled = NO;
  [self.viewModel requestPublishComplete:^(NSString *error, id data) {
    [XKHudView hideHUDForView:weakSelf.containView animated:YES];
    if (error) {
      self.publishBtn.userInteractionEnabled = YES;
      [XKHudView showErrorMessage:error to:weakSelf.containView animated:YES];;
    } else {
      [XKHudView showSuccessMessage:@"发布成功" to:self.containView time:2 animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                       ^{
                         EXECUTE_BLOCK(self.publishSuccess);
                       });
        [weakSelf.navigationController popViewControllerAnimated:YES];
      }];
    }
  }];
}

#pragma mark - 设置按钮禁用状态
- (void)resetPublishBtnStatus {
  if ([self checkData]) {
    _publishBtn.enabled = YES;
  } else {
    _publishBtn.enabled = NO;
  }
}

#pragma mark - 检测数据
- (BOOL)checkData {
  if (![self.viewModel.contentStr isExist] && [self.viewModel getMediaArray].count == 0) {
    //        [XKHudView showTipMessage:@"发布内容不能为空哦"];
    return NO;
  }
  return YES;
}

#pragma mark - 重设高度
- (void)resetMedioHeight {
  dispatch_async(dispatch_get_main_queue(), ^{
    NSInteger lines = ceil(self.viewModel.mediaInfoArr.count / 3.0);
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
      make.height.mas_equalTo(kItemWidth * lines + kItemSpace * (lines - 1));
    }];
  });
}

- (void)reloadData {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self resetPublishBtnStatus];
    [self.collectionView reloadData];
  });
}

#pragma mark - textView代理
- (void)textViewDidChange:(UITextView *)textView {
  self.viewModel.contentStr = textView.text;
  [self resetPublishBtnStatus];
}

#pragma mark - collectionView代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.viewModel.mediaInfoArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  XKChooseMediaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
  XKUploadMediaInfo *mediaInfo = self.viewModel.mediaInfoArr[indexPath.row];
  if(mediaInfo.isAdd) {
    cell.iconImgView.image = [UIImage imageNamed:@"xk_btn_friendsCirclePermissions_add"];
    cell.deleteBtn.alpha = 0;
  } else {
    cell.deleteBtn.alpha = 1;
    cell.iconImgView.image = mediaInfo.image;
  }
  XKWeakSelf(ws);
  cell.indexPath = indexPath;
  cell.deleteClick = ^(UIButton *sender,NSIndexPath *indexPath) {
    [ws.viewModel.mediaInfoArr removeObjectAtIndex:indexPath.row];
    [ws.viewModel resetMedioArr];
    [ws resetMedioHeight];
    [ws reloadData];
  };
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  [collectionView deselectItemAtIndexPath:indexPath animated:NO];
  [KEY_WINDOW endEditing:YES];
  XKUploadMediaInfo *mediaInfo = self.viewModel.mediaInfoArr[indexPath.row];
  if(mediaInfo.isAdd) {
    [self.bottomSheetView showView];
  } else {
    // 如果是视频 就播放
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"isVideo = YES"];
    NSArray *videos = [self.viewModel.mediaInfoArr filteredArrayUsingPredicate:pre];
    if (videos.count == 0) { // 没有视频
      NSMutableArray *models = [NSMutableArray array];
      for (XKUploadMediaInfo *imgModel in self.viewModel.mediaInfoArr) {
        if (!imgModel.isAdd && !imgModel.isVideo) {
          PhotoPreviewModel *model = [[PhotoPreviewModel alloc] init];
          model.thumbImage = imgModel.image;
          [models addObject:model];
        }
      }
      __weak typeof(self) weakSelf = self;
      // 如果是图片就预览
      BigPhotoPreviewDeleteController *photoPreviewController = [[BigPhotoPreviewDeleteController alloc] init];
      photoPreviewController.models = models;
      photoPreviewController.currentIndex = indexPath.row;
      [photoPreviewController setDeleteComplete:^(NSInteger index) {
        [weakSelf.viewModel.mediaInfoArr removeObjectAtIndex:indexPath.row];
        [weakSelf.viewModel resetMedioArr];
        [weakSelf resetMedioHeight];
        [weakSelf reloadData];
      }];
      [self presentViewController:photoPreviewController animated:YES completion:nil];
    } else {
      XKUploadMediaInfo *media = self.viewModel.mediaInfoArr.firstObject;
      [XKGlobleCommonTool playVideoWithUrl:media.videolocalURL];
    }
  }
}

- (XKMediaPickHelper *)bottomSheetView {
  if(!_bottomSheetView) {
    XKWeakSelf(ws);
    _bottomSheetView = [[XKMediaPickHelper alloc] init];
    _bottomSheetView.videoMaxSecond = 15;
    _bottomSheetView.choseImageBlcok = ^(NSArray<UIImage *> * _Nullable images) {
      for (UIImage *image in images) {
        XKUploadMediaInfo *info = [XKUploadMediaInfo new];
        info.isVideo = NO;
        info.image = image;
        [ws.viewModel.mediaInfoArr insertObject:info atIndex:ws.viewModel.mediaInfoArr.count - 1];
      }
      [ws.viewModel resetMedioArr];
      [ws resetMedioHeight];
      [ws reloadData];
    };
    
    _bottomSheetView.choseVideoPathBlcok = ^(NSURL *videoURL, UIImage *coverImg) {
      XKUploadMediaInfo *info = [XKUploadMediaInfo new];
      info.isVideo = YES;
      info.image = coverImg;
      info.videolocalURL = videoURL;
      [ws.viewModel.mediaInfoArr addObject:info];
      [ws.viewModel resetMedioArr];
      [ws resetMedioHeight];
      [ws reloadData];
    };
  }
  _bottomSheetView.maxCount = 9 - self.viewModel.mediaInfoArr.count + 1;
  if ([self canSelectVideo]) {
    _bottomSheetView.canSelectVideo = YES;
  } else {
    _bottomSheetView.canSelectVideo = NO;
  }
  return _bottomSheetView;
}

// 能否选视频
- (BOOL)canSelectVideo {
  return [self.viewModel getMediaArray].count == 0 ? YES : NO;
}

@end
