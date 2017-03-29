//
//  SelectView.m
//  sender
//
//  Created by fuzhaurui on 2016/12/28.
//  Copyright © 2016年 IOS-开发机. All rights reserved.
//

#import "FZRSelectView.h"
#import "AppDelegate.h"

static CGFloat width  = 280.0f;
static CGFloat cellHeight = 45.0f;
static CGFloat headerHeight = 85.0f;
static CGFloat footerHeight = 50.0f;




@interface FZRSelectView() <UITableViewDelegate,UITableViewDataSource>


@property (strong ,nonatomic) AppDelegate *appDelegate;
@property (strong ,nonatomic) UITableView *tableView;
@property (strong ,nonatomic) UIView *backgroundView;
@property (strong ,nonatomic) UIView *headerView;
@property (strong ,nonatomic) UIButton *footerButton;
@property (strong ,nonatomic) FZRSelectBlock selectBlock;
@property (strong ,nonatomic) NSArray *cellArray;
@property (strong ,nonatomic) UILabel *titleLabel;
@property (strong ,nonatomic) UILabel *promptLabel;

@end


@implementation FZRSelectView


///MARK: - 初始化共享视图
+ (FZRSelectView*)sharedView {
    static dispatch_once_t once;
    
    static FZRSelectView *sharedView;
    
    dispatch_once(&once, ^ {
        
        sharedView = [[FZRSelectView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        sharedView.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [sharedView.appDelegate.window addSubview:sharedView];
        
        [sharedView addSubview:sharedView.backgroundView];
        
        [sharedView addSubview:sharedView.tableView];

    });
    
    [sharedView.appDelegate.window bringSubviewToFront:sharedView];
    
    return sharedView;
}


-(UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        
        _tableView.center = self.appDelegate.window.center;
        
        _tableView.delegate = self;
        
        _tableView.dataSource = self;
        
        _tableView.layer.borderWidth = 0;
        
        _tableView.layer.cornerRadius = 20;
        
        _tableView.clipsToBounds = YES;
        
        _tableView.bounces = NO;
        
    }
    
    return _tableView;
}

-(UIView *)backgroundView
{
    if(!_backgroundView)
    {
        _backgroundView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        
        _backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        _backgroundView.center = self.appDelegate.window.center;
        
    }
    
    return _backgroundView;
}

-(UIView *)headerView
{
    if (!_headerView) {
    
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, headerHeight)];
        _headerView.backgroundColor = [UIColor whiteColor];

        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, headerHeight - 1, width, 1)];
        view.backgroundColor = [self color:@"#E5E5E5"];
        [_headerView addSubview:view];
        
        
        self.titleLabel = [self createLabel:CGRectMake(0, 0, width, 50) andFont:[UIFont boldSystemFontOfSize:19] andTextColor:[UIColor blackColor] andText:nil andnumberOfLines:0 andTextAlignment:NSTextAlignmentCenter andBackgroundColor:[UIColor clearColor]];
        
        [_headerView addSubview:self.titleLabel];
        
        self.promptLabel = [self createLabel:CGRectMake(0, 50, width, 30) andFont:[UIFont boldSystemFontOfSize:12] andTextColor:[self color:@"#BBBBBB"] andText:@"[温馨提示]:滑动显示隐藏选项" andnumberOfLines:0 andTextAlignment:NSTextAlignmentCenter andBackgroundColor:[UIColor clearColor]];
        
        [_headerView addSubview:self.promptLabel];
        
    }
    
    return _headerView;
}

-(UIButton *)footerButton
{
    
    if (!_footerButton) {
       
        _footerButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, footerHeight)];
        
        [_footerButton addTarget:self action:@selector(dismissSelectView) forControlEvents:UIControlEventTouchUpInside];
        
        [_footerButton setTitle:@"取  消" forState:UIControlStateNormal];
        
        [_footerButton setTitleColor:[self color:@"#FF545D"] forState:UIControlStateNormal];
        
        _footerButton.backgroundColor = [UIColor whiteColor];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _footerButton.frame.size.width, 1)];
        view.backgroundColor = [self color:@"#E5E5E5"];
        [_footerButton addSubview:view];
        
    }
    
    return _footerButton;
}


