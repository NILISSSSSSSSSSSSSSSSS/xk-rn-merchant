/*******************************************************************************
 # File        : XKFriendTalkContentView.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/17
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKFriendTalkContentView.h"
#import "XKFriendTalkImgView.h"

@interface XKFriendTalkContentView ()
/**宽度*/
@property(nonatomic, assign) CGFloat initWidth;
/**说说内容*/
@property(nonatomic, strong) UILabel *talkLabel;
/**展开收起按钮*/
@property(nonatomic, strong) UIButton *foldBtn;
/**图片父视图*/
@property(nonatomic, strong) XKFriendTalkImgView *imgView;
@end

@implementation XKFriendTalkContentView

#pragma mark - 初始化
- (instancetype)initWithWidth:(CGFloat)width {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.initWidth = width;
        self.backgroundColor = [UIColor whiteColor];
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
    __weak typeof(self) weakSelf = self;
    /**说说*/
    _talkLabel = [[UILabel alloc] init];
    _talkLabel.numberOfLines = 0;
    _talkLabel.font = kFontSize6(kFriendTalkContentFont);
    [self addSubview:_talkLabel];
    
    _foldBtn = [[UIButton alloc] init];
   [_foldBtn setTitleColor:HEX_RGB(0x777777) forState:UIControlStateNormal];

    _foldBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
  NSAttributedString *att = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
    confer.text(@"展开 ").textColor(HEX_RGB(0x777777)).font(XKNormalFont(12));
    confer.appendImage(IMG_NAME(@"xk_btn_mall_ticket_down")).bounds(CGRectMake(0, -1, 12, 12));
  }];
  NSAttributedString *att1 = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
    confer.text(@"收起 ").textColor(HEX_RGB(0x777777)).font(XKNormalFont(12));;
    confer.appendImage(IMG_NAME(@"xk_btn_mall_ticket_top")).bounds(CGRectMake(0, -1, 12, 12));
  }];
  [_foldBtn setAttributedTitle:att forState:UIControlStateNormal];
  
  [_foldBtn setAttributedTitle:att1 forState:UIControlStateSelected];

    _foldBtn.titleLabel.font = XKNormalFont(12);
    [_foldBtn addTarget:self action:@selector(foldClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_foldBtn];
    _foldBtn.clipsToBounds = YES;
    _imgView = [[XKFriendTalkImgView alloc] initWithWidth:self.initWidth];
    [self addSubview:_imgView];
    [_imgView setRefreshBlock:^(NSIndexPath *indexPath) {
        EXECUTE_BLOCK(weakSelf.refreshBlock,indexPath);
    }];
}

#pragma mark - 布局界面
- (void)createConstraints {
    /**说说父视图*/
    [_talkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(0);
    }];
    [_foldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.talkLabel);
        make.top.equalTo(self.talkLabel.mas_bottom);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(40);
    }];
    /**自定义内容view*/
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.foldBtn.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self);
    }];

}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)setModel:(XKFriendTalkModel *)model {
    _model = model;
    self.talkLabel.attributedText = model.contentAtt;
    if (self.contentNeedFold == YES) { // 需要显示折叠状态的情况
        [_talkLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(model.contentHeight);
        }];
        if (model.contentNeedFold && self.contentNeedFold == YES) {
            [self.foldBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@18);
                make.top.equalTo(self.talkLabel.mas_bottom).offset(5);
            }];
            _foldBtn.selected = model.contentFoldStatus;
        } else {
            [self.foldBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
                make.top.equalTo(self.talkLabel.mas_bottom).offset(0);
            }];
        }
    } else { // 直接显示全部的情况
        model.contentFoldStatus = YES;
        [_talkLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(model.contentHeight);
        }];
        [self.foldBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
            make.top.equalTo(self.talkLabel.mas_bottom).offset(0);
        }];
    }
    
    self.imgView.model = model;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    self.imgView.indexPath = indexPath;
}

- (void)foldClick {
    self.model.contentFoldStatus = !self.model.contentFoldStatus;
    self.refreshBlock(self.indexPath);
}

@end
