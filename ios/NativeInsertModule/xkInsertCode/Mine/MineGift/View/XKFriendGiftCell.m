

/*******************************************************************************
 # File        : XKFriendGiftCell.
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/13
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKFriendGiftCell.h"
#import "XKGoodsView.h"

@interface XKFriendGiftCell ()
/**礼物父视图*/
@property(nonatomic, strong) UIView *giftView;
/**分割*/
@property(nonatomic, strong) UIView *btmLine;
@end

@implementation XKFriendGiftCell

#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 初始化默认数据
        [self createSuperDefaultData];
        // 初始化界面
        [self createSuperUI];
        // 布局界面
        [self createSuperConstraints];
    }
    return self;
}

#pragma mark - 初始化默认数据
- (void)createSuperDefaultData {
    
}

#pragma mark - 初始化界面
- (void)createSuperUI {
    self.contentView.backgroundColor = HEX_RGB(0xF6F6F6);
    /**内容总视图*/
    _containView = [[UIView alloc] init];
    _containView.backgroundColor = [UIColor whiteColor];
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
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = HEX_RGB(0x999999);
    _timeLabel.font = XKRegularFont(12);
    [self.containView addSubview:_timeLabel];
    
    _giftView = [[UIView alloc] init];
    [self.containView addSubview:_giftView];
    /**时间*/
    _giftLabel = [[UILabel alloc] init];
    _giftLabel.textColor = HEX_RGB(0x777777);
    _giftLabel.font = XKRegularFont(12);
    [self.containView addSubview:_giftLabel];
    _giftLabel.text = @"赠送了你";
}

#pragma mark - 布局界面
- (void)createSuperConstraints {
    [_containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    /**头像*/
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containView.mas_top).offset(15);
        make.left.equalTo(self.containView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(46 , 46 ));
        make.bottom.lessThanOrEqualTo(self.containView.mas_bottom).offset(-15);
    }];
    _headImageView.layer.cornerRadius = 4;
    _headImageView.layer.masksToBounds = YES;
    /**名字*/
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(15);
        make.right.equalTo(self.containView.mas_right).offset(-100);
        make.top.equalTo(self.headImageView.mas_top).offset(-1);
    }];
    
    /**时间*/
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.containView.mas_right).offset(-12);
        make.top.equalTo(self.containView.mas_top).offset(23);
    }];;
    
    [_giftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.bottom.equalTo(self.headImageView.mas_bottom).offset(1);
    }];
    [_giftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.giftLabel.mas_right).offset(6);
        make.bottom.equalTo(self.headImageView.mas_bottom).offset(0);
        make.right.equalTo(self.containView.mas_right);
        make.height.equalTo(@15);
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
- (void)hideSeperateLine:(BOOL)hide {
    self.btmLine.hidden = hide;
}

- (void)setGiftType:(NSArray *)gifts {
    [_giftView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    UILabel *tmpLabel;
    for (int i = 0; i < gifts.count; i ++) {
        UILabel *label = [[UILabel alloc] init];
        label.text = gifts[i];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = XKMainTypeColor;
        CGFloat width = [self getWidthByText:label.text font:label.font];
        label.frame = CGRectMake(tmpLabel?tmpLabel.right + 3 : 0, 0, width + 11, 15);
        label.layer.cornerRadius = label.height / 2;
        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        [_giftView addSubview:label];
        tmpLabel = label;
    }
}

- (CGFloat)getWidthByText:(NSString *)text font:(UIFont *)font{
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGFloat width = (int)[text boundingRectWithSize:CGSizeMake(MAXFLOAT, 100) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
    return width;
}

@end

