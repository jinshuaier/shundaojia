//
//  TCShopViewController.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/11/24.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCShopViewController.h"
#import "TCListCell.h" //详情列表
#import "TCShopMessageViewController.h"
#import "TCSearchController.h"

@interface TCShopViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,TCListCellDelegate,UIGestureRecognizerDelegate,selectViewDelegate,UIGestureRecognizerDelegate>
{
    NSInteger selectIndex;//当前选择index
    BOOL isShow;//YES已展开，NO已收起
    UIView *backView;
    NSArray *_imagesURLStrings;
    SDCycleScrollView *_customCellScrollViewDemo;
}
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UIButton *lastButton; //最后的btn
@property (nonatomic, strong) UIView *lineView; //线
@property (nonatomic, strong) UITableView *downTableView;
@property (nonatomic, strong) UIView *headView; //头View
@property (nonatomic, strong) BSDropDownView   *departSelectView;
@property (nonatomic , copy)NSString *dropDownTitle;

@property (nonatomic, strong) ZYYWheelView *lunboView; //轮播的view
@property (nonatomic, strong) UIView *naView;
@property (nonatomic, strong) UIView *naView_two;

@property (nonatomic, strong) NSArray *btnTitleArray;//存放首页数据的数组
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) NSMutableArray *dataMuArr;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSMutableArray *imageAdsArr;
@property (nonatomic, strong) NSArray *cateArr;
@property (nonatomic, strong) UIButton *stypeBtn;
@property (nonatomic, strong) NSString *btntitle;
@property (nonatomic, strong) NSString *seleStr;



@end

@implementation TCShopViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.isAllDian == YES){
        self.navigationController.navigationBarHidden = NO;
    } else {
        self.navigationController.navigationBarHidden = YES;
    }
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [backView removeFromSuperview];
    }
    [backView removeFromSuperview];
    [_departSelectView removeFromSuperview];
}

-(BSDropDownView *)departSelectView
{
    if (!_departSelectView) {
        //        这里是设置的初始化位置，可以把那个Y值设置在你点击button的下边
        _departSelectView = [[BSDropDownView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height)];
        //        这里是个枚举，从下往上出还是从上往下出这里设置枚举就行
        _departSelectView.type = showTableStyleTypeFromUpToBottom;
        _departSelectView.delegate = self;
    }
    return _departSelectView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cateArr = @[@{@"id":@"1",@"name":@"综合排序"},@{@"id":@"4",@"name":@"起送价最低"},@{@"id":@"5",@"name":@"配送费最低"},@{@"id":@"6",@"name":@"评价最高"}];
    self.view.backgroundColor = TCBgColor;
    self.title = self.TitleStr;
    self.btntitle = @"综合排序";
    self.seleStr = @"1";
    self.dataMuArr = [NSMutableArray array];
    self.imageAdsArr = [NSMutableArray array];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:[UIImage imageNamed:@"首页搜索图标"] forState:(UIControlStateNormal)];
    searchBtn.frame = CGRectMake(WIDTH - 16 * WIDHTSCALE - 19 * WIDHTSCALE, 13 *HEIGHTSCALE + StatusBarHeight, 19 * WIDHTSCALE, 19 * HEIGHTSCALE);
//    [searchBtn addTarget:self action:@selector(searchBtn:) forControlEvents:(UIControlEventTouchUpInside)];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
   // self.navigationItem.rightBarButtonItem = rightItem;
    
    //创建首页的TableView
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, self.view.qh_width, self.view.qh_height - TabbarSafeBottomMargin - StatusBarAndNavigationBarHeight) style:UITableViewStylePlain];
    
    //解决ios11的导航栏布局的问
    AdjustsScrollViewInsetNever (self,self.mainTableView);
    self.mainTableView.delegate=self;//设置表视图外貌代理
    self.mainTableView.dataSource=self;
    //去掉分割线
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.mainTableView];
    
    //ios11解决点击刷新跳转的问题
    self.mainTableView.estimatedRowHeight = 0;
    self.mainTableView.estimatedSectionHeaderHeight = 0;
    self.mainTableView.estimatedSectionFooterHeight = 0;
    
    //一进来先让它刷新获取经纬度 默认综合排序
    [self setupRefresh:@"1" andsearchType:self.typeStr];
    
}

