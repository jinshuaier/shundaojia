#import "TCGoodsSearchViewController.h"
#import "TCSearchView.h"
#import "TCShopCarView.h"
#import "TCShopsSearchTableViewCell.h"
#import "TCShopDetailsViewController.h" //详情
#import "TCShopSearchModel.h"
#import "TCSubmitViewController.h"
#import "TCLoginViewController.h"

@interface TCGoodsSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UINavigationControllerDelegate, UIGestureRecognizerDelegate>
{
    UIView *backSearchView; //搜索框
    UIButton *searchBtn; //搜索的按钮
    UIButton *BackBtn; //返回按钮
    
    UIImageView *placeholderImage; //占位图  。。。。 能runtime
    UILabel *placeholderLabel_one;
    UILabel *placeholderLabel_two;
    
    UIImageView *im1;
}

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) TCSearchView *searchView;
@property (nonatomic, strong) NSMutableArray *hotArray;
@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) UITableView *shopGoodTabelView;
@property (nonatomic, strong) UIButton *lastButton; //最后的btn
@property (nonatomic, strong) UIView *lineView; //线

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *line2; //底部的线
@property (nonatomic, strong) UILabel *numlb;
@property (nonatomic, strong) UIButton *jisuan;
@property (nonatomic, strong) UILabel *allPrice;
@property (nonatomic, strong) NSMutableArray *sqlMuArr;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) NSUserDefaults *userdefaults;
@property (nonatomic, strong) FMDatabase *database;
@property (nonatomic, strong) NSMutableArray *shopMuArr;
@property (nonatomic, strong) UIView *noMesView;

@end

@implementation TCGoodsSearchViewController

- (NSMutableArray *)historyArray
{
    if (!_historyArray) {
        _historyArray = [NSKeyedUnarchiver unarchiveObjectWithFile:SGSearchPath];
        if (!_historyArray) {
            self.historyArray = [NSMutableArray array];
        }
    }
    return _historyArray;
}

- (TCSearchView *)searchView
{
    if (!_searchView) {
        self.searchView = [[TCSearchView alloc] initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, KScreenWidth, KScreenHeight - StatusBarAndNavigationBarHeight) hotArray:nil historyArray:self.historyArray];
        self.searchView.isShopGoodsSearch = YES;
        __weak TCGoodsSearchViewController *weakSelf = self;
        _searchView.tapAction = ^(NSString *str) {
            [weakSelf pushToSearchResultWithSearchStr:str];
        };
    }
    return _searchView;
}
//隐藏导航栏
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.delegate = self;
    [self reloadViews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = TCBgColor;
    [self.view addSubview:self.searchView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadViews) name:@"detailBack" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gogo) name:@"shopcarpush" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(relo) name:@"needreload" object:nil];
    
    _database = [FMDatabase databaseWithPath: SqlPath];
    _sqlMuArr = [NSMutableArray array];
    _shopMuArr = [NSMutableArray array];
    _userdefaults = [NSUserDefaults standardUserDefaults];
    //创建navView
    [self createNav];
    
    //占位图
    [self createNoGoods];
    //添加历史记录到视图上
    [self.view addSubview:self.searchView];
}

