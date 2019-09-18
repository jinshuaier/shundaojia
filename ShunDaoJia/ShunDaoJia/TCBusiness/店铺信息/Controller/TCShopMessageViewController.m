//
//  TCShopMessageViewController.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/5.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCShopMessageViewController.h"
#import "TCGoodsSearchViewController.h"
#import "LSXPopMenu.h" //popView
#import "TCShareView.h" //分享的View
#import "TCShopCarView.h"
#import "TCShopDetailsViewController.h" //店铺详情
#import "TCShopActiveView.h" //点击活动
#import "TCShopInfoViewController.h" //店铺信息
#import "TCReportBussViewController.h" //举报商家
#import "TCSubmitViewController.h" //提交订单
#import "TCLeftTableViewCell.h"
#import "TCRightTableViewCell.h"
#import "TCCategoryModel.h"
#import "TCTableViewHeaderView.h"
#import "NSObject+Property.h"
#import "TCSqliteModelTool.h"
#import "TCSpecifView.h"
#import "TCShopCategoryModel.h"
#import "TCShopModel.h"
#import "TCShopDataBase.h"
#import "SDAutoLayout.h"
#import "TCLoginViewController.h"

static float kLeftTableViewWidth = 96;
@interface TCShopMessageViewController ()<UIScrollViewDelegate,LSXPopMenuDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UINavigationControllerDelegate>
{
    UIImageView *backdImage; //商家头像
    UIView *grayView;
    NSInteger _selectIndex;
    NSInteger  _goodsCount; //储存的中间的数量

    BOOL _isScrollDown;
}
@property (nonatomic, strong) UIScrollView *Mainscroll;

@property (nonatomic, assign) BOOL isSelect; //收藏

@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;

@property (nonatomic, strong) NSMutableArray *sortMuArr;//记录分类
@property (nonatomic, strong) NSMutableArray *shopMuArr;//记录商品
@property (nonatomic, strong) NSMutableArray *sqlMuArr;//数据库中商品数

@property (nonatomic, strong) NSMutableArray *leftGoodsArr; //左边分类
@property (nonatomic, strong) NSMutableArray *rightGoodsArr; //右边

@property (nonatomic, strong) NSString *sortID;//记录分类id

@property (nonatomic, strong) UIView *bottomView; //底层的view

@property (nonatomic, strong) UIImageView *shopCarIm; //购物车图片
@property (nonatomic, strong) UILabel *numlb;
@property (nonatomic, strong) UIButton *jisuan;
@property (nonatomic, strong) UILabel *allPrice;
@property (nonatomic, assign) NSInteger select; //出现的条

@property (nonatomic, strong) NSUserDefaults *userdefaults;
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIButton *cutButton;
@property (nonatomic, strong) UILabel *countsLabel;

@property (nonatomic, strong) UIView *navcView; //虚假的

@property (nonatomic, strong) NSMutableArray *categoryData;
@property (nonatomic, strong) UIButton *offshelfBtn;
@property (nonatomic, strong) UIButton *deleBtn;
@property (nonatomic, strong) UIButton *scanBtn;
@property (nonatomic, strong) UIButton *manuBtn;
@property (nonatomic, strong) UILabel *checkallLab;
@property (nonatomic, strong) UIButton *checkBt;
@property (nonatomic , strong)NSArray *dbArray;
@property (nonatomic, strong) FMDatabase *dataBase; //数据库
@property (nonatomic, strong) TCSpecifView *specView; //规格框
@property (nonatomic, strong) TCLeftTableViewCell *selectCell;

// 暂无商品的图
@property (nonatomic, strong) UIImageView *noGoodsImage; //无商品的图片
@property (nonatomic, strong) UILabel *noGoodsLabel; //无商品的label
@property (nonatomic, strong) NSDictionary *shopDetailsDic; //店铺详情的字典

@end

@implementation TCShopMessageViewController

//隐藏导航栏
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.delegate = self;
    //遍历数据库
    [self bianliSQL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.categoryData = [NSMutableArray array];
    
    //初始化数组
    _sortMuArr = [[NSMutableArray alloc] init];
    _shopMuArr = [[NSMutableArray alloc] init];
    _sqlMuArr = [[NSMutableArray alloc] init];

    _userdefaults = [NSUserDefaults standardUserDefaults];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commitOrder) name:@"shopcarpush" object:nil];
    
//    if (self.isShouCang == YES) {
//        self.navigationController.delegate = self;
//    }
    
    self.view.backgroundColor = TCBgColor;
    
    _selectIndex = 0;
    _isScrollDown = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;

    //请求店铺商家详情接口
    [self createShopQuest];
    
    //创建视图
    [self createDB];
}

#pragma mark -- 创建视图
- (void)createDB
{
    //创建数据库
    self.dataBase = [FMDatabase databaseWithPath:SqlPath];
    NSLog(@"SqlPath = %@",SqlPath);
    
    //判断数据库是否打开
    if (![self.dataBase open]) {
        NSLog(@"数据库打开失败");
    }
    else
    {
        //建表 这里是数据库语句 这里是你需要的语句
        BOOL isSuccess = [self.dataBase executeUpdate:@"create table if not exists newShopCar (storeid text, shopid text, shopprice text, shopcount text, shopname text, shopPic text, stockcount text, goodscateid text)"];
        
        if (isSuccess) {
            NSLog(@"成功创表");
        } else {
            NSLog(@"创表失败");
        }
    }
    //请求接口
    [self createQuest];
}


