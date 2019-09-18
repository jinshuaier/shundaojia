//
//  TCFavoriteViewController.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/11/29.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCFavoriteViewController.h"
#import "TCListCell.h" //详情列表
#import "OrderInfoModel.h"
#import "TCShopMessageViewController.h" //店铺

@interface TCFavoriteViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,TCListCellDelegate>
@property (nonatomic, strong) UITableView *mainTableView; //创建的tableView
@property (nonatomic, strong) NSUserDefaults *defaults; //保存
@property (nonatomic, strong) NSMutableArray *dataArr; //数据

@end

@implementation TCFavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    self.view.backgroundColor = TCBgColor;
    self.defaults = [NSUserDefaults standardUserDefaults];
    self.dataArr = [NSMutableArray array];
    
    //创建首页的TableView
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, self.view.qh_width, self.view.qh_height - TabbarSafeBottomMargin - StatusBarAndNavigationBarHeight) style:UITableViewStyleGrouped];
    
    //解决ios11的导航栏布局的问
    AdjustsScrollViewInsetNever (self,self.mainTableView);
    self.mainTableView.delegate=self;//设置表视图外貌代理
    self.mainTableView.dataSource=self;
    //去掉分割线
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.backgroundColor = TCBgColor;
    [self.view addSubview:self.mainTableView];
    
    //ios11解决点击刷新跳转的问题
    self.mainTableView.estimatedRowHeight = 0;
    self.mainTableView.estimatedSectionHeaderHeight = 0;
    self.mainTableView.estimatedSectionFooterHeight = 0;
    
    //刷新
    [self setupRefresh];
    // Do any additional setup after loading the view.
}



#pragma mark -- 加载获取的数据
//添加刷新
- (void)setupRefresh{
    //下拉
    __block int  page = 1;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self requestShops];
        
    }];
    //设置刷新标题
    [header setTitle:@"下拉刷新顺道嘉周边..." forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新顺道嘉周边..." forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新顺道嘉周边..." forState:MJRefreshStateRefreshing];
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    // 设置颜色
    header.stateLabel.textColor = [UIColor lightGrayColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
    
    self.mainTableView.mj_header = header;
    [header beginRefreshing];
    
    //上拉
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page++;
        [self requestShops:page];
    }];
    //设置上拉标题
    [footer setTitle:@"上拉加载更多顺道嘉周边" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载更多顺道嘉周边..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"无更多顺道嘉周边!" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    self.mainTableView.mj_footer = footer;
}

//下拉请求
- (void)requestShops{
    //清除sdwebimage 的缓存 商家跟换头像后 首页头像还是之前的
    [[SDImageCache sharedImageCache] clearDisk];
    [self.dataArr removeAllObjects];
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.defaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.defaults valueForKey:@"userToken"]];
    
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"page":@"1",@"timestamp":timeStr};
    NSString *signStr = [TCServerSecret signStr:dic];
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"page":@"1",@"timestamp":timeStr,@"sign":signStr};
    
    NSLog(@" %@--",paramters);
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"101007"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        NSMutableArray *arr = jsonDic[@"data"];
        for (int i = 0; i < arr.count; i++) {
            OrderInfoModel *model = [OrderInfoModel orderInfoWithDictionary:arr[i]];
            [self.dataArr addObject:model];
        }
        //占位图
        [self NeedResetNoView];
        
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView reloadData];
    } failure:^(NSError *error) {
        nil;
    }];
    [self.mainTableView.mj_footer resetNoMoreData];
}

#pragma mark -- 没有商品的时候的占位图
- (void)NeedResetNoView
{
    if (self.dataArr.count >0) {
        [self.mainTableView dismissNoView];
    }else{
        [self.mainTableView showNoView:@"暂无收藏~" image: [UIImage imageNamed:@"暂无商品插图"] certer:CGPointZero];
    }
}

//上拉加载
- (void)requestShops:(int)page{
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *pageStr = [NSString stringWithFormat:@"%d",page];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.defaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.defaults valueForKey:@"userToken"]];
    
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"page":pageStr,@"timestamp":timeStr};
    NSString *signStr = [TCServerSecret signStr:dic];
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"page":pageStr,@"timestamp":timeStr,@"sign":signStr};
    NSLog(@" %@--",paramters);
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"101007"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        NSMutableArray *arr = jsonDic[@"data"];
        for (int i = 0; i < arr.count; i++) {
            OrderInfoModel *model = [OrderInfoModel orderInfoWithDictionary:arr[i]];
            [self.dataArr addObject:model];
        }
        [self.mainTableView.mj_footer endRefreshing];
        [self.mainTableView reloadData];
    } failure:^(NSError *error) {
        nil;
    }];
    [self.mainTableView.mj_footer resetNoMoreData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderInfoModel *model = self.dataArr[indexPath.section];
   return model.cellHight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0){
        return 12;
    }
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

//预防ios11错误
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.qh_width, 0)];
        headerView.backgroundColor = TCBgColor;
        return headerView;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.qh_width, 0)];
    footerView.backgroundColor = TCBgColor;
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        TCListCell *cell = [[TCListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArr.count == 0){
        NSLog(@"无");
    } else {
        OrderInfoModel *orderModel = self.dataArr[indexPath.section];
        cell.model = orderModel;
    }
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        TCShopMessageViewController *shopMessageVC = [[TCShopMessageViewController alloc] init];
        shopMessageVC.isShouCang = YES;
        OrderInfoModel *model = self.dataArr[indexPath.section];
        shopMessageVC.shopID = model.shopidStr;
        shopMessageVC.goodsID = @"0";
        shopMessageVC.goodCateID = @"0";
        [self.navigationController pushViewController:shopMessageVC animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}
//点击活动刷新
- (void)btnClick:(UITableViewCell *)cell{
    NSIndexPath *indexPath = [self.mainTableView indexPathForCell:cell];
    NSArray *indexPathAry = @[indexPath];
    [self.mainTableView reloadRowsAtIndexPaths:indexPathAry withRowAnimation:UITableViewRowAnimationAutomatic];
    //NSLog(@"刷新单个的一行了");
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
