/*******************************************************************************
 # File        : XKTagsDisplayView.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/18
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKTagsDisplayView.h"
#import "LeftCustomFlowLayout.h"
#import "TagsDisplayCollectionCell.h"

#define kCollectionInsetTop 10
#define kCollectionInsetBtm kCollectionLineSpace
#define kCollectionLineSpace 8 // cell行距
#define kCollectionCellHeight 25  // cell高度
#define kCollectionLimitLineNum 2 // 限制行数
#define kArrowBtnHeight 25 //
// 限制高度
#define kLimitCollectionHeight  (kCollectionInsetTop + kCollectionInsetBtm + kCollectionLimitLineNum * kCollectionCellHeight + (kCollectionLimitLineNum - 1) * kCollectionLineSpace)

@interface XKTagsDisplayView ()<UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>

/**dataArray*/
@property(nonatomic, strong) NSMutableArray <TagsDisplayInfo *>*dataArray;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
/**collection父视图*/
@property(nonatomic, strong) UIView *collectionSuperView;
/**视图*/
@property(nonatomic, strong) UICollectionView *collectionView;
/**<##>*/
@property(nonatomic, strong) UIButton *arrowBtn;
/**是否全显示*/
@property(nonatomic, assign) BOOL hasShowFull;
@end

@implementation XKTagsDisplayView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化默认数据
        [self createDefaultData];
        // 初始化界面
        [self createUI];
        // 布局界面
        [self createConstraints];
    }
    return self;
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
    _dataArray = [NSMutableArray array];
    _isNeedFold = NO;
}

- (void)setArr:(NSArray *)arr {
    for (NSString *text in arr) {
        TagsDisplayInfo *info = [TagsDisplayInfo new];
        info.name = text;
        [self.dataArray addObject:info];
    }
    [self reloadData];
}

#pragma mark - 设置默认选中
- (void)setDefualtIndex:(NSInteger)defualtIndex {
    _defualtIndex = defualtIndex;
    for (TagsDisplayInfo *info in self.dataArray) {
        info.selected = NO;
    }
    if (self.dataArray.count > defualtIndex) {
        self.dataArray[defualtIndex].selected = YES;
    }
    [self.collectionView reloadData];
}

#pragma mark - 初始化界面
- (void)createUI {
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
}

#pragma mark - 布局界面
- (void)createConstraints {
//    __weak typeof(self) weakSelf = self;
    _collectionSuperView = [[UIView alloc] init];
    [self addSubview:_collectionSuperView];
    _layout = [LeftCustomFlowLayout new];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    self.collectionView.delegate = self ;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[TagsDisplayCollectionCell class]
            forCellWithReuseIdentifier:@"Cell"];
    [_collectionSuperView addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.collectionSuperView);
    }];
    
    /**arrow*/
    __weak typeof(self) weakSelf = self;
    UIView *btnView = [[UIView alloc] init];
    [self addSubview:btnView];
    [btnView bk_whenTapped:^{
        weakSelf.hasShowFull = !weakSelf.hasShowFull;
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.arrowBtn.transform = weakSelf.hasShowFull ? CGAffineTransformMakeRotation(M_PI): CGAffineTransformIdentity;
        }];
        [weakSelf reloadData];
    }];
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionSuperView.mas_bottom);
        make.centerX.equalTo(self.collectionSuperView);
        make.size.mas_equalTo(CGSizeMake(40,kArrowBtnHeight));
    }];
    _arrowBtn = [[UIButton alloc] init];
    [btnView addSubview:_arrowBtn];
    [_arrowBtn setBackgroundImage:IMG_NAME(@"xk_ic_login_down_arrow") forState:UIControlStateNormal];
    _arrowBtn.userInteractionEnabled = NO;
    [_arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnView.mas_top);
        make.centerX.equalTo(btnView);
        make.size.mas_equalTo(CGSizeMake(15,12));
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionSuperView.width = self.width;
}

- (void)setIsNeedFold:(BOOL)isNeedFold {
    _isNeedFold = isNeedFold;
    if (!self.isNeedFold) {
        self.hasShowFull = YES;
        [self reloadData];
    }
}

#pragma mark -
- (void)reloadData {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        CGFloat collectionSizeHeight = self.layout.collectionViewContentSize.height;
        if (self.isNeedFold) {
            if (collectionSizeHeight > kLimitCollectionHeight) { // contentSize高度大于限制高度 代表有展开收起按钮的逻辑
                CGFloat newCollectionSizeHeight = self.hasShowFull ? collectionSizeHeight : kLimitCollectionHeight;
                if (newCollectionSizeHeight != self.collectionSuperView.height) { // 高度变化才设置
                    self.collectionSuperView.height = newCollectionSizeHeight;
                    self.height = self.collectionSuperView.height  + kArrowBtnHeight;
                    EXECUTE_BLOCK(self.heightChange,self.height,self);
                }
            } else { // 指定行数可以完全显示 没有展开收起按钮
                if (collectionSizeHeight != self.collectionSuperView.height) {
                    self.collectionSuperView.height = collectionSizeHeight; // collectionView的内容高度就是视图的高度
                    self.height = self.collectionSuperView.height;
                    EXECUTE_BLOCK(self.heightChange,self.height,self);
                }
            }
        } else {
            self.arrowBtn.hidden = YES;
            self.collectionSuperView.height = collectionSizeHeight;
            self.height = self.collectionSuperView.height + 10;
            EXECUTE_BLOCK(self.heightChange,self.height,self);
        }

    });
}

#pragma mark ----------------------------- 公用方法 ------------------------------
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TagsDisplayCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    TagsDisplayInfo *model = self.dataArray[indexPath.row];
    cell.text = model.name;
    cell.beSelected = model.selected;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TagsDisplayInfo *model = self.dataArray[indexPath.row];
    for (TagsDisplayInfo *info in self.dataArray) {
        info.selected = NO;
    }
    model.selected = YES;
    self.defualtIndex = indexPath.row;
    [self.collectionView reloadData];
    EXECUTE_BLOCK(self.itemChange,indexPath.row,model.name,self);
}

#pragma mark - WaterFlowLayoutDelegate

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kCollectionInsetTop,20,kCollectionInsetBtm,20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kCollectionLineSpace;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    TagsDisplayInfo *model = self.dataArray[indexPath.row];
    NSString *text = model.name;
    CGSize size = CGSizeMake([TagsDisplayCollectionCell cellSize:text].width, kCollectionCellHeight);
    return size;
}


@end
