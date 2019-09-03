//
//  XKConsumeCouponViewController.m
//  XKSquare
//
//  Created by william on 2018/9/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKConsumeCouponViewController.h"
#import "UIView+XKCornerRadius.h"
#import "XKMenuView.h"
#import "XKConsumeCouponDateMainView.h"
#import "XKConsumeCouponListTableViewCell.h"
#import "XKConsumeCouponDetailViewController.h"
#import "XKConsumeCouponCellModel.h"
#import "XKTransformHelper.h"
@interface XKConsumeCouponViewController ()<UITableViewDelegate,UITableViewDataSource>


/**
 主背景TableView
 */
@property (nonatomic ,strong) UITableView *mainBackTableView;


/**
 余额label
 */
@property (nonatomic ,strong) UILabel     *balanceLabel;


@property (nonatomic,strong)NSMutableArray  *dataArr;

@property (nonatomic,strong)NSMutableDictionary *dataDic;

@property (nonatomic,copy)NSString      *currentCategary;

@property (nonatomic,copy)NSString      *currentMonth;

@end

@implementation XKConsumeCouponViewController


#pragma mark – Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [NSMutableArray array];
    [self initView];
    _currentCategary = @"";
    _currentMonth = [XKTimeSeparateHelper backMonthStringWithDate:[NSDate date]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadDataWithCategaty:@"" month:_currentMonth];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark – Private Methods
-(void)initView{
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6);
    [self setNavTitle:@"消费券" WithColor:UIColorFromRGB(0xffffff)];
    [self.view addSubview:self.mainBackTableView];
}

-(void)loadDataWithCategaty:(NSString *)categaryStr month:(NSString *)monthStr{
    _dataArr = [NSMutableArray array];
    _dataDic = [NSMutableDictionary dictionary];
    NSDictionary *param = @{
                            @"page":@"1",
                            @"limit":@"10",
                            @"category":categaryStr,
                            @"month":monthStr
                            };
    [HTTPClient postEncryptRequestWithURLString:@"user/ua/consumerCouponQPageIOS/1.0"   timeoutInterval:10  parameters:param success:^(id responseObject) {
        
        NSDictionary *responsData = [XKTransformHelper dictByJsonString:responseObject];
        self->_dataDic = [NSMutableDictionary dictionaryWithDictionary:responsData];
        
        
        for (NSDictionary *d in responsData[@"result"][@"data"]) {
            XKConsumeCouponCellModel *model = [XKConsumeCouponCellModel yy_modelWithDictionary:d];
            [self->_dataArr addObject:model];
        }
        [self->_mainBackTableView reloadData];
        
    } failure:^(XKHttpErrror *error) {
            
    }];
}

/**
 获取顶部余额view
 */
-(UIView *)getBalanceView{
    UIView *mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 162 * ScreenScale)];
    mainView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *mainBackImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xk_bg_Mine_ConsumeCoupon_ConsumeCouponBackGroudImage"]];
    [mainView addSubview:mainBackImageView];
    [mainBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.and.bottom.mas_equalTo(mainView);
    }];
    
    UIImageView *coinBackImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xk_bg_Mine_ConsumeCoupon_balanceCoinBg"]];
    [mainView addSubview:coinBackImageView];
    [coinBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(mainView.mas_top);
        make.centerX.mas_equalTo(mainView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(170 * ScreenScale, 144 * ScreenScale));
    }];
    
    UILabel *balanceNameLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"余额" font:XKRegularFont(12) textColor:UIColorFromRGB(0xffffff) backgroundColor:[UIColor clearColor]];
    balanceNameLabel.adjustsFontSizeToFitWidth = YES;
    [mainView addSubview:balanceNameLabel];
    [balanceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(mainView.mas_centerX);
        make.bottom.mas_equalTo(coinBackImageView.mas_bottom).offset(-47 * ScreenScale);
        make.height.mas_equalTo(17 * ScreenScale);
    }];
    
    _balanceLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"0" font:XKMediumFont(24) textColor:UIColorFromRGB(0xfff26c) backgroundColor:[UIColor clearColor]];
    _balanceLabel.adjustsFontSizeToFitWidth = YES;
    [mainView addSubview:_balanceLabel];
    [_balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(mainView.mas_centerX);
        make.bottom.mas_equalTo(balanceNameLabel.mas_top);
        make.height.mas_equalTo(33 * ScreenScale);
    }];
    return mainView;
}


/**
 获取分类view
 */
