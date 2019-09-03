/*******************************************************************************
 # File        : XKReceiptSegmentCell.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/7
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKReceiptSegmentCell.h"

@interface XKReceiptSegmentCell ()
/**<##>*/
@property(nonatomic, strong) UIButton *personBtn;
/**<##>*/
@property(nonatomic, strong) UIButton *comanyBtn;
@end

@implementation XKReceiptSegmentCell

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
    __weak typeof(self) weakSelf = self;
    self.personBtn = [self creatBtnWithTitle:@"个人"];
    [self.personBtn bk_addEventHandler:^(id sender) {
        [weakSelf checkForPerson:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.personBtn];
    self.comanyBtn = [self creatBtnWithTitle:@"企业"];
    [self.comanyBtn bk_addEventHandler:^(id sender) {
        [weakSelf checkForPerson:NO];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.comanyBtn];
}

#pragma mark - 布局界面
- (void)createConstraints {
    [self.personBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(10);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(self.personBtn.width, self.personBtn.height));
    }];
    
    [self.comanyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.personBtn);
        make.left.equalTo(self.personBtn.mas_right).offset(10);
        make.size.equalTo(self.personBtn);
    }];
}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)setModel:(XKReceiptInfoModel *)model {
    [super setModel:model];
    [self setBtn:self.personBtn selected:model.isPersonal];
    [self setBtn:self.comanyBtn selected:!model.isPersonal];
}

- (void)checkForPerson:(BOOL)person {
    EXECUTE_BLOCK(self.check,person);
}

- (UIButton *)creatBtnWithTitle:(NSString *)title {
    UIButton *btn  = [UIButton new];
    CGFloat height = 20.0;
    btn.frame = CGRectMake(0, 0, 55, height);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:HEX_RGB(0x999999) forState:UIControlStateNormal];
    [btn setTitleColor:XKMainTypeColor forState:UIControlStateSelected];
    btn.titleLabel.font = XKRegularFont(13);
    btn.layer.cornerRadius = height / 2;
    btn.layer.borderWidth = 1;
    btn.layer.masksToBounds = YES;
    return btn;
};

- (void)setBtn:(UIButton *)btn selected:(BOOL)selected {
    btn.selected = selected;
    if (selected) {
        btn.layer.borderColor = XKMainTypeColor.CGColor;
    } else {
        btn.layer.borderColor = HEX_RGB(0x999999).CGColor;
    }
}
@end
