/*******************************************************************************
 # File        : XKMineFansCell.m
 # Project     : XKSquare
 # Author      : Jamesholy
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

#import "XKMineFansCell.h"

@interface XKMineFansCell ()
/**头像*/
@property(nonatomic, strong) UIImageView *headImageView;
/**名字*/
@property(nonatomic, strong) UILabel *nameLabel;
/**名字下方的文字*/
@property(nonatomic, strong) UILabel *giftLabel;
/**内容总视图*/
@property(nonatomic, strong) UIView *containView;

/**关注按钮*/
@property(nonatomic, strong) UIButton *focusBtn;
/**好友关系*/
@property(nonatomic, strong) UIButton *addFriendBtn;

@property(nonatomic, strong) UIView *btmLine;
@end

@implementation XKMineFansCell

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

}

#pragma mark - 初始化界面
- (void)createUI {
    self.contentView.backgroundColor = HEX_RGB(0xF6F6F6);
    /**内容总视图*/
    _containView = [[UIView alloc] init];
    _containView.backgroundColor = [UIColor whiteColor];
    _containView.xk_openClip = YES;
    _containView.xk_radius = 6;
    /**内容总视图*/
    [self.contentView addSubview:_containView];
    /**头像*/
    _headImageView = [[UIImageView alloc] init];
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.containView addSubview:_headImageView];
    /**名字*/
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = HEX_RGB(0x222222);
    _nameLabel.font = XKRegularFont(14);
    [self.containView addSubview:_nameLabel];
    /**时间*/
    _giftLabel = [[UILabel alloc] init];
    _giftLabel.textColor = HEX_RGB(0x777777);
    _giftLabel.font = XKRegularFont(12);
    [self.containView addSubview:_giftLabel];
    
    __weak typeof(self) weakSelf = self;
    _focusBtn = [[UIButton alloc] init];
    [_focusBtn bk_addEventHandler:^(id sender) {
        EXECUTE_BLOCK(weakSelf.focusClick,weakSelf.indexPath)
    } forControlEvents:UIControlEventTouchUpInside];
    [_containView addSubview:_focusBtn];
    _focusBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _focusBtn.layer.borderWidth = 1;
    _focusBtn.layer.cornerRadius = 11;
    [self setFouse:NO];

    _addFriendBtn = [[UIButton alloc] init];
    [_addFriendBtn bk_addEventHandler:^(id sender) {
        EXECUTE_BLOCK(weakSelf.addClick,weakSelf.indexPath)
    } forControlEvents:UIControlEventTouchUpInside];
    [self.containView addSubview:_addFriendBtn];
     _addFriendBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_addFriendBtn setImage:nil forState:UIControlStateSelected];
    [_addFriendBtn setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
    [_addFriendBtn setTitleColor:HEX_RGB(0x777777) forState:UIControlStateSelected];
    _addFriendBtn.layer.cornerRadius = 11;
}

#pragma mark - 布局界面
- (void)createConstraints {
    [_containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    /**头像*/
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containView.mas_top).offset(15);
        make.left.equalTo(self.containView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(39,39));
        make.bottom.equalTo(self.containView.mas_bottom).offset(-15);
    }];
    _headImageView.layer.cornerRadius = 4;
    _headImageView.layer.masksToBounds = YES;
    _headImageView.userInteractionEnabled = YES;
    __weak typeof(self) weakSelf = self;
    [_headImageView bk_whenTapped:^{
        [XKGlobleCommonTool jumpUserInfoCenter:weakSelf.model.userId vc:nil];
    }];
    /**名字*/
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(10);
        make.right.equalTo(self.focusBtn.mas_left).offset(-10);
        make.top.equalTo(self.headImageView.mas_top).offset(-1);
    }];
    
    [_giftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.bottom.equalTo(self.headImageView.mas_bottom).offset(1);
        make.right.equalTo(self.focusBtn.mas_left).offset(-10);
    }];
    
    [self.addFriendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containView.mas_top).offset(15);
        make.right.equalTo(self.containView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(60, 22));
    }];
    
    [self.focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addFriendBtn.mas_top);
        make.right.equalTo(self.addFriendBtn.mas_left).offset(-8);
        make.size.equalTo(self.addFriendBtn);
    }];
    
    self.btmLine = [UIView new];
    [self.containView addSubview:self.btmLine];
    self.btmLine.backgroundColor = HEX_RGB(0xF6F6F6);
    [self.btmLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.containView);
        make.height.equalTo(@1);
    }];
}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)setClipType:(XKCornerClipType)clipType {
    _clipType = clipType;
    self.containView.xk_clipType = clipType;
}

