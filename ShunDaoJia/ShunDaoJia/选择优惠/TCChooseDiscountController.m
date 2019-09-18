//
//  TCChooseDiscountController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/13.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCChooseDiscountController.h"
#import "TCUseDisTableViewCell.h"
#import "TCUnuseCell.h"

@interface TCChooseDiscountController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *maintableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *youhuiArr;
@property (nonatomic, strong) NSUserDefaults *userdefaults;

@end

@implementation TCChooseDiscountController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择优惠红包";
    self.dataArr = [NSMutableArray array];
    self.youhuiArr = [NSMutableArray array];
    
    self.view.backgroundColor = TCBgColor;
    [self creatUI];
    //添加刷新
    self.userdefaults = [NSUserDefaults standardUserDefaults];
    [self setupRefresh];
    // Do any additional setup after loading the view.
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
        [self requestNew];
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
- (void)requestNews{
    [self.dataArr removeAllObjects];
    
    NSString *timeStr = [TCGetTime getCurrentTime];
    
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"money":_moneyStr,@"timestamp":timeStr};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"money":self.moneyStr,@"timestamp":timeStr,@"sign":signStr};
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102025"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        for (NSDictionary *infoDic in jsonDic[@"data"]) {
            TCChooseDiscountInfo *model =  [TCChooseDiscountInfo orderInfoWithDictionary:infoDic];
            [self.dataArr addObject:model];
        }
        self.youhuiArr = jsonDic[@"data"];
        NSLog(@"%@",self.dataArr);
        //占位图
        [self NeedResetNoView];
        
        [self.maintableView reloadData];
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
-(void)requestNew{
    
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"sign":signStr};
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102025"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        for (NSDictionary *infoDic in jsonDic[@"data"]) {
            TCChooseDiscountInfo *model = [TCChooseDiscountInfo orderInfoWithDictionary:infoDic];
            [self.dataArr addObject:model];
        }
        [TCProgressHUD showMessage:jsonDic[@"msg"]];
        [self.maintableView.mj_footer endRefreshing];
        [self.maintableView reloadData];
    } failure:^(NSError *error) {
        nil;
        [self.maintableView.mj_footer endRefreshingWithNoMoreData];
    }];
}

-(void)creatUI{
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight + 8, WIDTH, 44)];
    bgview.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:bgview];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 13, 70, 18)];
    label.text = @"不使用红包";
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    label.textColor = TCUIColorFromRGB(0x4C4C4C);
    label.textAlignment = NSTextAlignmentLeft;
    [bgview addSubview:label];
    
    UIButton *checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 36 - 20, 12, 20, 20)];
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"商品选中框"] forState:(UIControlStateNormal)];
    checkBtn.selected = NO;
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"商品选中框（黄）"] forState:(UIControlStateSelected)];
    [checkBtn addTarget:self action:@selector(clickCheck:) forControlEvents:(UIControlEventTouchUpInside)];
    [bgview addSubview:checkBtn];
    
    self.maintableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgview.frame), WIDTH, HEIGHT - (CGRectGetMaxY(bgview.frame)) - TabbarSafeBottomMargin) style:(UITableViewStyleGrouped)];
    self.maintableView.delegate = self;
    self.maintableView.dataSource = self;
    self.maintableView.showsVerticalScrollIndicator = NO;
    self.maintableView.backgroundColor = TCBgColor;
    self.maintableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.maintableView];
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
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.qh_width, 40)];
        headerView.backgroundColor = TCBgColor;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 12, WIDTH - 48 - 36, 16)];
        
        //循环遍历
        NSMutableArray *arr_user = [NSMutableArray array];
        for (int i = 0; i < self.youhuiArr.count; i++){
            NSString *str = [NSString stringWithFormat:@"%@",self.youhuiArr[i][@"status"]];
            if ([str isEqualToString:@"1"]){
                [arr_user addObject:str];
            }
        }
        label.text = [NSString stringWithFormat:@"有%lu个可使用红包",(unsigned long)arr_user.count];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        label.textColor = TCUIColorFromRGB(0x666666);
        label.textAlignment = NSTextAlignmentLeft;
        [headerView addSubview:label];
        
//        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 12 - 48, 12, 48, 16)];
//        [btn setBackgroundColor:TCBgColor];
//        btn.layer.masksToBounds = YES;
//        btn.layer.cornerRadius = 4;
//        [btn setTitle:@"红包说明" forState:(UIControlStateNormal)];
//        [btn setTitleColor:TCUIColorFromRGB(0x4Ca6FF) forState:(UIControlStateNormal)];
//        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
//        btn.titleLabel.textAlignment = NSTextAlignmentRight;
//        [headerView addSubview:btn];
        return headerView;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 40;
    }else{
        return 8;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TCUseDisTableViewCell *cell = [[TCUseDisTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    if (self.dataArr.count != 0) {
        cell.model = self.dataArr[indexPath.section];
    }
    cell.myBlock = ^{
        NSLog(@"回传值你敢信");
        __weak typeof(self)weakself = self;
        // 实现Block回调并进行数据传递
        NSString *reMoney = cell.model.reduce;
        NSString *youhuiID = cell.model.IDStr;
        if (weakself.myBlock) {
            weakself.myBlock(reMoney, youhuiID);
        }
        [self.navigationController popViewControllerAnimated:YES];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)clickCheck:(UIButton *)sender{
    sender.selected = !sender.selected;
    __weak typeof(self)weakself = self;
    if (weakself.myBlock) {
        weakself.myBlock(@"0", @"0");
    }
    [self.navigationController popViewControllerAnimated:YES];
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
