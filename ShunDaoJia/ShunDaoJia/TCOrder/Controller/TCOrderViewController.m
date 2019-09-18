//
//  TCOrderViewController.m
//  顺道嘉
//
//  Created by 胡高广 on 2017/9/29.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCOrderViewController.h"
#import "TCOrderTableViewCell.h"
#import "TCOrderDetailsViewController.h"
#import "TCOrderListInfo.h"
#import "TCNoMessageView.h"
#import "TCShierViewController.h"
#import "TCOrderCommitViewController.h"
#import "TCSubmitViewController.h"
#import "TCLoginViewController.h"
#import "TCTabBarController.h"
#import "TCShopMessageViewController.h" //店铺信息
#import "TCOrderFlowView.h" //申诉跟踪

@interface TCOrderViewController () <UITableViewDataSource,UITableViewDelegate,CheckNetworkDelegate,MycellDelegate>

@property (nonatomic, strong) UIButton *lastButton; //用来选择记录
@property (nonatomic, strong) UIView *lineView; //线
@property (nonatomic, strong) NSString *typeStr; //分类
@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) TCNoMessageView *nomessageView; //占位
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, strong) UILabel *payhotLabel;
@property (nonatomic, strong) UILabel *fahotLabel;
@property (nonatomic, strong) UILabel *shouhotLabel;
@property (nonatomic, strong) UILabel *commithotLabel;
@property (nonatomic, strong) NSDictionary *messDic;
@property (nonatomic, assign) BOOL isShuaxin;

@end

@implementation TCOrderViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:NO animated:animated];
   
    self.userDefaults = [NSUserDefaults standardUserDefaults];

    //评价
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderShuaxincomm) name:@"orderShuaxincomm" object:nil];
    
    //取消订单
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quxiaoorder) name:@"quxiaoorder" object:nil];
    
    //完成订单后的订单刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dingdanshuaxin) name:@"dingdanshuaxin" object:nil];
    
    //创建View
//    [self createUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderShuaxin) name:@"orderShuaxin" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单";
    self.dataArr = [[NSMutableArray alloc] init];
    self.view.backgroundColor = TCBgColor;
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    //创建View
    [self createUI];
}

//支付完成后的支付刷新
- (void)dingdanshuaxin
{
    //添加刷新
    [self createUI];
//    [self requestOrder:@"0"];
}

//登录完成
- (void)orderShuaxin
{
    //添加刷新
    [self createUI];
}
#pragma mark -- 刷新去评价完
- (void)orderShuaxincomm
{
    //添加刷新
    [self createUI];
    //添加刷新
//    [self setupRefresh:@"0"];
}
#pragma mark -- 刷新取消订单
-(void)quxiaoorder{
//    [self setupRefresh:@"0"];
    //添加刷新
    [self createUI];
}

//创建UI
- (void)createUI {
    [self.nomessageView removeFromSuperview];
    [self.listTableView removeFromSuperview];
    if ([self.userDefaults valueForKey:@"userID"]){
        //创建历史记录的tableView
        self.listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - TabbarHeight - StatusBarAndNavigationBarHeight) style:UITableViewStyleGrouped];
        self.listTableView.delegate = self;
        self.listTableView.dataSource = self;
        self.listTableView.rowHeight = 60 + 106 + 44;
        self.listTableView.backgroundColor = TCBgColor;
        self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview: self.listTableView];
        
        //解决ios11的导航栏布局的问
        AdjustsScrollViewInsetNever (self,self.listTableView);
        //ios11解决点击刷新跳转的问题
        self.listTableView.estimatedRowHeight = 0;
        self.listTableView.estimatedSectionHeaderHeight = 0;
        self.listTableView.estimatedSectionFooterHeight = 0;
        
        //添加刷新
        [self setupRefresh:@"0"];
    } else {
        self.nomessageView = [[TCNoMessageView alloc] initWithFrame:CGRectMake(0, 42 + StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - 42 - TabbarHeight - StatusBarAndNavigationBarHeight) AndImage:@"暂无订单插图" AndLabel:@"登录后才可以看到订单哦~" andButton:@"登录"];
        self.isLogin = YES;
        self.nomessageView.delegate = self;
        [self.view addSubview:self.nomessageView];
    }
}

