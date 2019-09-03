/*******************************************************************************
 # File        : XKVisbleAuthorityChooseCell.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/16
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKVisbleAuthorityChooseCell.h"

@interface XKVisbleAuthorityChooseCell ()
/**checkBtn*/
@property(nonatomic, strong) UIButton *checkBtn;
/**title*/
@property(nonatomic, strong) UILabel *titleLabel;
/**arrow*/
@property(nonatomic, strong) UIButton *infoBtn;
/**<##>*/
@property(nonatomic, strong) UIView *line;
@end

@implementation XKVisbleAuthorityChooseCell

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
    /**checkBtn*/
    _checkBtn = [[UIButton alloc] init];
    _checkBtn.userInteractionEnabled = NO;
    [_checkBtn setImage:IMG_NAME(@"ic_btn_msg_circle_noselected") forState:UIControlStateNormal];
    [_checkBtn setImage:IMG_NAME(@"ic_btn_msg_circle_selected") forState:UIControlStateSelected];
    [self.contentView addSubview:_checkBtn];
    /**title*/
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = XKRegularFont(14);
    _titleLabel.numberOfLines = 2;
    _titleLabel.textColor = HEX_RGB(0x222222);
    [self.contentView addSubview:_titleLabel];
    /**arrow*/
    _infoBtn = [[UIButton alloc] init];
    [_infoBtn setImage:IMG_NAME(@"ic_btn_msg_circle_info") forState:UIControlStateNormal];
    [self.contentView addSubview:_infoBtn];
}

#pragma mark - 布局界面
- (void)createConstraints {
    [_checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(40);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(69);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.infoBtn.mas_right).offset(-2);
    }];
    
    [_infoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.titleLabel.mas_bottom).offset(-2);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.right.equalTo(self.contentView.mas_right).offset(-27);
    }];
    
    __weak typeof(self) weakSelf = self;
    [_infoBtn bk_addEventHandler:^(id sender) {
        EXECUTE_BLOCK(weakSelf.infoBtnBlock,weakSelf.indexPath);
    } forControlEvents:UIControlEventTouchUpInside];
    
    _line = [UIView new];
    _line.backgroundColor = HEX_RGB(0xF1F1F1);
    [self.contentView addSubview:_line];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@1);
        make.left.equalTo(self.contentView.mas_left).offset(45);
    }];
    
    [_titleLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.paragraphStyle.lineSpacing(6);
        confer.text(@"分组1");
        confer.text(@"\n");
        confer.text(@"消息，阿瓦达阿瓦达安慰安慰安慰。安慰").textColor(HEX_RGB(0x999999));
    }];
    [self.contentView showBorderSite:rzBorderSitePlaceTop];
    self.contentView.topBorder.borderLine.backgroundColor = HEX_RGB(0xF1F1F1);
}


- (void)setItem:(XKVisiblelAuthorityItem *)item {
    _item = item;
    [_titleLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.paragraphStyle.lineSpacing(6);
        confer.text(item.groupName);
        NSString *groupInfo = item.groupInfo;
        if (groupInfo.length != 0) {
            confer.text(groupInfo).textColor(HEX_RGB(0x999999));
        }
    }];
    _infoBtn.hidden = !item.hasInfo;
    _checkBtn.selected = item.selected;
}

#pragma mark ----------------------------- 公用方法 ------------------------------


@end
