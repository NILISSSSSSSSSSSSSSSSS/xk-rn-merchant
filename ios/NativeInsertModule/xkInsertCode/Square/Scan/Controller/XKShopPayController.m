/*******************************************************************************
 # File        : XKShopPayController.m
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

#import "XKShopPayController.h"
#import "XKCommonDiyHeadView.h"

@interface XKShopPayController () <UITextFieldDelegate>
/**scrollView*/
@property(nonatomic, strong) UIScrollView *scrollView;
/**消费金额输入视图*/
@property(nonatomic, strong) UIView *moneyInptView;
/**底部信息视图*/
@property(nonatomic, strong) UIView *bottomInfoView;
/**金额输入框*/
@property(nonatomic, strong) UITextField *inputTextField;
/**实际支付钱*/
@property(nonatomic, strong) XKCommonDiyHeadView *payMoneyView;
@end

@implementation XKShopPayController

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

- (void)dealloc {
    NSLog(@"=====%@被销毁了=====", [self class]);
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
    
}

#pragma mark - 初始化界面
- (void)createUI {
    self.navigationView.hidden = NO;
    [self setNavTitle:self.customTitle WithColor:[UIColor whiteColor]];
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = RGBGRAY(245);
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(self.navigationView.mas_bottom);
    }];
    
    [self.scrollView addSubview:self.moneyInptView];
    [self.scrollView addSubview:self.bottomInfoView];
    
    CGFloat space = 10;
    [self.moneyInptView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(space);
        make.left.equalTo(self.scrollView.mas_left).offset(space);
        make.centerX.equalTo(self.scrollView);
    }];
    [self.bottomInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyInptView.mas_bottom).offset(space);
        make.centerX.equalTo(self.scrollView);
        make.left.equalTo(self.scrollView.mas_left).offset(space);
    }];
    
    UIButton *sureBtn = [[UIButton alloc] init];
    sureBtn.backgroundColor = XKMainTypeColor;
    [sureBtn setTitle:@"确认买单" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = XKMediumFont(17);
    sureBtn.layer.cornerRadius = 5;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn bk_whenTapped:^{
        NSLog(@"跳转收银台");
    }];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.scrollView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomInfoView.mas_bottom).offset(space * 2);
        make.centerX.equalTo(self.scrollView);
        make.left.equalTo(self.scrollView.mas_left).offset(space);
        make.bottom.equalTo(self.scrollView.mas_bottom);
        make.height.equalTo(@50);
    }];
    if (self.vcType == ShopPayControllerFixationType) {
        self.inputTextField.text = self.money;
        self.inputTextField.enabled = NO;
        self.payMoneyView.contentLabel.text = [NSString stringWithFormat:@"￥%@",self.money];
    }
}

#pragma mark ----------------------------- 其他方法 ------------------------------

#pragma mark ----------------------------- 公用方法 ------------------------------

#pragma mark ----------------------------- 网络请求 ------------------------------

#pragma mark ----------------------------- 代理方法 ------------------------------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    UITextField *countTextField = textField;
    NSString *NumbersWithDot = @".1234567890";
    NSString *NumbersWithoutDot = @"1234567890";
    
    // 判断是否输入内容，或者用户点击的是键盘的删除按钮
    if (![string isEqualToString:@""]) {
        NSCharacterSet *cs;
        if ([textField isEqual:countTextField]) {
            // 小数点在字符串中的位置 第一个数字从0位置开始
            NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
            // 判断字符串中是否有小数点
            // NSNotFound 表示请求操作的某个内容或者item没有发现，或者不存在
            // range.location 表示的是当前输入的内容在整个字符串中的位置，位置编号从0开始
            if (dotLocation == NSNotFound ) {
                // -- 如果限制非第一位才能输入小数点，加上 && range.location != 0
                // 取只包含“myDotNumbers”中包含的内容，其余内容都被去掉
                /*
                 [NSCharacterSet characterSetWithCharactersInString:myDotNumbers]的作用是去掉"myDotNumbers"中包含的所有内容，只要字符串中有内容与"myDotNumbers"中的部分内容相同都会被舍去

                 在上述方法的末尾加上invertedSet就会使作用颠倒，只取与“myDotNumbers”中内容相同的字符
                 */
                cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithDot] invertedSet];
                if (range.location >= 9) {
//                    NSLog(@"单笔金额不能超过亿位");
                    if ([string isEqualToString:@"."] && range.location == 9) {
                        return YES;
                    }
                    return NO;
                }
            } else {
                cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithoutDot] invertedSet];
            }
            // 按cs分离出数组,数组按@""分离出字符串
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            BOOL basicTest = [string isEqualToString:filtered];
            if (!basicTest) {
//                NSLog(@"只能输入数字和小数点");
                return NO;
            }
            if (dotLocation != NSNotFound && range.location > dotLocation + 2) {
//                NSLog(@"小数点后最多两位");
                return NO;
            }
            if (textField.text.length > 11) {
                return NO;
            }
        }
    }
    return YES;
}


