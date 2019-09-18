//
//  TCSearchController.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/11/25.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCSearchController.h"
#import "TCSearchView.h"

#import "TCSearchGoodTableViewCell.h"
#import "TCSearchGoodsModel.h"
#import "TCShopMessageViewController.h" //店铺详情

@interface TCSearchController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UINavigationControllerDelegate>
{
    NSInteger selectIndex;//当前选择index
    UIView *backSearchView; //搜索框
    UIButton *searchBtn; //搜索的按钮
    UIButton *BackBtn; //返回按钮
    UIView *headerView; //头部的view
    
    UIImageView *placeholderImage; //占位图  。。。。 能runtime
    UILabel *placeholderLabel_one;
    UILabel *placeholderLabel_two;
    UIView *backView;
}

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) TCSearchView *searchView;
@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) UITableView *shopGoodTabelView;
@property (nonatomic, strong) UIButton *lastButton; //最后的btn
@property (nonatomic, strong) UIView *lineView; //线
@property (nonatomic, strong) NSMutableArray *dataArr; //数据
@property (nonatomic, strong) UIButton *shaixuanBtn;
@property (nonatomic, strong) BSDropDownView   *departSelectView;
@property (nonatomic, strong) NSArray *cateArr;
@property (nonatomic, strong) NSString *dropDownTitle;
@property (nonatomic, assign) BOOL isShow;


@end

@implementation TCSearchController
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

- (NSMutableArray *)historyArray
{
    if (!_historyArray) {
        _historyArray = [NSKeyedUnarchiver unarchiveObjectWithFile:KHistorySearchPath];
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
        __weak TCSearchController *weakSelf = self;
        _searchView.tapAction = ^(NSString *str) {
            [weakSelf pushToSearchResultWithSearchStr:str];
        };
    }
    return _searchView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = TCBgColor;
    self.dataArr = [NSMutableArray array];
    self.cateArr = @[@{@"id":@"1",@"name":@"综合排序"},@{@"id":@"4",@"name":@"起送价最低"},@{@"id":@"5",@"name":@"配送费最低"},@{@"id":@"6",@"name":@"评价最高"}];
    [self.view addSubview:self.searchView];
    
    //创建navView
    [self createNav];
    
    //占位图
    [self createNoGoods];
}

