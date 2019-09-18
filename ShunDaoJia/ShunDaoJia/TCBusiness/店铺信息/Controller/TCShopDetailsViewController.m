//
//  TCShopDetailsViewController.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/6.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCShopDetailsViewController.h"
#import "TCShopCarView.h"
#import "TCSubmitViewController.h"
#import "TCSpecifView.h"
#import "TCLoginViewController.h"
#import "AppDelegate.h"


@interface TCShopDetailsViewController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *numlb;
@property (nonatomic, strong) UIButton *jisuan;
@property (nonatomic, strong) UILabel *allPrice;
@property (nonatomic, strong) NSString *qisong;
@property (nonatomic, strong) NSString *peisong;
@property (nonatomic, strong) NSMutableArray *sqlMuArr;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) FMDatabase *database;
@property (nonatomic, strong) NSUserDefaults *userdefaults;
@property (nonatomic, strong) UILabel *countlb;
@property (nonatomic, strong) UIButton *cutsbtn;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIImageView *shopImage; //购物车的图片
@property (nonatomic, strong) UILabel *hotNumLabel; //小圆点
@property (nonatomic, strong) NSString *specHas; //判断有无规格
@property (nonatomic, assign) NSInteger shopCount; //商品的数量
@property (nonatomic, strong) UIImageView *shopCarIm;
@property (nonatomic, strong) NSDictionary *commodityDic; //商品详情

@end

@implementation TCShopDetailsViewController

//隐藏导航栏
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
    //便利数据库
    [self peizhi];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gogo) name:@"shopcarpush" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(relo) name:@"needreload" object:nil];
    self.view.backgroundColor = TCBgColor;
    self.userdefaults = [NSUserDefaults standardUserDefaults];
    _database = [FMDatabase databaseWithPath: SqlPath];
    _sqlMuArr = [NSMutableArray array];

    //请求接口
    [self questDis];
}

//创建的UI
- (void)cteateUI
{
    //添加滚动视图
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 50)];
    
    _mainScrollView.delegate=self;
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    AdjustsScrollViewInsetNever(self,_mainScrollView);
    [self.view addSubview: _mainScrollView];
    
    UIImageView *goodsImage;
    SDCycleScrollView *cycleScrollView3;
    
//    //判断版本
//    if (!([[UIDevice currentDevice].systemVersion floatValue] >= 11.0) || iPhone6plus) {
//
//        goodsImage = [[UIImageView alloc] init];
//        goodsImage.frame = CGRectMake(0, 0, WIDTH, 360);
//        NSArray *imageAdsArr = self.commodityDic[@"imgList"];
//        [goodsImage sd_setImageWithURL:[NSURL URLWithString:imageAdsArr[0][@"src"]] placeholderImage:[UIImage imageNamed:@"商品详情页占位"]];
//        goodsImage.contentMode = UIViewContentModeScaleAspectFit;
//
//        [_mainScrollView addSubview: goodsImage];
//
//    } else {
        //添加轮播图
        cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, 360) delegate:nil placeholderImage:[UIImage imageNamed:@"商品详情页占位"]];
        cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"轮播点（白）"];
        cycleScrollView3.pageDotImage = [UIImage imageNamed:@"轮播点（透明）"];
        
        NSMutableArray *urlArr = [NSMutableArray array];
        NSArray *imageAdsArr = self.commodityDic[@"imgList"];
        for (int i = 0; i < imageAdsArr.count; i++) {
            [urlArr addObject:imageAdsArr[i][@"src"]];
        }
        if (urlArr.count == 0){
            cycleScrollView3.imageURLStringsGroup = @[@"商品详情页占位"];
        } else {
            cycleScrollView3.imageURLStringsGroup = urlArr;
        }
        [_mainScrollView addSubview:cycleScrollView3];
//    }
    
    UIButton *backbtn = [[UIButton alloc]initWithFrame:CGRectMake(12, StatusBarHeight + 6, 28, 28)];
    [backbtn setImage:[UIImage imageNamed:@"返回按钮（带背景的）"] forState: UIControlStateNormal];
    [backbtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview: backbtn];
    
    //商品名view
    UIView *nameView = [[UIView alloc]init];
    
//    if (!([[UIDevice currentDevice].systemVersion floatValue] >= 11.0) || iPhone6plus) {
//        nameView.frame = CGRectMake(0, CGRectGetMaxY(goodsImage.frame), WIDTH, 104);
//    } else {
        nameView.frame = CGRectMake(0, CGRectGetMaxY(cycleScrollView3.frame), WIDTH, 104);
