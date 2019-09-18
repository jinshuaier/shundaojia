//
//  TCGroupViewController.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/11.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

//
//  TCOrderViewController.m
//  顺道嘉
//
//  Created by 胡高广 on 2017/9/29.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCGroupViewController.h"
#import "TCGrouppurchaseCell.h"
#import "TCCommodityController.h"
#import "TCGroupGoodsModel.h"
#import "ZMFloatButton.h"
#import "TCShopCarViewController.h"
#import "TCGroupDataBase.h"
#import "TCNoMessageView.h"
#import "GYTransitionAnimatorArc.h"

@interface TCGroupViewController ()<UITableViewDelegate,UITableViewDataSource,ZMFloatButtonDelegate,UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, assign) BOOL isNet;
@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, strong) TCGroupDataBase *groupDataBase;
@property (nonatomic, strong) UILabel *hotRedNumLabel; //红点的label
@property (nonatomic, strong) NSString *shopidStr; //店铺的id
@property (nonatomic, strong) NSString *distributionPrice; //配送费
@property (nonatomic, strong) TCNoMessageView *nomessageView; //占位
@property (nonatomic, strong) ZMFloatButton * floatBtn_xuan; //悬浮的按钮

@end

@implementation TCGroupViewController


-(void)viewWillAppear:(BOOL)animated{
    //每次进来遍历啊
    [self bianliFMDB];
    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isNet = YES;
    self.title = @"团购";
    self.view.backgroundColor = TCBgColor;
    self.dataArr = [NSMutableArray array];
    //初始化数据库
    self.groupDataBase = [[TCGroupDataBase alloc] initTCDataBase];

//    //请求接口
//    [self request];
    //创建View
    [self creatUI];
    //悬浮的按钮
    [self floatBtn];
    
    // Do any additional setup after loading the view.
}

//悬浮的button
- (void)floatBtn
{
   self.floatBtn_xuan = [[ZMFloatButton alloc]initWithFrame:CGRectMake(WIDTH - 48 * WIDHTSCALE - 15 * WIDHTSCALE, HEIGHT - 25 * HEIGHTSCALE - TabbarHeight - 48 * HEIGHTSCALE, 48 * WIDHTSCALE, 48 * HEIGHTSCALE)];
    self.floatBtn_xuan.delegate = self;
    //floatBtn.isMoving = NO;
    self.floatBtn_xuan.bannerIV.image = [UIImage imageNamed:@"悬浮购物车_新"];
    [self.view addSubview:self.floatBtn_xuan];
    [self.view bringSubviewToFront:self.floatBtn_xuan];
    
    self.hotRedNumLabel = [UILabel publicLab:nil textColor:TCUIColorFromRGB(0xFFFFFF) textAlignment:NSTextAlignmentCenter fontWithName:@"PingFangSC-Medium" size:10 * HEIGHTSCALE numberOfLines:0];
    self.hotRedNumLabel.backgroundColor = TCUIColorFromRGB(0xFF3355);
    self.hotRedNumLabel.frame = CGRectMake(CGRectGetMaxX(self.floatBtn_xuan.frame) - 16 * WIDHTSCALE, HEIGHT - 55 * HEIGHTSCALE - TabbarHeight - 18 * HEIGHTSCALE, 16 * WIDHTSCALE, 16 * HEIGHTSCALE);
    self.hotRedNumLabel.layer.cornerRadius = 8;
    self.hotRedNumLabel.layer.masksToBounds = YES;
    self.hotRedNumLabel.hidden = YES;
    [self.view addSubview:self.hotRedNumLabel];
    [self.view bringSubviewToFront:self.hotRedNumLabel];
}

#pragma mark -ZMFloatButtonDelegate
- (void)floatTapAction:(ZMFloatButton *)sender{
    //点击执行事件
    NSMutableArray *groupArr = [self.groupDataBase bianliFMDB:self.shopidStr];
    if (groupArr.count == 0){
        [TCProgressHUD showMessage:@"您还没有选择商品"];
    } else {
        TCShopCarViewController *shopCarVC = [[TCShopCarViewController alloc]init];
        shopCarVC.shopID = self.shopidStr;
        shopCarVC.distributionPrice = self.distributionPrice;
        shopCarVC.listGroup = YES;
        shopCarVC.transitioningDelegate = self;
        [self.navigationController pushViewController:shopCarVC animated:YES];
    }
}