#pragma mark
//添加刷新
- (void)setupRefresh:(NSString *)searchType andsearchType:(NSString *)Type{
    //下拉
    __block int  page = 1;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self requestShops:searchType andtitleType:Type];
        
    }];
    //设置刷新标题
    [header setTitle:@"下拉刷新顺道嘉周边..." forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新顺道嘉周边..." forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新顺道嘉周边..." forState:MJRefreshStateRefreshing];
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:12 * HEIGHTSCALE];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12 * HEIGHTSCALE];
    // 设置颜色
    header.stateLabel.textColor = [UIColor lightGrayColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
    
    self.mainTableView.mj_header = header;
    [header beginRefreshing];
    
    //上拉
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page++;
        [self requestShops:page andType:searchType andtitleType:Type];
    }];
    //设置上拉标题
    [footer setTitle:@"上拉加载更多顺道嘉周边" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载更多顺道嘉周边..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"无更多顺道嘉周边!" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:12 * HEIGHTSCALE];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    self.mainTableView.mj_footer = footer;
}


//下拉请求
- (void)requestShops:(NSString *)searchType andtitleType:(NSString *)Type{
    //清除sdwebimage 的缓存 商家跟换头像后 首页头像还是之前的
    [[SDImageCache sharedImageCache] clearDisk];
    [self.dataMuArr removeAllObjects];
    //    [_newshopMuArr removeAllObjects];
    
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSLog(@"%@",[self.userDefaults valueForKey:@"latitude"]);
    //如果登录了
    NSDictionary *paramters;
    
    if ([self.userDefaults valueForKey:@"userID"] == nil){
        NSDictionary *dic1 = @{@"page":@"1",@"timestamp":timeStr,@"latitude":self.latStr,@"longtitude":self.longStr,@"searchType":searchType,@"deviceid":[TCGetDeviceId getDeviceId],@"cateid":Type};
        NSString *signStr1 = [TCServerSecret signStr:dic1];
        paramters = @{@"page":@"1",@"timestamp":timeStr,@"latitude":[self.userDefaults valueForKey:@"latitude"],@"longtitude":[self.userDefaults valueForKey:@"longitude"],@"searchType":searchType,@"deviceid":[TCGetDeviceId getDeviceId],@"sign":signStr1,@"cateid":Type};
    } else {
        NSString *midStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userID"]];
        NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userToken"]];
        
        NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"page":@"1",@"timestamp":timeStr,@"latitude":self.latStr,@"longtitude":self.longStr,@"searchType":searchType,@"deviceid":[TCGetDeviceId getDeviceId],@"cateid":Type};
        NSString *signStr = [TCServerSecret signStr:dic];
        paramters = @{@"mid":midStr,@"token":tokenStr,@"page":@"1",@"timestamp":timeStr,@"latitude":self.latStr,@"longtitude":self.longStr,@"searchType":searchType,@"sign":signStr,@"deviceid":[TCGetDeviceId getDeviceId],@"cateid":Type};
    }
    
    NSLog(@" %@--",paramters);
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"101015"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        
        NSMutableArray *arr = jsonDic[@"data"][@"shopList"];
        for (int i = 0; i < arr.count; i++) {
            OrderInfoModel *model = [OrderInfoModel orderInfoWithDictionary:arr[i]];
            [self.dataMuArr addObject:model];
        }
        
        self.imageAdsArr = jsonDic[@"data"][@"bannerList"];
        
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView reloadData];
    } failure:^(NSError *error) {
        nil;
    }];
    [self.mainTableView.mj_footer resetNoMoreData];
}