#pragma mark --- 创建背景颜色
-(void)backView{
    self.isShow = YES;
    backView = [[UIView alloc]init];
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    backView.frame = CGRectMake(0, StatusBarAndNavigationBarHeight + 40 , WIDTH, HEIGHT - StatusBarAndNavigationBarHeight - TabbarSafeBottomMargin);
    [self.view addSubview:backView];
    UITapGestureRecognizer *tapgesrure = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cilcktap)];
    [backView addGestureRecognizer:tapgesrure];
}
-(void)didselectRow:(NSString *)context indexPath:(NSIndexPath *)indexPath selectView:(BSDropDownView *)selectView modelIndex:(NSInteger)index
{
    UIButton *btn = (UIButton *)[self.view viewWithTag:10000];
    if ([context isEqualToString:@""]||!context||[context isEqual:[NSNull class]] || !context.length) return;
    
    //    context这个就是你点击每一行拿到的值
    NSLog(@"id:%@---------%@",self.cateArr[indexPath.row][@"id"],context);
    NSString *idstr = [NSString stringWithFormat:@"%@",self.cateArr[indexPath.row][@"id"]];
    [self setupRefresh:idstr];
    [self.shaixuanBtn setTitle:context forState:(UIControlStateNormal)];
    [btn setTitle:context forState:(UIControlStateNormal)];
    self.dropDownTitle = context;
    NSLog(@"分类的table");
    [self.shaixuanBtn setImage:[UIImage imageNamed:@"下拉三角"] forState:(UIControlStateNormal)];
    CGFloat imageWidth = self.shaixuanBtn.imageView.bounds.size.width;
    CGFloat labelWidth = self.shaixuanBtn.titleLabel.bounds.size.width;
    self.shaixuanBtn.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + 14, 0, -labelWidth);
    self.shaixuanBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
    [backView removeFromSuperview];
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
    [BackBtn setImage:[UIImage imageNamed:@"返回系统"] forState:(UIControlStateNormal)];
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
    searchBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    searchBtn.hidden = YES;
    [searchBtn addTarget:self action:@selector(searchBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [navView addSubview:searchBtn];
    
    //搜索icon
    UIImageView *searchIcon = [[UIImageView alloc] init];
    searchIcon.image = [UIImage imageNamed:@"首页搜索icon"];
    searchIcon.frame = CGRectMake(12, 8, 16, 15.5);
    [backSearchView addSubview:searchIcon];
    
    //搜索框   WIDTH - (CGRectGetMaxX(BackBtn.frame) + 12) - 14 - (CGRectGetMaxX(searchIcon.frame) + 8)
    self.searchField = [[UITextField alloc] init];
    self.searchField.frame = CGRectMake(CGRectGetMaxX(searchIcon.frame) + 8, 6,backSearchView.frame.size.width - 36 - 12, 21);
    self.searchField.clearButtonMode = UITextFieldViewModeAlways;
    self.searchField.delegate = self;
    self.searchField.placeholder = @"输入您要的商品名称";
    [self.searchField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    self.searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.searchField setValue:TCUIColorFromRGB(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    [self.searchField setValue:[UIFont fontWithName:@"PingFangSC-Regular" size:15] forKeyPath:@"_placeholderLabel.font"];
    self.searchField.textColor = TCUIColorFromRGB(0x333333);
    self.searchField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [backSearchView addSubview:self.searchField];
    
    //一条细线
    UIView *lineNavcView = [[UIView alloc] init];
    lineNavcView.frame = CGRectMake(0, StatusBarAndNavigationBarHeight - 1, WIDTH, 1);
    lineNavcView.backgroundColor = TCBgColor;
    [navView addSubview:lineNavcView];
    
    //按钮
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, self.view.qh_width, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    headerView.hidden = YES;
    
    NSArray *titleArray = @[@"综合排序",@"销量最高",@"距离最近"];
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(WIDTH / titleArray.count * i, 0, WIDTH / titleArray.count, 40);
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:TCUIColorFromRGB(0x666666) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        [btn setTitleColor:TCUIColorFromRGB(0xF99E20) forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(typeSelect:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1000 + i;
        [headerView addSubview:btn];
        if (i == 0) {
            self.shaixuanBtn = btn;
            [btn setImage:[UIImage imageNamed:@"下拉三角"] forState:(UIControlStateNormal)];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            /******* 以下方法是让图片靠右，文字靠左 *******/
            CGFloat imageWidth = btn.imageView.bounds.size.width;
            CGFloat labelWidth = btn.titleLabel.bounds.size.width;
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + 14, 0, -labelWidth);
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
        }
        
        //添加细线
        if (i < 2){
            self.lineView = [[UIView alloc] init];
            self.lineView.frame = CGRectMake(WIDTH/3 * i + WIDTH/3,12, 1, 16);
            self.lineView.backgroundColor = TCUIColorFromRGB(0xEDEDED);
            [headerView addSubview:self.lineView];
        }
        UIView *bottom_Line = [[UIView alloc] init];
        bottom_Line.frame = CGRectMake(0, 39, WIDTH, 0.5);
        bottom_Line.backgroundColor = TCUIColorFromRGB(0xEDEDED);
        [headerView addSubview:bottom_Line];
        
        
        if (i == 0) {
            btn.selected = YES;
            self.lastButton = btn;
        }
    }
    //创建tableView
    self.shopGoodTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40 + StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - 40 - StatusBarAndNavigationBarHeight) style:UITableViewStylePlain];
    self.shopGoodTabelView.delegate = self;
    self.shopGoodTabelView.dataSource = self;
    self.shopGoodTabelView.hidden = YES;
    self.shopGoodTabelView.backgroundColor = TCBgColor;
    self.shopGoodTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    AdjustsScrollViewInsetNever (self,self.shopGoodTabelView);
    [self.view addSubview: self.shopGoodTabelView];
}

//收起button的方法
- (void)closeCurrViewOnIndex:(NSInteger)index isCloseShowView:(BOOL)isshow
{
    UIButton* btn = (UIButton*)[self.view viewWithTag:1000+index];
    [self removeTListViewWithSelectItemView:btn];
}

- (void)removeTListViewWithSelectItemView:(UIButton*)sender{
    self.isShow = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.departSelectView.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);
        //            self.departSelectView.dataArr = (NSMutableArray *)self.cateArr;
        self.departSelectView.selectTitle = self.dropDownTitle;
        [sender setImage:[UIImage imageNamed:@"下拉三角"] forState:(UIControlStateNormal)];
        //            [self.departSelectView.tableView reloadData];
    } completion:^(BOOL finished) {
        [self.departSelectView removeFromSuperview];
    }];
    [backView removeFromSuperview];
}

