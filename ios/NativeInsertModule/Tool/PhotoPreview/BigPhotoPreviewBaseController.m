/*******************************************************************************
 # File        : BigPhotoPreviewBaseController.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/20
 # Corporation : 水木科技
 # Description :
 浏览大图的基类 需要其他功能的时候需要继承然后定制
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)
#define iOS10Later ([UIDevice currentDevice].systemVersion.floatValue >= 10.0f)

#define kCurrentTitleStr(title,index,totalCount) [NSString stringWithFormat:@"%@ %ld / %ld",title,(long)index,(long)totalCount]

#import "BigPhotoPreviewBaseController.h"
#import "PhotoPreviewCollectionCell.h"
#import "PhotoPreviewModel.h"
#import "XKBottomAlertSheetView.h"
//#import <NSString+Utils.h>
#import "XKCommonAlertView.h"

@interface BigPhotoPreviewBaseController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

/**collectionView*/
@property (nonatomic, strong) UICollectionView *collectionView;
/**导航条*/
@property (nonatomic, strong) UIView *naviBar;
/**返回按钮*/
@property (nonatomic, strong) UIButton *backButton;
/**标题Label*/
@property (nonatomic, strong) UILabel *titleLabel;
/**删除按钮*/
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation BigPhotoPreviewBaseController

- (instancetype)init {
	self = [super init];
	if (self) {
		_isShowTitle = YES;
		_isSupportLongPress = YES;
		_isShowNav = NO;
        _longPressOptions = @[kLongPressOptionsSavePhoto];
	}
	return self;
}

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
	// 初始化默认数据
	[self createData];
	// 初始化界面
	[self createView];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.navigationController.navigationBar.hidden = YES;
	if (!_isShowStatusBar) {
		if (iOS7Later) //[UIApplication sharedApplication].statusBarHidden = YES;
            [self prefersStatusBarHidden];
	}
	if (_currentIndex) [_collectionView setContentOffset:CGPointMake((self.view.width + 20) * _currentIndex, 0) animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.navigationController.navigationBar.hidden = NO;
	if (!_isShowStatusBar) {
		if (iOS7Later) //[UIApplication sharedApplication].statusBarHidden = NO;
			[self prefersStatusBarHidden];
	}
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (void)dealloc {
	NSLog(@"=====%@被销毁了=====", [self class]);
}

- (BOOL)prefersStatusBarHidden {
	return !_isShowStatusBar;
}

#pragma mark - 初始化默认数据
- (void)createData {
	if (_models.count == 0 || _models == nil) {
		_models = [NSMutableArray array];
	}
}

#pragma mark - 初始化界面
- (void)createView {
	[self configCollectionView];
	if (_isShowNav) {
		[self configCustomNaviBar];
	}
	self.view.clipsToBounds = YES;
}

- (void)configCollectionView {
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	layout.itemSize = CGSizeMake(self.view.width + 20, self.view.height);
	layout.minimumInteritemSpacing = 0;
	layout.minimumLineSpacing = 0;
	_collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-10, 0, self.view.width + 20, self.view.height) collectionViewLayout:layout];
	_collectionView.backgroundColor = [UIColor blackColor];
	_collectionView.dataSource = self;
	_collectionView.delegate = self;
	_collectionView.pagingEnabled = YES;
	_collectionView.scrollsToTop = NO;
	_collectionView.showsHorizontalScrollIndicator = NO;
	_collectionView.contentOffset = CGPointMake(0, 0);
	_collectionView.contentSize = CGSizeMake(self.models.count * (self.view.width + 20), 0);
	[self.view addSubview:_collectionView];
	[_collectionView registerClass:[PhotoPreviewCollectionCell class] forCellWithReuseIdentifier:@"PhotoPreviewCollectionCell"];
}

