/*******************************************************************************
 # File        : XKCommentReplyCell.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/12
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKCommentReplyCell.h"

@interface XKCommentReplyCell ()

@end

@implementation XKCommentReplyCell

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
    UIButton *replyBtn = [UIButton new];
    [replyBtn setTitle:@"回复" forState:UIControlStateNormal];
    [replyBtn setTitleColor:HEX_RGB(0x999999) forState:UIControlStateNormal];
    [replyBtn addTarget:self action:@selector(replyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:replyBtn];
    replyBtn.layer.cornerRadius = 10;
    replyBtn.layer.masksToBounds = YES;
    replyBtn.layer.borderWidth = 1;
    replyBtn.layer.borderColor = HEX_RGB(0x999999).CGColor;
    replyBtn.titleLabel.font = XKRegularFont(12);
    [replyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(25);
        make.right.equalTo(self.contentView.mas_right).offset(-19);
        make.size.mas_equalTo(CGSizeMake(54 * ScreenScale, 20 *ScreenScale));
    }];
}

#pragma mark - 布局界面
- (void)createConstraints {
    

}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)replyBtnClick {
    EXECUTE_BLOCK(self.replyClick,self.indexPath);
}
@end