//    }
    nameView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview: nameView];
    //商品民
    UILabel *namelb = [[UILabel alloc]initWithFrame:CGRectMake(12, 8, WIDTH - 24, 22)];
    namelb.text = _commodityDic[@"name"];
    namelb.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    namelb.textColor = TCUIColorFromRGB(0x4C4C4C);
    [nameView addSubview: namelb];
    //月售
    UILabel *monthLabel = [[UILabel alloc] init];
    monthLabel.frame = CGRectMake(12, CGRectGetMaxY(namelb.frame) + 8, WIDTH - 24, 18);
    monthLabel.textColor = TCUIColorFromRGB(0x666666);
    monthLabel.text = [NSString stringWithFormat:@"月售%@单",_commodityDic[@"saleCount"]];
    monthLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    monthLabel.textAlignment = NSTextAlignmentLeft;
    [nameView addSubview:monthLabel];
    
    //价格
    UILabel *jiage = [[UILabel alloc]initWithFrame:CGRectMake(12 , CGRectGetMaxY(monthLabel.frame) + 12, WIDTH / 2, 24)];
    jiage.text = [NSString stringWithFormat:@"¥%@", _commodityDic[@"price"]];
    jiage.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:20];
    jiage.textColor = TCUIColorFromRGB(0xFF3355);
    jiage.textAlignment = NSTextAlignmentLeft;
    [nameView addSubview: jiage];
    
    //添加按钮
    UIButton *addbtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 12  - 24, jiage.frame.origin.y, 24, 24)];
    [addbtn setImage:[UIImage imageNamed:@"加商品"] forState: UIControlStateNormal];
    [addbtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    self.addBtn = addbtn;
    [nameView addSubview: addbtn];
    
    //个数
    UILabel *numlb = [[UILabel alloc]initWithFrame:CGRectMake(addbtn.frame.origin.x - 40 , addbtn.frame.origin.y,40, addbtn.frame.size.height)];
    numlb.text = @"";
    numlb.textColor = TCUIColorFromRGB(0x333333);
    numlb.font = [UIFont fontWithName:@"PingFangTC-Semibold" size:15];
    numlb.textAlignment = NSTextAlignmentCenter;
    [nameView addSubview: numlb];
    _countlb = numlb;
    //减号
    UIButton *cutbtn = [[UIButton alloc]initWithFrame:CGRectMake(numlb.frame.origin.x - 24, numlb.frame.origin.y, 24 , 24)];
    [cutbtn setImage:[UIImage imageNamed:@"减号按钮"] forState:UIControlStateNormal];
    [cutbtn addTarget:self action:@selector(cutAction) forControlEvents:UIControlEventTouchUpInside];
    [nameView addSubview: cutbtn];
    cutbtn.hidden = YES;
    _cutsbtn = cutbtn;
    
    //商品描述
    UIView *garyView = [[UIView alloc] init];
    garyView.frame = CGRectMake(0, CGRectGetMaxY(nameView.frame), WIDTH, 37);
    garyView.backgroundColor = TCBgColor;
    [_mainScrollView addSubview:garyView];
    
    UILabel *miaoshu = [[UILabel alloc]initWithFrame:CGRectMake(8, 12, 60, 21)];
    miaoshu.text = @"商品介绍";
    miaoshu.textColor = TCUIColorFromRGB(0x666666);
    miaoshu.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [garyView addSubview: miaoshu];
    //描述view
    UIView *mview = [[UIView alloc]initWithFrame:CGRectMake(0, garyView.frame.origin.y + garyView.frame.size.height, WIDTH, HEIGHT - 50 - garyView.frame.origin.y - garyView.frame.size.height)];
    mview.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview: mview];
    
    UILabel *miaolb = [[UILabel alloc]initWithFrame:CGRectMake(12 , 16, WIDTH - 24, mview.frame.size.height - 20)];
    miaolb.textColor = TCUIColorFromRGB(0x666666);
    miaolb.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    miaolb.numberOfLines = 0;
    if ([_commodityDic[@"description"] isEqualToString:@""]) {
        miaolb.text = @"暂无描述";
    }else{
        miaolb.text = _commodityDic[@"description"];
    }
    CGSize size3 = [miaolb sizeThatFits: CGSizeMake(WIDTH - 20 * WIDHTSCALE, mview.frame.size.height - 20 * HEIGHTSCALE)];
    miaolb.frame = CGRectMake(10 * WIDHTSCALE, 10 * HEIGHTSCALE, size3.width, size3.height);
    [mview addSubview: miaolb];

    _mainScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(mview.frame));

    //购物车
    //底层的view
    self.bottomView = [[UIView alloc] init];
    self.bottomView.frame = CGRectMake(0,HEIGHT - 50, WIDTH, 50);
    self.bottomView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:self.bottomView];
    
    //下划线
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, _bottomView.frame.origin.y - 0.5, WIDTH, 0.5)];
    line1.backgroundColor = TCLineColor;
    [self.view addSubview: line1];
    
    //图片
    UIImageView *im1 = [[UIImageView alloc]initWithFrame:CGRectMake(12, _bottomView.frame.origin.y + _bottomView.frame.size.height - 6.5 - 56, 56 , 56)];
    im1.image = [UIImage imageNamed:@"购物车（无商品）"];
    im1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taps)];
    [im1 addGestureRecognizer: tap];
    _shopCarIm = im1;
    [self.view addSubview: im1];
    
    _numlb = [[UILabel alloc]initWithFrame:CGRectMake(im1.frame.size.width + im1.frame.origin.x - 19 , im1.frame.origin.y + 10, 20 , 16 )];
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
    lb2.text = [NSString stringWithFormat:@"配送费 ¥%@",self.shopMesDic[@"distributionPrice"]];
    lb2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    lb2.textColor = TCUIColorFromRGB(0x999999);
    CGSize size1 = [lb2 sizeThatFits:CGSizeMake(WIDTH - 120 - CGRectGetMaxX(lb.frame) - 8, 15 )];
    lb2.frame = CGRectMake(lb.frame.origin.x, lb.frame.origin.y + lb.frame.size.height + 4 , size1.width, 15 );
    [_bottomView addSubview: lb2];
    
    //配置数据库信息
     [self peizhi];
}