- (void)configCustomNaviBar {
	_naviBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, NavigationAndStatue_Height)];
    _naviBar.backgroundColor = _navColor ?: [UIColor clearColor]; //kNavGlobalDefautColor;
	_naviBar.hidden = !_isShowNav;
	
	_backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _isShowStatusBar ? kStatusBarHeight : kStatusBarHeight - 10, NavigationBar_HEIGHT, NavigationBar_HEIGHT)];
	[_backButton setImage:[UIImage imageNamed:@"PhotoPreview.bundle/CDPBack"] forState:UIControlStateNormal];
	[_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
	[_naviBar addSubview:_backButton];
	
	self.deleteButton.frame = CGRectMake(SCREEN_WIDTH - 49, _isShowStatusBar ? kStatusBarHeight : kStatusBarHeight - 10, NavigationBar_HEIGHT, NavigationBar_HEIGHT);
	[_naviBar addSubview:_deleteButton];
	
    if (_isSave) {//发票保存的时候用
        _deleteButton.hidden = NO;
        [_deleteButton setImage:[UIImage imageNamed:@"xk_ic_order_save"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
       
    } else {
        _deleteButton.hidden = _isHiddenDeleteButton;
        [_deleteButton setImage:[UIImage imageNamed:@"PhotoPreview.bundle/deleteMessage"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
	self.titleLabel.frame = CGRectMake(0, _isShowStatusBar ? kStatusBarHeight : kStatusBarHeight - 10, 200, NavigationBar_HEIGHT);
	_titleLabel.centerX = _naviBar.centerX;
    
    if (self.isHiddenIndex) {
      _titleLabel.text = [_strNavTitle isExist] ? _strNavTitle : @"";
    } else {
     _titleLabel.text = kCurrentTitleStr([_strNavTitle isExist] ? _strNavTitle : @"", _currentIndex + 1, _models.count);
    }
	_titleLabel.textColor = RGBGRAY(255);
	_titleLabel.font = XKMediumFont(18);
	_titleLabel.textAlignment = NSTextAlignmentCenter;
	[_naviBar addSubview:_titleLabel];
	[self.view addSubview:_naviBar];
}

#pragma mark ----------------------------- 其他方法 ------------------------------
#pragma mark - 返回
- (void)backButtonClick {
	if (self.navigationController) {
		if (self.navigationController.viewControllers.count < 2) {
			[self.navigationController dismissViewControllerAnimated:YES completion:nil];
			return;
		}
		[self.navigationController popViewControllerAnimated:NO];
		return;
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 删除
- (void)deleteButtonClick {
	__weak typeof(self) weakSelf = self;;
    XKBottomAlertSheetView *view = [[XKBottomAlertSheetView  alloc] initWithBottomSheetViewWithDataSource:@[@"确认删除这张照片？",@"确认",@"取消"] firstTitleColor:nil choseBlock:^(NSInteger index, NSString *choseTitle) {
        if (index == 1) {
            [weakSelf deletePhotoDataAction];
        }
    }];
    [view show];
}
#pragma mark - 保存
- (void)saveButtonClick {
    __weak typeof(self) weakSelf = self;
    PhotoPreviewModel *model  = self.models.firstObject;
    XKBottomAlertSheetView *view = [[XKBottomAlertSheetView  alloc] initWithBottomSheetViewWithDataSource:@[@"确认保存这张照片到相册？",@"确认",@"取消"] firstTitleColor:nil choseBlock:^(NSInteger index, NSString *choseTitle) {
        if (index == 1) {
            
            UIImage *img = [[SDImageCache sharedImageCache] imageFromCacheForKey:model.imageURL];
            UIImageWriteToSavedPhotosAlbum(img, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    }];
    [view show];
}


#pragma mark -- <保存到相册>
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [XKHudView hideHUDForView:nil];
    if(error) {
        [XKHudView showWarnMessage:@"保存图片失败"];
    } else {
        [XKHudView showSuccessMessage:@"已保存到相册"];
    }
}

#pragma mark - 转发
- (void)sendImageToFriendAction:(PhotoPreviewModel *)model {
	// 转发事件 子类重写
}

#pragma mark - 删除图片
- (void)deletePhotoDataAction {
	// 删除事件 子类重写
}

#pragma mark - 滚动完成后需要做的事
- (void)scrollCompleteActionWithIndex:(NSInteger)index {
	// 子类重写
}

#pragma mark - 删除图片成功的处理
- (void)handleDeletePhotoAction:(PhotoPreviewModel *)deleteModel completeBlock:(void(^)(NSInteger deleteIndex))completeBlock {
	NSInteger deleteIndex = self.currentIndex;
	[self.models removeObjectAtIndex:self.currentIndex];
	self.currentIndex --;
	__weak typeof(self) weakSelf = self;;
	if (self.currentIndex < 0) {
		self.currentIndex = 0;
	}
	if (self.models.count == 0) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[weakSelf backButtonClick];
			return;
		});
	}
	dispatch_async(dispatch_get_main_queue(), ^{
		if (weakSelf.currentIndex >= 0) {
			[weakSelf.collectionView setContentOffset:CGPointMake((weakSelf.view.width + 20) * weakSelf.currentIndex, 0) animated:YES];
		}
		weakSelf.titleLabel.text = kCurrentTitleStr([weakSelf.strNavTitle isExist] ? weakSelf.strNavTitle : @"", weakSelf.currentIndex + 1, weakSelf.models.count);
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[weakSelf.collectionView reloadData];
			EXECUTE_BLOCK(completeBlock, deleteIndex);
		});
	});
}

#pragma mark ----------------------------- 公用方法 ------------------------------

#pragma mark ----------------------------- 代理方法 ------------------------------
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	CGFloat offSetWidth = scrollView.contentOffset.x;
	offSetWidth = offSetWidth + ((self.view.width + 20) * 0.5);
	
	NSInteger currentIndex = offSetWidth / (self.view.width + 20);
	if (currentIndex < _models.count && _currentIndex != currentIndex) {
		_currentIndex = currentIndex;
	}
	// 滚动完成后需要做的事
	[self scrollCompleteActionWithIndex:_currentIndex];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.isHiddenIndex) {
        _titleLabel.text = [_strNavTitle isExist] ? _strNavTitle : @"";
    } else {
        _titleLabel.text = kCurrentTitleStr([_strNavTitle isExist] ? _strNavTitle : @"", _currentIndex + 1, _models.count);
    }
}

#pragma mark - UICollectionViewDataSource && Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	PhotoPreviewCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoPreviewCollectionCell" forIndexPath:indexPath];
	cell.model = _models[indexPath.row];
	cell.isSupportLongPress = _isSupportLongPress;
    cell.longPressOptions = _longPressOptions;
	__weak typeof(self) weakSelf = self;;
	if (!cell.singleTapGestureBlock) {
		cell.singleTapGestureBlock = ^(){
			[weakSelf backButtonClick];
		};
	}
	if (!cell.sendImageToFriendBlock) {
		cell.sendImageToFriendBlock = ^(PhotoPreviewModel *model){
			[weakSelf sendImageToFriendAction:model];
		};
	}
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
	if ([cell isKindOfClass:[PhotoPreviewCollectionCell class]]) {
		[(PhotoPreviewCollectionCell *)cell recoverSubviews];
	}
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
	if ([cell isKindOfClass:[PhotoPreviewCollectionCell class]]) {
		[(PhotoPreviewCollectionCell *)cell recoverSubviews];
	}
}

#pragma mark --------------------------- setter&getter -------------------------
- (void)setIsHiddenDeleteButton:(BOOL)isHiddenDeleteButton {
	_isHiddenDeleteButton = isHiddenDeleteButton;
	if (_deleteButton) {
		_deleteButton.hidden = _isHiddenDeleteButton;
	}
}

- (void)setIsShowTitle:(BOOL)isShowTitle {
	_isShowTitle = isShowTitle;
	self.titleLabel.hidden = !isShowTitle;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    return _titleLabel;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton new];
    }
    return _deleteButton;
}

- (void)setIsSave:(BOOL)isSave {
    _isSave = isSave;
}

@end
