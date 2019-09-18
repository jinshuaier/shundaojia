//
//  TCCommoditydetailsController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/11.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCCommodityController.h"
#import "TCShopCarViewController.h"
#import "TCShareView.h"
#import "TCChooseDiscountController.h"
#import "TCShierViewController.h"
#import "TCGroupSpecView.h"
#import "TCGroupInfoModel.h" //商品的整体的Model
#import "TCGroupDataBase.h" //进来遍历数据库
#import "TCSubmitViewController.h"
#import "UIImage+ImgSize.h"
#import "TCLoginViewController.h"

static NSInteger buynum;
#define BaseWindow    ([UIApplication sharedApplication].keyWindow)
@interface TCCommodityController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,tapPayDelegete,UITableViewDelegate,UITableViewDataSource>
{
    UILabel *numLabel;
    CGRect cell_onehight;
    CGRect cell_twohight;
}

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bgckView;
@property (nonatomic, strong) NSMutableArray *specArr;
@property (nonatomic, strong) UIButton *selectBtn;//记录按钮
@property (nonatomic, strong) UIButton *lastBtn;//记录按钮
@property (nonatomic, assign) CGFloat scrollHeight;//规格视图的高度
@property (nonatomic, strong) UIRefreshControl *refresh;
@property (nonatomic, strong) NSMutableArray *guigeArr;
@property (nonatomic, strong) UILabel *specPrice;
@property (nonatomic, strong) NSString *goodsName; //商品名称
@property (nonatomic, strong) NSString *stockStr; //库存
@property (nonatomic, strong) NSString *goodsImage; //商品图片
@property (nonatomic, strong) NSMutableArray *sqlMuArr; //团购装的数组
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *midStr; //保留的用户ID
@property (nonatomic, strong) TCGroupInfoModel *groupModel;
@property (nonatomic, strong) TCGroupDataBase *groupDataBase;
@property (nonatomic, strong) UILabel *hotRedLabel; //购物车的小红点图标
@property (nonatomic, strong) NSDictionary *messDic;
@property (nonatomic, strong) NSDictionary *destionDic; //图片的详情
@property (nonatomic, strong) UIImageView *shopCarImage; //购物车
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation TCCommodityController

- (void)viewWillAppear:(BOOL)animated
{
   self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;

    //每次进来遍历啊
    [self bianliFMDB];
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TCBgColor;
    self.title = @"商品详情";
    self.guigeArr = [NSMutableArray array];
    self.specArr = [NSMutableArray array];
    self.sqlMuArr = [NSMutableArray array];
    self.dataArr = [NSMutableArray array];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    
    //导航栏右边添加按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 19 * WIDHTSCALE, 19 * HEIGHTSCALE);
    [rightButton setImage:[UIImage imageNamed:@"团购分享图标"] forState:(UIControlStateNormal)];
    [rightButton addTarget:self action:@selector(rightButton:) forControlEvents:UIControlEventTouchUpInside];
    //添加到导航条
    UIBarButtonItem *rightBarButtomItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtomItem;
    
    //每次进来都遍历一下数据库吧
    self.groupDataBase = [[TCGroupDataBase alloc] initTCDataBase];
    
    //创建底部View
    [self createBottomView];
    //请求数据
    [self request];
    
    // Do any additional setup after loading the view.
}

//创建底部的view
- (void)createBottomView
{
    //底下的view
    UIView *bomView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - 50, WIDTH, 50 )];
    bomView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:bomView];
    //可点击的购物车图标
    UIView *shopCarView = [[UIView alloc] init];
    shopCarView.frame = CGRectMake(0, 0, 68, 50);
    shopCarView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    shopCarView.userInteractionEnabled = YES;
    [bomView addSubview:shopCarView];
    //加手势
    UITapGestureRecognizer *shopCarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shopCarTap)];
    [shopCarView addGestureRecognizer:shopCarTap];
    //购物车的图片
    self.shopCarImage = [[UIImageView alloc] init];
    self.shopCarImage.image = [UIImage imageNamed:@"团购详情购物车（灰）"];
    self.shopCarImage.frame = CGRectMake(20, 11, 27, 28);
    [shopCarView addSubview:self.shopCarImage];
    
    //购物车的名字
    UILabel *shopCarLabel = [UILabel publicLab:@"购物车" textColor:TCUIColorFromRGB(0x808080) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:10 * HEIGHTSCALE numberOfLines:0];
    shopCarLabel.frame = CGRectMake(27 * WIDHTSCALE, CGRectGetMaxY(self.shopCarImage .frame) + 4 * HEIGHTSCALE, 30 * WIDHTSCALE, 10 * HEIGHTSCALE);