- (void)showTListViewWIthSelectItemView:(UIButton*)sender{
    
    [self backView];
    [self.shaixuanBtn setImage:[UIImage imageNamed:@"上拉三角"] forState:(UIControlStateNormal)];
    [UIView animateWithDuration:0.2 animations:^{
        [[UIApplication sharedApplication].keyWindow addSubview:self.departSelectView];
        if (self.departSelectView.dataArr.count == 0) {
            for (NSDictionary *dic in self.cateArr) {
                NSString *nameStr = dic[@"name"];
                [self.departSelectView.dataArr addObject:nameStr];
            }
        }
        
        //            self.departSelectView.dataArr = (NSMutableArray *)self.cateArr;
        self.departSelectView.selectTitle = self.dropDownTitle;
        
        self.departSelectView.tableView.frame = CGRectMake(0,0, self.view.frame.size.width, self.cateArr.count*48);
        
      //
          [self.departSelectView.tableView reloadData];
    } completion:^(BOOL finished) {
    }];
    selectIndex = sender.tag-1000;
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
    
    [self.dataArr removeAllObjects];
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSDictionary *dic = @{@"page":@"1",@"timestamp":timeStr,@"longtitude":self.longStr,@"latitude":self.latStr,@"keyword":self.searchField.text,@"sortKey":searchType};
        NSString *signStr = [TCServerSecret signStr:dic];
        NSDictionary *paramters = @{@"page":@"1",@"timestamp":timeStr,@"longtitude":self.longStr,@"latitude":self.latStr,@"keyword":self.searchField.text,@"sign":signStr,@"sortKey":searchType};
        
        [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102026"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
            NSLog(@"%@,%@",jsonDic,jsonStr);
            NSArray *arr = jsonDic[@"data"];
            
            if (arr.count == 0){
                //占位图
                placeholderImage.hidden = NO;
                placeholderLabel_one.hidden = NO;
                placeholderLabel_two.hidden = NO;
            } else {
                //占位图
                placeholderImage.hidden = YES;
                placeholderLabel_one.hidden = YES;
                placeholderLabel_two.hidden = YES;
                
                //获取数据
                for (NSDictionary *dic in arr) {
                    TCSearchGoodsModel *goodModel = [TCSearchGoodsModel searchInfoWithDictionary:dic];
                    [self.dataArr addObject:goodModel];
                }
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
    
    NSDictionary *dic = @{@"page":pageStr,@"timestamp":timeStr,@"longtitude":self.longStr,@"latitude":self.latStr,@"keyword":self.searchField.text,@"sortKey":searchType};
    NSString *signStr = [TCServerSecret signStr:dic];
    NSDictionary *paramters = @{@"page":pageStr,@"timestamp":timeStr,@"longtitude":self.longStr,@"latitude":self.latStr,@"keyword":self.searchField.text,@"sign":signStr,@"sortKey":searchType};
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102026"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        
        NSArray *arr = jsonDic[@"data"];

        //获取数据
        for (NSDictionary *dic in arr) {
            TCSearchGoodsModel *goodModel = [TCSearchGoodsModel searchInfoWithDictionary:dic];
            [self.dataArr addObject:goodModel];
        }
        
        [self.shopGoodTabelView.mj_footer endRefreshing];
        [self.shopGoodTabelView reloadData];
    } failure:^(NSError *error) {
        nil;
    }];
    [self.shopGoodTabelView.mj_footer resetNoMoreData];
}