//添加刷新
- (void)setupRefresh:(NSString *)shopID andGoodscateid:(NSString *)goodscateid{
    //下拉
    __block int  page = 1;
    
    //防止循环引用
    __weak typeof(self)weakSelf = self;
    self.view.userInteractionEnabled = NO;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        page = 1;
        //刷新
        [weakSelf requestRight:shopID andGoodscateid:goodscateid];
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
    
    _rightTableView.mj_header = header;
    [header beginRefreshing];
    
    //上拉
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weakSelf requestRight:page andShopStr:shopID andGoodscateid:goodscateid];
    }];
    //设置上拉标题
    [footer setTitle:@"上拉加载更多顺道嘉商品" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载更多顺道嘉商品..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"无更多顺道嘉商品!" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    _rightTableView.mj_footer = footer;
}

//下拉请求
- (void)requestRight:(NSString *)shopID andGoodscateid:(NSString *)goodscateid{
    [self.shopMuArr removeAllObjects];
    
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSDictionary *dic = @{@"page":@"1",@"timestamp":timeStr,@"shopid":shopID,@"goodscateid":goodscateid,@"goodsid":self.goodsID};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"page":@"1",@"timestamp":timeStr,@"shopid":shopID,@"goodscateid":goodscateid,@"sign":signStr,@"goodsid":self.goodsID};
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"101022"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        if (jsonDic[@"data"]) {
            [self.shopMuArr addObjectsFromArray: jsonDic[@"data"][@"goods"]];
        } else {
            [TCProgressHUD showMessage:jsonDic[@"msg"]];
        }
        [_rightTableView reloadData];
        [_rightTableView.mj_header endRefreshing];
        self.view.userInteractionEnabled = YES;
    } failure:^(NSError *error) {
        nil;
    }];
    [_rightTableView.mj_footer resetNoMoreData];
}

//上拉加载
- (void)requestRight:(int)page andShopStr:(NSString *)shopID andGoodscateid:(NSString *)cateid{
    
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *pageStr = [NSString stringWithFormat:@"%d",page];
    NSDictionary *dic = @{@"page":pageStr,@"timestamp":timeStr,@"shopid":shopID,@"goodscateid":cateid,@"goodsid":self.goodsID};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"page":pageStr,@"timestamp":timeStr,@"shopid":shopID,@"goodscateid":cateid,@"sign":signStr,@"goodsid":self.goodsID};
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"101022"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
//        NSLog(@"%@,%@",jsonDic,jsonStr);
        [self.shopMuArr addObjectsFromArray: jsonDic[@"data"][@"goods"]];

        [_rightTableView reloadData];
        [_rightTableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        nil;
        [_rightTableView.mj_footer endRefreshingWithNoMoreData];
    }];
}

// 请求商家详情接口
- (void)createShopQuest
{
    [ProgressHUD showHUDToView:self.view];
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr;
    NSString *tokenStr;
    
    //判断登录与否
    if ([self.userdefaults valueForKey:@"userID"] == nil) {
        midStr = @"0";
        tokenStr = @"0";
    } else {
        midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
        tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    }
    NSDictionary *dic = @{@"timestamp":timeStr,@"shopid":_shopID,@"mid":midStr,@"token":tokenStr};
    NSString *signStr = [TCServerSecret signStr:dic];
    NSDictionary *paramters = @{@"timestamp":timeStr,@"shopid":_shopID,@"mid":midStr,@"token":tokenStr,@"sign":signStr};
    NSLog(@" %@--",paramters);
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"101005"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        self.shopDetailsDic = jsonDic[@"data"][@"data"];
        //添加表头
        [self createHeaderView];
      } failure:^(NSError *error) {
        nil;
    }];
}

//请求接口
- (void)createQuest
{
    [ProgressHUD showHUDToView:self.view];
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSDictionary *dic1 = @{@"timestamp":timeStr,@"shopid":self.shopID,@"goodscateid":self.goodCateID};
    NSString *signStr1 = [TCServerSecret signStr:dic1];
    NSDictionary *paramters = @{@"timestamp":timeStr,@"shopid":self.shopID,@"sign":signStr1,@"goodscateid":self.goodCateID};
    
    NSLog(@" %@--",paramters);
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"101022"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        
        if (jsonDic){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                NSMutableArray *foodsort = jsonDic[@"data"][@"cateinfo"];
                [_sortMuArr addObjectsFromArray: jsonDic[@"data"][@"cateinfo"]];
                for (NSDictionary *dict in foodsort)
                {
                    TCShopCategoryModel *model = [TCShopCategoryModel shopCateInfogoryWithDictionary:dict];
                    [self.categoryData addObject:model];
                }
                [self.leftTableView reloadData];
                
                //没有商品的时候显示占位图
                [self NeedResetNoView];
                
                //这里是网络请求结束，创建视图
                [self createViews];
                
                //添加刷新 默认第一个啊
                NSString *goodsIDstr = [NSString stringWithFormat:@"%@",foodsort[0][@"goodscateid"]];
                //传入shopID 和 分类的ID
                [self setupRefresh:self.shopID andGoodscateid:goodsIDstr];
                
                [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                                animated:YES
                                          scrollPosition:UITableViewScrollPositionNone];
            });
        }
    } failure:^(NSError *error) {
        nil;
    }];
}