//    [shopCarView addSubview:shopCarLabel];
    
    //购物车的数量
    self.hotRedLabel = [UILabel publicLab:nil textColor:TCUIColorFromRGB(0xFFFFFF) textAlignment:NSTextAlignmentCenter fontWithName:@"PingFangSC-Medium" size:10 * HEIGHTSCALE numberOfLines:0];
    self.hotRedLabel.backgroundColor = TCUIColorFromRGB(0xFF3355);
    self.hotRedLabel.frame = CGRectMake(CGRectGetMaxX(shopCarLabel.frame) - 16 * WIDHTSCALE, 5 * HEIGHTSCALE, 16 * WIDHTSCALE, 16 * HEIGHTSCALE);
    self.hotRedLabel.layer.cornerRadius = 8;
    self.hotRedLabel.layer.masksToBounds = YES;
    self.hotRedLabel.layer.shadowRadius = 1;
    self.hotRedLabel.layer.shadowColor = TCUIColorFromRGB(0xFFFFFF).CGColor;
    self.hotRedLabel.hidden = YES;
    [shopCarView addSubview:self.hotRedLabel];
    
    //加入购物车的按钮
    UIButton *addShopCarBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    addShopCarBtn.frame = CGRectMake(CGRectGetMaxX(shopCarView.frame), 0, 135* WIDHTSCALE, 50 * HEIGHTSCALE);
    [addShopCarBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    addShopCarBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16 * HEIGHTSCALE];
    [addShopCarBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    addShopCarBtn.backgroundColor = TCUIColorFromRGB(0xF99E20);
    [addShopCarBtn addTarget:self action:@selector(addShopCarAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [bomView addSubview:addShopCarBtn];
    //立刻购买的按钮
    UIButton *payShopCarBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    payShopCarBtn.frame = CGRectMake(CGRectGetMaxX(addShopCarBtn.frame), 0,WIDTH - (CGRectGetMaxX(addShopCarBtn.frame)), 50 * HEIGHTSCALE);
    [payShopCarBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    payShopCarBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16 * HEIGHTSCALE];
    [payShopCarBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    payShopCarBtn.backgroundColor = TCUIColorFromRGB(0xFF884C);
    [payShopCarBtn addTarget:self action:@selector(payShopCarAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [bomView addSubview:payShopCarBtn];
}

-(void)request{
    //指示器
    [ProgressHUD showHUDToView:self.view];
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *goodsid = self.strid;
    NSDictionary *dic = @{@"goodsid":goodsid,@"timestamp":timeStr};
    NSString *signStr = [TCServerSecret signStr:dic];
    NSDictionary *paramters = @{@"goodsid":goodsid,@"timestamp":timeStr,@"sign":signStr};
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"104004"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"Dic = %@,Str = %@",jsonDic,jsonStr);
        
        NSMutableArray *modelArr = [NSMutableArray array];
        //商品的团购的model
        self.groupModel = [TCGroupInfoModel groupInfoWithDictionary:jsonDic[@"data"]];
        [modelArr addObject:self.groupModel];
        
        //分享的字典
        self.shareDic = jsonDic[@"data"][@"share"];
        
        //下方详情的字典
        self.destionDic = jsonDic[@"data"];
    
        //商品名字
        self.goodsName = jsonDic[@"data"][@"name"];
        self.goodsImage = jsonDic[@"data"][@"images"];
        self.stockStr = jsonDic[@"data"][@"stockTotal"];
        
        self.dataArr = jsonDic[@"data"][@"gaoDescription"];
        
        //字典传值用于提交订单
        self.messDic = jsonDic;
        
        self.dictionary = [[NSDictionary alloc]initWithDictionary:jsonDic];
        _Model = [TCGroupDetialModel detailInfoWithDictionary:jsonDic[@"data"]];
        NSLog(@"库存：%@",_Model.stockTotal);
        [ProgressHUD hiddenHUD:self.view];

        //创建tableView
        [self createTableView];
        [self.mainTableView reloadData];
        
        NSString *str = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if ([str isEqualToString:@"1"]){
            NSLog(@"获取数据成功");
        }
//        [TCProgressHUD showMessage:jsonDic[@"msg"]];
    } failure:^(NSError *error) {
        nil;
    }];
}

//每次进来遍历数据库哈
- (void)bianliFMDB
{
    NSMutableArray *groupArr = [self.groupDataBase bianliFMDB:self.shopID];
    NSLog(@"--%@",groupArr);
    if (groupArr.count == 0){
        self.hotRedLabel.hidden = YES;
        self.shopCarImage.image = [UIImage imageNamed:@"团购详情购物车（灰）"];
    } else {
        NSInteger count = 0;
        for (int i = 0; i < groupArr.count; i++) {
            count += [groupArr[i][@"shopCount"] integerValue];
        }
        if (count > 0) {
            self.hotRedLabel.text = [NSString stringWithFormat:@"%ld", (long)count];
            self.hotRedLabel.hidden = NO;
        } else {
            self.hotRedLabel.hidden = YES;
        }
        self.shopCarImage.image = [UIImage imageNamed:@"团购详情购物车（色）"];
    }
}

//创建tableView
- (void)createTableView
{
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - TabbarSafeBottomMargin - StatusBarAndNavigationBarHeight - 50) style:UITableViewStyleGrouped];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.backgroundColor = TCBgColor;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.mainTableView];
    //解决ios11的导航栏布局的问
    AdjustsScrollViewInsetNever (self,self.mainTableView);
    
    //添加headView
    UIView *headView = [[UIView alloc] init];
    headView.frame = CGRectMake(0, 0, WIDTH, WIDTH/2);
    headView.backgroundColor = TCBgColor;
    self.mainTableView.tableHeaderView = headView;
    //添加图片
    UIImageView *commImage = [[UIImageView alloc] init];
    commImage.frame = CGRectMake(0, 0, WIDTH, WIDTH/2);
    NSString *imageStr = _Model.images;
    [commImage sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"商品详情页占位"]];
    [headView addSubview:commImage];
    
}

