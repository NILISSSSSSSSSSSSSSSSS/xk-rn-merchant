//
//  XKTradingAreaPullDownMenu.m
//  XKSquare
//
//  Created by hupan on 2018/10/8.
//  Copyright © 2018年 xk. All rights reserved.
//


#import "XKTradingAreaPullDownMenu.h"
#import <objc/runtime.h>

#define KTitleButtonTag          10000
#define KTitleButtonHeight       44
#define KTableViewCellHeight     40
#define KDisplayMaxCellOfNumber  5

#define KOBJCSetObject(object,value)  objc_setAssociatedObject(object,@"title" , value, OBJC_ASSOCIATION_RETAIN_NONATOMIC)
#define KOBJCGetObject(object)        objc_getAssociatedObject(object, @"title")

@interface XKTradingAreaPullDownMenu () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, copy  ) NSArray        *titleArray ;
@property (nonatomic, strong) NSMutableArray *tableDataArray;
@property (nonatomic, strong) UIView         *maskBackGroundView;
@property (nonatomic, strong) UIButton       *tempButton;
@property (nonatomic, assign) NSInteger      currentMenuIndex;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;


@end


@implementation XKTradingAreaPullDownMenu

- (instancetype)initWithFrame:(CGRect)frame menuTitleArray:(NSArray *)titleArray {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.titleArray = titleArray;
        [self configBaseInfoWithFrame:frame];
    }
    return self;
}

-(void)configBaseInfoWithFrame:(CGRect)frame {
    
    //用于遮盖self.backgroundColor 。
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, frame.origin.y, SCREEN_WIDTH, KTitleButtonHeight)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    CGFloat width = SCREEN_WIDTH / self.titleArray.count;
    
    for (int index = 0; index < self.titleArray.count; index++) {
        
        UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake((width + 0.5) * index, 0, width-0.5, KTitleButtonHeight)];
        
        [titleButton setTitle:self.titleArray[index] forState:UIControlStateNormal];
        titleButton.titleLabel.font = XKRegularFont(14);
        titleButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail; //显示前面部分标题
        titleButton.tag = KTitleButtonTag + index ;
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];

        
        [titleButton setTitleColor:HEX_RGB(0x222222) forState:UIControlStateNormal];
        [titleButton setTitleColor:XKMainTypeColor forState:UIControlStateSelected];
        
        [titleButton setImage:[UIImage imageNamed:@"xk_icon_tradingArea_sort_normol"] forState:UIControlStateNormal];
        [titleButton setImage:[UIImage imageNamed:@"xk_icon_tradingArea_sort_selected"] forState:UIControlStateSelected];
        [titleButton setImageAtRightAndTitleAtLeftWithSpace:5];
        [self addSubview:titleButton];
        [self.buttonArray addObject:titleButton];
    }
    
}



#pragma mark --  UITableViewDelegate,UITableViewDataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.tableDataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
 
    DownMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
    if (!cell) {
        cell = [[DownMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menuCell"];
    }
    cell.textLabel.text = self.tableDataArray[indexPath.row];
    NSString *objcTitle = KOBJCGetObject(self.tempButton);
    
    if ([cell.textLabel.text isEqualToString:objcTitle]) {
        cell.isSelected = YES;
    } else {
        cell.isSelected = NO;
    }
    return cell;
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectedKeyWord:indexPath:currentMenuIndex:)]) {
        NSString * keyWord = nil;
     
        
        DownMenuCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell) {
            cell.isSelected = YES;
            [self.tempButton setTitle:cell.textLabel.text forState:UIControlStateNormal];
            KOBJCSetObject(self.tempButton, cell.textLabel.text);
            [self.tempButton setImageAtRightAndTitleAtLeftWithSpace:5];
            keyWord = cell.textLabel.text;
        } else {
            if (self.tableDataArray.count > indexPath.row) {
                keyWord = self.tableDataArray[indexPath.row];
            }
            [self.tempButton setTitle:keyWord forState:UIControlStateNormal];
            KOBJCSetObject(self.tempButton, keyWord);
            [self.tempButton setImageAtRightAndTitleAtLeftWithSpace:5];
        }
        
        [_delegate selectedKeyWord:keyWord indexPath:indexPath currentMenuIndex:self.currentMenuIndex];
    }
    
    [self takeBackTableView];
    
}



-(void)setDefauldSelectedCell {
    
    for (int index=0; index < self.buttonArray.count; index++) {
        
        self.tableDataArray = self.menuDataArray[index];
        
        UIButton *button = self.buttonArray[index];
        
        NSString *title = self.tableDataArray.firstObject;
        
        KOBJCSetObject(button, title);
    }
    
    [self takeBackTableView];
    
}

