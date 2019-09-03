/*******************************************************************************
 # File        : XKGroupFileCell.m
 # Project     : xkMerchant
 # Author      : Jamesholy
 # Created     : 2019/2/18
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKGroupFileCell.h"

@interface XKGroupFileCell ()
@property (nonatomic,strong) UIImageView    *iconView;
@property (nonatomic,strong) UILabel        *titleLabel;
//@property (nonatomic,strong) UILabel        *desLabel;
@property (nonatomic,strong) UILabel        *timeLabel;
@end

@implementation XKGroupFileCell

#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 初始化界面
        [self createUI];
        // 布局界面
        [self createConstraints];
    }
    return self;
}

#pragma mark - 初始化界面
- (void)createUI {
  [self.contentView addSubview:self.iconView];
  [self.contentView addSubview:self.titleLabel];
//  [self.contentView addSubview:self.desLabel];
  [self.contentView addSubview:self.timeLabel];
}

#pragma mark - 布局界面
- (void)createConstraints {
  [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.mas_equalTo(self.contentView.mas_centerY);
    make.left.mas_equalTo(self.contentView.mas_left).offset(10);
    make.size.mas_equalTo(CGSizeMake(48 * 1, 48 * 1));
    make.top.equalTo(self.contentView.mas_top).offset(8);
  }];
  _iconView.layer.cornerRadius = 5;
  _iconView.layer.masksToBounds = YES;
  _iconView.contentMode = UIViewContentModeScaleAspectFill;
  
  [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(self.contentView.mas_right).offset(-15 * ScreenScale);
    make.top.mas_equalTo(self.contentView.mas_top).offset(10 * 1);
    make.height.mas_equalTo(20 * 1);
  }];
  
  [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.top.mas_equalTo(self->_iconView.mas_top);
//    make.bottom.mas_equalTo(self->_iconView.mas_centerY);
    make.centerY.equalTo(self.iconView.mas_centerY);
    make.left.mas_equalTo(self->_iconView.mas_right).offset(18 * ScreenScale);
    make.right.mas_equalTo(self.timeLabel.mas_left).offset(-10);
  }];
  
//  [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.top.mas_equalTo(self->_iconView.mas_centerY);
//    make.bottom.mas_equalTo(self->_iconView.mas_bottom);
//    make.left.mas_equalTo(self->_titleLabel.mas_left);
//    make.right.mas_equalTo(self->_timeLabel.mas_right);
//  }];
//
}

#pragma mark ----------------------------- 公用方法 ------------------------------

-(UIImageView *)iconView{
  if (!_iconView) {
    _iconView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50 * 1, 50 * 1)];
    _iconView.contentMode = UIViewContentModeScaleAspectFill;
    _iconView.clipsToBounds = YES;
  }
  return _iconView;
}


-(UILabel *)timeLabel{
  if (!_timeLabel) {
    _timeLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12] textColor:UIColorFromRGB(0x999999) backgroundColor:[UIColor whiteColor]];
    _timeLabel.adjustsFontSizeToFitWidth = YES;
  }
  return _timeLabel;
}

-(UILabel *)titleLabel{
  if (!_titleLabel) {
    _titleLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:16] textColor:RGBGRAY(102) backgroundColor:[UIColor whiteColor]];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
  }
  return _titleLabel;
}

//-(UILabel *)desLabel{
//  if (!_desLabel) {
//    _desLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12] textColor:UIColorFromRGB(0x777777) backgroundColor:[UIColor whiteColor]];
//    _desLabel.textAlignment = NSTextAlignmentLeft;
//  }
//  return _desLabel;
//}

- (void)setModel:(XKGroupFileModel *)model {
  _model = model;
 
  NSString *type = [model.fileName componentsSeparatedByString:@"."].lastObject;
  NSString *imgName = [NSString stringWithFormat:@"fileSource.bundle/%@",type?type.lowercaseString:@"xx"];
  UIImage *typeImage = IMG_NAME(imgName);
  if (typeImage == nil) {
    typeImage = IMG_NAME(@"fileSource.bundle/unknow");
  }
  self.iconView.image = typeImage;
  _titleLabel.text = model.fileName;
  _timeLabel.text =  [NSString stringWithFormat:@"%@", [XKTimeSeparateHelper customTimeStyleWithTimestampString:model.updatedAt]];;
}


@end