#pragma mark -- 没有商品的时候的占位图
- (void)NeedResetNoView
{
    if (self.categoryData.count >0) {
        
    }else{
        self.noGoodsImage = [[UIImageView alloc] init];
        self.noGoodsImage.image = [UIImage imageNamed:@"暂无商品插图"];
        self.noGoodsImage.frame = CGRectMake((WIDTH - 120)/2, (HEIGHT - 120)/2, 120, 120);
        [self.view addSubview:self.noGoodsImage];
        
        self.noGoodsLabel = [UILabel publicLab:@"店铺暂无商品~" textColor:TCUIColorFromRGB(0x999999) textAlignment:NSTextAlignmentCenter fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
        self.noGoodsLabel.frame = CGRectMake(0, CGRectGetMaxY(self.noGoodsImage.frame) + 12, WIDTH, 22);
        [self.view addSubview:self.noGoodsLabel];
    }
}

//创建表头
- (void)createHeaderView
{
    //后面的背景 （没有头像数据）
    backdImage = [[UIImageView alloc]init];
    backdImage.frame = CGRectMake(0, 0, WIDTH, StatusBarAndNavigationBarHeight + 156);
    backdImage.userInteractionEnabled = YES;
    //（有头像数据）
    [backdImage sd_setImageWithURL:[NSURL URLWithString:self.shopDetailsDic[@"headPic"]] placeholderImage:[UIImage imageNamed:@"占位图（方形）"]];
    [self.view addSubview: backdImage];
    //模糊
    UIVisualEffectView *ruVisualEffectView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    ruVisualEffectView.frame = backdImage.bounds;
    ruVisualEffectView.alpha = 1;
    [backdImage addSubview:ruVisualEffectView];
    
    //铺一个图层
    grayView = [[UIView alloc]init];
    grayView.frame = CGRectMake(0, 0, WIDTH, StatusBarAndNavigationBarHeight + 156);
    grayView.backgroundColor = [TCUIColorFromRGB(0x000000) colorWithAlphaComponent:0.4];
    [backdImage addSubview:grayView];
    
    //默认的头像
    UIImageView *defaultImage = [[UIImageView alloc]init];
    defaultImage.frame = CGRectMake(12, StatusBarAndNavigationBarHeight, 72, 72);
    //(有数据)
    [defaultImage sd_setImageWithURL:[NSURL URLWithString:self.shopDetailsDic[@"headPic"]] placeholderImage:[UIImage imageNamed:@"占位图（方形）"]];
    defaultImage.layer.cornerRadius = 4;
    defaultImage.clipsToBounds = YES;
    [grayView addSubview:defaultImage];
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮店铺"] forState:(UIControlStateNormal)];
    [backBtn addTarget:self action:@selector(backbtn) forControlEvents:(UIControlEventTouchUpInside)];
    backBtn.frame = CGRectMake(0, 14.2 + StatusBarHeight, 30, 20);
    [grayView addSubview:backBtn];
    //三个点
    UIButton *dotBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [dotBtn setImage:[UIImage imageNamed:@"三个点"] forState:(UIControlStateNormal)];
    [dotBtn addTarget:self action:@selector(dotBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    dotBtn.frame = CGRectMake(WIDTH - 16 - 24, 12 + StatusBarHeight, 32, 32);
    [grayView addSubview:dotBtn];
    
    //商店
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(CGRectGetMaxX(defaultImage.frame) + 11, StatusBarAndNavigationBarHeight, WIDTH -(CGRectGetMaxX(defaultImage.frame) + 11 + 12) , 22);
    [button setImage:[UIImage imageNamed:@"三角（店铺名称）"] forState:(UIControlStateNormal)];
    [button setTitle:self.shopDetailsDic[@"name"] forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
    button.tag = 10000;
    [button setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, - button.imageView.size.width , 0, button.imageView.size.width)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, button.titleLabel.bounds.size.width + 12, 0, -button.titleLabel.bounds.size.width)];
    //文字局左
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button addTarget:self action:@selector(shopBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [grayView addSubview:button];
    
    //起送价和配送价
    UILabel *sendLabel = [UILabel publicLab:[NSString stringWithFormat:@"起送 ¥%@",self.shopDetailsDic[@"startPrice"]] textColor:TCUIColorFromRGB(0xFFFFFF) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    
    sendLabel.frame = CGRectMake(CGRectGetMaxX(defaultImage.frame) + 12, CGRectGetMaxY(button.frame) + 10, 50, 14);
    CGSize size = [sendLabel sizeThatFits:CGSizeMake(WIDTH/2, 16)];
    sendLabel.frame = CGRectMake(CGRectGetMaxX(defaultImage.frame) + 12, CGRectGetMaxY(button.frame) + 10, size.width, 14);
    [grayView addSubview:sendLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(CGRectGetMaxX(sendLabel.frame) + 8,CGRectGetMaxY(button.frame) + 12, 1, 10);
    lineView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [grayView addSubview:lineView];
    
    UILabel *deliveryLabel = [UILabel publicLab:[NSString stringWithFormat:@"配送 ¥%@",self.shopDetailsDic[@"distributionPrice"]] textColor:TCUIColorFromRGB(0xFFFFFF) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    deliveryLabel.frame = CGRectMake(CGRectGetMaxX(lineView.frame) + 8, CGRectGetMaxY(button.frame) + 10, 100, 14);
    [grayView addSubview:deliveryLabel];
    
    //满减
    UILabel *signDeLabel = [UILabel publicLab:@"减" textColor:TCUIColorFromRGB(0xFFFFFF) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:10 numberOfLines:0];
    signDeLabel.frame = CGRectMake(14, CGRectGetMaxY(defaultImage.frame) + 12, 16, 16);
    if (self.activeArr.count == 0){
        signDeLabel.hidden = YES;
    } else {
        signDeLabel.hidden = NO;
    }
    signDeLabel.layer.cornerRadius = 4;
    signDeLabel.layer.masksToBounds = YES;
    signDeLabel.textAlignment = NSTextAlignmentCenter;
    signDeLabel.backgroundColor = TCUIColorFromRGB(0xF99E20);
    [grayView addSubview:signDeLabel];
    
    UILabel *discountsLabel = [UILabel publicLab:nil textColor:TCUIColorFromRGB(0xFFFFFF) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    
    discountsLabel.frame = CGRectMake(CGRectGetMaxX(signDeLabel.frame) + 6, CGRectGetMaxY(defaultImage.frame) + 12, WIDTH - 70 - (CGRectGetMaxX(signDeLabel.frame) + 6), 16);
    if (self.activeArr.count == 0){
        discountsLabel.hidden = YES;
        discountsLabel.frame = CGRectMake(CGRectGetMaxX(signDeLabel.frame) + 6, CGRectGetMaxY(defaultImage.frame) + 12, WIDTH - 70 - (CGRectGetMaxX(signDeLabel.frame) + 6), 0);
    } else {
        discountsLabel.hidden = NO;
        discountsLabel.text = self.activeArr[0][@"content"];
        discountsLabel.frame = CGRectMake(CGRectGetMaxX(signDeLabel.frame) + 6, CGRectGetMaxY(defaultImage.frame) + 12, WIDTH - 70 - (CGRectGetMaxX(signDeLabel.frame) + 6), 16);
    }
    [grayView addSubview:discountsLabel];
    
    //活动的点击事件
    UIButton *activeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    activeButton.frame = CGRectMake(WIDTH - 70, CGRectGetMaxY(defaultImage.frame) + 12, 70 , 14);
    [activeButton setImage:[UIImage imageNamed:@"三角（店铺名称）"] forState:(UIControlStateNormal)];
    if (self.activeArr.count == 0){
        activeButton.hidden = YES;
    } else {
        activeButton.hidden = NO;
    }
    [activeButton setTitle:[NSString stringWithFormat:@"%lu个活动",(unsigned long)self.activeArr.count] forState:(UIControlStateNormal)];
    activeButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
    [activeButton setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    [activeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, - activeButton.imageView.size.width , 0, activeButton.imageView.size.width)];
    [activeButton setImageEdgeInsets:UIEdgeInsetsMake(0, activeButton.titleLabel.bounds.size.width + 8, 0, -activeButton.titleLabel.bounds.size.width)];
    //文字局左
    activeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [activeButton addTarget:self action:@selector(activeButton) forControlEvents:(UIControlEventTouchUpInside)];
    [grayView addSubview:activeButton];
    
    //变化多变的搜索框(点击)
    UIView *searchView = [[UIView alloc] init];
    searchView.frame = CGRectMake(12, CGRectGetMaxY(discountsLabel.frame) + 12, WIDTH - 24, 32);
    searchView.userInteractionEnabled = YES;
    searchView.layer.cornerRadius = 4;
    searchView.layer.masksToBounds = YES;
    searchView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [grayView addSubview:searchView];
    
    UIImageView *searchIcon = [[UIImageView alloc] init];
    searchIcon.image = [UIImage imageNamed:@"搜索icon（店内）"];
    searchIcon.frame = CGRectMake(76, (32 - 12)/2, 12, 12);
    [searchView addSubview:searchIcon];
    
    UILabel *searchLabel = [UILabel publicLab:[NSString stringWithFormat:@"搜索店内商品，共%@种商品",self.shopDetailsDic[@"goodsnum"]] textColor:TCUIColorFromRGB(0x999999) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    searchLabel.frame = CGRectMake(CGRectGetMaxX(searchIcon.frame) + 8, 0, 159, 32);
    [searchView addSubview:searchLabel];
    
    //加手势
    UITapGestureRecognizer *tapSearch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSearch)];
    [searchView addGestureRecognizer:tapSearch];
}
#pragma mark -- 创建视图
- (void)createViews
{
    //底层的view
    self.bottomView = [[UIView alloc] init];
    self.bottomView.frame = CGRectMake(0,HEIGHT - 50, WIDTH, 50);
    self.bottomView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    
    [self.view addSubview:self.bottomView];
    
//    下划线
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, _bottomView.frame.origin.y - 0.5, WIDTH, 0.5)];
    line1.backgroundColor = TCLineColor;
    [self.view addSubview: line1];

    //图片
    UIImageView *im1 = [[UIImageView alloc]initWithFrame:CGRectMake(12, _bottomView.frame.origin.y + _bottomView.frame.size.height - 6.5  - 56, 56 , 56)];
    im1.image = [UIImage imageNamed:@"购物车（无商品）"];
    im1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taps)];
    [im1 addGestureRecognizer: tap];
    _shopCarIm = im1;
    [self.view addSubview: im1];

    _numlb = [[UILabel alloc]initWithFrame:CGRectMake(im1.frame.size.width + im1.frame.origin.x - 19 , im1.frame.origin.y + 5, 20 , 16 )];
    _numlb.layer.cornerRadius = 8 ;
    _numlb.layer.masksToBounds = YES;
    _numlb.backgroundColor = TCUIColorFromRGB(0xFF3355);
    _numlb.text = @"";
    _numlb.hidden = YES;
    _numlb.textAlignment = NSTextAlignmentCenter;
    _numlb.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    _numlb.textColor = [UIColor whiteColor];
    [self.view addSubview: _numlb];

    //结算按钮
    _jisuan = [UIButton buttonWithType:UIButtonTypeCustom];
    _jisuan.frame = CGRectMake(WIDTH - 120 , 0, 120 , _bottomView.frame.size.height);
    _jisuan.backgroundColor = TCUIColorFromRGB(0xCCCCCC);
    [_jisuan setTitle:[NSString stringWithFormat:@"去结算"] forState:UIControlStateNormal];
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
    lb2.text = [NSString stringWithFormat:@"配送费 ¥%@",self.shopDetailsDic[@"distributionPrice"]];
    lb2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    lb2.textColor = TCUIColorFromRGB(0x999999);
    CGSize size1 = [lb2 sizeThatFits:CGSizeMake(WIDTH - 120 - CGRectGetMaxX(lb.frame) - 8, 15 )];
    lb2.frame = CGRectMake(lb.frame.origin.x, lb.frame.origin.y + lb.frame.size.height + 4 , size1.width, 15 );
    [_bottomView addSubview: lb2];
    
    //遍历数据库
    [self bianliSQL];
    
    //创建左侧的tableView
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight + 156, kLeftTableViewWidth, HEIGHT - 50 - StatusBarAndNavigationBarHeight - 156 - 6.5 - 4)];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.rowHeight = 58;
    _leftTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _leftTableView.tableFooterView = [UIView new];
    _leftTableView.showsVerticalScrollIndicator = NO;
    _leftTableView.separatorColor = TCBgColor;
    _leftTableView.backgroundColor = TCBgColor;
    [_leftTableView registerClass:[TCLeftTableViewCell class] forCellReuseIdentifier:kCellIdentifier_Left];
    AdjustsScrollViewInsetNever(self,_leftTableView);
    //ios11解决点击刷新跳转的问题
    _leftTableView.estimatedRowHeight = 0;
    _leftTableView.estimatedSectionHeaderHeight = 0;
    _leftTableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview: _leftTableView];

    //创建右边的tableView
    _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(kLeftTableViewWidth, StatusBarAndNavigationBarHeight + 156 , WIDTH - kLeftTableViewWidth, HEIGHT - 50 - StatusBarAndNavigationBarHeight - 156 - 1)];
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    _rightTableView.rowHeight = 124;
    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _rightTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _rightTableView.showsVerticalScrollIndicator = NO;
    [_rightTableView registerClass:[TCRightTableViewCell class] forCellReuseIdentifier:kCellIdentifier_Right];
    AdjustsScrollViewInsetNever(self,_rightTableView);
    [self.view addSubview: self.rightTableView];
    
    _rightTableView.estimatedRowHeight = 0;
    _rightTableView.estimatedSectionHeaderHeight = 0;
    _rightTableView.estimatedSectionFooterHeight = 0;
}