#pragma mark -- questDis
- (void)questDis
{
    //指示器
    [ProgressHUD showHUDToView:self.view];
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSDictionary *dic = @{@"timestamp":timeStr,@"goodsid":self.idStr};
    NSString *signStr = [TCServerSecret signStr:dic];
    NSDictionary *paramters = @{@"timestamp":timeStr,@"goodsid":self.idStr,@"sign":signStr};
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"101020"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"Dic = %@,Str = %@",jsonDic,jsonStr);
        _commodityDic = jsonDic[@"data"];
        //创建ui
        [self cteateUI];
        [ProgressHUD hiddenHUD:self.view];
    } failure:^(NSError *error) {
        nil;
    }];
}

- (void)gogo{
    [_backView removeFromSuperview];
    [self peizhi];
}

- (void)relo{
    [self peizhi];
}

//配置页面上的数量与减号状态
- (void)peizhi{
    //遍历数据库
    [self bianliSQL];
    //遍历记录  如果有 就显示对应个数
    if (_sqlMuArr.count == 0) {
        //主要用于  购物车减到0后 该数组中无数据  就不执行下方循环 则数量与减号状态不改变
        _cutsbtn.hidden = YES;
        _countlb.text = @"";
    }else{
        for (int i = 0; i < _sqlMuArr.count; i++) {
            if ([_shopDetailDic[@"goodsid"] isEqualToString: _sqlMuArr[i][@"id"]]) {
                _countlb.text = _sqlMuArr[i][@"amount"];
                _cutsbtn.hidden = NO;
                return;
            }else{
                _cutsbtn.hidden = YES;
            }
        }
    }
}

//添加选择规格
- (void)addSpecBtn:(UIButton *)sender
{
    //选择规格的弹窗
    TCSpecifView *specView = [[TCSpecifView alloc] initWithFrame:self.view.frame andArr:self.shopModel];
    __weak typeof(self) weakself = self;
    specView.reloadData = ^{
        [weakself bianliSQL];
    };
    [self.view addSubview:specView];
}