/**
 快速初始UILabel
 font Label的字体
 textColor Label的字体颜色
 text      Label的文字
 numberOfLines 是否自动换行
 textAlignment Label的文字位置
 backgroundColor Label的背景颜色
 **/
-(UILabel *)createLabel:(CGRect)frame  andFont:(UIFont *)font andTextColor:(UIColor *)textColor andText:(NSString *)text andnumberOfLines:(NSInteger)numberOfLines andTextAlignment:(NSTextAlignment)textAlignment andBackgroundColor:(UIColor *)backgroundColor
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.numberOfLines =numberOfLines;
    label.textAlignment = textAlignment;
    if (backgroundColor != nil) {
        label.backgroundColor = backgroundColor;
    }
    
    if (font != nil) {
        label.font = font;
    }
    
    if (textColor != nil) {
        label.textColor = textColor;
    }
    
    if (text != nil) {
        label.text = text;
    }
    
    return label;
}



-(void)dismissSelectView
{

    [UIView beginAnimations:nil context:nil];
    //动画时间
    [UIView setAnimationDuration:0.3];
    //移动后的位置
    self.alpha = 0;
    self.tableView.frame = [UIScreen mainScreen].bounds;
    //开始动画
    [UIView commitAnimations];
}


-(void)showSelectView:(CGRect)frame
{
    [UIView beginAnimations:nil context:nil];
    //动画时间
    [UIView setAnimationDuration:0.3];
    //移动后的位置
    self.alpha = 1;
    self.tableView.frame = frame;
    //开始动画
    [UIView commitAnimations];
}


/*
 *MARK: - 开始进行选择
 * selectArray : 输入选择待选列表
 * selectBlock : 模块传值
 */
- (void)startChoiceTitle:(NSString *)title andSelect:(NSArray *)selectArray blockcompletion:(FZRSelectBlock)selectBlock
{
    
    self.titleLabel.text = title;
    
    
    CGFloat height = selectArray.count*cellHeight + headerHeight + footerHeight;
  
    height = height >430?430:height<225?225:height;
    
    CGFloat x = ([UIScreen mainScreen].bounds.size.width - width)/2;
    
    CGFloat y = ([UIScreen mainScreen].bounds.size.height - height)/2;
  
    self.selectBlock  = selectBlock;
    
    self.cellArray = selectArray;
    
    if (selectArray.count >6) {
        [self.promptLabel setHidden:NO];
        self.titleLabel.frame = CGRectMake(0, 10, width, 50);
    }
    else
    {
        [self.promptLabel setHidden:YES];
        self.titleLabel.frame = CGRectMake(0, 20, width, 50);
    }
    
    [self.tableView reloadData];
    

    [self showSelectView:CGRectMake(x, y, width, height)];
    
    
}




#pragma mark -UITableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"UITableViewCellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = self.cellArray[indexPath.row];
    cell.textLabel.textColor = [self color:@"#5676FC"];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return cellHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.footerButton;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.headerView.frame.size.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return self.footerButton.frame.size.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    self.selectBlock(indexPath.row);
    [self dismissSelectView];
    
}


/**
 MARK: - NSString扩展:将NSString转化为NSData
 **/
-(UIColor *)color:(NSString *)string
{
    if (!string || [string isEqualToString:@""]) {
        return nil;
    }
    unsigned red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = string.length == 7?1:0;
    [[NSScanner scannerWithString:[string substringWithRange:range]] scanHexInt:&red];
    range.location = string.length == 7?3:2;
    [[NSScanner scannerWithString:[string substringWithRange:range]] scanHexInt:&green];
    range.location = string.length == 7?5:4;
    [[NSScanner scannerWithString:[string substringWithRange:range]] scanHexInt:&blue];
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    return color;
}



@end