#pragma mark -- 购物车点击事件
- (void)taps{
    NSLog(@"购物车点击事件");
    //先遍历
    [self bianliSQL];
    if (_sqlMuArr.count != 0) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _backView.backgroundColor = [[UIColor darkGrayColor]colorWithAlphaComponent:0.3];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hahha)];
        tap.delegate = self;//这句不要漏掉
        [_backView addGestureRecognizer:tap];
        [[UIApplication sharedApplication].keyWindow addSubview: _backView];
        
        TCShopCarView *shop = [[TCShopCarView alloc] initWithFrame:CGRectMake(0, HEIGHT - 372, WIDTH, 372) andData:_sqlMuArr andqisong:self.shopDetailsDic[@"startPrice"] andPeisong:self.shopDetailsDic[@"distributionPrice"] andShop:self.shopID];
        [_backView addSubview: shop];
        
        //到达0
        [shop disBackView:^{
            [self bianliSQL];
            [_rightTableView reloadData];
            [_backView removeFromSuperview];
        }];
        
        //刷新遍历数据库 这个block每个都能顾及到（仿美团）
        [shop shuaxin:^{
            [self bianliSQL];
            [_rightTableView reloadData];
        }];
        
    }else{
        [TCProgressHUD showMessage:@"您还没有选择商品！"];
    }
}
- (void)hahha{
    [self bianliSQL];
    [_rightTableView reloadData];
    [_backView removeFromSuperview];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (![touch.view isKindOfClass: [TCShopCarView class]]) {
        return NO;
    }
    return YES;
}

