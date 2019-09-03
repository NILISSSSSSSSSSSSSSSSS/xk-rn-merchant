/*******************************************************************************
 # File        : XKRealNameAuthController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/6
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKRealNameAuthController.h"
#import "XKCommonDiyHeadView.h"
#import "XKInfoInputView.h"
#import "UIView+Border.h"
#import "XKIDCardPickHelper.h"
#import "XKRealNameResultController.h"
#import "XKUploadManager.h"
#import <IQKeyboardManager.h>
#import "XKBottomAlertSheetView.h"

@interface XKRealNameAuthController () <UITextFieldDelegate>
/**scrollView*/
@property(nonatomic, strong) UIScrollView *scrollView;
/**消费金额输入视图*/
@property(nonatomic, strong) UIView *infoView;
/**底部信息视图*/
@property(nonatomic, strong) UIView *idCardView;
/**身份证图片*/
@property(nonatomic, strong) UIImageView *idCardImageView;
@property(nonatomic, strong) UIImageView *idCardImageView2;
@property(nonatomic, strong) UIView *btn1;
@property(nonatomic, strong) UIView *btn2;
@property(nonatomic, strong) UIButton *delteBtn1;
@property(nonatomic, strong) UIButton *delteBtn2;
/**<##>*/
@property(nonatomic, strong) XKIDCardPickHelper *pickHelper;

/**身份证号*/
@property(nonatomic, copy) NSString *idCard;
/**名字*/
@property(nonatomic, copy) NSString *realName;
@property(nonatomic, copy) NSString *sex;
/**身份证信息*/
@property(nonatomic, strong) NSMutableDictionary *idCardImgDic;
@property(nonatomic, strong) NSMutableDictionary *idCardImgDic2;

@end

@implementation XKRealNameAuthController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].enable = YES;
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];
}

- (void)dealloc {
    NSLog(@"=====%@被销毁了=====", [self class]);
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
    _idCardImageView = @{}.mutableCopy;
}

#pragma mark - 初始化界面
- (void)createUI {
    self.navigationView.hidden = NO;
    [self setNavTitle:@"实名认证" WithColor:[UIColor whiteColor]];
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = HEX_RGB(0xF6F6F6);
    self.scrollView.tag = kNeedFixHudOffestViewTag;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(self.navigationView.mas_bottom);
    }];
    
    [self.scrollView addSubview:self.infoView];
    [self.scrollView addSubview:self.idCardView];
    
    UILabel *idLabel = [UILabel new];
    idLabel.text = @"身份证照片";
    idLabel.textColor = HEX_RGB(0x7777777);
    idLabel.font = XKRegularFont(14);
    [self.scrollView addSubview:idLabel];
    
    CGFloat space = 10;
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(space);
        make.left.equalTo(self.scrollView.mas_left).offset(space);
        make.centerX.equalTo(self.scrollView);
    }];
    [idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView.mas_bottom).offset(15);
        make.left.equalTo(self.scrollView.mas_left).offset(space * 2);
    }];
    [self.idCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(idLabel.mas_bottom).offset(space);
        make.centerX.equalTo(self.scrollView);
        make.left.equalTo(self.scrollView.mas_left).offset(space);
    }];
    
    UIButton *sureBtn = [[UIButton alloc] init];
    sureBtn.backgroundColor = XKMainTypeColor;
    [sureBtn setTitle:@"提交审核" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = XKMediumFont(17);
    sureBtn.layer.cornerRadius = 5;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.scrollView addSubview:sureBtn];
    [sureBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.idCardView.mas_bottom).offset(space * 2);
        make.centerX.equalTo(self.scrollView);
        make.left.equalTo(self.scrollView.mas_left).offset(space);
        make.bottom.equalTo(self.scrollView.mas_bottom);
        make.height.equalTo(@50);
    }];
}

#pragma mark ----------------------------- 其他方法 ------------------------------

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)commit {
    [KEY_WINDOW endEditing:YES];
    if (![self checkData]) {
        return;
    }
    // 传图片
    [XKHudView showLoadingTo:self.scrollView animated:YES];
    [self uploadImgResult:^(NSString *error, NSString *key1, NSString *key2) {
        if (error) {
            [XKHudView hideHUDForView:self.scrollView];
            [XKHudView showErrorMessage:@"上传图片失败" to:self.scrollView animated:YES];
            return ;
        }
        NSMutableDictionary *params = @{}.mutableCopy;
        params[@"realName"] = self.realName;
        params[@"idCardNum"] = self.idCard;
        params[@"idCardImageFront"] = key1;
        params[@"idCardImageBack"] = key2;
        params[@"sex"] = self.sex;

        [HTTPClient postEncryptRequestWithURLString:@"user/ua/xkUserAuthCreate/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
            [XKHudView hideHUDForView:self.scrollView];
            XKRealNameResultController *vc = [[XKRealNameResultController alloc] init];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                           ^{
                               EXECUTE_BLOCK(self.sumbitCompelete);
                           });
            [self.navigationController pushViewController:vc animated:YES];
        } failure:^(XKHttpErrror *error) {
            [XKHudView hideHUDForView:self.scrollView];
            [XKHudView showErrorMessage:error.message to:self.scrollView animated:YES];
        }];
    }];
}