//创建nav
- (void)createNav{
    UIView *navView = [[UIView alloc] init];
    navView.frame = CGRectMake(0, 0, WIDTH, StatusBarAndNavigationBarHeight);
    navView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:navView];
    
    //返回按钮
    BackBtn = [[UIButton alloc] init];
    BackBtn.frame = CGRectMake(12, StatusBarHeight + 10, 24, 24);
    [BackBtn setImage:[UIImage imageNamed:@"返回按钮1.5（黑）"] forState:(UIControlStateNormal)];
    [BackBtn addTarget:self action:@selector(backBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [navView addSubview:BackBtn];
    
    //搜索view
    backSearchView = [[UIView alloc] init];
    backSearchView.frame = CGRectMake(CGRectGetMaxX(BackBtn.frame) + 12, StatusBarHeight + 6, WIDTH - (CGRectGetMaxX(BackBtn.frame) + 12) - 14, 32);
    backSearchView.backgroundColor = TCUIColorFromRGB(0xF5F5F5);
    [navView addSubview:backSearchView];
    
    //搜索的按钮
    searchBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    searchBtn.frame = CGRectMake(WIDTH - 15 - 30, StatusBarHeight + 6, 30, 32);
    searchBtn.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [searchBtn setTitle:@"搜索" forState:(UIControlStateNormal)];
    [searchBtn setTitleColor:TCUIColorFromRGB(0xF99E20) forState:(UIControlStateNormal)];
    searchBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    searchBtn.hidden = YES;
    [searchBtn addTarget:self action:@selector(searchBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [navView addSubview:searchBtn];
    
    //搜索icon
    UIImageView *searchIcon = [[UIImageView alloc] init];
    searchIcon.image = [UIImage imageNamed:@"首页搜索icon"];
    searchIcon.frame = CGRectMake(12, 8, 16, 15.5);
    [backSearchView addSubview:searchIcon];
    
    //搜索框
    self.searchField = [[UITextField alloc] init];
    self.searchField.frame = CGRectMake(CGRectGetMaxX(searchIcon.frame) + 8, 6, backSearchView.frame.size.width - 36 - 12 - 30, 21);
    self.searchField.clearButtonMode = UITextFieldViewModeAlways;
    self.searchField.delegate = self;
    self.searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchField.placeholder = @"输入您要的商品名称";
    [self.searchField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    [self.searchField setValue:TCUIColorFromRGB(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    [self.searchField setValue:[UIFont fontWithName:@"PingFangSC-Regular" size:13] forKeyPath:@"_placeholderLabel.font"];
    self.searchField.textColor = TCUIColorFromRGB(0x333333);
    self.searchField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    [backSearchView addSubview:self.searchField];
    
    //一条细线
    UIView *lineNavcView = [[UIView alloc] init];
    lineNavcView.frame = CGRectMake(0, StatusBarAndNavigationBarHeight - 1, WIDTH, 1);
    lineNavcView.backgroundColor = TCBgColor;
    [navView addSubview:lineNavcView];
    
    //创建tableView
    self.shopGoodTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - 50 - StatusBarAndNavigationBarHeight - TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
    self.shopGoodTabelView.delegate = self;
    self.shopGoodTabelView.dataSource = self;
    self.shopGoodTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.shopGoodTabelView.hidden = YES;
    self.shopGoodTabelView.backgroundColor = TCBgColor;
    [self.view addSubview: self.shopGoodTabelView];
    
    //刷新
    //底层的view
    self.bottomView = [[UIView alloc] init];
    self.bottomView.frame = CGRectMake(0,HEIGHT - 50 - TabbarSafeBottomMargin, WIDTH, 50);
    self.bottomView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:self.bottomView];

    //下划线
    self.line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, _bottomView.frame.origin.y - 0.5, WIDTH, 0.5)];
    self.line2.backgroundColor = TCLineColor;
    [self.view addSubview: self.line2];

    //图片
    im1 = [[UIImageView alloc]initWithFrame:CGRectMake(12, _bottomView.frame.origin.y + _bottomView.frame.size.height - 10  - 56 , 56 , 56 )];
    im1.image = [UIImage imageNamed:@"购物车（无商品）"];
    im1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taps)];
    [im1 addGestureRecognizer: tap];
    [self.view addSubview: im1];

    _numlb = [[UILabel alloc]initWithFrame:CGRectMake(im1.frame.size.width + im1.frame.origin.x - 19 , im1.frame.origin.y + 10, 20 , 16 )];
    _numlb.layer.cornerRadius = 8 ;
    _numlb.layer.masksToBounds = YES;
    _numlb.backgroundColor = TCUIColorFromRGB(0xFF3355);
    _numlb.text = @"";
    _numlb.textAlignment = NSTextAlignmentCenter;
    _numlb.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    _numlb.textColor = [UIColor whiteColor];
    [self.view addSubview: _numlb];

    //结算按钮
    _jisuan = [UIButton buttonWithType:UIButtonTypeCustom];
    _jisuan.frame = CGRectMake(WIDTH - 120 , 0, 120 , _bottomView.frame.size.height);
    _jisuan.backgroundColor = TCUIColorFromRGB(0xCCCCCC);
    [_jisuan setTitle:[NSString stringWithFormat:@"还差¥%@起送", @"10"] forState:UIControlStateNormal];
    [_jisuan setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    _jisuan.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15 ];
    [_jisuan addTarget:self action:@selector(qujiesuan) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview: _jisuan];
    //总计
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(im1.frame.origin.x + im1.frame.size.width + 8 , 4 , 48, 20 )];
    lb.text = @"总计：";
    lb.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    CGSize size = [lb sizeThatFits:CGSizeMake(48, 20 )];
    lb.frame = CGRectMake(im1.frame.origin.x + im1.frame.size.width + 8 , 4 , size.width, 20 );
    lb.textColor = TCUIColorFromRGB(0x333333);
    lb.textAlignment = NSTextAlignmentLeft;
    [_bottomView addSubview: lb];
    //价格
    _allPrice = [[UILabel alloc]initWithFrame:CGRectMake(lb.frame.origin.x + lb.frame.size.width , lb.frame.origin.y, _jisuan.frame.origin.x - lb.frame.origin.x - lb.frame.size.width - 5  - 12 , lb.frame.size.height)];
    _allPrice.text = @"¥0.00";
    _allPrice.textColor = TCUIColorFromRGB(0x333333);
    _allPrice.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    _allPrice.textAlignment = NSTextAlignmentLeft;
    [_bottomView addSubview: _allPrice];
    //配送费
    UILabel *lb2 = [[UILabel alloc]initWithFrame:CGRectMake(lb.frame.origin.x, lb.frame.origin.y + lb.frame.size.height + 4 , WIDTH - 120 - CGRectGetMaxX(lb.frame) - 8, 15 )];
    lb2.text = [NSString stringWithFormat:@"配送费 ¥%@",_shopMesDic[@"distributionPrice"]];
    lb2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    lb2.textColor = TCUIColorFromRGB(0x999999);
    CGSize size_lb2 = [lb2 sizeThatFits:CGSizeMake(WIDTH - 120 - CGRectGetMaxX(lb.frame) - 8, 15 )];
    lb2.frame = CGRectMake(lb.frame.origin.x, lb.frame.origin.y + lb.frame.size.height + 4 , size_lb2.width, 15 );
    [_bottomView addSubview: lb2];
    
    [self shopCarHid];

    [self bianliSQL];
}