-(UIView *)getHeaderCategaryView{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 54 * ScreenScale)];
    backView.backgroundColor =UIColorFromRGB(0xf6f6f6);
    
    UIView *cornerView = [[UIView alloc]init];
    cornerView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:cornerView];
    [cornerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView.mas_left).offset(10 * ScreenScale);
        make.right.mas_equalTo(backView.mas_right).offset(-10 * ScreenScale);
        make.bottom.mas_equalTo(backView.mas_bottom);
        make.top.mas_equalTo(backView.mas_top).offset(10 * ScreenScale);
    }];
    cornerView.xk_openClip = YES;
    cornerView.xk_radius = 8;
    cornerView.xk_clipType = XKCornerClipTypeTopBoth;
   
    UIButton *categaryButton = [BaseViewFactory buttonWithFrame:CGRectMake(0, 0, 0, 0) font:XKRegularFont(14) title:@"分类" titleColor:UIColorFromRGB(0x222222) backColor:[UIColor clearColor]];
    [cornerView addSubview:categaryButton];
    [categaryButton addTarget:self action:@selector(categaryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [categaryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cornerView.mas_left).offset(14 * ScreenScale);
        make.top.and.bottom.mas_equalTo(cornerView);
        make.width.mas_equalTo(30 * ScreenScale);
    }];
    
    UIImageView *buttonImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xk_bg_Mine_ConsumeCoupon_ButtonDown"]];
    [cornerView addSubview:buttonImageView];
    [buttonImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(categaryButton.mas_centerY);
        make.left.mas_equalTo(categaryButton.mas_right).offset(4 * ScreenScale);
        make.size.mas_equalTo(CGSizeMake(5 * ScreenScale, 5 * ScreenScale));
    }];
    
    
    return backView;
}

#pragma mark - Events
-(void)categaryButtonClicked:(UIButton *)sender{
    XKMenuView *menuView = [XKMenuView menuWithTitles:@[@"购物返积分",@"支付返积分",@"购物抵扣",@"抽奖"] images:nil width:100 relyonView:sender clickBlock:^(NSInteger index, NSString *text) {
        NSLog(@"%@",text);
    }];
    menuView.menuColor = HEX_RGBA(0xffffff, 1);
    menuView.textColor = UIColorFromRGB(0x222222);
    menuView.separatorPadding = 5;
    menuView.textImgSpace = 10;
    [menuView show];
}
#pragma mark - UITextFieldDelegate

#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *XKConsumeCouponListTableViewCellID  = @"XKConsumeCouponListTableViewCell";
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        [cell addSubview:[self getBalanceView]];
        return cell;
    }
    else{
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell = [[UITableViewCell alloc]init];
            XKConsumeCouponDateMainView *view = [[XKConsumeCouponDateMainView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64 * ScreenScale)];
            [cell addSubview:view];
            XKWeakSelf(weakSelf);
            view.backBlock = ^(NSString *backString) {
                weakSelf.currentMonth = backString;
                [weakSelf loadDataWithCategaty:weakSelf.currentCategary month:weakSelf.currentMonth];
            };
            cell.backgroundColor = UIColorFromRGB(0xf6f6f6);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            view.dataDic = _dataDic;
            return cell;
            
        }
        else{
        
            XKConsumeCouponListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XKConsumeCouponListTableViewCellID];
            if (!cell) {
                cell = [[XKConsumeCouponListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:XKConsumeCouponListTableViewCellID];
            }
            if (indexPath.row == _dataArr.count) {
                [cell hiddenLineView:YES];
                
            }else{
                [cell hiddenLineView:NO];
            }

            cell.backgroundColor = UIColorFromRGB(0xf6f6f6);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.dataModel = _dataArr[indexPath.row - 1];
            return cell;
        }
}
    
}
#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return _dataArr.count + 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 162 * ScreenScale;
    }
    else{
        return 62;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.0000001f;
    }
    else{
        return 54 * ScreenScale;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return [UIView new];
    }
    else{
        
        UIView *view = [self getHeaderCategaryView];
        self->_balanceLabel.text = self->_dataDic[@"count"]?[self->_dataDic[@"count"]stringValue]:@"0";
        return view;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row !=0) {
            XKConsumeCouponDetailViewController *vc = [[XKConsumeCouponDetailViewController alloc]init];
            vc.dataModel = _dataArr[indexPath.row - 1];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}
#pragma mark - Custom Delegates

#pragma mark – Getters and Setters
-(UITableView *)mainBackTableView{
    if (!_mainBackTableView) {
        _mainBackTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavigationAndStatue_Height, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationAndStatue_Height) style:UITableViewStylePlain];
        _mainBackTableView.delegate = self;
        _mainBackTableView.dataSource = self;
        _mainBackTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainBackTableView.backgroundColor = UIColorFromRGB(0xf6f6f6);
    }
    return _mainBackTableView;
}
@end
