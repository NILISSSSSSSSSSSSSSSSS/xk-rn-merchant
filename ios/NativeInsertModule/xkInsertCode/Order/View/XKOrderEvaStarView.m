/*******************************************************************************
 # File        : XKOrderEvaStarView.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/5
 # Corporation : 水木科技
 # Description :
 订单评论星星view
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKOrderEvaStarView.h"
#import "XKCommonStarView.h"

#define kDefaultTotalNum 5

@interface XKOrderEvaStarView () <XKCommonStarViewDelegate>
/**星星*/
@property(nonatomic, strong) XKCommonStarView *starView;
/**标题*/
@property(nonatomic, strong) UILabel *titleLabel;
/**描述*/
@property(nonatomic, strong) UILabel *statusLabel;
@end

@implementation XKOrderEvaStarView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化界面
        [self createUI];
        // 布局界面
        [self createConstraints];
    }
    return self;
}

#pragma mark - 初始化默认数据
- (void)createUI {
    _titleLabel = [UILabel new];
    _titleLabel.textColor = HEX_RGB(0x222222);
    _titleLabel.font = XKRegularFont(12);
    _titleLabel.frame = CGRectMake(0, 0, 50, 20);
    [self addSubview:_titleLabel];
    _starView = [[XKCommonStarView alloc] initWithFrame:CGRectMake(_titleLabel.right + 8, 0, 130, 14) numberOfStars:kDefaultTotalNum];
    _starView.delegate = self;
    [self addSubview:_starView];
    _statusLabel = [UILabel new];
    _statusLabel.frame = CGRectMake(_starView.right + 15, 0, 80, 20);
    _statusLabel.textColor =  HEX_RGB(0x777777);
    _statusLabel.font = XKRegularFont(12);
    [self addSubview:_statusLabel];
}

#pragma mark - 布局界面
- (void)createConstraints {
//    __weak typeof(self) weakSelf = self;

}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setStarNum:(NSInteger)starNum {
    _starNum = starNum;
    [_starView setScorePercent:starNum * 1.0 / kDefaultTotalNum];
}

- (void)setDes:(NSString *)des {
    _des = des;
    _statusLabel.text = des;
}

- (void)layoutSubviews {
    _titleLabel.centerY = self.height / 2;
    _starView.centerY = self.height / 2 - 1;
    _statusLabel.centerY = self.height / 2;
}

- (void)starRateView:(XKCommonStarView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent {
    NSInteger starNum = kDefaultTotalNum * newScorePercent;
    if (starNum == 1) {
        _statusLabel.text = @"非常差";
    } else if (starNum == 2) {
        _statusLabel.text = @"差";
    } else if (starNum == 3) {
        _statusLabel.text = @"一般";
    } else if (starNum == 4) {
        _statusLabel.text = @"好";
    } else if (starNum == 5) {
        _statusLabel.text = @"非常好";
    }
    if (starNum != _starNum) {
        EXECUTE_BLOCK(self.starChange,starNum);
    }
}

@end
