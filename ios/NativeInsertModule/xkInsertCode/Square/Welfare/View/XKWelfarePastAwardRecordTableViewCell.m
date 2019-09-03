//
//  XKWelfarePastAwardRecordTableViewCell.m
//  XKSquare
//
//  Created by xudehuai on 2018/12/3.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKWelfarePastAwardRecordTableViewCell.h"
#import "XKWelfarePastAwardRecordModel.h"

@interface XKWelfarePastAwardRecordTableViewCell()

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *periodLab;

@property (nonatomic, strong) UILabel *timeLab;

@property (nonatomic, strong) UILabel *idLab;


@property (nonatomic, strong) XKWelfarePastAwardRecordModel *welfarePastAwardRecord;

@end

@implementation XKWelfarePastAwardRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.containerView = [[UIView alloc] init];
        self.containerView.backgroundColor = HEX_RGB(0xFFFFFF);
        [self.contentView addSubview:self.containerView];
        
        self.imgView = [[UIImageView alloc] init];
        self.imgView.image = kDefaultPlaceHolderImg;
        [self.containerView addSubview:self.imgView];
        self.imgView.layer.cornerRadius = 4.0;
        self.imgView.layer.masksToBounds = YES;
        self.imgView.clipsToBounds = YES;
        
        self.periodLab = [[UILabel alloc] init];
        [self.containerView addSubview:self.periodLab];
        
        self.timeLab = [[UILabel alloc] init];
        self.timeLab.text = @"中奖时间";
        self.timeLab.font = XKRegularFont(12.0);
        self.timeLab.textColor = HEX_RGB(0x222222);
        [self.containerView addSubview:self.timeLab];
        
        self.idLab = [[UILabel alloc] init];
        self.idLab.text = @"编号";
        self.idLab.font = XKRegularFont(12.0);
        self.idLab.textColor = HEX_RGB(0x222222);
        [self.containerView addSubview:self.idLab];
        
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0));
        }];

        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(15.0);
            make.centerY.mas_equalTo(self.containerView);
            make.width.height.mas_equalTo(40.0);
        }];

        [self.periodLab setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [self.periodLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.imgView);
            make.left.mas_equalTo(self.imgView.mas_right).offset(10.0);
            make.right.mas_equalTo(self.timeLab.mas_left).offset(-10.0);
        }];

        [self.timeLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.imgView);
            make.trailing.mas_equalTo(-15.0);
        }];

        [self.idLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.imgView);
            make.left.mas_equalTo(self.imgView.mas_right).offset(10.0);
            make.trailing.mas_equalTo(-15.0);
        }];
    }
    return self;
}

- (void)configCellWithWelfarePastAwardRecordModel:(XKWelfarePastAwardRecordModel *)welfarePastAwardRecord {
    _welfarePastAwardRecord = welfarePastAwardRecord;
    if (_welfarePastAwardRecord.mainUrl && _welfarePastAwardRecord.mainUrl.length) {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:_welfarePastAwardRecord.mainUrl] placeholderImage:kDefaultPlaceHolderImg];
    } else {
        self.imgView.image = kDefaultPlaceHolderImg;
    }
    
    self.periodLab.attributedText = [NSMutableAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
        confer.text(@"中奖期数：").font(XKRegularFont(14.0)).textColor(HEX_RGB(0x222222));
        confer.text(self.welfarePastAwardRecord.sequenceId).font(XKRegularFont(14.0)).textColor(XKMainRedColor);
    }];
    
    self.timeLab.text = [NSString stringWithFormat:@"开奖时间：%@", [XKTimeSeparateHelper backYMDHMStringByStrigulaSegmentWithTimestampString:[NSString stringWithFormat:@"%tu", _welfarePastAwardRecord.expectDrawTime]]];
    self.idLab.text = [NSString stringWithFormat:@"编号：%@", _welfarePastAwardRecord.goodsId];
}

@end