#pragma mark -- datasouce
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1){
        return self.dataArr.count;
    }
    return 1;
}
//预防ios11错误
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *sectionHeadView = [[UIView alloc] init];
    sectionHeadView.frame = CGRectMake(0, 0, WIDTH, 53 * HEIGHTSCALE);
    sectionHeadView.backgroundColor = TCBgColor;
    
    if (section == 1){
        //商品介绍
        UILabel *introduce = [[UILabel alloc]initWithFrame:CGRectMake((WIDTH - 56 * WIDHTSCALE)/2, 0, 56 * WIDHTSCALE, 53 * HEIGHTSCALE)];
        introduce.textColor = TCUIColorFromRGB(0x666666);
        introduce.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14 * HEIGHTSCALE];
        introduce.textAlignment = NSTextAlignmentCenter;
        introduce.text = @"商品介绍";
        [sectionHeadView addSubview:introduce];
        
        //两条线
        UIView *one_intrView = [[UIView alloc] init];
        one_intrView.frame = CGRectMake(introduce.frame.origin.x - 20 * WIDHTSCALE - 100 * WIDHTSCALE, (53 * HEIGHTSCALE - 1 * HEIGHTSCALE)/2, 100 * WIDHTSCALE, 1 * HEIGHTSCALE);
        one_intrView.backgroundColor = TCUIColorFromRGB(0xCCCCCC);
        [sectionHeadView addSubview:one_intrView];
        //第二条
        UIView *two_intrView = [[UIView alloc] init];
        two_intrView.frame = CGRectMake(CGRectGetMaxX(introduce.frame) + 20 * WIDHTSCALE, (53 * HEIGHTSCALE - 1 * HEIGHTSCALE)/2, 100 * WIDHTSCALE, 1 * HEIGHTSCALE);
        two_intrView.backgroundColor = TCUIColorFromRGB(0xCCCCCC);
        [sectionHeadView addSubview:two_intrView];
        
        return sectionHeadView;
    }
    return [[UIView alloc] init];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        return cell_onehight.size.height;
    }
    return cell_twohight.size.height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 20 * HEIGHTSCALE;
    }
    return 53 * HEIGHTSCALE;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    // 通过indexPath创建cell实例 每一个cell都是单独的
    UITableViewCell *cellgoods = [tableView cellForRowAtIndexPath:indexPath];
    if (!cellgoods) {
        cellgoods=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section == 0){
        cellgoods.backgroundColor = TCBgColor;
        UIView *bgView1 = [[UIView alloc]initWithFrame:CGRectMake(8, 0, WIDTH - 16 * WIDHTSCALE, 206 * HEIGHTSCALE)];
        bgView1.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
        
        UILabel *recommendLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 82 * WIDHTSCALE, 20 * HEIGHTSCALE)];
        recommendLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12 * HEIGHTSCALE];
        recommendLabel.textColor = TCUIColorFromRGB(0xFFFFFF);
        recommendLabel.text = self.destionDic[@"remark"];
        
        CGSize size = [recommendLabel sizeThatFits:CGSizeMake(MAXFLOAT, 20 * HEIGHTSCALE)];
        recommendLabel.frame = CGRectMake(12 * WIDHTSCALE, 12 * HEIGHTSCALE, size.width + 8 * WIDHTSCALE, 20 * HEIGHTSCALE);
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.frame = CGRectMake(0,0,size.width + 8 * WIDHTSCALE,20 * HEIGHTSCALE);
        recommendLabel.textAlignment = NSTextAlignmentCenter;
        [recommendLabel.layer addSublayer:layer];
        
        layer.colors = [NSArray arrayWithObjects:(id)TCUIColorFromRGB(0xFF884c).CGColor,(id)TCUIColorFromRGB(0xFF4C79).CGColor,nil];
        layer.locations = @[@(0.0f), @(1.0f)];
        layer.cornerRadius = 2;
        layer.masksToBounds = YES;
        [recommendLabel.layer insertSublayer:layer atIndex:0];
        [bgView1 addSubview: recommendLabel];
        
        UILabel *commodityLabel = [[UILabel alloc]initWithFrame:CGRectMake(12 * WIDHTSCALE, CGRectGetMaxY(recommendLabel.frame) + 10 * HEIGHTSCALE, WIDTH - 24 * WIDHTSCALE, 20 * HEIGHTSCALE)];
        commodityLabel.textAlignment = NSTextAlignmentLeft;
        commodityLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16 * HEIGHTSCALE];
        commodityLabel.textColor = TCUIColorFromRGB(0x333333);
        commodityLabel.text = _Model.name;
        CGSize size_comm = [commodityLabel sizeThatFits:CGSizeMake(WIDTH - 24 * WIDHTSCALE, MAXFLOAT)];
        commodityLabel.frame = CGRectMake(12 * WIDHTSCALE, CGRectGetMaxY(recommendLabel.frame) + 10 * HEIGHTSCALE, WIDTH - 24 * WIDHTSCALE, size_comm.height);
        [bgView1 addSubview:commodityLabel];
        
        UILabel *GrouppurLabel = [[UILabel alloc]initWithFrame:CGRectMake(12 * WIDHTSCALE, CGRectGetMaxY(commodityLabel.frame) + 20 * HEIGHTSCALE, 40 * WIDHTSCALE, 12 * HEIGHTSCALE)];
        GrouppurLabel.text = @"团购价:";
        GrouppurLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12 * HEIGHTSCALE];
        GrouppurLabel.textColor = TCUIColorFromRGB(0x333333);
        GrouppurLabel.textAlignment = NSTextAlignmentLeft;
        [bgView1 addSubview:GrouppurLabel];
        
        UILabel*presentPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(GrouppurLabel.frame), CGRectGetMaxY(commodityLabel.frame) + 10 * HEIGHTSCALE, 49 * WIDHTSCALE, 22 * HEIGHTSCALE)];
        presentPriceLabel.textColor = TCUIColorFromRGB(0xFF2F51);
        presentPriceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:22 * HEIGHTSCALE];
        presentPriceLabel.text = [NSString stringWithFormat:@"￥%@",_Model.price];
        presentPriceLabel.textAlignment = NSTextAlignmentLeft;
        presentPriceLabel.numberOfLines = 0;
        presentPriceLabel.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize size2 = [presentPriceLabel sizeThatFits:CGSizeMake(MAXFLOAT, 20 * HEIGHTSCALE)];
        presentPriceLabel.frame = CGRectMake(CGRectGetMaxX(GrouppurLabel.frame), CGRectGetMaxY(commodityLabel.frame) + 10 * HEIGHTSCALE, size2.width, 22 * HEIGHTSCALE);
        [bgView1 addSubview:presentPriceLabel];
        
        UILabel *oriPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(presentPriceLabel.frame) + 2 * WIDHTSCALE, CGRectGetMaxY(commodityLabel.frame) + 19 * HEIGHTSCALE, 27 * WIDHTSCALE, 12 * HEIGHTSCALE)];
        oriPriceLabel.textColor = TCUIColorFromRGB(0x999999);
        oriPriceLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12 * HEIGHTSCALE];
        oriPriceLabel.textAlignment = NSTextAlignmentLeft;
        oriPriceLabel.text = [NSString stringWithFormat:@"￥%@",_Model.marketPrice];
        presentPriceLabel.numberOfLines = 0;
        presentPriceLabel.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize size3 = [oriPriceLabel sizeThatFits:CGSizeMake(MAXFLOAT, 12 * HEIGHTSCALE)];
        oriPriceLabel.frame = CGRectMake(CGRectGetMaxX(presentPriceLabel.frame) + 2 * WIDHTSCALE, CGRectGetMaxY(commodityLabel.frame)  + 19 * HEIGHTSCALE, size3.width, 12 * HEIGHTSCALE);
        [bgView1 addSubview:oriPriceLabel];
        
        //线
        UIView *line = [[UIView alloc]init];
        line.frame = CGRectMake(0,(12 * HEIGHTSCALE - 1 * HEIGHTSCALE)/2, size3.width, 1 * HEIGHTSCALE);
        line.backgroundColor = TCUIColorFromRGB(0x999999);
        [oriPriceLabel addSubview:line];
        
        UILabel *salesvoLabel = [[UILabel alloc]initWithFrame:CGRectMake(12 * WIDHTSCALE, CGRectGetMaxY(oriPriceLabel.frame) + 24 * HEIGHTSCALE, WIDTH/3, 12 * HEIGHTSCALE)];
        salesvoLabel.textAlignment = NSTextAlignmentLeft;
        salesvoLabel.textColor = TCUIColorFromRGB(0x666666);
        salesvoLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12 * HEIGHTSCALE];
        salesvoLabel.text = [NSString stringWithFormat:@"月销售%@单",_Model.saleCount];
        [bgView1 addSubview:salesvoLabel];
        
        UILabel *stockLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH - 12 * WIDHTSCALE - 16 * WIDHTSCALE - WIDTH/3, CGRectGetMaxY(oriPriceLabel.frame) + 24 * HEIGHTSCALE, WIDTH/3, 12 * HEIGHTSCALE)];
        stockLabel.textAlignment = NSTextAlignmentRight;
        stockLabel.font  = [UIFont fontWithName:@"PingFangSC-Regular" size:12 * HEIGHTSCALE];
        stockLabel.textColor = TCUIColorFromRGB(0x666666);
        stockLabel.text = [NSString stringWithFormat:@"库存：%@",_Model.stockTotal];
        [bgView1 addSubview:stockLabel];
        
        //下划线
        UIView *line_three = [[UIView alloc] init];
        line_three.frame = CGRectMake(12 * WIDHTSCALE, CGRectGetMaxY(salesvoLabel.frame) + 12 * HEIGHTSCALE, WIDTH - 16 * WIDHTSCALE - 24 * WIDHTSCALE, 0.5 * HEIGHTSCALE);
        line_three.backgroundColor = TCUIColorFromRGB(0xEEEEEE);
        [bgView1 addSubview:line_three];
        
        UIView *bgview2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line_three.frame), WIDTH - 16 * WIDHTSCALE, 45 * HEIGHTSCALE)];
        bgview2.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
        
        UITapGestureRecognizer* tapspeci = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseSpeci:)];
        [bgview2 addGestureRecognizer:tapspeci];
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(13 * WIDHTSCALE, 0, 78 * WIDHTSCALE, 45 * HEIGHTSCALE)];
        textLabel.tag = 512;
        textLabel.text = @"选择商品规格";
        textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        textLabel.textColor = TCUIColorFromRGB(0x333333);
        [bgview2 addSubview:textLabel];
        
        UIImageView *sanimage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 13 * WIDHTSCALE - 16 * WIDHTSCALE - 5 * WIDHTSCALE, (45 * HEIGHTSCALE - 8 * HEIGHTSCALE)/2, 5 * WIDHTSCALE, 8 * HEIGHTSCALE)];
        sanimage.image = [UIImage imageNamed:@"团购进入小箭头"];
        [bgview2 addSubview:sanimage];
        [bgView1 addSubview:bgview2];
        
        bgView1.frame = CGRectMake(8, 0, WIDTH - 16 * WIDHTSCALE, CGRectGetMaxY(bgview2.frame));
        cell_onehight.size.height = bgView1.frame.size.height;
        
        //加个图层 设置阴影
        CALayer *layersss = [[CALayer alloc] init];
        layersss.frame = CGRectMake(8 * WIDHTSCALE, 0, WIDTH - 16 * WIDHTSCALE, CGRectGetMaxY(bgview2.frame));
        layersss.shadowOffset = CGSizeMake(0, 0);
        layersss.backgroundColor = TCUIColorFromRGB(0xDADADA).CGColor;
        layersss.shadowColor = TCUIColorFromRGB(0xDADADA).CGColor;
        layersss.shadowOpacity = 0.5;
        layersss.cornerRadius = 4;
