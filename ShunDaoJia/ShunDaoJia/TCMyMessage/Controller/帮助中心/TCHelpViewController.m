//
//  TCHelpViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/29.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCHelpViewController.h"
#import "TCCommonProblemController.h"
#import "TCAwardViewController.h" //奖励政策
#import "TCLoading.h"
#import "AppDelegate.h"
@interface TCHelpViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIWebView *webviews;
@property (nonatomic, strong) NSUserDefaults *userdefaults;
@property (nonatomic, strong) TCLoading *loading;
@end

@implementation TCHelpViewController

- (void)viewWillAppear:(BOOL)animated
{
    //记录返回按钮
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    delegate.isBack = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    //记录返回按钮
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    delegate.isBack = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助中心";
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.html = @"https://h5.moumou001.com/help/index.html";
    _loading  = [[TCLoading alloc]init];
    _userdefaults = [NSUserDefaults standardUserDefaults];
    _webviews = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _webviews.delegate = self;
    [_webviews setUserInteractionEnabled:YES];//是否支持交互
    //[_webviews setOpaque:NO];//opaque是不透明的意思
    [_webviews setScalesPageToFit:YES];//自动缩放以适应屏幕
    [self.view addSubview:_webviews];
    //加载网页的方式
    //1.创建并加载远程网页
    NSURL *url = [NSURL URLWithString:self.html];
    if(_whereLogin) {
        NSString *body = [NSString stringWithFormat:@"mid=%@&token=%@", [_userdefaults valueForKey:@"userID"], [_userdefaults valueForKey:@"userToken"]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[body dataUsingEncoding: NSUTF8StringEncoding]];
        [_webviews loadRequest: request];
    }else{
        [_webviews loadRequest:[NSURLRequest requestWithURL:url]];
    }
    [_loading Start];
    
    //接受返回的通知，用来控制返回按钮
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isBack) name:@"tongzhifanhui" object:nil];
}

//通知事件
- (void)isBack
{
    if ([_webviews canGoBack]) {
        [_webviews goBack];
        
    }else{
        [self.view resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [_loading Start];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_loading Stop];
    [self.view addSubview: _webviews];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [_loading Stop];
}


-(void)creatUI{
    self.dataArr = [[NSMutableArray alloc]initWithObjects:@"常见问题",@"购物流程帮助", nil];
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - TabbarSafeBottomMargin - StatusBarAndNavigationBarHeight) style:UITableViewStyleGrouped];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.backgroundColor = TCBgColor;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.mainTableView];
    //解决ios11的导航栏布局的问
    AdjustsScrollViewInsetNever (self,self.mainTableView);
}


#pragma mark -- uitableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//预防ios11错误
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.qh_width, 0)];
        headerView.backgroundColor = TCBgColor;
        return headerView;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(12, 0, WIDTH/2, 54);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        titleLabel.textColor = TCUIColorFromRGB(0x4C4C4C);
        titleLabel.text = _dataArr[indexPath.row];
        [cell.contentView addSubview:titleLabel];
        
        
        if (indexPath.row < self.dataArr.count) {
            //线
            UIView *lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake(12, CGRectGetMaxY(titleLabel.frame) - 1, WIDTH - 24, 1);
            lineView.backgroundColor = TCLineColor;
            [cell.contentView addSubview:lineView];
        }
        
        
        //图片
        UIImageView *image = [[UIImageView alloc] init];
        image.image = [UIImage imageNamed:@"进入小三角（灰）"];
        image.frame = CGRectMake(WIDTH - 12 - 5, (54 - 8)/2, 5, 8);
        [cell.contentView addSubview:image];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NSLog(@"常见问题");
        TCCommonProblemController *commonVC = [[TCCommonProblemController alloc]init];
        [self.navigationController pushViewController:commonVC animated:YES];
    }else if (indexPath.row == 1){
        TCAwardViewController *awardVC = [[TCAwardViewController alloc]init];
        awardVC.isShopHelp = YES;
        [self.navigationController pushViewController:awardVC animated:YES];
//        NSLog(@"奖励政策");
//        TCAwardViewController *awardVC = [[TCAwardViewController alloc]init];
//        awardVC.isShopHelp = NO;
//        [self.navigationController pushViewController:awardVC animated:YES];
        
//    }else{
//        NSLog(@"购物流程帮助");
//
    }
}


#pragma mark -- 点击客服按钮
-(void)clickRightBtn:(UIButton *)sender{
    //拨打电话
    NSString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4000-111-888"];
    // NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

