//
//  TCMyBankCardViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/24.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCMyBankCardViewController.h"
#import "TCBankCardTableCell.h"
#import "TCBankCardFooterView.h"
#import "TCinputBankCController.h"
#import "TCBindingPassViewController.h"
#import "TCBindingNoSetController.h"
#import "TCNoemptyPassController.h"
#import "TCBankCardInfo.h"
#import "TCModiViewController.h"
#import "TCWithAlSetViewController.h"

@interface TCMyBankCardViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate
>
@property (nonatomic, strong) UITableView *cardtableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSUserDefaults *userdefaults;
@property (nonatomic, strong) UIBarButtonItem *right;

@end

@implementation TCMyBankCardViewController

//-(void)viewWillAppear:(BOOL)animated{
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shuaxin) name:@"refresh" object:nil];
//
//    //添加刷新
//    [self setupRefresh];
//}
//- (void)request{
//    [self.dataArr removeAllObjects];
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的银行卡";
    self.view.backgroundColor = TCBgColor;
    self.dataArr = [NSMutableArray array];
    self.userdefaults = [NSUserDefaults standardUserDefaults];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(huoquset:) name:@"huoquset" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shuaxin) name:@"refresh" object:nil];

    self.navigationItem.rightBarButtonItem = _right;
//    [_right setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Medium" size:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
//    [_right setTintColor:TCUIColorFromRGB(0x333333)];
    
    [self creatUI];
    //添加刷新
    [self setupRefresh];
}

-(void)shuaxin{
    
    [self setupRefresh];
}

-(void)huoquset:(NSNotification *)notification{
    self.isSet = notification.userInfo[@"is_pay"];
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
    
    self.cardtableView.mj_header = header;
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
    self.cardtableView.mj_footer = footer;
}

//下拉请求
- (void)requestNews{
    [self.dataArr removeAllObjects];
    
    NSString *timeStr = [TCGetTime getCurrentTime];
    
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"page":@"1",@"timestamp":timeStr};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"page":@"1",@"timestamp":timeStr,@"sign":signStr};
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102020"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if ([codeStr isEqualToString:@"1"]){
            for (NSDictionary *infoDic in jsonDic[@"data"]) {
                TCBankCardInfo *model = [TCBankCardInfo orderInfoWithDictionary:infoDic];
                [self.dataArr addObject:model];
            }
            _right = [[UIBarButtonItem alloc]initWithTitle:@"管理" style:UIBarButtonItemStylePlain target:self action:@selector(guanli)];
            [_right setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Medium" size:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
            [_right setTintColor:TCUIColorFromRGB(0x333333)];
            self.navigationItem.rightBarButtonItem = _right;
        } else {
            [TCProgressHUD showMessage:jsonDic[@"msg"]];
        }
        NSLog(@"%@",self.dataArr);
        //占位图
        [self NeedResetNoView];
        
        [self.cardtableView reloadData];
        [self.cardtableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        nil;
    }];
    [self.cardtableView.mj_footer resetNoMoreData];
    
}
- (void)NeedResetNoView{
    if (self.dataArr.count >0) {
        [self.cardtableView dismissNoView];
    }else{
        [self.cardtableView showNoView:@"暂无银行卡" image: [UIImage imageNamed:@"无搜索结果插图"] certer:CGPointZero];
    }
}
//上拉加载
- (void)requestNews:(int)page{
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    NSString *pageStr = [NSString stringWithFormat:@"%d",page];
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"page":pageStr,@"timestamp":timeStr};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"page":pageStr,@"timestamp":timeStr,@"sign":signStr};
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102020"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if ([codeStr isEqualToString:@"1"]) {
            for (NSDictionary *infoDic in jsonDic[@"data"]) {
                TCBankCardInfo *model = [TCBankCardInfo orderInfoWithDictionary:infoDic];
                [self.dataArr addObject:model];
            }
        } else {
            [TCProgressHUD showMessage:jsonDic[@"msg"]];
        }
        [self.cardtableView.mj_footer endRefreshing];
        [self.cardtableView reloadData];
    } failure:^(NSError *error) {
        nil;
        [self.cardtableView.mj_footer endRefreshingWithNoMoreData];
    }];
}


