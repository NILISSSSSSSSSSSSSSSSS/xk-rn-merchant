/*******************************************************************************
 # File        : XKGoodsAndCommentView.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/11
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKGoodsAndCommentView.h"
#import "XKGoodsView.h"
@interface XKGoodsAndCommentView ()
/**评论view*/
@property(nonatomic, strong) UILabel *commentLabel;
/**信息视图*/
@property(nonatomic, strong) XKGoodsView *goodsView;

@end

@implementation XKGoodsAndCommentView

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

}

#pragma mark - 初始化界面
- (void)createUI {
    self.commentLabel = [[UILabel alloc] init];
    self.commentLabel.font = XKRegularFont(12);
    self.commentLabel.textColor = HEX_RGB(0x777777);
    self.commentLabel.numberOfLines = 1;
    [self addSubview:self.commentLabel];
    self.goodsView = [[XKGoodsView alloc] init];
    self.goodsView.backgroundColor = [UIColor whiteColor];
    self.goodsView.layer.cornerRadius = 2;
    self.goodsView.layer.masksToBounds = YES;
    [self addSubview:self.goodsView];
    
}

#pragma mark - 布局界面
- (void)createConstraints {
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.mas_top).offset(12);
    }];
    
    [self.goodsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentLabel.mas_bottom).offset(5);
        make.left.equalTo(self.commentLabel);
        make.width.equalTo(self.commentLabel);
        make.bottom.equalTo(self.mas_bottom).offset(-14);
    }];

}

#pragma mark ----------------------------- 公用方法 ------------------------------


@end
