/*******************************************************************************
 # File        : XKGroupQRCodeController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/30
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKGroupQRCodeController.h"
#import <RZColorful.h>
#import "XKAuthorityTool.h"
#import "XKQRCodeView.h"

@interface XKGroupQRCodeController () {
    UIView *_contentView;
}
/**<##>*/
@property(nonatomic, strong) UIImageView *imageView;
/**信息label*/
@property(nonatomic, strong) UILabel *nameLabel;
/**信息label*/
@property(nonatomic, strong) UILabel *infoLabel;
/***/
@property (nonatomic, strong) XKQRCodeView *codeView;



@end

@implementation XKGroupQRCodeController

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
    
    [self setNavTitle:@"群二维码" WithColor:[UIColor whiteColor]];
    
    // 保存按钮
    UIButton *saveBtn  = [UIButton new];
    [saveBtn setTitle:@"存入相册" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.titleLabel.font = XKRegularFont(17);
    [saveBtn sizeToFit];
    [saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self setRightView:saveBtn withframe:saveBtn.bounds];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 6;
    contentView.clipsToBounds = YES;
    [self.containView addSubview:contentView];
    _contentView = contentView;
    
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = 3;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.imageView sd_setImageWithURL:kURL(self.groupIconUrl) placeholderImage:kDefaultPlaceHolderImg];
    [contentView addSubview:self.imageView];
    
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.numberOfLines = 1;
    self.nameLabel.font = XKRegularFont(17);
    self.nameLabel.textColor = HEX_RGB(0x222222);
    [contentView addSubview:self.nameLabel];
    self.nameLabel.text = self.groupName ? :@"未命名";
    
    self.infoLabel = [[UILabel alloc] init];
    self.infoLabel.numberOfLines = 1;
    self.infoLabel.font = XKRegularFont(13);
    self.infoLabel.textColor = HEX_RGB(0x777777);
    self.infoLabel.text = @"扫一扫二维码，加入该群";
    [contentView addSubview:self.infoLabel];
    
    
    
    self.codeView = [[XKQRCodeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 60, SCREEN_WIDTH - 60)];
    [self.codeView createQRImageWithQRString:[NSString stringWithFormat:@"xksl://group_business_card?groupId=%@",[XKUserInfo currentUser].userId,[XKUserInfo currentUser].qrCode,self.groupQrStr] correctionLevel:@"M"];
    [contentView addSubview:self.codeView];

    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containView).offset(14);
        make.left.equalTo(self.containView).offset(14);
        make.right.equalTo(self.containView).offset(-14);
    }];
    
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(contentView.mas_top).offset(30);
        //        make.centerX.equalTo(contentView);
        make.left.equalTo(contentView).offset(40);
        make.right.equalTo(contentView).offset(-40);
        make.height.equalTo(self.codeView.mas_width);
    }];
    
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeView.mas_bottom).offset(33);
        make.left.equalTo(contentView.mas_left).offset(16);
        make.size.mas_equalTo(CGSizeMake(46, 46));
        make.bottom.equalTo(contentView.mas_bottom).offset(-20);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(15);
        make.right.equalTo(contentView).offset(-15);
        make.top.equalTo(self.imageView.mas_top).offset(-2);
    }];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(15);
        make.right.equalTo(contentView).offset(-15);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(3);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = HEX_RGB(0xF0F0F0);
    [contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(self.codeView.mas_bottom).offset(13);
        make.height.equalTo(@1);
    }];
}

#pragma mark ----------------------------- 其他方法 ------------------------------

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)save {
    [XKAuthorityTool judgeAuthorityType:PrivacyAuthorityTypeAlbum needGuide:YES has:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            CGRect frame = self->_contentView.frame;
            UIGraphicsBeginImageContextWithOptions(frame.size, NO, [UIScreen mainScreen].scale);
            CGContextRef contextRef = UIGraphicsGetCurrentContext();
            [self->_contentView.layer renderInContext:contextRef];
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
        [XKHudView showTipMessage:@"存入失败"];
    }else{
        [XKHudView showTipMessage:@"已存入系统相册"];
    }
    
}

#pragma mark ----------------------------- 网络请求 ------------------------------

#pragma mark ----------------------------- 代理方法 ------------------------------

#pragma mark --------------------------- setter&getter -------------------------


@end