//添加刷新
- (void)setupRefresh:(NSString *)status{
    //下拉
    __block int  page = 1;
    self.isShuaxin = YES;
    self.view.userInteractionEnabled = NO;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        page = 1;
        //刷新
        [self requestOrder:status];
    }];
    //设置刷新标题
    [header setTitle:@"下拉刷新顺道嘉订单..." forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新顺道嘉订单..." forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新顺道嘉订单..." forState:MJRefreshStateRefreshing];
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
        [self requestOrder:page andstatus:status];
    }];
    //设置上拉标题
    [footer setTitle:@"上拉加载更多顺道嘉订单" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载更多顺道嘉订单..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"无更多顺道嘉订单!" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    self.listTableView.mj_footer = footer;
}

//下拉请求
- (void)requestOrder:(NSString *)status{
    self.listTableView.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
    NSString *timeStr = [TCGetTime getCurrentTime];
    
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userToken"]];
    
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"page":@"1",@"timestamp":timeStr,@"status":status};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"page":@"1",@"timestamp":timeStr,@"sign":signStr,@"status":status};
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"103002"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        [self.dataArr removeAllObjects];

        NSMutableArray *arr = jsonDic[@"data"];
        for (int i = 0; i < arr.count; i++) {
            TCOrderListInfo *model = [TCOrderListInfo orderInfoWithDictionary:arr[i]];
            [self.dataArr addObject:model];
        }
        NSLog(@"%@",self.dataArr);
        
        //占位图
        [self NeedResetNoView];
        [self.listTableView reloadData];
        [self.listTableView.mj_header endRefreshing];
        _listTableView.userInteractionEnabled = YES;
        self.view.userInteractionEnabled = YES;
    } failure:^(NSError *error) {
        nil;
    }];
    [self.listTableView.mj_footer resetNoMoreData];
}
- (void)NeedResetNoView{
    if (self.dataArr.count >0) {
        [self.nomessageView removeFromSuperview];
    }else{
        
        NSString *stateStr;
        if ([self.typeStr isEqualToString:@"申诉"]){
            stateStr = @"暂无申诉";
        } else {
            stateStr = @"您还没有下过单~";
        }
        if (self.nomessageView){
            [self.nomessageView removeFromSuperview];
            self.nomessageView = [[TCNoMessageView alloc] initWithFrame:CGRectMake(0, 42 + StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - 42 - TabbarHeight - StatusBarAndNavigationBarHeight) AndImage:@"暂无订单插图" AndLabel:stateStr andButton:@"去逛逛"];
            self.nomessageView.delegate = self;
            [self.view addSubview:self.nomessageView];
            
        } else {
            self.nomessageView = [[TCNoMessageView alloc] initWithFrame:CGRectMake(0, 42 + StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - 42 - TabbarHeight - StatusBarAndNavigationBarHeight) AndImage:@"暂无订单插图" AndLabel:stateStr andButton:@"去逛逛"];
            self.nomessageView.delegate = self;
            [self.view addSubview:self.nomessageView];
        }
    }
}
//上拉加载
- (void)requestOrder:(int)page andstatus:(NSString *)status{
    
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userToken"]];
    NSString *pageStr = [NSString stringWithFormat:@"%d",page];
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"page":pageStr,@"timestamp":timeStr,@"status":status};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"page":pageStr,@"timestamp":timeStr,@"sign":signStr,@"status":status};
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"103002"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        NSMutableArray *arr = jsonDic[@"data"];
        for (int i = 0; i < arr.count; i++) {
            TCOrderListInfo *model = [TCOrderListInfo orderInfoWithDictionary:arr[i]];
            [self.dataArr addObject:model];
        }
        self.view.userInteractionEnabled = YES;

        [self.listTableView.mj_footer endRefreshing];
        [self.listTableView reloadData];
    } failure:^(NSError *error) {
        nil;
        [self.listTableView.mj_footer endRefreshingWithNoMoreData];
        self.view.userInteractionEnabled = YES;
    }];
}
 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

   return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    UIView *viewHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0)];
    viewHead.backgroundColor = TCBgColor;
    return viewHead;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0)];
    footerView.backgroundColor = TCBgColor;
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return 8;
    }
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TCOrderTableViewCell *cell = [[TCOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (self.dataArr.count != 0){
        cell.model = self.dataArr[indexPath.section];
        cell.tag = indexPath.section + 1000;
        cell.delegate = self;
    } else {
        NSLog(@"无数据");
    }
    
    cell.comeblock = ^{
        TCOrderDetailsViewController *orderDetailVC = [[TCOrderDetailsViewController alloc] init];
        TCOrderListInfo *model = self.dataArr[indexPath.section];
        orderDetailVC.idStr = model.orderidStr;
        orderDetailVC.shopidStr = model.shopidStr;
        [self.navigationController pushViewController:orderDetailVC animated:YES];
    };
    cell.shopLock = ^{
        //点击进入店铺
        TCOrderListInfo *model = self.dataArr[indexPath.section];
        //如果是3487团购
        if ([model.shopidStr isEqualToString:@"3487"]){
//            self.tabBarController.selectedIndex = 1;
        } else {
            TCShopMessageViewController *shopMessageVC = [[TCShopMessageViewController alloc] init];
            shopMessageVC.shopID = model.shopidStr;
            shopMessageVC.goodsID = @"0";
            shopMessageVC.goodCateID = @"0";
            [self.navigationController pushViewController:shopMessageVC animated:YES];
        }
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -- 点击去逛逛
- (void)reloadData{
    if ([self.userDefaults valueForKey:@"userID"]){
        NSLog(@"去逛逛");
        self.tabBarController.selectedIndex = 0;
    } else {
        NSLog(@"去登录");
        TCLoginViewController *loginVC = [[TCLoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

#pragma mark -- cell的delegate
-(void)didClickButton:(UIButton *)button{
    NSLog(@"进来了");
    TCOrderTableViewCell *cell = (TCOrderTableViewCell *)button.superview.superview.superview;
    NSIndexPath *indexPath = [self.listTableView indexPathForCell:cell];
    cell.model = self.dataArr[indexPath.section];
    //查看详情
    if ([cell.model.issueStatusStr isEqualToString:@"1"] || [cell.model.issueStatusStr isEqualToString:@"2"]) {
        NSLog(@"查看详情");
        TCOrderFlowView *orderFlowView = [[TCOrderFlowView alloc] initWithFrame:self.view.frame andOrderId:cell.model.orderidStr];
        orderFlowView.buttonAction = ^{
            TCOrderDetailsViewController *orderDetailVC = [[TCOrderDetailsViewController alloc] init];
            TCOrderListInfo *model = self.dataArr[indexPath.section];
            orderDetailVC.idStr = model.orderidStr;
            orderDetailVC.shopidStr = model.shopidStr;
            [self.navigationController pushViewController:orderDetailVC animated:YES];
        };
        [self.view addSubview:orderFlowView];
    } else {
    
        if ([cell.model.orderType isEqualToString:@"0"]) {
            NSLog(@"去付款");
            TCShierViewController *shierVC = [[TCShierViewController alloc]init];
            shierVC.orderidStr = cell.model.orderidStr;
            shierVC.priceGoods = cell.model.goodsPriceStr;
            shierVC.shopName = cell.model.shopNameStr;
            shierVC.headImageStr = cell.model.orderHeadImage;
            shierVC.rmakStr = cell.model.rmakStr;
            [self.navigationController pushViewController:shierVC animated:YES];
            
        }else if ([cell.model.orderType isEqualToString:@"1"] || [cell.model.orderType isEqualToString:@"2"]){
            NSLog(@"去催单");
            //催发货的接口
            [self expediteQuest:cell.model.orderidStr];
            
        }else if ([cell.model.orderType isEqualToString:@"3"] || [cell.model.orderType isEqualToString:@"4"]){
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认商品已到达您手中？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确认送达" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *orderid = cell.model.orderidStr;
                [self ConfirmationRequest:orderid];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"点错了" style:UIAlertActionStyleCancel handler:nil]];
            [self.navigationController presentViewController:alert animated:YES completion:nil];
            
        }else if ([cell.model.orderType isEqualToString:@"5"]){
            NSLog(@"再来一单去评价");
            if ([button.titleLabel.text isEqualToString:@"去评价"]) {
                TCOrderCommitViewController *orderCommit = [[TCOrderCommitViewController alloc]init];
                orderCommit.orderid = cell.model.orderidStr;
                orderCommit.shopImageStr = cell.model.orderHeadImage;
                orderCommit.shopNameStr = cell.model.shopNameStr;
                [self.navigationController pushViewController:orderCommit animated:YES];
            }else{
                NSLog(@"再来一单");
                [self againOrder:cell.model.orderidStr];
            }
        } else if ([cell.model.orderType isEqualToString:@"-2"] || [cell.model.orderType isEqualToString:@"-3"]) {
            [self againOrder:cell.model.orderidStr];
        }
    }
}

#pragma mark -- 确认收货的请求
-(void)ConfirmationRequest:(NSString *)orderid{
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userToken"]];
    NSString *terminal = @"IOS";
    NSString *mmdid = [TCGetDeviceId getDeviceId];
    NSString *deviceid = [TCDeviceName getDeviceName];
//    NSString *pageStr = [NSString stringWithFormat:@"%d",page];
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"orderid":orderid,@"timestamp":timeStr,@"terminal":terminal,@"mmdid":mmdid,@"deviceid":deviceid};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"sign":signStr,@"orderid":orderid,@"terminal":terminal,@"mmdid":mmdid,@"deviceid":deviceid};
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"101014"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@--%@",jsonDic,jsonStr);
        NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if ([codeStr isEqualToString:@"1"]) {
            [self setupRefresh:@"0"];
        }else{
            [TCProgressHUD showMessage:[NSString stringWithFormat:@"%@",jsonDic[@"msg"]]];
        }
    } failure:^(NSError *error) {
        nil;
    }];
}


#pragma mark -- 催发货的接口
- (void)expediteQuest:(NSString *)orderID
{
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userToken"]];

    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"orderid":orderID,@"timestamp":timeStr};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"orderid":orderID,@"timestamp":timeStr,@"sign":signStr};
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"101018"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@--%@",jsonDic,jsonStr);
        [TCProgressHUD showMessage:[NSString stringWithFormat:@"%@",jsonDic[@"msg"]]];
        
    } failure:^(NSError *error) {
        nil;
    }];
}

