//
//  TCDetailedViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/23.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCDetailedViewController.h"
#import "TClistTableCell.h"
#import "TCBalanceInfo.h"


@interface TCDetailedViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *typestr;
    UITableView *listTableView;
}
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *lastBtn;
@property (nonatomic, strong) UIButton *lastbt;
@property (nonatomic, strong) NSUserDefaults *userdefaults;
@property (nonatomic, strong) NSDictionary *messDic;
@property (nonatomic, strong) NSMutableArray*dataArr;
@end

@implementation TCDetailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"余额明细";
    self.dataArr = [NSMutableArray array];
    
    self.view.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    
    [self creatUI];
    //添加刷新
    self.userdefaults = [NSUserDefaults standardUserDefaults];
    [self setupRefresh:@"1"];
    // Do any additional setup after loading the view.
}

//添加刷新
- (void)setupRefresh:(NSString *)type{
    //下拉
    __block int  page = 1;
    self.view.userInteractionEnabled = NO;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        page = 1;
        //刷新
        [self requestNews:type];
    }];
    //设置刷新标题
    [header setTitle:@"下拉刷新余额明细..." forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新余额明细..." forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新余额明细..." forState:MJRefreshStateRefreshing];
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    // 设置颜色
    header.stateLabel.textColor = [UIColor lightGrayColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
    
    listTableView.mj_header = header;
    [header beginRefreshing];
    
    //上拉
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page++;
        [self requestNews:page andtype:type];
    }];
    //设置上拉标题
    [footer setTitle:@"上拉加载更多余额明细" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载更多余额明细..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"无更多余额明细!" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    listTableView.mj_footer = footer;
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
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"104007"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
//        [self.dataArr addObjectsFromArray: jsonDic[@"data"]];
        NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if ([codeStr isEqualToString:@"1"]) {
            for (NSDictionary *infoDic in jsonDic[@"data"]) {
                TCBalanceInfo *model = [TCBalanceInfo orderInfoWithDictionary:infoDic];
                [self.dataArr addObject:model];
            }
        } else {
            [TCProgressHUD showMessage:jsonDic[@"msg"]];
        }
        //占位图
        [self NeedResetNoView];
        self.view.userInteractionEnabled = YES;
        [listTableView reloadData];
        [listTableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        nil;
    }];
    [listTableView.mj_footer resetNoMoreData];
}
- (void)NeedResetNoView{
    if (self.dataArr.count >0) {
        [listTableView dismissNoView];
    }else{
        [listTableView showNoView:@"暂无余额明细" image: [UIImage imageNamed:@"无搜索结果插图"] certer:CGPointZero];
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
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"104007"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        for (NSDictionary *infoDic in jsonDic[@"data"]) {
            TCBalanceInfo *model = [TCBalanceInfo orderInfoWithDictionary:infoDic];
            [self.dataArr addObject:model];
        }
        [TCProgressHUD showMessage:jsonDic[@"msg"]];
        [listTableView.mj_footer endRefreshing];
        [listTableView reloadData];
    } failure:^(NSError *error) {
        nil;
        [listTableView.mj_footer endRefreshingWithNoMoreData];
    }];
}

-(void)creatUI{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, 46)];
    _bgView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:_bgView];
    
    CGFloat w = WIDTH/3;
    CGFloat h = 22;
    NSArray *titleArr = @[@"全部",@"收入",@"支出"];
    
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(w * i, 12, w, h);
        [btn setTitle:titleArr[i] forState:(UIControlStateNormal)];
        [btn setTitleColor:TCUIColorFromRGB(0x4C4C4C) forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        
        UIButton *lineView = [[UIButton alloc]initWithFrame:CGRectMake((w - 20)/2 + i * w, _bgView.frame.size.height - 4, 20, 4)];
        lineView.backgroundColor = TCUIColorFromRGB(0xF99E20);
        lineView.hidden = YES;
        lineView.tag = 2000 + i;
        
        [_bgView addSubview:btn];
        [_bgView addSubview:lineView];
        
        if (i == 0) {
            btn.selected = YES;
            _lastBtn = btn;
            
            lineView.selected = YES;
            _lastbt = lineView;
            
           _lastbt.hidden = NO;
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
        }
    }
    
    //声明tableView 按下单时间顺序
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 46 + StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - StatusBarAndNavigationBarHeight - 8) style:UITableViewStyleGrouped];
    
    listTableView.delegate = self;
    listTableView.dataSource = self;
    listTableView.showsVerticalScrollIndicator = NO;
    listTableView.backgroundColor = TCBgColor;
    listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    AdjustsScrollViewInsetNever(self,listTableView);
    
    [listTableView registerClass:[TClistTableCell class] forCellReuseIdentifier:@"cell"];
    
     [self.view addSubview:listTableView];
}

#pragma mark -- 选中按钮
-(void)clickBtn:(UIButton *)sender{
     NSInteger tag = sender.tag + 1000;

    _lastbt.selected = NO;
    _lastbt.hidden = YES;
    UIButton *find_btn = (UIButton *)[self.bgView viewWithTag:tag];

    _lastbt = find_btn;
    _lastbt.selected = YES;
    _lastbt.hidden = NO;
    
    
    _lastbt.hidden = YES;
    _lastBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    _lastBtn.selected = NO;
    sender.selected = YES;
    _lastBtn = sender;
    _lastBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    _lastbt.hidden = NO;
    
    if (sender.tag == 1000) {
//        UILabel *find_label = (UILabel *)[self.bgView viewWithTag:2000];
//        find_label.hidden = NO;
//
                NSLog(@"全部");
        [self setupRefresh:@"1"];
        
    }else if (sender.tag == 1001){
        UILabel *find_label = (UILabel *)[self.bgView viewWithTag:2001];
        find_label.hidden = NO;
        
        [self setupRefresh:@"2"];
        NSLog(@"收入");
    }else if(sender.tag == 1002){
        UILabel *find_label = (UILabel *)[self.bgView viewWithTag:2002];
        find_label.hidden = NO;
        [self setupRefresh:@"3"];
        NSLog(@"支出");
        
    }
//    [listTableView reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
//预防ios11错误
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.qh_width, 0)];
        headerView.backgroundColor = [UIColor whiteColor];
        return headerView;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *identifier = @"cell";
    TClistTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[TClistTableCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
        
    }
    if (self.dataArr.count != 0) {
        cell.model = self.dataArr[indexPath.row];
    }
    
    
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