-(void)creatUI{

    self.cardtableView = [[UITableView alloc]initWithFrame:CGRectMake(12, StatusBarAndNavigationBarHeight, WIDTH - 24, HEIGHT - StatusBarAndNavigationBarHeight - TabbarSafeBottomMargin - 48) style:UITableViewStyleGrouped];
    self.cardtableView.showsVerticalScrollIndicator = NO;
    self.cardtableView.backgroundColor = TCBgColor;
    self.cardtableView.dataSource = self;
    self.cardtableView.delegate = self;
    
    AdjustsScrollViewInsetNever(self,self.cardtableView);
    
    self.cardtableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.cardtableView registerClass:[TCBankCardTableCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.cardtableView];

    //添加银行卡
    UILabel *addLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT - 48 - TabbarSafeBottomMargin, WIDTH, 48 + TabbarSafeBottomMargin)];
    addLabel.text = @"添加银行卡";
    addLabel.userInteractionEnabled = YES;
    addLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    addLabel.textColor = TCUIColorFromRGB(0xFFFFFF);
    addLabel.backgroundColor = TCUIColorFromRGB(0xF99E20);
    addLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:addLabel];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addBank:)];
    [addLabel addGestureRecognizer:tap];
}

#pragma mark -- dataSouce
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = TCBgColor;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = TCBgColor;
}
//预防ios11错误
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.qh_width, 12)];
        headerView.backgroundColor = TCBgColor;
        return headerView;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 102;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 12;
    }else{
        return 8;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == self.dataArr.count - 1) {
        return 40;
    }else{
        return 0.1;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TCBankCardTableCell *cell = [[TCBankCardTableCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    if (self.dataArr.count != 0) {
        cell.model = self.dataArr[indexPath.section];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",(long)indexPath.section);
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0) __TVOS_PROHIBITED{
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //删除银行卡接口
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    
    TCBankCardInfo *model = self.dataArr[indexPath.section];
    
    NSString *backCodeStr = [NSString stringWithFormat:@"%@",model.ID];
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"cardId":backCodeStr};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"cardId":backCodeStr,@"sign":signStr};
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102028"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if ([codeStr isEqualToString:@"1"]){
            if (self.dataArr.count != 0) {
                [self.dataArr removeObjectAtIndex:indexPath.section];
            } else {
                //占位图
                [self NeedResetNoView];
            }
        } else {
            
            [TCProgressHUD showMessage:jsonDic[@"msg"]];
            
            [self setupRefresh];
           }
        } failure:^(NSError *error) {
            nil;
        }];
}

//管理
- (void)guanli{
    self.cardtableView.editing = !self.cardtableView.editing;
    if (self.cardtableView.isEditing) {
        _right.title = @"取消";
    }else{
        _right.title = @"管理";
    }
}

#pragma mark -- 点击添加银行卡
-(void)addBank:(UITapGestureRecognizer *)sender{
    if (self.dataArr.count != 0) {
        TCNoemptyPassController *intVC = [[TCNoemptyPassController alloc]init];
        [self.navigationController pushViewController:intVC animated:YES];
    }else{
        if (self.isPay == YES) {
            TCWithAlSetViewController *bindingVC = [[TCWithAlSetViewController alloc]init];
            bindingVC.entranceTypeStr = @"5";
            [self.navigationController pushViewController:bindingVC animated:YES];
        }else{
            TCModiViewController*noSetVC = [[TCModiViewController alloc]init];
            noSetVC.mobile = self.mobile;
            noSetVC.entranceTypeStr = @"5";
            noSetVC.titleStr = @"设置支付密码";
            [self.navigationController pushViewController:noSetVC animated:YES];
        }
    }
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
