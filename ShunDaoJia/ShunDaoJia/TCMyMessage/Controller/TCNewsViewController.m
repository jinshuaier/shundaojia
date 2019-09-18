//
//  TCNewsViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/23.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCNewsViewController.h"
#import "TCNewsCell.h"//消息自定义cell
#import "TCNewDetialViewController.h"
#import "TCMessageNewInfo.h"

@interface TCNewsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end

@implementation TCNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通知中心";
    self.view.backgroundColor = TCBgColor;
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.dataArr = [NSMutableArray array];
    [self creatUI];
    //通知过来的刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newDetialReadload) name:@"newDetialReadload" object:nil];
    // Do any additional setup after loading the view.
}

#pragma mark -- 通知过来的刷新
- (void)newDetialReadload
{
    [self setupRefresh];
}

-(void)creatUI{
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - TabbarSafeBottomMargin - StatusBarAndNavigationBarHeight) style:UITableViewStyleGrouped];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.backgroundColor = TCBgColor;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.mainTableView];
    //解决ios11的导航栏布局的问
//    AdjustsScrollViewInsetNever (self,self.mainTableView);
   
    //添加刷新
    [self setupRefresh];
}
//添加刷新
- (void)setupRefresh{
    //下拉
    __block int  page = 1;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        page = 1;
       //刷新
        [self requestNews];
    }];
    //设置刷新标题
    [header setTitle:@"下拉刷新顺道嘉消息..." forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新顺道嘉消息..." forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新顺道嘉消息..." forState:MJRefreshStateRefreshing];
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
        [self requestNews:page];
    }];
    //设置上拉标题
    [footer setTitle:@"上拉加载更多顺道嘉消息" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载更多顺道嘉消息..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"无更多顺道嘉消息!" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    self.mainTableView.mj_footer = footer;
}

//下拉请求
- (void)requestNews{
    [self.dataArr removeAllObjects];
   
    NSString *timeStr = [TCGetTime getCurrentTime];

    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userToken"]];
    
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"page":@"1",@"timestamp":timeStr};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
   
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"page":@"1",@"timestamp":timeStr,@"sign":signStr};
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102002"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
//        [self.dataArr addObjectsFromArray: jsonDic[@"data"]];
        //code
        NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if ([codeStr isEqualToString:@"1"]){
            for (NSDictionary *infoDic in jsonDic[@"data"][@"notifyList"]) {
                TCMessageNewInfo *model = [TCMessageNewInfo orderInfoWithDictionary:infoDic];
                [self.dataArr addObject:model];
            }
        } else {
            [TCProgressHUD showMessage:jsonDic[@"msg"]];
        }
        NSLog(@"%@",self.dataArr);
        //占位图
        [self NeedResetNoView];
        
        [self.mainTableView reloadData];
        [self.mainTableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        nil;
    }];
    [self.mainTableView.mj_footer resetNoMoreData];
   
}
- (void)NeedResetNoView{
    if (self.dataArr.count >0) {
        [self.mainTableView dismissNoView];
    }else{
        [self.mainTableView showNoView:@"暂无消息" image: [UIImage imageNamed:@"无搜索结果插图"] certer:CGPointZero];
    }
}
//上拉加载
- (void)requestNews:(int)page{

    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userToken"]];
    NSString *pageStr = [NSString stringWithFormat:@"%d",page];
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"page":pageStr,@"timestamp":timeStr};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"page":pageStr,@"timestamp":timeStr,@"sign":signStr};
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102002"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        
        for (NSDictionary *infoDic in jsonDic[@"data"][@"notifyList"]) {
            TCMessageNewInfo *model = [TCMessageNewInfo orderInfoWithDictionary:infoDic];
            [self.dataArr addObject:model];
        }
        [self.mainTableView.mj_footer endRefreshing];
        [self.mainTableView reloadData];
    } failure:^(NSError *error) {
        nil;
        [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
    }];
}

#pragma mark -- datasouce
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
//预防ios11错误
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 74;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 12;
    }
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TCNewsCell *Newscell = [[TCNewsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Newscell"];
    Newscell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArr.count != 0){
        Newscell.model = self.dataArr[indexPath.row];
    } else {
        NSLog(@"无数据");
    }
    NSLog(@"%@ %@",self.dataArr,Newscell.model);
    return Newscell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了%lu条消息",indexPath.row);
    TCMessageNewInfo *NewInfo = self.dataArr[indexPath.row];
    NSLog(@"%@",NewInfo.messTitleStr);
    
    TCNewDetialViewController *newDetial = [[TCNewDetialViewController alloc]init];
    newDetial.messIdStr = NewInfo.messageid;
    newDetial.typeStr = NewInfo.typeStr;
    [self.navigationController pushViewController:newDetial animated:YES];    
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