//隐藏和显示
- (void)shopCarHid {
    self.bottomView.hidden = YES;
    im1.hidden = YES;
    self.line2.hidden = YES;
    _numlb.hidden = YES;
}

- (void)shopCarOn{
    self.bottomView.hidden = NO;
    im1.hidden = NO;
    self.line2.hidden = NO;
    _numlb.hidden = NO;
}

//商品详情页面更改数据后  发来的通知 要求重新配置数据
- (void)reloadViews{
    [self bianliSQL];
    [_shopGoodTabelView reloadData];
}

- (void)relo{
    [self bianliSQL];
    [_shopGoodTabelView reloadData];
}
//占位图
- (void)createNoGoods
{
    //没有搜索商品的图
    placeholderImage = [[UIImageView alloc] init];
    placeholderImage.image = [UIImage imageNamed:@"无搜索结果插图"];
    placeholderImage.frame = CGRectMake((WIDTH - 120)/2, (HEIGHT - StatusBarAndNavigationBarHeight - 120)/2, 120, 120);
    placeholderImage.hidden = YES;
    [self.view addSubview:placeholderImage];
    
    placeholderLabel_one = [UILabel publicLab:@"没有搜索结果" textColor:TCUIColorFromRGB(0x999999) textAlignment:NSTextAlignmentCenter fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    placeholderLabel_one.frame = CGRectMake(0, CGRectGetMaxY(placeholderImage.frame) + 14, WIDTH, 22);
    placeholderLabel_one.hidden = YES;
    [self.view addSubview:placeholderLabel_one];
    
    placeholderLabel_two = [UILabel publicLab:@"换个关键词试试" textColor:TCUIColorFromRGB(0x999999) textAlignment:NSTextAlignmentCenter fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    placeholderLabel_two.frame = CGRectMake(0, CGRectGetMaxY(placeholderLabel_one.frame) + 4, WIDTH, 18);
    placeholderLabel_two.hidden = YES;
    [self.view addSubview:placeholderLabel_two];
}

#pragma mark -- 加载获取的数据
//添加刷新
- (void)setupRefresh:(NSString *)searchType{
    //下拉
    __block int  page = 1;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self requestShops:searchType];
        
    }];
    //设置刷新标题
    [header setTitle:@"下拉刷新顺道嘉商品..." forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新顺道嘉商品..." forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新顺道嘉商品..." forState:MJRefreshStateRefreshing];
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    // 设置颜色
    header.stateLabel.textColor = [UIColor lightGrayColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
    
    self.shopGoodTabelView.mj_header = header;
    [header beginRefreshing];
    
    //上拉
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page++;
        [self requestShops:page andType:searchType];
    }];
    //设置上拉标题
    [footer setTitle:@"上拉加载更多顺道嘉商品" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载更多顺道嘉商品..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"无更多顺道嘉商品!" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    self.shopGoodTabelView.mj_footer = footer;
}