- (void)addPullTableView {
    
    [self addSubview:self.tableView];
}
- (void)addPullMaskingView {
    [self addSubview:self.maskBackGroundView];
}


-(void)titleButtonClick:(UIButton *)titleButton {
    
    NSUInteger index =  titleButton.tag - KTitleButtonTag;
    self.currentMenuIndex = index;
    for (UIButton *button in self.buttonArray) {
        if (button == titleButton) {
            button.selected = !button.selected;
            self.tempButton = button;
        } else {
            button.selected = NO;
        }
    }
    if (titleButton.selected) {
        
        self.tableDataArray = self.menuDataArray[index];
        
        if (_tableView) {
            
            //设置默认选中第一项。
            [_tableView reloadData];
            
            CGFloat tableViewHeight = 0;
            tableViewHeight = self.tableDataArray.count * KTableViewCellHeight < (SCREEN_HEIGHT- self.frame.origin.y) ?
            self.tableDataArray.count * KTableViewCellHeight : (SCREEN_HEIGHT- self.frame.origin.y);
            [self expandWithTableViewHeight:tableViewHeight];
        }
        
        
    } else {
        [self takeBackTableView];
    }
}



//展开。
-(void)expandWithTableViewHeight:(CGFloat )tableViewHeight {
    
//    self.maskBackGroundView.hidden = NO;
    if (_tableView) {
        __block typeof(_maskBackGroundView) blockMaskBackGroundView = _maskBackGroundView;
        [self showSpringAnimationWithDuration:0.3 animations:^{
            
            self.tableView.frame = CGRectMake(0, KTitleButtonHeight, SCREEN_WIDTH, tableViewHeight);
            if (blockMaskBackGroundView) {
                blockMaskBackGroundView.alpha = 1;
            }
        } completion:^{
            
        }];
    }
}

//收起。
-(void)takeBackTableView {
    
    
    for (UIButton *button in self.buttonArray) {
        button.selected = NO;
    }
    if (_tableView) {
        __block typeof(_maskBackGroundView) blockMaskBackGroundView = _maskBackGroundView;
        [self showSpringAnimationWithDuration:.3 animations:^{
            self.tableView.frame = CGRectMake(0, KTitleButtonHeight, SCREEN_WIDTH,0);
            if (blockMaskBackGroundView) {
                blockMaskBackGroundView.alpha = 0;
            }
        } completion:^{
            //        self.maskBackGroundView.hidden = YES;
        }];
    }
}



- (void)showSpringAnimationWithDuration:(CGFloat)duration
                            animations:(void (^)(void))animations
                            completion:(void (^)(void))completion
{
    
    
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:.8 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        if (animations) {
            animations();
        }
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}



-(void)maskBackGroundViewTapClick {
    [self takeBackTableView];
}




-(void)selectedAtIndex:(NSInteger)index items:(NSInteger)items {
    UIButton * button = [self viewWithTag:index + KTitleButtonTag];
    [self titleButtonClick:button];
    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:items inSection:0]];
}


- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskBackGroundViewTapClick)];
    }
    return _tapGesture;
}

- (UITableView *)tableView {
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, SCREEN_WIDTH, 0)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.rowHeight = KTableViewCellHeight;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}



-(NSMutableArray *)menuDataArray {
    if (!_menuDataArray) {
        _menuDataArray =[[NSMutableArray alloc] init];
    }
    return _menuDataArray;
}


-(NSMutableArray *)tableDataArray {
    if (!_tableDataArray) {
        _tableDataArray = [[NSMutableArray alloc]init];
    }
    return _tableDataArray;
}

-(NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray =[[NSMutableArray alloc] init];
    }
    return _buttonArray;
}

- (UIView *)maskBackGroundView {
    
    if (!_maskBackGroundView) {
        _maskBackGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, KTitleButtonHeight, SCREEN_WIDTH, SCREEN_HEIGHT- self.y - KTitleButtonHeight)];
        _maskBackGroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _maskBackGroundView.userInteractionEnabled = YES;
        _maskBackGroundView.alpha = 0;
        [_maskBackGroundView addGestureRecognizer:self.tapGesture];
    }
    return _maskBackGroundView;
}

@end



@implementation DownMenuCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.font = XKRegularFont(14);;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(5, 39, SCREEN_WIDTH-10, 1)];
        line.backgroundColor = XKSeparatorLineColor;
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (isSelected) {
        self.textLabel.textColor = XKMainTypeColor;
    } else {
        self.textLabel.textColor = HEX_RGB(0x777777);
    }
}

@end
