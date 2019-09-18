//
//  TCMydiscountViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/28.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCMydiscountViewController.h"
#import "TCDiscountTableViewCell.h"
#import "TCDescriptionViewController.h" //规则说明
#import "TCChooseSlideView.h"
#import "TCDiscountInfo.h"
#import "TCMyMessageViewController.h"

@interface TCMydiscountViewController ()<UITableViewDelegate,UITableViewDataSource,ButtonDelegete,TCChooseSlideProtocol>
@property (nonatomic, strong) UITableView *maintableView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *lastBtn;
@property (nonatomic, strong) UIButton *lastbtn;

@property (nonatomic, strong) UIView *lineView; //线
@property(strong,nonatomic)TCChooseSlideView *sliderView;
@property (nonatomic, strong) NSDictionary *messDic;
@property (nonatomic, strong) NSMutableArray*dataArr;
@property (nonatomic, strong) NSUserDefaults *userdefaults;
@property (nonatomic, strong) NSString *numStr;

@end

@implementation TCMydiscountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的优惠";
    self.dataArr = [NSMutableArray array];
    
    //确定按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"规则说明" forState:(UIControlStateNormal)];
    rightBtn.frame = CGRectMake(WIDTH - 60 - 12, 14, 60, 16);
    [rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [rightBtn setTitleColor:TCUIColorFromRGB(0x4C4C4C) forState:(UIControlStateNormal)];
    rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    self.view.backgroundColor = TCBgColor;
    
    [self creatUI];
    //添加刷新
    self.userdefaults = [NSUserDefaults standardUserDefaults];
    [self setupRefresh:@"1"];
    // Do any additional setup after loading the view.
}

//添加刷新
- (void)setupRefresh:(NSString *)type{
    //下拉
    self.view.userInteractionEnabled = NO;
    __block int  page = 1;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        //刷新
        [self requestNews:type];
    }];
    //设置刷新标题
    [header setTitle:@"下拉刷新优惠券..." forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新优惠券..." forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新优惠券..." forState:MJRefreshStateRefreshing];
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    // 设置颜色
    header.stateLabel.textColor = [UIColor lightGrayColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
    
    self.maintableView.mj_header = header;
    [header beginRefreshing];
    
    //上拉
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page++;
        [self requestNews:page andtype:type];
    }];
    //设置上拉标题
    [footer setTitle:@"上拉加载更多优惠券" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载更多优惠券..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"无更多优惠券!" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    self.maintableView.mj_footer = footer;
}
//下拉请求
- (void)requestNews:(NSString *)type{
    [self.dataArr removeAllObjects];
    NSString *timeStr = [TCGetTime getCurrentTime];
    
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    NSString* pageSize = @"15";
    
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"page":@"1",@"pagesize":pageSize,@"timestamp":timeStr,@"type":type};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"page":@"1",@"pagesize":pageSize,@"timestamp":timeStr,@"sign":signStr,@"type":type};
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"104009"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        
        NSArray *arr = jsonDic[@"data"];
        for (int i = 0; i < arr.count; i ++) {
            TCDiscountInfo *model = [TCDiscountInfo orderInfoWithDictionary:arr[i]];
            [self.dataArr addObject:model];
        }
        self.numStr = [NSString stringWithFormat:@"%lu",(unsigned long)self.dataArr.count];
        NSLog(@"%@",self.dataArr);
        //占位图
        [self NeedResetNoView];
        [self.maintableView reloadData];
        self.view.userInteractionEnabled = YES;

        [self.maintableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        nil;
    }];
    [self.maintableView.mj_footer resetNoMoreData];
    
}
- (void)NeedResetNoView{
    if (self.dataArr.count >0) {
        [self.maintableView dismissNoView];
    }else{
        [self.maintableView showNoView:@"暂无优惠券" image: [UIImage imageNamed:@"无搜索结果插图"] certer:CGPointZero];
        
    }
}
//上拉加载
- (void)requestNews:(int)page andtype:(NSString *)type{
    
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    NSString *pageStr = [NSString stringWithFormat:@"%d",page];
    NSString *pageSize = @"15";
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"page":pageStr,@"pagesize":pageSize,@"timestamp":timeStr,@"type":type};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"page":pageStr,@"pagesize":pageSize,@"timestamp":timeStr,@"sign":signStr,@"type":type};
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"104009"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        for (NSDictionary *infoDic in jsonDic[@"data"]) {
            TCDiscountInfo *model = [TCDiscountInfo orderInfoWithDictionary:infoDic];
            [self.dataArr addObject:model];
        }
        self.numStr = [NSString stringWithFormat:@"%lu",(unsigned long)self.dataArr.count];
        [self.maintableView.mj_footer endRefreshing];
        [self.maintableView reloadData];
    } failure:^(NSError *error) {
        nil;
        [self.maintableView.mj_footer endRefreshingWithNoMoreData];
    }];
}


