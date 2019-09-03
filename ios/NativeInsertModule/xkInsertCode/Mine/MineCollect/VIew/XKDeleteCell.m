/*******************************************************************************
 # File        : XKDeleteCell.m
 # Project     : XKSquare
 # Author      : Lin Li
 # Created     : 2018/9/14
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKDeleteCell.h"
#define MAX_OFFSET_X 250 * ScreenScale
#define MIN_OFFSET_X 60 * ScreenScale
#define DELETE_BUTTON_WIDTH 90 * ScreenScale
#define CELL_BUTTON_HEIGHT 109 * ScreenScale
#define CONTENT_WIDTH SCREEN_WIDTH - 20 * ScreenScale
@interface XKDeleteCell ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollContent;
@property (nonatomic, strong) UIView *deleteView;
@property (nonatomic, strong) UILabel *sureDeleteView;
@property (nonatomic, assign) BOOL isSelectDelete;

@end

@implementation XKDeleteCell

#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    self.isSelectDelete = NO;
}

#pragma mark - 初始化界面
- (void)createUI {
    [self configContentView];
    [self configDeleteView];
    _myContentView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.scrollContent addSubview:_myContentView];
    [self.myContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.scrollContent);
        make.width.equalTo(self.contentView.mas_width);
        make.height.equalTo(self.contentView.mas_height);
    }];
    self.myContentView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellSelectAction)];
    [self.myContentView  addGestureRecognizer:tap];
}

#pragma mark - 布局界面
- (void)createConstraints {

}
#pragma mark - 滑动删除

- (UILabel*)sureDeleteView {
    if (!_sureDeleteView) {
        _sureDeleteView = [[UILabel alloc]initWithFrame:CGRectMake(CONTENT_WIDTH + DELETE_BUTTON_WIDTH, 0, DELETE_BUTTON_WIDTH + 40 * ScreenScale, CELL_BUTTON_HEIGHT)];
        _sureDeleteView.backgroundColor = [UIColor redColor];
        _sureDeleteView.userInteractionEnabled = YES;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70 * ScreenScale, 30 * ScreenScale)];
        label.text = @"确认删除";
        label.textColor = [UIColor whiteColor];
        label.center = CGPointMake(_sureDeleteView.width/2,_sureDeleteView.height/2);
        label.font = [UIFont systemFontOfSize:15];
        [_sureDeleteView addSubview:label];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(realDelete)];
        [_sureDeleteView addGestureRecognizer:tap];
    }
    return _sureDeleteView;
}
- (void)configDeleteView {
    self.deleteView = [[UIView alloc]initWithFrame:CGRectMake(CONTENT_WIDTH + DELETE_BUTTON_WIDTH, 0, DELETE_BUTTON_WIDTH, CELL_BUTTON_HEIGHT)];
    self.deleteView.backgroundColor = [UIColor redColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40 * ScreenScale, 30 * ScreenScale)];
    label.text = @"删除";
    label.textColor = [UIColor whiteColor];
    label.center = CGPointMake(self.deleteView.width/2 - 20 * ScreenScale, self.deleteView.height/2);
    label.font = [UIFont systemFontOfSize:15];
    [self.deleteView addSubview:label];
    [self.scrollContent addSubview:self.deleteView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showSureDelete)];
    [self.deleteView addGestureRecognizer:tap];
}
- (void)configContentView {
    
    self.scrollContent = [[UIScrollView alloc]init];
    self.scrollContent.showsHorizontalScrollIndicator = NO;
    self.scrollContent.backgroundColor = [UIColor redColor];
    self.scrollContent.contentSize = CGSizeMake(CONTENT_WIDTH + DELETE_BUTTON_WIDTH, 115 * ScreenScale);
    self.scrollContent.delegate = self;
    [self.contentView addSubview:self.scrollContent];
    [self.scrollContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    self.contentView.backgroundColor = [UIColor whiteColor];
}
#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x<0) {
        scrollView.contentOffset = CGPointMake(0, 0);
        [self cancleEdite];
    } else {
        if (scrollView.contentOffset.x>MAX_OFFSET_X) {
            scrollView.contentOffset = CGPointMake(MAX_OFFSET_X, 0);
        }
        self.deleteView.width = scrollView.contentOffset.x;
        if (self.deleteView.width>DELETE_BUTTON_WIDTH) self.deleteView.width = DELETE_BUTTON_WIDTH;
        self.deleteView.x = SCREEN_WIDTH;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x<MIN_OFFSET_X)  {
        scrollView.contentOffset = CGPointMake(0, 0);
        [self cancleEdite];
    } else {
        if (self.isSelectDelete) {
            [scrollView setContentOffset:CGPointMake(DELETE_BUTTON_WIDTH + 40 * ScreenScale, 0) animated:YES];
        }else{
            scrollView.contentOffset = CGPointMake(DELETE_BUTTON_WIDTH, 0);
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    !self.scrollBlock?:self.scrollBlock();
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.x < MIN_OFFSET_X)  {
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [self cancleEdite];
    }
    else {
        if (self.isSelectDelete) {
            [scrollView setContentOffset:CGPointMake(DELETE_BUTTON_WIDTH + 40 * ScreenScale, 0) animated:YES];
        }else{
            [scrollView setContentOffset:CGPointMake(DELETE_BUTTON_WIDTH, 0) animated:YES];
        }
    }
}


#pragma mark - do action
- (void)showSureDelete {
    self.isSelectDelete = YES;
    self.sureDeleteView.frame = CGRectMake(CONTENT_WIDTH + DELETE_BUTTON_WIDTH, 0, DELETE_BUTTON_WIDTH + 40 * ScreenScale, CELL_BUTTON_HEIGHT);
    [self.scrollContent addSubview:self.sureDeleteView];
    [self.scrollContent layoutSubviews];
    [UIView animateWithDuration:0.5 animations:^{
        self.sureDeleteView.x = CONTENT_WIDTH;
        [self.scrollContent setContentOffset:CGPointMake(DELETE_BUTTON_WIDTH + 40 * ScreenScale, 0) animated:YES];
        self.deleteView.alpha = 0;
    }];
}

- (void)cancleEdite {
    self.isSelectDelete = NO;
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollContent setContentOffset:CGPointMake(0, 0)];
    } completion:^(BOOL finished) {
        self.deleteView.alpha = 1.0;
        [self.sureDeleteView removeFromSuperview];
    }];
}

- (void)realDelete {
    self.isSelectDelete = NO;
    !self.deleteBlock?:self.deleteBlock();
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self cancleEdite];
}
#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)cellSelectAction {
    [self cancleEdite];
    NSLog(@"cellSelectAction");
    if (self.selectBlock) {
        self.selectBlock(self.tableView, self.indexPath);
    }
}
@end
