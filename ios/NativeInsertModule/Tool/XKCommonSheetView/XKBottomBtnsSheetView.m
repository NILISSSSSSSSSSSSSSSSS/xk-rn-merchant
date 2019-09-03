/*******************************************************************************
 # File        : IKComplaintView.m
 # Project     : ErpApp
 # Author      : Jamesholy
 # Created     : 2018/2/11
 # Corporation : xk
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKBottomBtnsSheetView.h"

#define IKComplaintViewSpace 0

@interface XKBottomBtnsSheetView () {
    NSString * _title;
}

/**bg*/
@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) UILabel *titleLabel;
/**内容视图*/
@property(nonatomic, strong) UIView *contentView;
/**滚动视图*/
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, copy) NSArray *contents;
/**complete*/
@property(nonatomic, copy) void(^complete)(XKBottomBtnsSheetView *view,NSArray *indexs);

/**按钮数组*/
@property(nonatomic, strong) NSMutableArray <UIButton *> *btnsArray;

@end

@implementation XKBottomBtnsSheetView

- (instancetype)initWithContents:(NSArray <NSString *>*)contents title:(NSString *)titile completeBlock:(void (^)(XKBottomBtnsSheetView *, NSArray<NSNumber *> *))complete {
    if (self = [super init]) {
        _contents = contents;
        _complete = complete;
        _title = titile;
        _btnsArray = [NSMutableArray array];
        [self createUI];
    }
    return self;
}

- (void)createUI {
    __weak typeof(self) weakSelf = self;
    self.frame = [UIScreen mainScreen].bounds;
    _bgView = [UIView new];
    _bgView.backgroundColor = RGBA(0, 0, 0, 0.2);
    _bgView.frame = self.bounds;
    [self addSubview:_bgView];
    [_bgView bk_whenTapped:^{
        [weakSelf dismiss];
    }];
    _contentView = [UIView new];
    _contentView.backgroundColor = RGBGRAY(246);
    _contentView.layer.cornerRadius = 6;
    _contentView.layer.masksToBounds = YES;
    _contentView.frame = CGRectMake(IKComplaintViewSpace, 0, SCREEN_WIDTH - 2 *IKComplaintViewSpace, 0);
    [self addSubview:_contentView];
    if (_title) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = XKRegularFont(16);
        _titleLabel.text =  @"标题";
        _titleLabel.textColor = RGBGRAY(102);
        _titleLabel.backgroundColor = RGBGRAY(249);
        _titleLabel.frame = CGRectMake(0, 0, self.contentView.width, 50);
        [self.contentView addSubview:_titleLabel];
    }
    _scrollView = [UIScrollView new];
    [self.contentView addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(self.contentView.width, _contents.count * 56);
    _scrollView.frame = CGRectMake(0, _titleLabel.bottom, self.contentView.width, 0);
    UIView *lastView = nil;
    for (int i = 0; i < _contents.count; i++) {
        UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, i * 56, self.contentView.width, 56);
        btn.tag = i;
        [btn setTitle:[NSString stringWithFormat:@"%@", _contents[i]] forState:UIControlStateNormal];
        btn.titleLabel.font = XKRegularFont(17);
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:RGBGRAY(51) forState:UIControlStateNormal];
        [btn setImage:IMG_NAME(@"xk_ic_contact_nochose") forState:UIControlStateNormal];
        [btn setImage:IMG_NAME(@"xk_ic_contact_chose") forState:UIControlStateSelected];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
        if (i != _contents.count - 1) {
            [btn showBorderSite:rzBorderSitePlaceBottom];
            btn.bottomBorder.borderLine.backgroundColor = XKSeparatorLineColor;
            btn.bottomBorder.borderSize = 1;
        }
        [_btnsArray addObject:btn];
        lastView = btn;
    }
    
    _scrollView.height = MIN(lastView.bottom, 56 * 6);
    
    _sureBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureBtn.backgroundColor = XKMainTypeColor;
    _sureBtn.frame = CGRectMake(10, _scrollView.bottom + 10, self.contentView.width - 20, 50);
    [_sureBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sureBtn.layer.cornerRadius = 6;
    _sureBtn.layer.masksToBounds = YES;
    _sureBtn.titleLabel.font = XKRegularFont(18);
    [_sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_sureBtn];
    
    self.contentView.height = _sureBtn.bottom + 10 + kBottomSafeHeight;
}

- (void)btnClick:(UIButton *)button {
    button.selected = !button.selected;
}

- (void)sureClick {
    NSMutableArray *indexs = [NSMutableArray array];
    for (UIButton * btn in _btnsArray) {
        if (btn.selected) {
            [indexs addObject:@(btn.tag)];
        }
    }
    EXECUTE_BLOCK(self.complete,self,indexs.copy);
}

- (void)show {
    self.backgroundColor = [UIColor clearColor];
    _bgView.backgroundColor = RGBA(0, 0, 0, 0);
    self.contentView.y = SCREEN_HEIGHT;
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.backgroundColor = RGBA(0, 0, 0, 0.2);
        self.contentView.bottom = SCREEN_HEIGHT;
    }];
    [KEY_WINDOW addSubview:self];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.backgroundColor = RGBA(0, 0, 0, 0);
        self.contentView.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