-(void)request{
    //指示器
    [self.dataArr removeAllObjects];
//    [BQActivityView showActiviTy];
//    [ProgressHUD showHUDToView:self.view];
    
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSDictionary *dic = @{@"timestamp":timeStr};
    NSString *signStr = [TCServerSecret signStr:dic];
    NSDictionary *paramters = @{@"timestamp":timeStr,@"sign":signStr};
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"104003"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"Dic = %@,Str = %@",jsonDic,jsonStr);
        NSMutableArray *arr = jsonDic[@"data"];
        for (NSDictionary *infoDic in arr) {
            TCGroupGoodsModel *model = [TCGroupGoodsModel goodsInfoWithDictionary:infoDic];
            [self.dataArr addObject:model];
            self.shopidStr = [NSString stringWithFormat:@"%@",arr[0][@"shopid"]];
            self.distributionPrice = [NSString stringWithFormat:@"%@",arr[0][@"distributionPrice"]];
        }
        //占位图
        [self NeedResetNoView];
        [self.mainTableView reloadData];
        //请求接口遍历数据库
        [self bianliFMDB];
        [self.mainTableView.mj_header endRefreshing];
//        [ProgressHUD hiddenHUD:self.view];
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
        self.floatBtn_xuan.hidden = NO;
    }else{
        [self.mainTableView showNoView:@"暂无团购商品~" image: [UIImage imageNamed:@"暂无商品插图"] certer:CGPointZero];
        self.floatBtn_xuan.hidden = YES;
    }
}

-(void)creatUI{
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - TabbarHeight - StatusBarAndNavigationBarHeight) style:(UITableViewStyleGrouped)];
    
    //修改过这块可以去掉
    if (self.isTiao == YES) {
        self.mainTableView.frame = CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - StatusBarAndNavigationBarHeight);
    }
    self.mainTableView.backgroundColor = TCBgColor;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.rowHeight = 322;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    AdjustsScrollViewInsetNever(self,self.mainTableView);
    [self.view addSubview:self.mainTableView];
    
    //不如此处加个上拉刷新吧
    //添加刷新
     [self setupRefresh];
}

//添加刷新
- (void)setupRefresh{
    //下拉
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //请求接口
        [self request];
    }];
    //设置刷新标题
    [header setTitle:@"下拉刷新顺道嘉团购..." forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新顺道嘉团购..." forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新顺道嘉团购..." forState:MJRefreshStateRefreshing];
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:12 * HEIGHTSCALE];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12 * HEIGHTSCALE];
    // 设置颜色
    header.stateLabel.textColor = [UIColor lightGrayColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
    
    self.mainTableView.mj_header = header;
    [header beginRefreshing];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//预防ios11错误
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 4 * HEIGHTSCALE;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1 * HEIGHTSCALE;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TCGrouppurchaseCell *Groupcell = [[TCGrouppurchaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    Groupcell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.dataArr.count != 0){
        TCGroupGoodsModel *model = self.dataArr[indexPath.section];
        Groupcell.model = model;
    } else {
        
    }
    return Groupcell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TCCommodityController *commDetail = [[TCCommodityController alloc]init];
    TCGroupGoodsModel *model = self.dataArr[indexPath.section];
    commDetail.shopID = model.shopID;
    commDetail.strid = model.goodsid;
    commDetail.distributionPrice = self.distributionPrice;
    [self.navigationController pushViewController:commDetail animated:YES];
}

//每次进来遍历数据库哈
- (void)bianliFMDB
{
    NSMutableArray *groupArr = [self.groupDataBase bianliFMDB:self.shopidStr];
    NSLog(@"--%@",groupArr);
    if (groupArr.count == 0){
        self.hotRedNumLabel.hidden = YES;
        self.floatBtn_xuan.bannerIV.image = [UIImage imageNamed:@"悬浮购物车_新"];
    } else {
        self.floatBtn_xuan.bannerIV.image = [UIImage imageNamed:@"悬浮购物车（色）"];
        NSInteger count = 0;
        for (int i = 0; i < groupArr.count; i++) {
            count += [groupArr[i][@"shopCount"] integerValue];
        }
        if (count > 0) {
            self.hotRedNumLabel.text = [NSString stringWithFormat:@"%ld", (long)count];
            self.hotRedNumLabel.hidden = NO;
        } else {
            self.hotRedNumLabel.hidden = YES;
        }
    }
}
- (GYTransitionAnimatorArc *)isPresentToController4:(BOOL)present{
    GYTransitionAnimatorArc *animator = [[GYTransitionAnimatorArc alloc]init];
    animator.isPresent = present;
    animator.duration = 0.5;
    animator.currentFrame = self.floatBtn_xuan.frame;
    return animator;
}


@end


