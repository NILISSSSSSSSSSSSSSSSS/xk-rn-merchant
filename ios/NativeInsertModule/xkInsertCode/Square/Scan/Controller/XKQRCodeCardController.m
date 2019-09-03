/*******************************************************************************
 # File        : XKQRCodeCardController.m
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

#import "XKQRCodeCardController.h"
#import <RZColorful.h>
#import "XKAuthorityTool.h"
#import "XKQRCodeView.h"
#import "UIView+XKCornerBorder.h"

@interface XKQRCodeCardController () {
  
}
/**<##>*/
@property(nonatomic, strong) UIImageView *imageView;
/**信息label*/
@property(nonatomic, strong) UILabel *infoLabel;
/***/
@property (nonatomic, strong) XKQRCodeView *codeView;

@property(nonatomic, strong) UIImageView *codeImageView;
/**推荐码label*/
@property(nonatomic, strong) UILabel *numLabel;
/**<##>*/
@property(nonatomic, strong)   UIView *contentView;

@property(nonatomic, strong) UILabel *addessLabel;

@end

@implementation XKQRCodeCardController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
    
}

#pragma mark - 初始化界面
- (void)createUI {
    self.navigationView.hidden = NO;
    [self hideNavigationSeperateLine];
    [self setNavTitle:@"二维码名片" WithColor:[UIColor whiteColor]];
    UIView *bgView = [[UIView alloc] init];
    [self.view addSubview:bgView];
    bgView.backgroundColor = RGBGRAY(110);
    
    // 保存按钮
    if (self.canSave) {
        UIButton *saveBtn  = [UIButton new];
        saveBtn.frame = CGRectMake(0, 0, 30, 25);
        [saveBtn setImage:IMG_NAME(@"xk_btn_down_img") forState:UIControlStateNormal];
        [saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        [self setRightView:saveBtn withframe:saveBtn.bounds];
    }
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 6;
    contentView.clipsToBounds = YES;
    [bgView addSubview:contentView];
    _contentView = contentView;
    

    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.cornerRadius = 5;
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imageView.layer.masksToBounds = YES;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[XKUserInfo getCurrentUserAvatar]] placeholderImage:kDefaultPlaceHolderImg];
    [contentView addSubview:self.imageView];
    
    
    self.infoLabel = [[UILabel alloc] init];
    self.infoLabel.numberOfLines = 1;
    [self.infoLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.paragraphStyle.lineSpacing(8);
        confer.text([XKUserInfo getCurrentUserName]).textColor(RGBGRAY(51)).font(XKRegularFont(17));
    }];
    [contentView addSubview:self.infoLabel];
    
    
    self.addessLabel = [[UILabel alloc] init];
    self.addessLabel.numberOfLines = 1;
    [self.addessLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.paragraphStyle.lineSpacing(8);
        confer.text([XKUserInfo getCurrentAddress]).textColor(RGBGRAY(151)).font(XKRegularFont(14));
    }];
    [contentView addSubview:self.addessLabel];
    
    
    self.codeView = [[XKQRCodeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 60, SCREEN_WIDTH - 60)];
    [self.codeView createQRImageWithQRString:[NSString stringWithFormat:@"xksl://business_card?userId=%@&securityCode=%@",[XKUserInfo getCurrentUserId],[XKUserInfo getCurrentMrCode]] correctionLevel:@"L"];
    [contentView addSubview:self.codeView];
    
    
    self.codeImageView = [[UIImageView alloc] init];
    self.codeImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.codeImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.codeImageView.layer.borderWidth = 3.0;
    self.codeImageView.layer.cornerRadius = 3;
    self.codeImageView.layer.masksToBounds = YES;
    [self.codeImageView sd_setImageWithURL:[NSURL URLWithString:[XKUserInfo getCurrentUserAvatar]] placeholderImage:kDefaultPlaceHolderImg];
    [self.codeView addSubview:self.codeImageView];
    
    
    self.numLabel = [[UILabel alloc] init];
    self.numLabel.numberOfLines = 0;
    [self.numLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.paragraphStyle.lineSpacing(8).alignment(NSTextAlignmentCenter);
        confer.text([NSString stringWithFormat:@"安全码:%@",[XKUserInfo getCurrentMrCode]]).textColor(RGBGRAY(51)).font(XKRegularFont(17));
        confer.text(@"\n");
        confer.text(@"加好友或获取安全码请扫我！").textColor(RGBGRAY(151)).font(XKRegularFont(14));
    }];
    [contentView addSubview:self.numLabel];

    
    CGFloat space = 15;
    // 约束
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navigationView.mas_bottom);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(60*ScreenScale);
        make.left.equalTo(bgView).offset(30*ScreenScale);
        make.right.equalTo(bgView).offset(-30*ScreenScale);
    }];
    
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top).offset(space);
        make.left.equalTo(contentView.mas_left).offset(space);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(space);
        make.right.equalTo(self.contentView).offset(-space);
        make.top.equalTo(self.imageView.mas_top);
    }];
    
    
    [self.addessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(space);
        make.top.equalTo(self.infoLabel.mas_bottom).offset(10);
    }];
    
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.imageView.mas_bottom).offset(20);
//        make.centerX.equalTo(contentView);
        make.left.equalTo(contentView).offset(30);
        make.right.equalTo(contentView).offset(-30);
        make.height.equalTo(self.codeView.mas_width);
        
    }];
    
    [self.codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.codeView);
        make.height.width.equalTo(@40);
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeView.mas_bottom).offset(space * 1.5);
        make.centerX.equalTo(contentView);
        make.bottom.equalTo(contentView.mas_bottom).offset(-space * 1.5);
    }];
    

}

#pragma mark ----------------------------- 其他方法 ------------------------------

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)save {
    [XKAuthorityTool judgeAuthorityType:PrivacyAuthorityTypeAlbum needGuide:YES has:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            CGRect frame = self.contentView.frame;
            UIGraphicsBeginImageContextWithOptions(frame.size, NO, [UIScreen mainScreen].scale);
            CGContextRef contextRef = UIGraphicsGetCurrentContext();
            [self.contentView.layer renderInContext:contextRef];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            if (!image) {
                [XKHudView showTipMessage:@"保存失败"];
            } else {
                UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            }
        });
    } hasnt:^{
        //
    }];

}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
//    NSString *msg = nil ;
    if(error){
       [XKHudView showTipMessage:@"保存失败"];
    }else{
       [XKHudView showTipMessage:@"保存成功"];
    }
   
}

#pragma mark ----------------------------- 网络请求 ------------------------------

#pragma mark ----------------------------- 代理方法 ------------------------------

#pragma mark --------------------------- setter&getter -------------------------


@end