- (void)uploadImgResult:(void(^)(NSString *error,NSString *key1,NSString *key2))result {
    [self uploadSingImg:self.idCardImgDic result:^(NSString *error, NSString *key1) {
        if (error) {
            result(error,nil,nil);
        } else {
            [self uploadSingImg:self.idCardImgDic2 result:^(NSString *error, NSString *key2) {
                if (error) {
                    result(error,nil,nil);
                } else {
                    result(nil, kQNPrefix(key1),kQNPrefix(key2));
                }
            }];
        }
    }];
}

- (void)uploadSingImg:(NSMutableDictionary *)imgDic result:(void(^)(NSString *error,NSString *key))result {
    if (imgDic[@"key"]) {
        result(nil,imgDic[@"key"]);
        return;
    }
    [[XKUploadManager shareManager] uploadImage:imgDic[@"img"] withKey:@"realNameAuth" progress:nil success:^(NSString *url) {
        imgDic[@"key"] = url;
        result(nil,url);
    } failure:^(id data) {
        result(data,nil);
    }];
}

- (BOOL)checkData {
    if (self.realName.length == 0) {
        [XKHudView showWarnMessage:@"请输入姓名"];
        return NO;
    }
    if (self.realName.length < 2) {
        [XKHudView showWarnMessage:@"请输入两位数及以上的姓名"];
        return NO;
    }
    if (self.idCard.length != 18) {
        [XKHudView showWarnMessage:@"请输入正确的身份证号"];
        return NO;
    }
    if (self.sex.length == 0) {
        [XKHudView showWarnMessage:@"请选择性别"];
        return NO;
    }
    if (self.idCardImgDic[@"img"] == nil) {
        [XKHudView showWarnMessage:@"请上传身份证正面照"];
        return NO;
    }
    if (self.idCardImgDic2[@"img"] == nil) {
        [XKHudView showWarnMessage:@"请上传身份证背面照"];
        return NO;
    }
    return YES;
}
#pragma mark ----------------------------- 网络请求 ------------------------------

#pragma mark ----------------------------- 代理方法 ------------------------------

