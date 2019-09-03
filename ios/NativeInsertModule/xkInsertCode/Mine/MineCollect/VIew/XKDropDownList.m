///*******************************************************************************
// # File        : XKDropDownList.m
// # Project     : XKSquare
// # Author      : Lin Li
// # Created     : 2018/9/12
// # Corporation : 水木科技
// # Description :
// <#Description Logs#>
// -------------------------------------------------------------------------------
// # Date        : <#Change Date#>
// # Author      : <#Change Author#>
// # Notes       :
// <#Change Logs#>
// ******************************************************************************/
//
//#import "XKDropDownList.h"
//#import "XKChooseCountyButton.h"
//
//@interface XKDropDownList ()<UITableViewDelegate,UITableViewDataSource>
//@property (nonatomic, strong) UITableView *dropDownTableView;
//
//@property (nonatomic, strong) UILabel *label;
//
//@property (nonatomic, strong) UIView *coverView;
//
//@property (nonatomic, strong) XKChooseCountyButton    *titleButton;
//
//
//@end
//
//@implementation XKDropDownList
//
//#pragma mark - 初始化
//
//-(instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)dataArray onTheView:(UIView *)view {
//    if (self = [super initWithFrame:frame])
//    {
//        /* 0.弹出遮挡页面遮挡界面 */
//        self.coverView = [[UIView alloc] initWithFrame:view.frame];
//        _coverView.backgroundColor = [UIColor clearColor];
//        UITapGestureRecognizer *coverTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moveTheCoverView)];
//        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveTheCoverView)];
//        [_coverView addGestureRecognizer:coverTap];
//        [_coverView addGestureRecognizer:pan];
//        [view addSubview:_coverView];
//        
//        /* 2.定义tableview */
//        self.dropDownTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, frame.size.height - 10) style:UITableViewStylePlain];
//        self.dropDownTableView.layer.masksToBounds = YES;
//        self.dropDownTableView.delegate = self;
//        self.dropDownTableView.dataSource = self;
//        self.dropDownTableView.backgroundColor = RGBA(237,237,237,1);
//        [self addSubview:self.dropDownTableView];
//        
//        /* 3.传值 */
//        // 赋值
//        self.dataArray = dataArray;
//        
//    }
//    return self;
//}
//- (void)touchUpButtonEnevt:(XKChooseCountyButton *)sender {
//
//}
//- (void)reloadData {
//    [self.dropDownTableView reloadData];
//}
//#pragma mark UITableViewDataSource
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.dataArray.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//    }
//    cell.textLabel.text = self.dataArray[indexPath.row];
//    cell.textLabel.font = [UIFont systemFontOfSize:14];
//    cell.textLabel.textColor = [UIColor blackColor];
//    cell.textLabel.textAlignment = NSTextAlignmentCenter;
//    cell.backgroundColor = [UIColor clearColor];
//    return cell;
//}
//
//#pragma mark UITableViewDelegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    // 选中时的颜色不显示
//    [self.dropDownTableView deselectRowAtIndexPath:indexPath animated:NO];
//    
//    // 调用block传值
//    if (self.selectBlock) {
//        self.selectBlock(indexPath.row,self.dataArray[indexPath.row]);
//    }
//    
//    // 移除遮挡页面和tableview
//    [self moveTheCoverView];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 40.0f;
//}
//
//#pragma mark 移除遮挡页面和tableview
//- (void)moveTheCoverView {
//    [self.coverView removeFromSuperview];
//    [self removeFromSuperview];
//    if (self.taptBlock) {
//        self.taptBlock();
//    }
//}
//
//
//@end
//