//上拉加载
- (void)requestShops:(int)page andType:(NSString *)searchType andtitleType:(NSString *)titleType{
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *pageStr = [NSString stringWithFormat:@"%d",page];
    //如果登录了
    NSDictionary *paramters;
    if ([self.userDefaults valueForKey:@"userID"]){
        NSString *midStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userID"]];
        NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userToken"]];
        
        NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"page":pageStr,@"timestamp":timeStr,@"latitude":self.latStr,@"longtitude":self.longStr,@"searchType":searchType,@"cateid":titleType,@"deviceid":[TCGetDeviceId getDeviceId]};
        NSString *signStr = [TCServerSecret signStr:dic];
        paramters = @{@"mid":midStr,@"token":tokenStr,@"page":pageStr,@"timestamp":timeStr,@"latitude":self.latStr,@"longtitude":self.longStr,@"searchType":searchType,@"sign":signStr,@"cateid":titleType,@"deviceid":[TCGetDeviceId getDeviceId]};
    } else {
        NSDictionary *dic1 = @{@"page":pageStr,@"timestamp":timeStr,@"latitude":self.latStr,@"longtitude":self.longStr,@"searchType":searchType,@"cateid":titleType,@"deviceid":[TCGetDeviceId getDeviceId]};
        NSString *signStr1 = [TCServerSecret signStr:dic1];
        paramters = @{@"page":pageStr,@"timestamp":timeStr,@"latitude":self.latStr,@"longtitude":self.longStr,@"searchType":searchType,@"sign":signStr1,@"cateid":titleType,@"deviceid":[TCGetDeviceId getDeviceId]};
    }
    
    NSLog(@" %@--",paramters);
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"101015"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        
        NSMutableArray *arr = jsonDic[@"data"][@"shopList"];
        for (int i = 0; i < arr.count; i++) {
            OrderInfoModel *model = [OrderInfoModel orderInfoWithDictionary:arr[i]];
            [self.dataMuArr addObject:model];
        }
        
        [self.mainTableView.mj_footer endRefreshing];
        [self.mainTableView reloadData];
       
    } failure:^(NSError *error) {
        nil;
    }];
    [self.mainTableView.mj_footer resetNoMoreData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return 1;
    }
    return self.dataMuArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        return 120 * HEIGHTSCALE;
    }else{
        if (self.dataMuArr.count > 0) {
            OrderInfoModel *model = self.dataMuArr[indexPath.row];
            return model.cellHight;
        }
        return (98 + 12) * HEIGHTSCALE;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1){
        return 40 * HEIGHTSCALE;
    }
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

//预防ios11错误
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1){
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.qh_width, 40 * HEIGHTSCALE)];
        headerView.backgroundColor = [UIColor whiteColor];
        //创建3个按钮
        _btnTitleArray = @[self.btntitle,@"销量最高",@"距离最近"];
        _isSelect = NO;
        CGFloat btnWidth = WIDTH / 3;
        for (int i = 0; i < 3; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(btnWidth * i, 0, btnWidth, 40 * HEIGHTSCALE);
            btn.tag = 1000 + i;
            [btn setTitle:_btnTitleArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:TCUIColorFromRGB(0x666666) forState:(UIControlStateNormal)];
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13 * HEIGHTSCALE];
            if (i == 0){
                self.stypeBtn = btn;
                [btn setImage:[UIImage imageNamed:@"下拉三角"] forState:(UIControlStateSelected)];
                [btn setImage:[UIImage imageNamed:@"进入定位小三角"] forState:(UIControlStateNormal)];
            }
            if ([self.seleStr isEqualToString:@"1"]) {
                if (i == 0) {
                    btn.selected = YES;
                   [btn setTitleColor:TCUIColorFromRGB(0xF99E20) forState:(UIControlStateNormal)];
                }else{
                    [btn setTitleColor:TCUIColorFromRGB(0x666666) forState:(UIControlStateNormal)];
                }
            }else if ([self.seleStr isEqualToString:@"2"]){
                if (i == 1) {
                    [btn setTitleColor:TCUIColorFromRGB(0xF99E20) forState:(UIControlStateNormal)];
                }else{
                    [btn setTitleColor:TCUIColorFromRGB(0x666666) forState:(UIControlStateNormal)];
                }
            }else if ([self.seleStr isEqualToString:@"3"]){
                if (i == 2) {
                    [btn setTitleColor:TCUIColorFromRGB(0xF99E20) forState:(UIControlStateNormal)];
                }else{
                    [btn setTitleColor:TCUIColorFromRGB(0x666666) forState:(UIControlStateNormal)];
                }
            }
            /******* 以下方法是让图片靠右，文字靠左 *******/
            CGFloat imageWidth = btn.imageView.bounds.size.width;
            CGFloat labelWidth = btn.titleLabel.bounds.size.width;
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth - 10 * HEIGHTSCALE);
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
            
            UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(WIDTH / 3 , 14 * HEIGHTSCALE, 1 * WIDHTSCALE, 11 * HEIGHTSCALE)];
            viewline.backgroundColor = TCUIColorFromRGB(0xE8E8E8);
            [btn addSubview:viewline];
            
            UIView *bottom_Line = [[UIView alloc] init];
            bottom_Line.frame = CGRectMake(0, 39 * HEIGHTSCALE, WIDTH, 0.5 * HEIGHTSCALE);
            bottom_Line.backgroundColor = TCUIColorFromRGB(0xE8E8E8);
            [headerView addSubview:bottom_Line];
            
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionOfTap:)];
            [btn addGestureRecognizer:tap];
            [headerView addSubview:btn];
        }
        return headerView;
    }
    return [[UIView alloc] init];
}