#pragma mark --------------------------- setter&getter -------------------------
- (UIView *)infoView {
    if (!_infoView) {
        __weak typeof(self) weakSelf = self;
        _infoView = [[UIView alloc] init];
        _infoView.backgroundColor = [UIColor whiteColor];
        [_infoView drawCommonShadowUselayer];
        WEAK_TYPES(_infoView);
        XKInfoInputView *nameInputView = [[XKInfoInputView alloc] init];
        nameInputView.title = @"真实姓名";
        nameInputView.placeHolder = @"请输入姓名";
        nameInputView.type = XKInfoInputViewTypeNormal;
        nameInputView.maxNum = 20;
        [nameInputView setTextChange:^(NSString *text) {
            weakSelf.realName = text;
        }];
        [_infoView addSubview:nameInputView];
        [nameInputView showBorderSite:rzBorderSitePlaceBottom];
        nameInputView.bottomBorder.borderLine.backgroundColor = RGBGRAY(231);
        nameInputView.bottomBorder.borderSize = 0.5;
        
        XKInfoInputView *sexChooseView = [[XKInfoInputView alloc] init];
        sexChooseView.title = @"真实性别";
        sexChooseView.placeHolder = @"";
        sexChooseView.textField.userInteractionEnabled = NO;
        sexChooseView.type = XKInfoInputViewTypeNormal;
        [_infoView addSubview:sexChooseView];
        [sexChooseView showBorderSite:rzBorderSitePlaceBottom];
        sexChooseView.bottomBorder.borderLine.backgroundColor = RGBGRAY(231);
        sexChooseView.bottomBorder.borderSize = 0.5;
        
        UIButton *chooseBtn = [[UIButton alloc] init];
        chooseBtn.tintColor = [UIColor whiteColor];
        chooseBtn.backgroundColor = XKMainTypeColor;
        chooseBtn.layer.cornerRadius = 9;
        chooseBtn.layer.masksToBounds = YES;
        [chooseBtn setImage:[IMG_NAME(@"xk_btn_mine_arrow_down") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [sexChooseView addSubview:chooseBtn];
        chooseBtn.transform = CGAffineTransformMakeRotation(-M_PI_2);
        [chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(sexChooseView.titleLabel.mas_right).offset(50);
            make.centerY.equalTo(sexChooseView);
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }];
        [chooseBtn bk_addEventHandler:^(id sender) {
            [KEY_WINDOW endEditing:YES];
            XKBottomAlertSheetView *view = [[XKBottomAlertSheetView alloc] initWithBottomSheetViewWithDataSource:@[@"男", @"女",@"取消"] firstTitleColor:nil choseBlock:^(NSInteger index, NSString *choseTitle) {
                if ([choseTitle isEqualToString:@"男"]) {
                    sexChooseView.text = @"男";
                    weakSelf.sex = @"male";
                } else if ([choseTitle isEqualToString:@"女"]) {
                    sexChooseView.text = @"女";
                    weakSelf.sex = @"female";
                }
            }];
            [view show];
        } forControlEvents:UIControlEventTouchUpInside];
        sexChooseView.text = @"男";
        self.sex = @"male";
        XKInfoInputView *idCardInputView = [[XKInfoInputView alloc] init];
        idCardInputView.title = @"身份证号";
        idCardInputView.placeHolder = @"请输入身份证号";
        idCardInputView.type = XKInfoInputViewTypeIdCard;
        [idCardInputView setTextChange:^(NSString *text) {
            weakSelf.idCard = text;
        }];
        [_infoView addSubview:idCardInputView];
        [nameInputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(weak_infoView);
            make.height.equalTo(@50);
        }];
        [sexChooseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(nameInputView);
            make.top.equalTo(nameInputView.mas_bottom);
            make.height.equalTo(@50);
        }];
        [idCardInputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(weak_infoView);
            make.height.equalTo(@50);
            make.top.equalTo(sexChooseView.mas_bottom);
        }];
    }
    return _infoView;
}

