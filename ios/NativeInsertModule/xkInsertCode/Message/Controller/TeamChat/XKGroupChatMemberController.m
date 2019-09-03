/*******************************************************************************
 # File        : XKGroupChatMemberController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/11/16
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKGroupChatMemberController.h"
#import "XKChooseMediaCell.h"
#import "UTPinYinHelper.h"

@interface XKGroupChatMemberController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,XKGroupChatSettingViewModelDelegate,UITextFieldDelegate>

@property(nonatomic, strong) UICollectionView *collectionView;
/**<##>*/
@property(nonatomic, strong) UIScrollView *scrollView;
/**<##>*/
@property(nonatomic, strong) UIView *searchView;
/**<##>*/
@property(nonatomic, strong) UITextField *searchField;

@property(nonatomic, assign) BOOL searchStatus;
@property(nonatomic, strong) NSMutableArray *searchArray;
@end

@implementation XKGroupChatMemberController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)dealloc {
    NSLog(@"=====%@被销毁了=====", [self class]);
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
  _searchArray = [NSMutableArray array];
}

#pragma mark - 初始化界面
- (void)createUI {
    _scrollView = [UIScrollView new];
    [self.containView addSubview:_scrollView];
    _scrollView.backgroundColor = HEX_RGB(0xEEEEEE);
    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
  if (self.viewModel.isOffical) {
    [self createSearchView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self.searchView.mas_bottom).offset(1);
      make.left.right.bottom.equalTo(self.containView);
    }];
  } else {
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.containView);
    }];
  }
  
    [self createCollectionView];
    [self reloadTotalUI];
}

- (void)setViewModel:(XKGroupChatSettingViewModel *)viewModel {
    _viewModel = viewModel;
    _viewModel.delegate = self;
}

- (void)refreshTableView {
    [self reloadTotalUI];
}

- (void)reloadTotalUI {
  NSInteger itemsCount;
  if (self.searchStatus) {
    itemsCount = self.searchArray.count;
  } else {
    [self.viewModel rebuildTotalUserAndAddDeleteArray];
    itemsCount = [self.viewModel.totalUserAndAddDeleteArray count];
  }
  if (itemsCount == 0) {
    self.scrollView.hidden = YES;
  } else {
    self.scrollView.hidden = NO;
  }
  
  NSInteger lineNum = ceil(itemsCount * 1.0 / kItemLineNum);
  CGFloat height = kItemTopBtm * 2 + lineNum * kItemHeight +  (lineNum - 1) *kItemSpace;
  [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
    make.height.mas_equalTo(height);
  }];
  self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, height>SCREEN_HEIGHT -NavigationAndStatue_Height  ?height + 20:SCREEN_HEIGHT - NavigationAndStatue_Height + 1);
  [self.collectionView reloadData];
  if (!self.searchStatus) {
    NSString *str = [NSString stringWithFormat:@"群成员(%ld)",self.viewModel.getSettingModel.userArray.count];
   [self setNavTitle:str WithColor:[UIColor whiteColor]];
  }
}

- (void)createCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kItemWidth, kItemHeight);
    layout.minimumLineSpacing = kItemSpace;
    layout.minimumInteritemSpacing = kItemSpace;
    layout.sectionInset = UIEdgeInsetsMake(kItemTopBtm,kItemSpace,kItemSpace, kItemSpace);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.layer.masksToBounds = YES;
    _collectionView.layer.cornerRadius = 8;
    _collectionView.scrollEnabled = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[XKChooseMediaCell class] forCellWithReuseIdentifier:@"cell"];
    [_scrollView addSubview:_collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView);
        make.left.equalTo(self.scrollView.mas_left).offset(kItemSpace);
        make.top.equalTo(self.scrollView.mas_top).offset(10);
        make.height.equalTo(@1);
    }];
}