#pragma mark -- 再来一单的请求  //这里是先请求订单详情
- (void)againOrder:(NSString *)order
{
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userToken"]];
    
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"orderid":order,@"timestamp":timeStr};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"orderid":order,@"timestamp":timeStr,@"sign":signStr};
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102014"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@--%@",jsonDic,jsonStr);
        NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if ([codeStr isEqualToString:@"1"]){
            //移除数组多余元素
            NSArray *arr = jsonDic[@"data"][@"goods"];
            NSMutableArray *newarr = [NSMutableArray array];
            for (int i = 0; i < arr.count; i++) {
                NSString *currentCount;
                
                currentCount = arr[i][@"amount"];
                NSDictionary *dic;
                NSString *typeStr = [NSString stringWithFormat:@"%@",jsonDic[@"data"][@"type"]];
                if ([typeStr isEqualToString:@"1"]){ //团购
                    dic = @{@"amount":currentCount, @"id":arr[i][@"goodsid"], @"price":arr[i][@"new_price"], @"name":arr[i][@"name"], @"pic":arr[i][@"src"],@"specID":arr[i][@"specid"]};
                } else {
                   dic = @{@"amount":currentCount, @"id":arr[i][@"goodsid"], @"price":arr[i][@"new_price"], @"name":arr[i][@"name"], @"pic":arr[i][@"src"]};
                }
                [newarr addObject: dic];
            }
            
            TCSubmitViewController *commit = [[TCSubmitViewController alloc]init];
            commit.shopMuArr = newarr;
            commit.messDic = jsonDic[@"data"];
            commit.typeStr = [NSString stringWithFormat:@"%@",jsonDic[@"data"][@"type"]];
            commit.zailai = YES;
            commit.shopIDStr = [NSString stringWithFormat:@"%@",jsonDic[@"data"][@"shopid"]];
            commit.disPriceStr = jsonDic[@"data"][@"distributionPrice"];
            commit.agianDic = jsonDic[@"data"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"hiddenbar" object:nil];
            [self.navigationController pushViewController:commit animated:YES];
        }
    } failure:^(NSError *error) {
        nil;
    }];
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