//添加
- (void)addAction{
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([_shopDetailDic[@"goodscateid"] isEqualToString:@"312"] && (delegate.iscate == NO)) {
        delegate.iscate = YES;
        _countlb.text = [NSString stringWithFormat:@"%d", [_countlb.text intValue] + 1];
        //添加商品信息到数据库
        if ([_database open]) {
            //查找数据库 该店铺下是否有该商品
            FMResultSet *re = [_database executeQuery:@"select *from newShopCar where storeid = ? and shopid = ?", self.shopID, _shopDetailDic[@"goodsid"]];
            if ([re next]) {
                //如果有  更新个数
                BOOL isSuccess = [_database executeUpdate:@"update newShopCar set shopcount = ? where shopid = ? and storeid = ?", _countlb.text, _shopDetailDic[@"goodsid"], self.shopID];
                if (isSuccess) {
                    NSLog(@"更新数据成功");
                }
            }else{
                //如果没有  创建该记录
                NSString *shopname = @"";
                shopname = _shopDetailDic[@"name"];
                BOOL isSuccess = [_database executeUpdate:@"insert into newShopCar (storeid, shopid, shopprice, shopname, shopcount, shopPic, stockcount, goodscateid) values (?, ?, ?, ?, ?, ?, ?, ?)", self.shopID, _shopDetailDic[@"goodsid"], _shopDetailDic[@"price"], shopname, _countlb.text, _shopDetailDic[@"srcThumbs"], _shopDetailDic[@"stockTotal"],_shopDetailDic[@"goodscateid"]];
                if (isSuccess) {
                    NSLog(@"记录创建成功");
                }
            }
        }
        _cutsbtn.hidden = NO;
        [self bianliSQL];
        
    } else if ([_shopDetailDic[@"goodscateid"] isEqualToString:@"312"] && (delegate.iscate == YES)) {
        [TCProgressHUD showMessage:@"特价商品一次只能购买一个"];
    } else {
    
    
    if ([_countlb.text intValue] + 1 > [_shopDetailDic[@"stockTotal"] intValue]) {
        [TCProgressHUD showMessage:@"超出库存啦!"];
    }else{
        _countlb.text = [NSString stringWithFormat:@"%d", [_countlb.text intValue] + 1];
        //添加商品信息到数据库
        if ([_database open]) {
            //查找数据库 该店铺下是否有该商品
            FMResultSet *re = [_database executeQuery:@"select *from newShopCar where storeid = ? and shopid = ?", self.shopID, _shopDetailDic[@"goodsid"]];
            if ([re next]) {
                //如果有  更新个数
                BOOL isSuccess = [_database executeUpdate:@"update newShopCar set shopcount = ? where shopid = ? and storeid = ?", _countlb.text, _shopDetailDic[@"goodsid"], self.shopID];
                if (isSuccess) {
                    NSLog(@"更新数据成功");
                }
            }else{
                //如果没有  创建该记录
                NSString *shopname = @"";
                shopname = _shopDetailDic[@"name"];
                BOOL isSuccess = [_database executeUpdate:@"insert into newShopCar (storeid, shopid, shopprice, shopname, shopcount, shopPic, stockcount, goodscateid) values (?, ?, ?, ?, ?, ?, ?, ?)", self.shopID, _shopDetailDic[@"goodsid"], _shopDetailDic[@"price"], shopname, _countlb.text, _shopDetailDic[@"srcThumbs"], _shopDetailDic[@"stockTotal"],_shopDetailDic[@"goodscateid"]];
                if (isSuccess) {
                    NSLog(@"记录创建成功");
                }
            }
        }
        _cutsbtn.hidden = NO;
        [self bianliSQL];
    }
    }
}
//减少
- (void)cutAction{
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if ( [_shopDetailDic[@"goodscateid"] isEqualToString:@"312"] && (delegate.iscate == YES)) {
        delegate.iscate = NO;
    }
    
    _countlb.text = [NSString stringWithFormat:@"%d", [_countlb.text intValue] - 1];
    //添加商品信息到数据库
    if ([_database open]) {
        //查找数据库 该店铺下是否有该商品
        FMResultSet *re = [_database executeQuery:@"select *from newShopCar where storeid = ? and shopid = ?", self.shopID, _shopDetailDic[@"goodsid"]];
        if ([re next]) {
            //如果有  更新个数
            BOOL isSuccess = [_database executeUpdate:@"update newShopCar set shopcount = ? where shopid = ? and storeid = ?", _countlb.text, _shopDetailDic[@"goodsid"], self.shopID];
            if (isSuccess) {
                NSLog(@"更新数据成功");
            }
        }else{
            //如果没有  创建该记录
            BOOL isSuccess = [_database executeUpdate:@"insert into newShopCar (storeid, shopid, shopprice, shopname, shopcount, shopPic, stockcount, goodscateid) values (?, ?, ?, ?, ?, ?, ?, ?)", self.shopID, _shopDetailDic[@"goodsid"], _shopDetailDic[@"price"], _shopDetailDic[@"name"], _countlb.text, _shopDetailDic[@"srcThumbs"], _shopDetailDic[@"stockTotal"],_shopDetailDic[@"goodscateid"]];
            if (isSuccess) {
                NSLog(@"记录创建成功");
            }
        }
    }
    [self bianliSQL];
    //当减到0 的时候  tableview中移除刚数据
    if ([_countlb.text intValue] == 0) {
        _cutsbtn.hidden = YES;
        _countlb.text = @"";
    }
}


