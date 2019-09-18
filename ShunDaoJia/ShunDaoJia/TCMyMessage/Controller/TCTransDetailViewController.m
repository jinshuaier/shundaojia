//
//  TCTransDetailViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/26.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCTransDetailViewController.h"
#import "TCTranDetailCell.h"
#import "TCTransDetialInfo.h"

@interface TCTransDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) UIView*bgView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) UIButton *lastbt;
@property (nonatomic, strong) UIButton *lastBtn;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSUserDefaults *userdefaults;
@property (nonatomic, strong) UIView *lineView; //下方的线

@end

@implementation TCTransDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"交易明细";
    self.view.backgroundColor = TCBgColor;
    self.dataArr = [NSMutableArray array];
    [self creatUI];
    self.userdefaults = [NSUserDefaults standardUserDefaults];
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
    [header setTitle:@"下拉刷新交易明细..." forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新交易明细..." forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新交易明细..." forState:MJRefreshStateRefreshing];
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    // 设置颜色
    header.stateLabel.textColor = [UIColor lightGrayColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
    
    self.listTableView.mj_header = header;
    [header beginRefreshing];
    
    //上拉
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page++;
        [self requestNews:page andtype:type];
    }];
    //设置上拉标题
    [footer setTitle:@"上拉加载更多交易明细" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载更多交易明细..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"无更多交易明细!" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    self.listTableView.mj_footer = footer;
}
//下拉请求
- (void)requestNews:(NSString *)type{
    
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"page":@"1",@"timestamp":timeStr,@"type":type};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"page":@"1",@"timestamp":timeStr,@"sign":signStr,@"type":type};
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"104015"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        [self.dataArr removeAllObjects];
        NSArray *arr = jsonDic[@"data"];
        for (int i = 0; i < arr.count; i ++) {
            TCTransDetialInfo *model = [TCTransDetialInfo orderInfoWithDictionary:arr[i]];
            [self.dataArr addObject:model];
        }
        
        NSLog(@"%@",self.dataArr);
        //占位图
        [self NeedResetNoView];
        [self.listTableView reloadData];
        [self.listTableView.mj_header endRefreshing];
        self.view.userInteractionEnabled = YES;

    } failure:^(NSError *error) {
        nil;
    }];
    [self.listTableView.mj_footer resetNoMoreData];
    
}
- (void)NeedResetNoView{
    if (self.dataArr.count >0) {
        [self.listTableView dismissNoView];
    }else{
        [self.listTableView showNoView:@"暂无交易" image: [UIImage imageNamed:@"无搜索结果插图"] certer:CGPointZero];
    }
}
//上拉加载
- (void)requestNews:(int)page andtype:(NSString *)type{
    
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    NSString *pageStr = [NSString stringWithFormat:@"%d",page];
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"page":pageStr,@"timestamp":timeStr,@"type":type};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"page":pageStr,@"timestamp":timeStr,@"sign":signStr,@"type":type};
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"104015"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        for (NSDictionary *infoDic in jsonDic[@"data"]) {
            TCTransDetialInfo *model = [TCTransDetialInfo orderInfoWithDictionary:infoDic];
            [self.dataArr addObject:model];
        }
        [self.listTableView.mj_footer endRefreshing];
        [self.listTableView reloadData];
    } failure:^(NSError *error) {
        nil;
        [self.listTableView.mj_footer endRefreshingWithNoMoreData];
    }];
}

-(void)creatUI{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, 46)];
    _bgView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:_bgView];
    
    CGFloat w = WIDTH/4;
    CGFloat h = 22;
    NSArray *titleArr = @[@"全部",@"消费",@"提现",@"退款"];
    
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(w * i, 12, w, h);
        [btn setTitle:titleArr[i] forState:(UIControlStateNormal)];
        [btn setTitleColor:TCUIColorFromRGB(0x4C4C4C) forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        btn.tag = 1000 + i;
        btn.exclusiveTouch = YES;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [_bgView addSubview:btn];
        if (i == 0) {
            btn.selected = YES;
            _lastBtn = btn;
            _lastbt.hidden = NO;
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
        }
    }
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake((w - 20)/2, _bgView.frame.size.height - 4, 20, 4)];
    self.lineView.backgroundColor = TCUIColorFromRGB(0xF99E20);
    [_bgView addSubview:self.lineView];
    
    //创建tableView
    self.listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_bgView.frame) + 12, WIDTH, HEIGHT - 46 - StatusBarAndNavigationBarHeight - 12)];
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.backgroundColor = TCBgColor;
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listTableView.showsVerticalScrollIndicator = NO;
    [self.listTableView registerClass:[TCTranDetailCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.listTableView];
    AdjustsScrollViewInsetNever(self, self.listTableView);
    //刷新
    [self setupRefresh:@"1"];
}

#pragma mark -- 选中按钮
-(void)clickBtn:(UIButton *)sender{
    NSInteger tag = sender.tag ;
    CGRect frame = self.lineView.frame;

    _lastbt.selected = NO;
    UIButton *find_btn = (UIButton *)[self.bgView viewWithTag:tag];
    
    _lastbt = find_btn;
    _lastbt.selected = YES;
    
    _lastBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    _lastBtn.selected = NO;
    sender.selected = YES;
    _lastBtn = sender;
    _lastBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    NSLog(@"%ld",(long)sender.tag);
    if (tag == 1000) {
        [self setupRefresh:@"1"];
        frame.origin.x = (WIDTH/4 - 20)/2;

    }else if (tag == 1001){
        [self setupRefresh:@"2"];
        frame.origin.x = (WIDTH/4 - 20)/2 + WIDTH/4;

    }else if (tag == 1002){
        [self setupRefresh:@"3"];
        frame.origin.x = (WIDTH/4 - 20)/2 + WIDTH/4 * 2;

    }else{
        [self setupRefresh:@"4"];
        frame.origin.x = (WIDTH/4 - 20)/2 + WIDTH/4 * 3;
    }
    [self.listTableView reloadData];
    self.lineView.frame = frame;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TCTranDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[TCTranDetailCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    if (self.dataArr != 0) {
        cell.model = self.dataArr[indexPath.row];
    }
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第%lu行cell",indexPath.row);
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