//购物车红去结算
- (void)commitOrder{
    [_rightTableView reloadData];
    [_backView removeFromSuperview];
    [self bianliSQL];
    //把数据库里的东西添加到数组里
    NSMutableArray *ar = [NSMutableArray array];
    [ar addObjectsFromArray: _sqlMuArr];
    if ([_userdefaults valueForKey:@"userID"]) {
        TCSubmitViewController *submitVC = [[TCSubmitViewController alloc]init];
        submitVC.typeStr = @"0";
        submitVC.shopMuArr = ar;
        submitVC.shopIDStr = self.shopID;
        submitVC.messDic = self.shopDetailsDic;
        [self.navigationController pushViewController: submitVC animated:YES];
    }else{
        TCLoginViewController *loginVC = [[TCLoginViewController alloc]init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

#pragma mark -- 提交订单的点击事件
- (void)qujiesuan
{
    if (_sqlMuArr.count != 0) {
        if ([_userdefaults valueForKey:@"userID"]) {
            TCSubmitViewController *submitVC = [[TCSubmitViewController alloc]init];
            submitVC.shopMuArr = _sqlMuArr;
            submitVC.typeStr = @"0";
            submitVC.shopIDStr = self.shopID;
            submitVC.messDic = self.shopDetailsDic;
            [self.navigationController pushViewController:submitVC animated:YES];
        }else{
            TCLoginViewController *loginVC = [[TCLoginViewController alloc]init];
            [self presentViewController:loginVC animated:YES completion:nil];
        }
    }
}
#pragma mark -- 返回按钮
- (void)backbtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 三个点
- (void)dotBtn:(UIButton *)sender
{
    if (_isSelect == YES){
        [LSXPopMenu showRelyOnView:sender titles:@[@"联系商家",@"投诉商家"]  icons:@[@"联系商家图标",@"举报商家图标"] menuWidth:118 isShowTriangle:YES delegate:self];
    } else {
        [LSXPopMenu showRelyOnView:sender titles:@[@"联系商家",@"投诉商家"]  icons:@[@"联系商家图标",@"举报商家图标"] menuWidth:118 isShowTriangle:YES delegate:self];
    }
}
-(void)LSXPopupMenuDidSelectedAtIndex:(NSInteger)index LSXPopupMenu:(LSXPopMenu *)LSXPopupMenu{
    
    NSLog(@"------点击---%ld",(long)index);
    if (index == 0){
        if ([self.shopDetailsDic[@"tel"] isEqualToString:@""]){
            [TCProgressHUD showMessage:@"暂无联系方式"];
        } else {
            //拨打电话
            NSString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.shopDetailsDic[@"tel"]];
            // NSLog(@"str======%@",str);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    } else if (index == 1){
        //拨打电话
        NSString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"400-011-1228"];
        // NSLog(@"str======%@",str);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

#pragma mark -- 店铺进入
- (void)shopBtn
{
    UIButton *Btn = (UIButton *)[self.view viewWithTag:10000];
    TCShopInfoViewController *shopInfoVC = [[TCShopInfoViewController alloc] init];
    shopInfoVC.shopImage = backdImage.image;
    NSString *buttonTitle = Btn.titleLabel.text;
    shopInfoVC.shopTitle = buttonTitle;
    shopInfoVC.mesDic = self.shopDetailsDic;
    shopInfoVC.shopID = self.shopID;
    [self.navigationController pushViewController:shopInfoVC animated:YES];
}

#pragma mark -- 活动的点击事件
- (void)activeButton
{
    NSLog(@"5个活动");
    TCShopActiveView *shopActiveView = [[TCShopActiveView alloc] initWithFrame:self.view.bounds andImage:self.shopDetailsDic[@"headPic"] andSend:self.shopDetailsDic[@"startPrice"] andpeisong:self.shopDetailsDic[@"distributionPrice"] andTime:self.shopDetailsDic[@"deliverTime"] andBuss:self.shopDetailsDic[@"shopTime"] andActive:self.activeArr andStar:self.shopDetailsDic[@"rank"] andNameShop:self.shopDetailsDic[@"name"]];
    
    [self.view addSubview:shopActiveView];
}

#pragma mark -- 手势的点击事件
- (void)tapSearch
{
    NSLog(@"进去搜索页面");
    TCGoodsSearchViewController *seacrchVC = [[TCGoodsSearchViewController alloc] init];
    seacrchVC.enStr = @"0";
    seacrchVC.shopID = self.shopID;
    seacrchVC.shopMesDic = self.shopDetailsDic;
    seacrchVC.isHinddenAddBtn = _isHinddenAddBtn;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:seacrchVC animated:YES];
}

#pragma mark - TableView DataSource Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_leftTableView == tableView)
    {
        return 1;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_leftTableView == tableView)
    {
        return self.categoryData.count;
    }
    else
    {
        return _shopMuArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_leftTableView == tableView)
    {
        _selectIndex = indexPath.row;
    
        TCLeftTableViewCell *cell = [[TCLeftTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.tag = indexPath.row + 100;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        TCShopCategoryModel *model = self.categoryData[indexPath.row];
        cell.name.text = model.shopCategoryName;
        cell.numLabel.text = [NSString stringWithFormat:@"(%@)",model.shopCategoryNum];
        if (indexPath.row == 0) {
            self.selectCell = cell;
            self.selectCell.name.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
            self.selectCell.numLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        }
        return cell;
    }
    else
    {
        TCRightTableViewCell *cell_right = [[TCRightTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_right"];
        cell_right.selectionStyle = UITableViewCellSelectionStyleNone;
       
        if (_shopMuArr.count == 0){
            NSLog(@"没有数据");
        } else {
            //赋值时，连带数据库数据也
            [cell_right create:_shopMuArr[indexPath.row] andSQLData:_sqlMuArr];
            //点击加号按钮
            [cell_right getShopMes:^(NSString *goodID, NSString *shopName, NSString *shopPrice, NSString *shopCount, NSString *spec, NSString *headPic, NSString *stock, NSString *goodscateid) {
                
                //添加数据库
                [self joinData:goodID andname:shopName andprice:shopPrice andcount:shopCount andSpec:spec andpic:headPic andstock:stock andgoodscateid:goodscateid];
                NSLog(@"添加按钮");
                
                //添加动画添加到购物车
                UIImageView *im = [[UIImageView alloc] init];
                NSInteger i = indexPath.row;
                
                 im = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH * 0.28 + 10, i * 124 + 20  -  _rightTableView.contentOffset.y + StatusBarAndNavigationBarHeight + 156 , 40, 40)];
                
                im.layer.cornerRadius = 20;
                im.clipsToBounds = YES;
                im.image = cell_right.imageV.image;
                [self.view addSubview: im];
                //设置旋转
                CABasicAnimation* rotationAnimation;
                rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
                rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
                rotationAnimation.duration = 0.4f;
                rotationAnimation.cumulative = YES;
                rotationAnimation.repeatCount = 99999;
                //添加商品到购物车动画
                [UIView animateWithDuration:0.3 animations:^{
                    im.frame = CGRectMake(im.frame.origin.x - 10, im.frame.origin.y - 10, 40 , 40 );
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.7 animations:^{
                        [im.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
                        im.center = _shopCarIm.center;
                        im.transform = CGAffineTransformMakeScale(0.1, 0.1);
                    }completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.2 animations:^{
                            im.alpha = 0;
                        }completion:^(BOOL finished) {
                            [im removeFromSuperview];
                        }];
                    }];
                }];
            }];
        }
        //减号
        [cell_right cutBtn:^(NSString *goodID, NSString *shopCount) {
            NSLog(@"减号");
            
            //从数据库减少
            [self joinData:goodID andcount:shopCount];
        }];
        return cell_right;
    }
    return nil;
}

#pragma  mark -- 点击+号 添加商品到数据库
- (void)joinData:(NSString *)goodID andname:(NSString *)shopName andprice:(NSString *)shopPrice andcount:(NSString *)shopCount andSpec:(NSString *)spec andpic:(NSString *)headPic andstock:(NSString *)stockcount andgoodscateid:(NSString *)goodscateid
{
    //数字改变的动态效果
    [UIView animateWithDuration:0.3 animations:^{
        _numlb.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        _numlb.transform = CGAffineTransformIdentity;
    }];
    
    NSLog(@"-- --- %@",shopCount);
    //添加商品信息到数据库
    if ([_dataBase open])
    {
        //查看数据库，该店铺是否存在有该商品 //查询语句
        FMResultSet *result = [_dataBase executeQuery:@"select *from newShopCar where storeid = ? and shopid = ?", self.shopID, goodID];
        if ([result next])
        {
            //如果有，更新数据
            BOOL isSuccess = [_dataBase executeUpdate:@"update newShopCar set shopcount = ? where shopid = ? and storeid = ?", shopCount, goodID, self.shopID];
            if (isSuccess)
            {
                NSLog(@"更新数据成功");
            }
        }
        else //如果没有就创建该商品信息
        {
            NSString *shopname = @"";
            if ([spec isEqualToString:@""])
            {
                shopname = shopName;
            }else{
                shopname = [shopName stringByAppendingString: [NSString stringWithFormat:@"(%@)", spec]];
            }
            BOOL isSuccess = [_dataBase executeUpdate:@"insert into newShopCar (storeid, shopid, shopprice, shopname, shopcount, shopPic, stockcount,goodscateid) values (?, ?, ?, ?, ?, ?, ?, ?)", self.shopID, goodID, shopPrice, shopName, shopCount, headPic, stockcount,goodscateid];
            if (isSuccess) {
                NSLog(@"创建成功");
            }
        }
    }
    
    //遍历数据库
    [self bianliSQL];
}

#pragma  mark -- 点击减号事件
- (void)joinData:(NSString *)goodID andcount:(NSString *)shopCount
{
    NSLog(@"-- %@",shopCount);
    //添加商品到数据库
    if ([_dataBase open])
    {
        //查找数据库 是否有商品
        FMResultSet *re = [_dataBase executeQuery:@"select *from newShopCar where storeid = ? and shopid = ?", self.shopID, goodID];
        
        if ([re next]){
            //如果有，更新
            BOOL isSuccess = [_dataBase executeUpdate:@"update newShopCar set shopcount = ? where shopid = ? and storeid = ?", shopCount, goodID, self.shopID];
            if (isSuccess) {
                NSLog(@"更新数据成功");
            }
        }else{
            //如果没有  创建该记录
            BOOL isSuccess = [_dataBase executeUpdate:@"insert into newShopCar (storeid, shopid, shopcount) values (?, ?, ?)", self.shopID, goodID, shopCount];
            if (isSuccess) {
                NSLog(@"记录创建成功");
            }
        }
    }
    [self bianliSQL];
    
    if ([shopCount intValue] == 0) {
        [_rightTableView reloadData];
    }
}
#pragma mark -- 遍历数据库
- (void)bianliSQL
{
    //把之前的数据清空
    [_sqlMuArr removeAllObjects];
    //遍历数据库，更改底层购物车的数据
    if ([_dataBase open]) {
        //通过ID找到
        FMResultSet *res = [_dataBase executeQuery:@"select *from newShopCar where storeid = ?", self.shopID];
        NSLog(@" --- %@",self.shopID);
        while ([res next]) {
            //把数据拿出来
            NSDictionary *dic = @{@"id":[res stringForColumn:@"shopid"], @"price":[res stringForColumn:@"shopprice"], @"amount":[res stringForColumn:@"shopcount"], @"name":[res stringForColumn:@"shopname"], @"pic":[res stringForColumn:@"shopPic"], @"stockcount":[res stringForColumn:@"stockcount"],@"goodscateid":[res stringForColumn:@"goodscateid"]};
            [_sqlMuArr addObject:dic];
            NSLog(@"数据库 ---%@",dic);
        }
    }
    
    //更新总价格 与 角标
    float x = 0;
    int y = 0;
    _numlb.hidden = NO;
    for (int i = 0; i < _sqlMuArr.count ; i++) {
        x += [_sqlMuArr[i][@"amount"] floatValue] * [_sqlMuArr[i][@"price"] floatValue];
        y += [_sqlMuArr[i][@"amount"] intValue];
    }
    
    if (y > 0){
        _shopCarIm.image = [UIImage imageNamed:@"购物车（有商品的）"];
    } else {
        _shopCarIm.image = [UIImage imageNamed:@"购物车（无商品）"];
    }
    
    NSLog(@" %d",y);
    _allPrice.text = [NSString stringWithFormat:@"¥%.2f", x];
    _numlb.text = [NSString stringWithFormat:@"%d", y];
    
    NSLog(@"-- %@",_numlb.text);
    //去除数组中数量为0的元素
    NSMutableArray *muarr = [NSMutableArray array];
    for (int i = 0; i < _sqlMuArr.count; i++) {
        if ([_sqlMuArr[i][@"amount"] intValue] != 0) {
            //如果不等于0  取出
            [muarr addObject:_sqlMuArr[i]];
        }
    }
    [_sqlMuArr removeAllObjects];
    //重新赋值
    _sqlMuArr = muarr;
    
    //判断是否达到起送价格
    float cha = [_shopDetailsDic[@"startPrice"] floatValue] - x;
    
     if (y > 0){
         if (cha > 0) {
             if (x == 0) {
                 [_jisuan setTitle:[NSString stringWithFormat:@"¥%.2f起送", [_shopDetailsDic[@"startPrice"] floatValue]] forState:UIControlStateNormal];
             }else{
                 [_jisuan setTitle:[NSString stringWithFormat:@"还差¥%.2f起送", cha] forState:UIControlStateNormal];
             }
             _jisuan.userInteractionEnabled = NO;
             _jisuan.backgroundColor = TCUIColorFromRGB(0xCCCCCC);
         } else {
             [_jisuan setTitle:[NSString stringWithFormat:@"去结算"] forState:UIControlStateNormal];
             _jisuan.userInteractionEnabled = YES;
             _jisuan.backgroundColor = TCUIColorFromRGB(0xF99E20);
         }
     } else {
          [_jisuan setTitle:[NSString stringWithFormat:@"¥%.2f起送", [_shopDetailsDic[@"startPrice"] floatValue]] forState:UIControlStateNormal];
         _jisuan.userInteractionEnabled = NO;
         _jisuan.backgroundColor = TCUIColorFromRGB(0xCCCCCC);
     }
    [_rightTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView)
    {
        //刷新
        TCShopCategoryModel *model = self.categoryData[indexPath.row];
        [self setupRefresh:_shopID andGoodscateid:model.shopCategoryID];
        
    } else if (_rightTableView == tableView) {
        
        if (_shopMuArr.count != 0){
            TCShopDetailsViewController *shopDetailVC = [[TCShopDetailsViewController alloc]init];
            shopDetailVC.shopMesDic = self.shopDetailsDic;
            shopDetailVC.shopID = self.shopID;
            shopDetailVC.idStr = _shopMuArr[indexPath.row][@"goodsid"];
            shopDetailVC.messDisArr = self.categoryData;
            shopDetailVC.shopDetailDic = _shopMuArr[indexPath.row];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:shopDetailVC animated:YES];
        }
    }
}

- (void)dealloc
{
    NSLog(@"走这个方法没有循环引用");
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.delegate = self;
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