//下拉请求
- (void)requestShops:(NSString *)searchType{
    
    [self.shopMuArr removeAllObjects];
    NSString *timeStr = [TCGetTime getCurrentTime];
    
    NSDictionary *dic = @{@"page":@"1",@"timestamp":timeStr,@"longtitude":self.shopMesDic[@"longtitude"],@"latitude":self.shopMesDic[@"latitude"],@"keyword":searchType,@"shopid":self.shopID};
    NSString *signStr = [TCServerSecret signStr:dic];
    NSDictionary *paramters = @{@"page":@"1",@"timestamp":timeStr,@"longtitude":self.shopMesDic[@"longtitude"],@"latitude":self.shopMesDic[@"latitude"],@"keyword":searchType,@"shopid":self.shopID,@"sign":signStr};
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102026"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        NSArray *arr = jsonDic[@"data"];
        if (arr.count > 0){
            [_shopMuArr addObjectsFromArray: jsonDic[@"data"]];
            placeholderImage.hidden = YES;
            placeholderLabel_two.hidden = YES;
            placeholderLabel_one.hidden = YES;
            self.shopGoodTabelView.hidden = NO;
            [self shopCarOn];
        } else {
            placeholderImage.hidden = NO;
            placeholderLabel_two.hidden = NO;
            placeholderLabel_one.hidden = NO;
            [self shopCarHid];
        }
        [self.shopGoodTabelView.mj_header endRefreshing];
        [self.shopGoodTabelView reloadData];
    } failure:^(NSError *error) {
        nil;
    }];
    [self.shopGoodTabelView.mj_footer resetNoMoreData];
}