//占位图
- (void)createNoGoods
{
    //没有搜索商品的图
    placeholderImage = [[UIImageView alloc] init];
    placeholderImage.image = [UIImage imageNamed:@"无搜索结果插图"];
    placeholderImage.frame = CGRectMake((WIDTH - 160)/2, (HEIGHT - StatusBarAndNavigationBarHeight - 153)/2, 160, 153);
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArr.count;
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
        return 12;
    } else {
        return 4;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TCSearchGoodTableViewCell *cell = [[TCSearchGoodTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    if (self.dataArr.count == 0){
        NSLog(@"无");
    } else {
        TCSearchGoodsModel *goodModel = self.dataArr[indexPath.section];
        cell.goodModel = goodModel;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 160;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TCShopMessageViewController *shopMessVC = [[TCShopMessageViewController alloc] init];
    TCSearchGoodsModel *model = self.dataArr[indexPath.section];
    shopMessVC.shopID = model.shopid;
    shopMessVC.goodsID = model.goodsid;
    shopMessVC.goodCateID = model.goodscateid;
    [self.navigationController pushViewController:shopMessVC animated:YES];
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
    headerView.hidden = NO;
    
    //刷新请求接口
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
    [NSKeyedArchiver archiveRootObject:_historyArray toFile:KHistorySearchPath];
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
        self.searchField.frame = CGRectMake(36, 6,backSearchView.frame.size.width - 36 - 12, 21);
        searchBtn.hidden = NO;
        
    } else {
        backSearchView.frame = CGRectMake(CGRectGetMaxX(BackBtn.frame) + 12, StatusBarHeight + 6, WIDTH - (CGRectGetMaxX(BackBtn.frame) + 12) - 14, 32);
        searchBtn.hidden = YES;
        self.shopGoodTabelView.hidden = YES;
        headerView.hidden = YES;
        _searchView.hidden = NO;
        
        [self.view addSubview:self.searchView];
        [self.view bringSubviewToFront:_searchView];

        placeholderImage.hidden = YES;
        placeholderLabel_two.hidden = YES;
        placeholderLabel_one.hidden = YES;
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
        headerView.hidden = NO;
        
        [self setupRefresh:self.searchField.text];
    } else {
        [TCProgressHUD showMessage:@"输入您要的商品名称"];
    }
}

//点击搜索键盘的事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //发送请求
    if (self.searchField.text.length != 0){
        [self.searchField resignFirstResponder];
        [self setHistoryArrWithStr:self.searchField.text];
        
        _searchView.hidden = YES;
        self.shopGoodTabelView.hidden = NO;
        headerView.hidden = NO;
        
        [self setupRefresh:self.searchField.text];
    } else {
        [TCProgressHUD showMessage:@"输入您要的商品名称"];
    }
    return YES;
}

#pragma mark -- 返回按钮
- (void)backBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)typeSelect:(UIButton *)button {
    self.lastButton.selected = NO;
    button.selected = YES;
    self.lastButton = button;
    
    switch (button.tag) {
        case 1000: {
            if (self.isShow == NO) {
                [self showTListViewWIthSelectItemView:button];
                //[self setupRefresh:@"1"];
                [self.shaixuanBtn setImage:[UIImage imageNamed:@"上拉三角"] forState:(UIControlStateNormal)];
            }else{
                
               // [self setupRefresh:@"1"];
                
                    [self closeCurrViewOnIndex:selectIndex isCloseShowView:YES];
                   // [backView removeFromSuperview];
                
            }
        }
            break;
        case 1001: {
            [self setupRefresh:@"6"];
        }
            break;
        case 1002: {
            [self setupRefresh:@"5"];
        }
            break;
        default:
            break;
    }
    
    // [listTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.delegate = self;
}

#pragma mark - UINavigationControllerDelegate
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