#pragma mark ----------------------------- 其他方法 ------------------------------
- (void)createSearchView {
  _searchView = [UIView new];
  _searchView.backgroundColor = [UIColor whiteColor];
  _searchView.xk_openClip = YES;
  _searchView.xk_radius = 8;
  _searchView.xk_clipType = XKCornerClipTypeAllCorners;
  self.searchView.frame = CGRectMake(10, 10, SCREEN_WIDTH - 2 *10, 44);
  [self.containView addSubview:self.searchView];
  
  UIImageView *imageView = [[UIImageView alloc] init];
  imageView.image = self.navStyle == BaseNavWhiteStyle ? IMG_NAME(@"xk_ic_search_xi") : IMG_NAME(@"xk_ic_contact_search");
  imageView.contentMode = UIViewContentModeScaleAspectFit;
  [_searchView addSubview:imageView];
  [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.searchView.mas_left).offset(10);
    make.height.equalTo(@16);
    make.centerY.equalTo(self.searchView);
    make.width.equalTo(@26);
  }];
  
  self.searchField = [[UITextField alloc] init];
//  self.searchField.placeholder = @"搜索";
  self.searchField.font = XKRegularFont(15);
//  self.searchField.userInteractionEnabled = NO;
  [_searchView addSubview:self.searchField];
  [self.searchField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
  self.searchField.delegate = self;
  [self.searchField mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(imageView.mas_right).offset(5);
    make.top.bottom.equalTo(self.searchView);
    make.right.equalTo(self.searchView.mas_right).offset(-10);
  }];

}

- (void)textChange:(UITextField *)textfield {
  NSString *text = textfield.text;
  if (text.length == 0) {
    self.searchStatus = NO;
    [self reloadTotalUI];
  } else {
    self.searchStatus = YES;
    [self searchContentChanged:textfield.text];
    [self reloadTotalUI];
  }
}


- (void)searchContentChanged:(NSString *)text {
  [_searchArray removeAllObjects];
  for (XKContactModel *model in self.viewModel.totalUserAndAddDeleteArray) {
    if ([model isKindOfClass:[XKContactModel class]]) {
      if ([self compareStr:model.nickname containStr:text]) {
        [_searchArray addObject:model];
      }
    }
  }
}

#pragma mark - 数据筛选等
- (BOOL)compareStr:(NSString *)str containStr:(NSString *)containStr {
  if ([str containsString:containStr]) {
    return YES;
  } else {
    return [[UTPinYinHelper sharedPinYinHelper] isString:str MatchsKey:containStr IgnorCase:YES];
  }
  return NO;
}


#pragma mark - collectionView代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  if (self.searchStatus) {
    return self.searchArray.count;
  } else {
   return self.viewModel.totalUserAndAddDeleteArray.count;
  }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XKChooseMediaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.withoutDelte = YES;
    cell.showText = YES;
    id model;
    if (self.searchStatus) {
      model = self.searchArray[indexPath.row];
    } else {
      model = self.viewModel.totalUserAndAddDeleteArray[indexPath.row];
    }
  
    if ([model isKindOfClass:[XKContactModel class]]) {
        XKContactModel *user = (XKContactModel *)model;
        [cell.iconImgView sd_setImageWithURL:kURL(user.avatar) placeholderImage:kDefaultHeadImg];
        cell.textLabel.text = user.displayName;
    } else {
        cell.textLabel.text = @"";
        if ([model isEqualToString:@"add"]) {
            cell.iconImgView.image = IMG_NAME(@"xk_btn_friendsCirclePermissions_add");
        } else if ([model isEqualToString:@"delete"]) {
            cell.iconImgView.image = IMG_NAME(@"xk_btn_friendsCirclePermissions_delete");
        }
    }
    //    XKWeakSelf(ws);
    cell.indexPath = indexPath;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  if (self.searchStatus) {
    [self.viewModel jumpPersonCenter:self.searchArray[indexPath.row]];
  } else {
      [self.viewModel dealCollectionViewClick:indexPath dataArray:self.viewModel.totalUserAndAddDeleteArray vc:self];
  }
}



@end