#pragma mark --- 创建背景颜色
-(void)backView{
    backView = [[UIView alloc]init];
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    backView.frame = CGRectMake(0, StatusBarAndNavigationBarHeight + 40 * HEIGHTSCALE , WIDTH, HEIGHT - StatusBarAndNavigationBarHeight - TabbarSafeBottomMargin);
    [self.view addSubview:backView];
    UITapGestureRecognizer *tapgesrure = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cilcktap)];
    [backView addGestureRecognizer:tapgesrure];
}
#pragma mark -- 手势下滑
- (void)cilcktap
{
    isShow = NO;
    UIButton *btn = (UIButton *)[self.view viewWithTag:1000];
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:1001];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:1002];
    [self removeTListViewWithSelectItemView:btn];
    [self removeTListViewWithSelectItemView:btn1];
    [self removeTListViewWithSelectItemView:btn2];
}

#pragma mark --- 点击button
- (void)actionOfTap:(UITapGestureRecognizer*)button {
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:1000];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:1001];
    UIButton *btn3 = (UIButton *)[self.view viewWithTag:1002];
    UIButton* btn = (UIButton*)button.view;
    btn.selected = !btn.selected;
    if (btn.tag == 1000){
        self.seleStr = @"1";
        [self.stypeBtn setImage:[UIImage imageNamed:@"上拉三角"] forState:(UIControlStateNormal)];
       // [self setupRefresh:@"1" andsearchType:self.typeStr];
        if (isShow){
            //移除当前
            [self closeCurrViewOnIndex:selectIndex isCloseShowView:YES];
        }else{
            //展开新的
            [self showTListViewWIthSelectItemView:btn];
        }
    } else if (btn.tag == 1001){
        self.seleStr = @"2";
        [self setupRefresh:@"2" andsearchType:self.typeStr];
        if (isShow){
            //移除当前
            [self closeCurrViewOnIndex:selectIndex isCloseShowView:YES];
        }else{
            //展开新的
            [self showTListViewWIthSelectItemView:btn];
        }
    } else if (btn.tag == 1002){
        [self setupRefresh:@"3" andsearchType:self.typeStr];
        self.seleStr = @"3";
        if (isShow){
            //移除当前
            [self closeCurrViewOnIndex:selectIndex isCloseShowView:YES];
        }else{
            //展开新的
            [self showTListViewWIthSelectItemView:btn];
        }
        btn3.selected = YES;
        btn2.selected = NO;
        btn1.selected = NO;
        [btn1 setTitleColor:TCUIColorFromRGB(0x666666) forState:(UIControlStateNormal)];
        [btn2 setTitleColor:TCUIColorFromRGB(0x666666) forState:(UIControlStateNormal)];
        [btn3 setTitleColor:TCUIColorFromRGB(0xF99E20) forState:(UIControlStateNormal)];
    }
    [self.mainTableView reloadData];
}
//收起button的方法
- (void)closeCurrViewOnIndex:(NSInteger)index isCloseShowView:(BOOL)isshow
{
    UIButton* btn = (UIButton*)[self.view viewWithTag:1000+index];
    [self removeTListViewWithSelectItemView:btn];
}

- (void)removeTListViewWithSelectItemView:(UIButton*)sender{
    isShow = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.mainTableView.frame = CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - StatusBarAndNavigationBarHeight - TabbarSafeBottomMargin);
        [self.mainTableView setContentOffset:CGPointMake(0, 0)];
        self.departSelectView.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);
        self.departSelectView.selectTitle = self.dropDownTitle;
    } completion:^(BOOL finished) {
        [self.departSelectView removeFromSuperview];
    }];
    [backView removeFromSuperview];
    selectIndex = sender.tag-1000;
    if (selectIndex == 0){
        //按钮样式变化
        [sender setImage:[UIImage imageNamed:@"上拉三角"] forState:(UIControlStateNormal)];
    }
    [sender setTitleColor:TCUIColorFromRGB(0x666666) forState:(UIControlStateNormal)];
}