//上拉加载
- (void)requestShops:(int)page andType:(NSString *)searchType{
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *pageStr = [NSString stringWithFormat:@"%d",page];
    
    NSDictionary *dic = @{@"page":pageStr,@"timestamp":timeStr,@"longtitude":self.shopMesDic[@"longtitude"],@"latitude":self.shopMesDic[@"latitude"],@"keyword":searchType,@"shopid":self.shopMesDic[@"shopid"]};
    NSString *signStr = [TCServerSecret signStr:dic];
    NSDictionary *paramters = @{@"page":pageStr,@"timestamp":timeStr,@"longtitude":self.shopMesDic[@"longtitude"],@"latitude":self.shopMesDic[@"latitude"],@"keyword":searchType,@"shopid":self.shopMesDic[@"shopid"],@"sign":signStr};
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102026"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        if (jsonDic[@"data"]) {
            [_shopMuArr addObjectsFromArray: jsonDic[@"data"]];
            [_shopGoodTabelView.mj_footer endRefreshing];
            [_shopGoodTabelView reloadData];
        }else{
            [_shopGoodTabelView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        nil;
    }];
    [self.shopGoodTabelView.mj_footer resetNoMoreData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.shopMuArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.qh_width, 0)];
    footerView.backgroundColor = TCBgColor;
    return footerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.qh_width, 0)];
    footerView.backgroundColor = TCBgColor;
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return 8;
    } else {
        return 4;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [_shopGoodTabelView registerClass:[TCShopsSearchTableViewCell class] forCellReuseIdentifier:[NSString stringWithFormat:@"cell%zd%zd", (long)indexPath.section, (long)indexPath.row]];
    TCShopsSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell%zd%zd", (long)indexPath.section, (long)indexPath.row]];
    if (_shopMuArr.count != 0) {
        cell = [[TCShopsSearchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"cell%zd%zd", (long)indexPath.section, (long)indexPath.section] andData:_shopMuArr[indexPath.section] andSQLArr:_sqlMuArr];
        [cell bianli:^{
            [self bianliSQL];
        }];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_shopMuArr.count != 0) {
        TCShopDetailsViewController *shopDetailVC = [[TCShopDetailsViewController alloc]init];
        shopDetailVC.shopMesDic = _shopMesDic;
        shopDetailVC.shopID = self.shopID;
        shopDetailVC.idStr = _shopMuArr[indexPath.section][@"goodsid"];
        shopDetailVC.shopDetailDic = _shopMuArr[indexPath.section];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shopDetailVC animated:YES];
    }
}


- (void)presentVCFirstBackClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushToSearchResultWithSearchStr:(NSString *)str
{
    [self.searchField resignFirstResponder];
    self.searchField.text = str;
    
    _searchView.hidden = YES;
    self.shopGoodTabelView.hidden = NO;
    
    [self setupRefresh:str];
    [self setHistoryArrWithStr:str];
}

- (void)setHistoryArrWithStr:(NSString *)str
{
    
    for (int i = 0; i < _historyArray.count; i++) {
        if ([_historyArray[i] isEqualToString:str]) {
            [_historyArray removeObjectAtIndex:i];
            break;
        }
    }
    [_historyArray insertObject:str atIndex:0];
    [NSKeyedArchiver archiveRootObject:_historyArray toFile:SGSearchPath];
}

#pragma mark - UISearchBarDelegate -
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self pushToSearchResultWithSearchStr:searchBar.text];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}


//监听文本框刚开始的变化
-(void)valueChanged:(UITextField *)textField{
    
    //textfield的协议
    if (textField.text.length != 0) {
        backSearchView.frame = CGRectMake(CGRectGetMaxX(BackBtn.frame) + 12, StatusBarHeight + 6, WIDTH - (CGRectGetMaxX(BackBtn.frame) + 12) - 55 , 32);
        searchBtn.hidden = NO;
        
    } else {
        backSearchView.frame = CGRectMake(CGRectGetMaxX(BackBtn.frame) + 12, StatusBarHeight + 6, WIDTH - (CGRectGetMaxX(BackBtn.frame) + 12) - 14, 32);
        searchBtn.hidden = YES;
        placeholderImage.hidden = YES;
        placeholderLabel_two.hidden = YES;
        placeholderLabel_one.hidden = YES;
        self.shopGoodTabelView.hidden = YES;
        _searchView.hidden = NO;
        [self shopCarHid];

        [self.view addSubview:self.searchView];
        [self.view bringSubviewToFront:_searchView];
    }
}