#pragma mark --------------------------- setter&getter -------------------------
- (UIView *)moneyInptView {
    if (!_moneyInptView) {
        _moneyInptView = [[UIView alloc] init];
        _moneyInptView.layer.cornerRadius = 5;
        _moneyInptView.layer.masksToBounds = YES;
        UIImageView *imageView = [[UIImageView alloc] init];
        [_moneyInptView addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1536054595955&di=1c1cf6ac41bf2a857fec0dd300b92986&imgtype=0&src=http%3A%2F%2Fs2.sinaimg.cn%2Fbmiddle%2F4d09676and3e1c53a9791%26690"]];
        WEAK_TYPES(_moneyInptView)
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weak_moneyInptView);
        }];
        // 白色背景框
        UIView *whiteView = [[UIView alloc] init];
        whiteView.backgroundColor = [UIColor whiteColor];
        whiteView.layer.cornerRadius = 7;
        whiteView.layer.masksToBounds = YES;
        [_moneyInptView addSubview:whiteView];
        [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weak_moneyInptView).offset(15);
            make.left.equalTo(weak_moneyInptView.mas_left).offset(15);
            make.right.equalTo(weak_moneyInptView.mas_right).offset(-15);
            make.bottom.equalTo(weak_moneyInptView.mas_bottom).offset(-80);
            make.height.equalTo(@70);
        }];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = XKRegularFont(15);
        titleLabel.text = @"消费金额：";
        [whiteView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(whiteView.mas_left).offset(10);
            make.centerY.equalTo(whiteView);
        }];
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.delegate = self;
        _inputTextField.placeholder = @"询问服务员后输入";
        _inputTextField.font = XKRegularFont(17);
        _inputTextField.textAlignment = NSTextAlignmentRight;
        _inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
        [_inputTextField addTarget:self action:@selector(inputTextFieldAction:) forControlEvents:UIControlEventEditingChanged];
        [whiteView addSubview:_inputTextField];
        [_inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_right).offset(20);
            make.right.equalTo(whiteView.mas_right).offset(-10);
            make.top.bottom.equalTo(whiteView);
        }];
    }
    return _moneyInptView;
}

- (void)inputTextFieldAction:(UITextField *)sender {
    self.payMoneyView.contentLabel.text = [NSString stringWithFormat:@"￥%@",sender.text];
}

- (UIView *)bottomInfoView {
    if (!_bottomInfoView) {
        _bottomInfoView = [[UIView alloc] init];
        _bottomInfoView.layer.cornerRadius = 5;
        _bottomInfoView.layer.masksToBounds = YES;
        _bottomInfoView.backgroundColor = [UIColor whiteColor];
        WEAK_TYPES(_bottomInfoView)
//        XKCommonDiyHeadView *quanView = [[XKCommonDiyHeadView alloc] init];
//        quanView.showSeparateLine = YES;
//        [quanView bk_whenTapped:^{
//            //
//        }];
//        quanView.titleLabel.text = @"抵用券/优惠码";
//        [_bottomInfoView addSubview:quanView];
        _payMoneyView = [[XKCommonDiyHeadView alloc] init];
        _payMoneyView.titleLabel.text = @"实付金额";
        _payMoneyView.arrowImgView.hidden = YES;
        _payMoneyView.contentLabel.text = @"￥";
        [_bottomInfoView addSubview:_payMoneyView];
//        [quanView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.right.equalTo(weak_bottomInfoView);
//            make.height.equalTo(@50);
//        }];
        [_payMoneyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(weak_bottomInfoView);
            make.height.equalTo(@50);
            make.top.equalTo(weak_bottomInfoView);
        }];
    }
    return _bottomInfoView;
}

@end
