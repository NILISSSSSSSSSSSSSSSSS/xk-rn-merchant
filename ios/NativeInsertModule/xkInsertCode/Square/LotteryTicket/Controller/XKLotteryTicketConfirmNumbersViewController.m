//
//  XKLotteryTicketConfirmNumbersViewController.m
//  XKSquare
//
//  Created by xudehuai on 2018/12/10.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKLotteryTicketConfirmNumbersViewController.h"
#import "XKLotteryTicketNumbersTableViewCell.h"
#import "XKLotteryTicketAnnouncementViewController.h"
#import "XKCommonResultViewController.h"

@interface XKLotteryTicketConfirmNumbersViewController ()

@property (nonatomic, strong) XKLotteryTicketNumbersTableViewCell *numbersView;

@property (nonatomic, strong) UIButton *checkBtn;

@property (nonatomic, strong) YYLabel *protocolLab;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *lotteryTicketNumLab;

@property (nonatomic, strong) UIButton *confirmBtn;

@end

@implementation XKLotteryTicketConfirmNumbersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"大乐透" WithColor:HEX_RGB(0xFFFFFF)];
    
    [self initializeViews];
    [self updateViews];
    [self refreshBottomView];
    [self.numbersView configBallsViewWithNums:self.selectedNums];
}

- (void)initializeViews {
    self.numbersView = [[XKLotteryTicketNumbersTableViewCell alloc] init];
    self.numbersView.frame = CGRectMake(0.0, 10.0, SCREEN_WIDTH, 60.0);
    self.numbersView.cellType = XKLotteryTicketNumbersCellTypeImg;
    [self.containView addSubview:self.numbersView];
    
    self.numbersView.containerView.layer.cornerRadius = 4.0;
    
    self.checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.checkBtn setImage:IMG_NAME(@"xk_img_lotteryTicket_normal") forState:UIControlStateNormal];
    [self.checkBtn setImage:IMG_NAME(@"xk_img_lotteryTicket_selected") forState:UIControlStateSelected];
    [self.containView addSubview:self.checkBtn];
    [self.checkBtn addTarget:self action:@selector(checkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.protocolLab = [[YYLabel alloc] init];
    self.protocolLab.numberOfLines = 1;
    [self.containView addSubview:self.protocolLab];
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = HEX_RGB(0xFFFFFF);
    [self.containView addSubview:self.bottomView];
    
    self.lotteryTicketNumLab = [[UILabel alloc] init];
    [self.bottomView addSubview:self.lotteryTicketNumLab];
    self.lotteryTicketNumLab.attributedText = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
        confer.text(@"注数：").font(XKRegularFont(14.0)).textColor(HEX_RGB(0x777777));
        confer.text([NSString stringWithFormat:@"%tu注", self.selectedLotteryTicketNum]).font(XKRegularFont(14.0)).textColor(HEX_RGB(0x555555));
    }];
    
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmBtn.titleLabel.font = XKRegularFont(17.0);
    [self.confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmBtn setTitleColor:HEX_RGB(0xFFFFFF) forState:UIControlStateNormal];
    [self.bottomView addSubview:self.confirmBtn];
    [self.confirmBtn addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)updateViews {

    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.numbersView.mas_bottom).offset(15.0);
        make.leading.mas_equalTo(self.numbersView).offset(10.0);
        make.width.height.mas_equalTo(20.0);
    }];
    
    NSString *protocol = @"《xx协议》";
    NSMutableAttributedString *protocolStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"我已阅读并同意%@", protocol]];
    [protocolStr addAttribute:NSFontAttributeName value:XKRegularFont(14.0) range:NSMakeRange(0, protocolStr.length)];
    [protocolStr addAttribute:NSForegroundColorAttributeName value:HEX_RGB(0x999999) range:NSMakeRange(0, protocolStr.length - protocol.length)];
    [protocolStr addAttribute:NSForegroundColorAttributeName value:XKMainTypeColor range:NSMakeRange(protocolStr.length - protocol.length, protocol.length)];
    [self.protocolLab.textParser parseText:protocolStr selectedRange:NULL];
    self.protocolLab.attributedText = protocolStr;
    
    [protocolStr yy_setTextHighlightRange:[protocolStr.string rangeOfString:protocol] color:XKMainTypeColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        
    }];
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    container.linePositionModifier = self.protocolLab.linePositionModifier;
    container.insets = self.protocolLab.textContainerInset;
    container.maximumNumberOfRows = self.protocolLab.numberOfLines;
    //创建layout
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:protocolStr];
    
    [self.protocolLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.checkBtn.mas_right).offset(5.0);
        make.centerY.mas_equalTo(self.checkBtn);
        make.size.mas_equalTo(layout.textBoundingSize);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.containView);
        make.bottom.mas_equalTo(-kBottomSafeHeight);
        make.height.mas_equalTo(50.0);
    }];
    
    [self.lotteryTicketNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.bottomView);
        make.right.mas_equalTo(self.confirmBtn.mas_left).offset(-15.0);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.bottom.mas_equalTo(self.bottomView);
        make.width.mas_equalTo(120.0);
    }];
}

- (void)checkBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self refreshBottomView];
}

- (void)confirmBtnAction:(UIButton *)sender {
//    XKLotteryTicketAnnouncementViewController *vc = [[XKLotteryTicketAnnouncementViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    XKCommonResultViewController *vc = [[XKCommonResultViewController alloc] init];
    vc.titleStr = @"选号成功";
    vc.vcType = XKCommonResultVCTypeSucceed;
    vc.resultStr = @"选号成功，请等待平台投注！";
    [vc addBtnWithBtnTitle:@"继续抽奖" btnColor:HEX_RGB(0x999999) btnBlock:^(UIViewController * _Nonnull resultVC) {
        [resultVC.navigationController popViewControllerAnimated:YES];
    }];
    [vc addBtnWithBtnTitle:@"返回广场" btnColor:XKMainTypeColor btnBlock:^(UIViewController * _Nonnull resultVC) {
        [resultVC.navigationController popToRootViewControllerAnimated:YES];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshBottomView {
    self.confirmBtn.enabled = self.checkBtn.selected;
    self.confirmBtn.backgroundColor = self.checkBtn.selected ? XKMainTypeColor : HEX_RGB(0x999999);
}

@end
