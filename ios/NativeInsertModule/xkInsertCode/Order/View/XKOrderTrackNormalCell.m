/*******************************************************************************
 # File        : XKOrderTrackNormalCell.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/4
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKOrderTrackNormalCell.h"
#import <RZColorful.h>

@interface XKOrderTrackNormalCell ()
/**顶部自定义视图*/
@property(nonatomic, strong) UIView *topDiyView;
/**运输信息*/
@property(nonatomic, strong) UILabel *trackLabel;
/**时间*/
@property(nonatomic, strong) UILabel *timeLabel;
/**顶部线*/
@property(nonatomic, strong) UIView *topLine;
/**圆圈*/
@property(nonatomic, strong) UIView *circleView;
/**底部线*/
@property(nonatomic, strong) UIView *btmLine;

/**配送中视图*/
@property(nonatomic, strong) UIView *sendingView;

/**<##>*/
@property(nonatomic, strong) MASConstraint *topDiyHeightCons;

@end

@implementation XKOrderTrackNormalCell

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
    /**顶部自定义视图*/
    _topDiyView = [[UIView alloc] init];
    [self.contentView addSubview:_topDiyView];
    /**运输信息*/
    _trackLabel = [[UILabel alloc] init];
    _trackLabel.textColor = HEX_RGB(0x999999);
    _trackLabel.numberOfLines = 0;
    _trackLabel.font = XKRegularFont(14);
    [self.contentView addSubview:_trackLabel];
    /**时间*/
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = XKRegularFont(12);
    _timeLabel.textColor = HEX_RGB(0x999999);
    [self.contentView addSubview:_timeLabel];

    /**顶部线*/
    _topLine = [[UIView alloc] init];
    _topLine.backgroundColor = HEX_RGB(0xD8D8D8);
    [self.contentView addSubview:_topLine];
    /**底部线*/
    _btmLine = [[UIView alloc] init];
    _btmLine.backgroundColor = HEX_RGB(0xD8D8D8);
    [self.contentView addSubview:_btmLine];
    /**圆圈*/
    _circleView = [[UIView alloc] init];
    _circleView.backgroundColor = HEX_RGB(0x4A90FA);
    [self.contentView addSubview:_circleView];
}

#pragma mark - 布局界面
- (void)createConstraints {
    [_topDiyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(32 * ScreenScale);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.top.equalTo(self.contentView.mas_top).offset(15 * ScreenScale);
//        self.topDiyHeightCons = make.height.equalTo(@0);
    }];

    [_trackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.topDiyView);
        make.top.equalTo(self.topDiyView.mas_bottom);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.trackLabel);
        make.top.equalTo(self.trackLabel.mas_bottom).offset(4);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
    }];
    
    CGFloat lineCenter = 16;
    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_left).offset(lineCenter);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.topDiyView.mas_top).offset(5);
        make.width.equalTo(@1);
    }];
    
    [_btmLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topLine);
        make.top.equalTo(self.topLine.mas_bottom);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.width.equalTo(@1);
    }];
    
    [_circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topLine);
        make.centerY.equalTo(self.topLine.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(7, 7));
    }];
    _circleView.layer.cornerRadius = 3.5;
    _circleView.layer.masksToBounds = YES;

}

#pragma mark ----------------------------- 公用方法 ------------------------------

#pragma mark - 设置是否有顶部自定义视图
- (void)setHasTopDiyView:(BOOL)has {
    if (has) {
        [self.topDiyHeightCons deactivate]; // 禁用 自己撑大高度
    } else {
        [self.topDiyHeightCons activate];
    }
}

- (void)setLineStyle:(XKOrderTrackCellLineStyle)lineStyle {
    _lineStyle = lineStyle;
    if (lineStyle == XKOrderTrackCellLineBtmStyle) {
        _btmLine.hidden = NO;
        _topLine.hidden = YES;
    } else if (lineStyle == XKOrderTrackCellLineTopStyle) {
        _btmLine.hidden = YES;
        _topLine.hidden = NO;
    } else if (lineStyle == XKOrderTrackCellLineFullStyle) {
        _btmLine.hidden = NO;
        _topLine.hidden = NO;
    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    if (indexPath.row == 0) {
        self.trackLabel.textColor = HEX_RGB(0x222222);
        [self setHasTopDiyView:YES];
        [self addSendingStatus];// 加入配送中状态
    } else {
        self.trackLabel.textColor = HEX_RGB(0x999999);
        [self setHasTopDiyView:YES];
    }
}


- (void)setModel:(id)model {
    _model = model;
    self.trackLabel.text = @"订单从上号【上海】发往【成都】果然是个人二哥二嫂额二嫂色色格式srg二嫂 ";
    self.timeLabel.text = @"2019-1-2 12:12:11";
}

- (void)addSendingStatus {
    [self.topDiyView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.topDiyView addSubview:self.sendingView];
    [self.sendingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.topDiyView);
    }];
}

- (UIView *)sendingView {
    if (!_sendingView) {
        _sendingView = [[UIView alloc] init];
        UILabel *label = [[UILabel alloc] init];
        [label rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.appendImage([UIImage imageNamed:@"xk_ic_order_sending"]).bounds(CGRectMake(0, -2.5, 14, 14));
            confer.text(@" 运送中").textColor(HEX_RGB(0x222222)).font(XKRegularFont(12));
        }];
        [_sendingView addSubview:label];
        WEAK_TYPES(_sendingView)
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weak_sendingView).insets(UIEdgeInsetsMake(0, 0, 5, 0));
            make.height.equalTo(@15);
        }];
    }
    return _sendingView;
}

@end