#pragma mark - 展开
- (void)showTListViewWIthSelectItemView:(UIButton*)sender{
    if(sender.tag == 1000){
        //分类的接口
        [self backView];
        
        [sender setImage:[UIImage imageNamed:@"上拉三角"] forState:(UIControlStateNormal)];
        [UIView animateWithDuration:0.2 animations:^{
            self.mainTableView.frame = CGRectMake(0,-58 * HEIGHTSCALE, WIDTH, HEIGHT + 58 * HEIGHTSCALE);
            self.mainTableView.contentOffset = CGPointMake(0, 0);
            [self.mainTableView reloadData];
            [[UIApplication sharedApplication].keyWindow addSubview:self.departSelectView];
            //加手势
            UITapGestureRecognizer *departTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(departTap)];
            departTap.delegate = self;
            [self.departSelectView addGestureRecognizer:departTap];
            
            if (self.departSelectView.dataArr.count == 0) {
                for (NSDictionary *dic in self.cateArr) {
                    NSString *nameStr = dic[@"name"];
                    [self.departSelectView.dataArr addObject:nameStr];
                }
            }
            
            //            self.departSelectView.dataArr = (NSMutableArray *)self.cateArr;
            self.departSelectView.selectTitle = self.dropDownTitle;
            
            self.departSelectView.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.cateArr.count*48 * HEIGHTSCALE);
            
            [self.departSelectView.tableView reloadData];
        } completion:^(BOOL finished) {
        }];
    }
    
    selectIndex = sender.tag-1000;
    
    if (selectIndex == 0){
        //按钮样式变化
        [self.stypeBtn setImage:[UIImage imageNamed:@"上拉三角"] forState:(UIControlStateNormal)];
    }
    [sender setTitleColor:TCUIColorFromRGB(0xF99E20) forState:(UIControlStateNormal)];
    isShow = YES;
}
-(void)didselectRow:(NSString *)context indexPath:(NSIndexPath *)indexPath selectView:(BSDropDownView *)selectView modelIndex:(NSInteger)index
{
    UIButton *btn = (UIButton *)[self.view viewWithTag:10000];
    if ([context isEqualToString:@""]||!context||[context isEqual:[NSNull class]] || !context.length) return;
    
    //    context这个就是你点击每一行拿到的值
    NSLog(@"id:%@---------%@",self.cateArr[indexPath.row][@"id"],context);
    NSString *idstr = [NSString stringWithFormat:@"%@",self.cateArr[indexPath.row][@"id"]];
    [self setupRefresh:idstr andsearchType:self.typeStr];
    [self.stypeBtn setTitle:context forState:(UIControlStateNormal)];
    [btn setTitle:context forState:(UIControlStateNormal)];
    self.dropDownTitle = context;
    self.btntitle = context;
    NSLog(@"分类的table");
    isShow = NO;
    [backView removeFromSuperview];
    //点击按钮会下移
    [UIView animateWithDuration:0.2 animations:^{
        [self.mainTableView setContentOffset:CGPointMake(0, 0)];
        self.mainTableView.frame = CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - StatusBarAndNavigationBarHeight - TabbarSafeBottomMargin);
        self.mainTableView.contentInset  = UIEdgeInsetsMake(0, 0, 0, 0);
    } completion:^(BOOL finished) {
    }];
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.qh_width, 0)];
    footerView.backgroundColor = TCBgColor;
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identfire=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identfire];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfire];
        cell.backgroundColor = [UIColor redColor];
    }
    NSMutableArray *urlArr = [NSMutableArray array];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0){
        for (int i = 0; i < self.imageAdsArr.count; i++) {
            [urlArr addObject:self.imageAdsArr[i][@"images"]];
        }
        NSLog(@"你看看%@",urlArr);
        SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, 120 * HEIGHTSCALE) delegate:self placeholderImage:[UIImage imageNamed:@"商品详情页占位"]];
        cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"轮播点（白）"];
        cycleScrollView3.pageDotImage = [UIImage imageNamed:@"轮播点（透明）"];
        if (urlArr.count != 0){
            cycleScrollView3.imageURLStringsGroup = urlArr;
        } else {
            NSLog(@"哈哈");
            _imagesURLStrings = @[@"商品详情页占位"];
            cycleScrollView3.imageURLStringsGroup = _imagesURLStrings;
        }
        [cell.contentView addSubview:cycleScrollView3];
    } else {
        TCListCell *Listcell = [[TCListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        if (self.dataMuArr.count > 0){
            Listcell.model = self.dataMuArr[indexPath.row];
            Listcell.distributionLabel.frame = CGRectMake(CGRectGetMaxX(Listcell.lineView.frame) + 8 * WIDHTSCALE, CGRectGetMaxY(Listcell.monthNumLabel.frame) + 11 * HEIGHTSCALE, 75 * WIDHTSCALE, 11 * HEIGHTSCALE);
        } else {
            NSLog(@"无数据");
        }
        
        if (Listcell.count < 3){
            NSLog(@"不刷新");
        } else {
            Listcell.delegate = self;
        }
        Listcell.selectionStyle = UITableViewCellSelectionStyleNone;
        return Listcell;
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
    }else{
        TCShopMessageViewController *shopMessageVC = [[TCShopMessageViewController alloc] init];
        OrderInfoModel *model = self.dataMuArr[indexPath.row];
        
        shopMessageVC.shopImageStr = model.headPicStr;
        shopMessageVC.shopNameStr = model.nameStr;
        shopMessageVC.sendStr = model.startPriceStr;
        shopMessageVC.peisongStr = model.distributionPriceStr;
        shopMessageVC.activeArr = model.activitiesArr;
        shopMessageVC.numGoods = model.numGoods;
        shopMessageVC.timeStr = model.deliverTimeStr;
        shopMessageVC.bussnissStr = model.shopTime;
        shopMessageVC.starStr = model.rankStr;
        shopMessageVC.MesDic = model.shareDic;
        shopMessageVC.shopID = model.shopidStr;
        shopMessageVC.goodsID = @"0";
        shopMessageVC.goodCateID = @"0";
        [self.navigationController pushViewController:shopMessageVC animated:YES];
    }
}
#pragma mark -- 排序
- (void)typeSelect:(UIButton *)button {
    self.lastButton.selected = NO;
    button.selected = YES;
    self.lastButton = button;
    //    self.mainTableView.frame = CGRectMake(0, StatusBarAndNavigationBarHeight + 48, self.view.qh_width, HEIGHT - TabbarSafeBottomMargin - 48 - StatusBarAndNavigationBarHeight);
    self.mainTableView.contentInset = UIEdgeInsetsMake(- 48 * WIDHTSCALE - 120 * WIDHTSCALE, 0, 0, 0);
    switch (button.tag) {
        case 1000: {
            
        }
            break;
        case 1001: {
            
        }
            break;
        case 1002: {
            
        }
            break;
        default:
            break;
    }
    
    // [listTableView reloadData];
}
#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
}
#pragma mark -- 手势的点击事件
- (void)tap
{
    NSLog(@"点击搜索");
    TCSearchController *searchVC = [[TCSearchController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
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

//返回按钮点击事件
- (void)backBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

//代理方法
- (void)sendValue
{
    isShow = NO;
    [UIView animateWithDuration:0.2 animations:^{
        [self.mainTableView setContentOffset:CGPointMake(0, 0)];
        self.mainTableView.frame = CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - StatusBarAndNavigationBarHeight - TabbarSafeBottomMargin);
        self.departSelectView.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);
        //            self.departSelectView.dataArr = (NSMutableArray *)self.cateArr;
        self.departSelectView.selectTitle = self.dropDownTitle;
        
        [self.departSelectView.tableView reloadData];

    } completion:^(BOOL finished) {
        [self.departSelectView removeFromSuperview];
        [backView removeFromSuperview];
    }];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(nonnull UITouch *)touch{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }else{
        return YES;
    }
    
}

#pragma mark -- 点击空白处的手势
- (void)departTap
{
    isShow = NO;
    [UIView animateWithDuration:0.2 animations:^{
        [self.mainTableView setContentOffset:CGPointMake(0, 0)];
        self.mainTableView.frame = CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - StatusBarAndNavigationBarHeight - TabbarSafeBottomMargin);
        self.departSelectView.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);
        //            self.departSelectView.dataArr = (NSMutableArray *)self.cateArr;
        self.departSelectView.selectTitle = self.dropDownTitle;
        
        //            [self.departSelectView.tableView reloadData];
    } completion:^(BOOL finished) {
        [self.departSelectView removeFromSuperview];
    }];
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