//购物车点击事件
- (void)taps{
    //先遍历
    [self bianliSQL];
    if (_sqlMuArr.count != 0) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _backView.backgroundColor = [[UIColor darkGrayColor]colorWithAlphaComponent:0.3];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(haha)];
        tap.delegate = self;
        [_backView addGestureRecognizer: tap];
        [[UIApplication sharedApplication].keyWindow addSubview: _backView];
        //创建是  将起送跟配送传过去
        TCShopCarView *shop = [[TCShopCarView alloc] initWithFrame:CGRectMake(0, HEIGHT - 350 , WIDTH, 350) andData:_sqlMuArr andqisong:_shopMesDic[@"startPrice"] andPeisong:_shopMesDic[@"distributionPrice"] andShop:self.shopID];
        [_backView addSubview: shop];
        //点击购物车按钮  移除view后的回调方法  在此处要重新配置主页面上的减号状态与数量
        [shop disBackView:^{
            [self bianliSQL];
            [self peizhi];
            [_backView removeFromSuperview];
        }];
        //到达0 这里是同步上面的数据
        [shop shuaxin:^{
            [self bianliSQL];
            [self peizhi];
            //[_backView removeFromSuperview];
        }];
    }else{
        [TCProgressHUD showMessage:@"您还没有选购商品！"];
    }
}

- (void)haha{
    [self bianliSQL];
    [self peizhi];
    [_backView removeFromSuperview];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (![touch.view isKindOfClass: [TCShopCarView class]]) {
        return NO;
    }
    return YES;
}

//遍历数据库
- (void)bianliSQL{
    //读取数据库
    //获取之前先移除之前数据
    [_sqlMuArr removeAllObjects];
    //遍历数据库  更改底部购物车view的数据
    if ([_database open]) {
        FMResultSet *res = [_database executeQuery:@"select *from newShopCar where storeid = ?", self.shopID];
        while ([res next]) {
            NSDictionary *dic = @{@"id":[res stringForColumn:@"shopid"], @"price":[res stringForColumn:@"shopprice"], @"amount":[res stringForColumn:@"shopcount"], @"name":[res stringForColumn:@"shopname"], @"pic":[res stringForColumn:@"shopPic"], @"stockcount":[res stringForColumn:@"stockcount"],@"goodscateid":[res stringForColumn:@"goodscateid"]};
            [_sqlMuArr addObject: dic];
        }
    }
    //更新总价钱 与 角标
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
            _jisuan.backgroundColor = TCUIColorFromRGB(0xF99E20);
        }
    } else {
         [_jisuan setTitle:[NSString stringWithFormat:@"¥%.2f起送", [_shopMesDic[@"startPrice"] floatValue]] forState:UIControlStateNormal];
        _jisuan.userInteractionEnabled = NO;
        _jisuan.backgroundColor = TCUIColorFromRGB(0xCCCCCC);
    }
}

- (void)qujiesuan{
    NSLog(@"去结算..");
    
    if (_sqlMuArr.count != 0) {
        if ([_userdefaults valueForKey:@"userID"]) {
            TCSubmitViewController *submitVC = [[TCSubmitViewController alloc]init];
            submitVC.shopMuArr = _sqlMuArr;
            submitVC.typeStr = @"0";
            submitVC.shopIDStr = self.shopID;
            submitVC.messDic = self.shopMesDic;
            [self.navigationController pushViewController:submitVC animated:YES];
        }else{
            TCLoginViewController *loginVC = [[TCLoginViewController alloc]init];
            [self presentViewController:loginVC animated:YES completion:nil];
        }
    }
}

- (void)back{
    //要求前一个页面刷新数据
    [[NSNotificationCenter defaultCenter]postNotificationName:@"detailBack" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    NSLog(@"哈哈");
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
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