//        [cellgoods.layer addSublayer:layersss];
        bgView1.layer.masksToBounds = YES;
        bgView1.layer.cornerRadius = 4;
        
        [cellgoods.contentView addSubview:bgView1];

    } else {
        //商品介绍的图片
        UIImageView *introduceImage = [[UIImageView alloc]init];
        [introduceImage sd_setImageWithURL:[NSURL URLWithString:self.dataArr[indexPath.row][@"src"]] placeholderImage:[UIImage imageNamed:@"商品详情页占位"]];
        //手动计算cell
        CGFloat imgHeight = introduceImage.image.size.height * [UIScreen mainScreen].bounds.size.width / introduceImage.image.size.width;
        introduceImage.frame = CGRectMake(0, 0, WIDTH, imgHeight);
        
        cell_twohight.size.height = imgHeight;
        [cellgoods.contentView addSubview:introduceImage];
    }
    cellgoods.selectionStyle=UITableViewCellSelectionStyleNone;
    return cellgoods;
}

-(void)chooseSpeci:(UIGestureRecognizer *)sender{
    //选择规格的弹窗
    TCGroupSpecView *specView = [[TCGroupSpecView alloc] initWithFrame:self.view.frame andtype:@"2" andModel:self.groupModel];
    specView.delegate = self;
    specView.spceViewType = @"2";
    [self.view addSubview:specView];
}