#pragma mark -- 搜索的点击事件
- (void)searchBtn:(UIButton *)sender
{
    if (self.searchField.text.length != 0){
        [self.searchField resignFirstResponder];
        [self setHistoryArrWithStr:self.searchField.text];
        _searchView.hidden = YES;

        self.shopGoodTabelView.hidden = NO;
        //请求搜索商品的接口
        [self setupRefresh:self.searchField.text];

    } else {
        [TCProgressHUD showMessage:@"输入您要的商品名称"];
    }
}

//点击搜索键盘的事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //发送请求
    if (self.searchField.text.length != 0){
        [textField resignFirstResponder];
        _searchView.hidden = YES;
        self.shopGoodTabelView.hidden = NO;
        [self setHistoryArrWithStr:self.searchField.text];
        
        [self setupRefresh:textField.text];
    } else {
        [TCProgressHUD showMessage:@"输入您要的商品名称"];
    }
    return YES;
}

//购物车点击事件
- (void)taps{
    //先遍历
    [self bianliSQL];
    if (_sqlMuArr.count != 0) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _backView.backgroundColor = [[UIColor darkGrayColor]colorWithAlphaComponent:0.3];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hahha)];
        tap.delegate = self;//这句不要漏掉
        [_backView addGestureRecognizer:tap];
        [[UIApplication sharedApplication].keyWindow addSubview: _backView];
        //创建是  将起送跟配送传过去
        TCShopCarView *shop = [[TCShopCarView alloc] initWithFrame:CGRectMake(0, HEIGHT - 372, WIDTH, 372) andData:_sqlMuArr andqisong:_shopMesDic[@"startPrice"] andPeisong:_shopMesDic[@"distributionPrice"] andShop:self.shopID];
        [_backView addSubview: shop];
        //点击购物车按钮  移除view后的回调方法  在此处要重新配置主页面上的减号状态与数量
        //点击购物车按钮  移除view后的回调方法  在此处要重新配置主页面上的减号状态与数量
        [shop disBackView:^{
            [self bianliSQL];
            [_shopGoodTabelView reloadData];
            [_backView removeFromSuperview];
        }];
        //到达0 这里是同步上面的数据
        [shop shuaxin:^{
            [self bianliSQL];
            [_shopGoodTabelView reloadData];

            //[_backView removeFromSuperview];
        }];
    }else{
        [TCProgressHUD showMessage:@"您还没有选购商品！"];
    }
}

#pragma mark -- 点击空白处下落
- (void)shopcarTap
{
    [_backView removeFromSuperview];
}