- (UIView *)idCardView {
    if (!_idCardView) {
        
        UIView *cardView = [[UIView alloc] init];
        _idCardView = cardView;
        _idCardView.layer.cornerRadius = 5;
        _idCardView.layer.masksToBounds = YES;
        _idCardView.backgroundColor = [UIColor whiteColor];
        [_idCardView drawCommonShadowUselayer];
 
        UILabel *desLabel = [[UILabel alloc] init];
        desLabel.text = @"温馨提示：请上传身份证正反面照片共两张，并保证上传照片内的证件文字清晰可见";
        desLabel.textColor = HEX_RGB(0x222222);
        desLabel.font = XKRegularFont(13);
        desLabel.numberOfLines = 0;
        [cardView addSubview:desLabel];
        [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cardView.mas_top).offset(15);
            make.centerX.equalTo(cardView);
            make.left.equalTo(cardView.mas_left).offset(15);
        }];
        
        _idCardImageView = [[UIImageView alloc] init];
        _idCardImageView.userInteractionEnabled = YES;
        CGFloat width = (SCREEN_WIDTH - 10 * 2 - 15 * 2 - 15)/2;
        CGFloat heidht = width * 79/126.0;
        _idCardImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addXuxian:_idCardImageView frame:CGRectMake(0, 0, width, heidht)];
        _idCardImageView.backgroundColor = HEX_RGB(0xF6F6F6);
        [_idCardView addSubview:_idCardImageView];
        __weak typeof(self) weakSelf = self;
        UIView *btn1 = [self getBtn:@"正面照片"];
        [_idCardImageView addSubview:btn1];
        [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.idCardImageView);
        }];
        _btn1 = btn1;
        [_btn1 bk_whenTapped:^{
            [self.view endEditing:YES];
            [weakSelf.pickHelper showView];
            [weakSelf.pickHelper setChoseImageBlcok:^(UIImage *image) {
                weakSelf.btn1.hidden = YES;
                weakSelf.delteBtn1.hidden = NO;
                weakSelf.idCardImageView.image = image;
                NSMutableDictionary *params = @{}.mutableCopy;
                params[@"img"] = image;
                weakSelf.idCardImgDic = params;
                
            }];
        }];
        _delteBtn1 = [UIButton new];
        _delteBtn1.hidden = YES;
        [_delteBtn1 setImage:IMG_NAME(@"xk_btn_welfare_delete") forState:UIControlStateNormal];
        [self.idCardImageView addSubview:_delteBtn1];
        [_delteBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.idCardImageView).offset(4);
            make.right.equalTo(self.idCardImageView).offset(-4);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        [_delteBtn1 bk_addEventHandler:^(id sender) {
            weakSelf.delteBtn1.hidden = YES;
            weakSelf.btn1.hidden = NO;
            weakSelf.idCardImageView.image = nil;
            weakSelf.idCardImgDic = nil;
            
        } forControlEvents:UIControlEventTouchUpInside];
        
        _idCardImageView2 = [[UIImageView alloc] init];
        _idCardImageView2.userInteractionEnabled = YES;
        _idCardImageView2.contentMode = UIViewContentModeScaleAspectFill;
        _idCardImageView2.backgroundColor = HEX_RGB(0xF6F6F6);
        [self addXuxian:_idCardImageView2 frame:CGRectMake(0, 0, width, heidht)];
        [_idCardView addSubview:_idCardImageView2];
        UIView *btn2 = [self getBtn:@"背面照片"];
        [_idCardImageView2 addSubview:btn2];
        [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.idCardImageView2);
        }];
        _btn2 = btn2;
        [_btn2 bk_whenTapped:^{
            [self.view endEditing:YES];
            [weakSelf.pickHelper showView];
            [weakSelf.pickHelper setChoseImageBlcok:^(UIImage *image) {
                weakSelf.btn2.hidden = YES;
                weakSelf.delteBtn2.hidden = NO;
                weakSelf.idCardImageView2.image = image;
                NSMutableDictionary *params = @{}.mutableCopy;
                params[@"img"] = image;
                weakSelf.idCardImgDic2 = params;
            }];
        }];
        _delteBtn2 = [UIButton new];
        _delteBtn2.hidden = YES;
        [_delteBtn2 setImage:IMG_NAME(@"xk_btn_welfare_delete") forState:UIControlStateNormal];
        [self.idCardImageView2 addSubview:_delteBtn2];
        [_delteBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.idCardImageView2).offset(4);
            make.right.equalTo(self.idCardImageView2).offset(-4);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        [_delteBtn2 bk_addEventHandler:^(id sender) {
            weakSelf.delteBtn2.hidden = YES;
            weakSelf.btn2.hidden = NO;
            weakSelf.idCardImageView2.image = nil;
            weakSelf.idCardImgDic2 = nil;
        } forControlEvents:UIControlEventTouchUpInside];
    
        [_idCardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(heidht);
            make.top.equalTo(desLabel.mas_bottom).offset(20);
            make.left.equalTo(cardView.mas_left).offset(15);
            make.bottom.equalTo(cardView.mas_bottom).offset(-25);
        }];
        [_idCardImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.width.height.equalTo(self.idCardImageView);
            make.right.equalTo(cardView.mas_right).offset(-15);
        }];
    }
    return _idCardView;
}

- (void)addXuxian:(UIView *)view frame:(CGRect)bounds {
    CAShapeLayer *border = [CAShapeLayer layer];
    //虚线的颜色
    border.strokeColor = HEX_RGB(0xe0e0e0).CGColor;
    //填充的颜色
    border.fillColor = [UIColor clearColor].CGColor;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:6];
    //设置路径
    border.path = path.CGPath;
    border.frame = bounds;
    //虚线的宽度
    border.lineWidth = 1.f;
    //设置线条的样式
    //    border.lineCap = @"square";
    //虚线的间隔
    border.lineDashPattern = @[@5, @3];
    view.layer.cornerRadius = 6.f;
    view.layer.masksToBounds = YES;
    [view.layer addSublayer:border];
}

- (UIView *)getBtn:(NSString *)text {
    UIView *view = [UIView new];
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:IMG_NAME(@"xk_ic_video_addFoucs") forState:UIControlStateNormal];
    btn.userInteractionEnabled = NO;
    btn.layer.cornerRadius = 15;
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.masksToBounds = YES;
    [view addSubview:btn];
    UILabel *label = [UILabel new];
    label.text = text;
    label.font = XKRegularFont(13);
    label.textColor = HEX_RGB(0x777777);
    [view addSubview:label];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn.mas_bottom).offset(5);
        make.centerX.equalTo(view);
        make.bottom.equalTo(view.mas_bottom);
        make.left.equalTo(view.mas_left).offset(20);
    }];
    return view;
}

- (XKIDCardPickHelper *)pickHelper {
    if (!_pickHelper) {
        _pickHelper = [[XKIDCardPickHelper alloc] init];
    }
    return _pickHelper;
}

@end