- (void)setModel:(XKContactModel *)model {
    _model = model;
    _nameLabel.text = model.nickname;
    _giftLabel.text = model.signature;
    [_headImageView sd_setImageWithURL:kURL(model.avatar) placeholderImage:kDefaultHeadImg];
    if ([model.userId isEqualToString:[XKUserInfo getCurrentUserId]]) {
        _focusBtn.hidden = YES;
        _addFriendBtn.hidden = YES;
    } else {
        _focusBtn.hidden = NO;
        _addFriendBtn.hidden = NO;
        [self setFouse:model.isFocusForFansList];
        [self setAdd:model.isFriends];
    }
}

- (void)setFocusModel:(XKContactModel *)model {
    _model = model;
    _nameLabel.text = model.nickname;
    _giftLabel.text = model.signature;
    [_headImageView sd_setImageWithURL:kURL(model.avatar) placeholderImage:kDefaultHeadImg];
    if ([model.userId isEqualToString:[XKUserInfo getCurrentUserId]]) {
        _focusBtn.hidden = YES;
        _addFriendBtn.hidden = YES;
    } else {
        _focusBtn.hidden = NO;
        _addFriendBtn.hidden = NO;
        [self setFouse:model.followRelation == XKRelationNoting ? NO : YES];
        [self setAdd:model.isFriends];
    }
}

#pragma mark - 设置已经关注
- (void)setFouse:(BOOL)focus {
    if (focus) {
        [_focusBtn setTitle:@"取消关注" forState:UIControlStateNormal];
        [_focusBtn setTitleColor:HEX_RGB(0x777777)  forState:UIControlStateNormal];
        [_focusBtn setImage:nil forState:UIControlStateNormal];
        _focusBtn.layer.borderColor = HEX_RGB(0xE5E5E5).CGColor;
    } else {
        [_focusBtn setTitle:@" 关注" forState:UIControlStateNormal];
        [_focusBtn setTitleColor:HEX_RGB(0xEE6161)  forState:UIControlStateNormal];
        [_focusBtn setImage:IMG_NAME(@"xk_btn_IM_fans_addFocus") forState:UIControlStateNormal];
        _focusBtn.layer.borderColor = HEX_RGB(0xEE6161).CGColor;
    }
}

#pragma mark - 设置已经添加
- (void)setAdd:(BOOL)add{
    _addFriendBtn.userInteractionEnabled = YES;
    if (add) {
        _addFriendBtn.userInteractionEnabled = NO;
        [_addFriendBtn setImage:nil forState:UIControlStateNormal];
        [_addFriendBtn setTitle:@"已是好友" forState:UIControlStateNormal];
        [_addFriendBtn setTitleColor:HEX_RGB(0x777777)  forState:UIControlStateNormal];
        _addFriendBtn.layer.borderWidth = 0;
        _addFriendBtn.layer.borderColor = [UIColor clearColor].CGColor;
    } else {
        [_addFriendBtn setImage:IMG_NAME(@"xk_btn_IM_fans_add") forState:UIControlStateNormal];
        [_addFriendBtn setTitleColor:XKMainTypeColor  forState:UIControlStateNormal];
        _addFriendBtn.layer.borderWidth = 1;
        _addFriendBtn.layer.borderColor = XKMainTypeColor.CGColor;
        [_addFriendBtn setTitle:@" 好友" forState:UIControlStateNormal];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.containView setNeedsLayout];
    [self.containView layoutIfNeeded];
}

@end