#pragma mark -- 搜索记录的点击事件
-(void)recordBtn:(UIButton *)sender
{
    _selectBtn.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    _selectBtn.layer.borderColor = TCUIColorFromRGB(0xDEDEDE).CGColor;
    [_selectBtn setTitleColor:TCUIColorFromRGB(0x666666) forState:(UIControlStateNormal)];
    sender.backgroundColor = [TCUIColorFromRGB(0xF99E20) colorWithAlphaComponent:0.2];
    [sender setTitleColor:TCUIColorFromRGB(0xF99E20) forState:(UIControlStateNormal)];
    sender.layer.borderColor = TCUIColorFromRGB(0xF99E20).CGColor;
    _selectBtn = sender;
    NSInteger tag = sender.tag;
    NSDictionary *dic = self.specArr[tag];
    NSLog(@"价格:%@",dic[@"price"]);
    self.specPrice.text = [NSString stringWithFormat:@"￥%@",dic[@"price"]];
}

-(void)clickSure:(UIButton *)sender{
    NSLog(@"点击了确定");
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightButton:(UIButton *)sender{
    TCShareView *shareView = [[TCShareView alloc]init];
    [TCShareView ShowTheViewOfShareAndShowMes:self.shareDic andShareSuccess:^{
        [TCProgressHUD showMessage:@"分享成功"];
    } andShareFailure:^{
//        [TCProgressHUD showMessage:@"分享失败"];
    } andShareCancel:^{
        
    }];
    [self.view addSubview:shareView];
}

#pragma mark -- 购物车的手势
-(void)shopCarTap{
    NSLog(@"进入购物车");
    NSMutableArray *groupArr = [self.groupDataBase bianliFMDB:self.shopID];
    if (groupArr.count == 0){
        [TCProgressHUD showMessage:@"您还没有选择商品"];
    } else {
        TCShopCarViewController *shopCarVC = [[TCShopCarViewController alloc]init];
        shopCarVC.shopID = self.shopID;
        shopCarVC.dicGroup = self.messDic;
        [self.navigationController pushViewController:shopCarVC animated:YES];
    }
}

#pragma mark -- 加入购物车的按钮的点击事件
- (void)addShopCarAction:(UIButton *)sender
{
    NSLog(@"加入购物车");
//    TCShierViewController *shierVC = [[TCShierViewController alloc]init];
//    [self.navigationController pushViewController:shierVC animated:YES];
    TCGroupSpecView *specView = [[TCGroupSpecView alloc] initWithFrame:self.view.frame andtype:@"1" andModel:self.groupModel];
    specView.spceViewType = @"1";
    specView.delegate = self;
    [self.view addSubview:specView];
}

#pragma mark -- 立即购买的按钮的点击事件
- (void)payShopCarAction:(UIButton *)sender
{
    NSLog(@"立即购买");
//    TCChooseDiscountController *chooseVC = [[TCChooseDiscountController alloc]init];
//    [self.navigationController pushViewController:chooseVC animated:YES];
    //选择规格的弹窗
    TCGroupSpecView *specView = [[TCGroupSpecView alloc] initWithFrame:self.view.frame andtype:@"1" andModel:self.groupModel];
    specView.spceViewType = @"1";
    specView.fromType = @"1";
    specView.delegate = self;
    [self.view addSubview:specView];
}

#pragma mark -- 立即购买
- (void)submitCommitValue
{
    if ([self.userDefaults valueForKey:@"userID"] == nil){
        TCLoginViewController *loginVC = [[TCLoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    } else {
        //遍历
        NSMutableArray *groupArr = [self.groupDataBase bianliFMDB:self.shopID];
        TCSubmitViewController *submitVC = [[TCSubmitViewController alloc] init];
        submitVC.disPriceStr = self.distributionPrice;
        submitVC.listGroup = YES;
        submitVC.shopIDStr = self.shopID;
        submitVC.shopMuArr = groupArr;
        
        submitVC.typeStr = @"1";
        [self.navigationController pushViewController:submitVC animated:YES];
    }
}

- (void)needReloadData {
    [self bianliFMDB];
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