//遍历数据库
- (void)bianliSQL{
    //获取之前先移除之前数据
    [_sqlMuArr removeAllObjects];
    //遍历数据库  更改底部购物车view的数据
    if ([_database open]) {
        FMResultSet *res = [_database executeQuery:@"select *from newShopCar where storeid = ?", self.shopID];
        while ([res next]) {
            NSDictionary *dic = @{@"id":[res stringForColumn:@"shopid"], @"price":[res stringForColumn:@"shopprice"], @"amount":[res stringForColumn:@"shopcount"], @"name":[res stringForColumn:@"shopname"], @"pic":[res stringForColumn:@"shopPic"],@"goodscateid":[res stringForColumn:@"goodscateid"]};
            [_sqlMuArr addObject: dic];
        }
    }
    
    //更新总价钱 与 角标
    float x = 0;
    int y = 0;
    if (self.shopGoodTabelView.hidden == YES){
        _numlb.hidden = YES;
    } else {
        _numlb.hidden = NO;
    }
    for (int i = 0; i < _sqlMuArr.count ; i++) {
        x += [_sqlMuArr[i][@"amount"] floatValue] * [_sqlMuArr[i][@"price"] floatValue];
        y += [_sqlMuArr[i][@"amount"] intValue];
    }
    _allPrice.text = [NSString stringWithFormat:@"¥%.2f", x];
    _numlb.text = [NSString stringWithFormat:@"%d", y];
    
    //去除数组中数量为0的元素
    NSMutableArray *muarr = [NSMutableArray array];
    for (int i = 0; i < _sqlMuArr.count; i++) {
        if ([_sqlMuArr[i][@"amount"] intValue] != 0) {
            //如果不等于0  取出
            [muarr addObject:_sqlMuArr[i]];
        }
    }
    if (y > 0){
        im1.image = [UIImage imageNamed:@"购物车（有商品的）"];
    } else {
        im1.image = [UIImage imageNamed:@"购物车（无商品）"];
    }
    [_sqlMuArr removeAllObjects];
    //重新赋值
    _sqlMuArr = muarr;
    
    //判断是否达到起送价格
    float cha = [_shopMesDic[@"startPrice"] floatValue] - x;
    if (y > 0){
        if (cha > 0) {
            if (x == 0) {
                [_jisuan setTitle:[NSString stringWithFormat:@"¥%.2f起送", [_shopMesDic[@"startPrice"] floatValue]] forState:UIControlStateNormal];
            }else{
                [_jisuan setTitle:[NSString stringWithFormat:@"还差¥%.2f起送", cha] forState:UIControlStateNormal];
            }
            _jisuan.userInteractionEnabled = NO;
            _jisuan.backgroundColor = TCUIColorFromRGB(0xCCCCCC);
        }else{
            [_jisuan setTitle:[NSString stringWithFormat:@"去结算"] forState:UIControlStateNormal];
            _jisuan.userInteractionEnabled = YES;
            _jisuan.backgroundColor = TCUIColorFromRGB(0xF99E20);        }
    } else {
        [_jisuan setTitle:[NSString stringWithFormat:@"¥%.2f起送", [_shopMesDic[@"startPrice"] floatValue]] forState:UIControlStateNormal];
        _jisuan.userInteractionEnabled = NO;
        _jisuan.backgroundColor = TCUIColorFromRGB(0xCCCCCC);
    }
}
- (void)qujiesuan{
    [self bianliSQL];
    //不重新用一个数组赋值  就传不过去值    很奇怪！
    NSMutableArray *ar = [NSMutableArray array];
    [ar addObjectsFromArray: _sqlMuArr];
    if (_sqlMuArr.count != 0) {
        if ([_userdefaults valueForKey:@"userID"]) {
            TCSubmitViewController *submitVC = [[TCSubmitViewController alloc] init];
            submitVC.shopIDStr = self.shopID;
            submitVC.typeStr = @"0";
            submitVC.shopMuArr = ar;
            submitVC.messDic = self.shopMesDic;
            [self.navigationController pushViewController:submitVC animated:YES];
        }else{
            TCLoginViewController *login = [[TCLoginViewController alloc]init];
            [self presentViewController:login animated:YES completion:nil];
        }
    }else{
        [TCProgressHUD showMessage:@"您还没有选购商品！"];
    }
}
- (void)hahha{
    [_backView removeFromSuperview];
    [self bianliSQL];
    [_shopGoodTabelView reloadData];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (![touch.view isKindOfClass: [TCShopCarView class]]) {
        return NO;
    }
    return YES;
}


- (void)gogo{
    [_backView removeFromSuperview];
    [self bianliSQL];
    [_shopGoodTabelView reloadData];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    NSLog(@"123");
}

#pragma mark -- 返回按钮
- (void)backBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.searchField resignFirstResponder];
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