-(void)creatUI{
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, 46)];
    self.bgView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:self.bgView];
    
    self.sliderView = [[TCChooseSlideView alloc]init];
    self.sliderView.frame = CGRectMake(0, 0, WIDTH, 46);
    self.sliderView.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:self.sliderView];
    self.sliderView.sliderDelegate = self;
    NSArray *menuArray = [NSArray arrayWithObjects:@"可使用",@"不可使用", nil];
    [self.sliderView  setNameWithArray:menuArray];
    [self _getTag:0];
    
    self.maintableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bgView.frame), WIDTH, HEIGHT - (CGRectGetMaxY(self.bgView.frame)) - TabbarSafeBottomMargin) style:(UITableViewStyleGrouped)];
    self.maintableView.delegate = self;
    self.maintableView.dataSource = self;
    self.maintableView.showsVerticalScrollIndicator = NO;
    self.maintableView.backgroundColor = TCBgColor;
    self.maintableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.maintableView];
    
    AdjustsScrollViewInsetNever(self, self.maintableView);
}

#pragma mark -- 实现
//实现协议方法;
-(void)_getTag:(NSInteger)tag
{
    if (tag == 0){
        NSLog(@"可用");
        [self setupRefresh:@"1"];
    }else{
        NSLog(@"不可用");
        [self setupRefresh:@"2"];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


//预防ios11错误
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.qh_width, 22 + 24)];
        headerView.backgroundColor = TCBgColor;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, WIDTH - 24, 22 + 24)];
        label.text = [NSString stringWithFormat:@"优惠券（%@）",self.numStr];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        label.textColor = TCUIColorFromRGB(0x4C4C4C);
        label.textAlignment = NSTextAlignmentLeft;
        [headerView addSubview:label];
        return headerView;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TCDiscountInfo *model = self.dataArr[indexPath.section];
    return model.cellHight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    if (section == 0) {
        return 22 + 24;
    }else{
        return 0.1;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TCDiscountTableViewCell *cell = [[TCDiscountTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.delegate = self;
    cell.countBtn.tag = indexPath.section + 1000;
    if (self.dataArr.count != 0) {
        TCDiscountInfo *mode = self.dataArr[indexPath.section];
        cell.model = mode;
    }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return  cell;
}
#pragma mark -- 优惠券点击使用
- (void)sendValue:(UIButton *)sender
{
    UIView *contentView = (UIView *)[sender superview];
    TCDiscountTableViewCell *cell = (TCDiscountTableViewCell *)[contentView superview];
    NSIndexPath *path = [self.maintableView indexPathForCell:cell];
    NSLog(@"%ld %ld",(long)path.section,sender.tag);
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
//    for (UIViewController *controller in self.navigationController.viewControllers) { if ([controller isKindOfClass:[TCMyMessageViewController class]]) { [self.navigationController popToViewController:controller animated:YES]; } }
    
}
#pragma mark -- 规则说明
- (void)clickRightBtn:(UIButton *)sender
{
    TCDescriptionViewController *descripVC = [[TCDescriptionViewController alloc] init];
    [self.navigationController pushViewController:descripVC animated:YES];
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
