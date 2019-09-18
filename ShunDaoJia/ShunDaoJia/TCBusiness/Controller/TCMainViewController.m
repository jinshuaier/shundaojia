//
//  TCMainViewController.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/10/10.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCMainViewController.h"
#import "TCSearchController.h"
#import "TCLocationViewController.h"
#import "TCSpecialViewController.h" //特价商品
#import "TCAllServeViewController.h" //全部服务
#import "TCShopMessageViewController.h"

#import "TCShowHeadView.h" //轮播图
#import "TCGoodsHandheldCell.h"
#import "TCNewActiveCell.h" //图片瀑布流
#import "TCTitleFootView.h" //道嘉优选
#import "TCShopHeadView.h" //商品头部
#import "TCServiceGoodsItem.h"
#import "TCServiceGoodsCell.h"
#import "TCZhanweiFootView.h"

/* 轮播图跳转的页面 */
#import "TCLoginViewController.h"
#import "TCHtmlViewController.h"

@interface TCMainViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate>
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (strong , nonatomic)NSMutableArray<TCServiceGoodsItem *> *serviceGoodsItem;
@property (nonatomic, strong) UIView *custom_navView; //自定义的导航栏
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) UILabel *locationLabel; //定位
@property (nonatomic, strong) UIImageView *imageLocate;
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIImageView *subscriptImage; //
@property (nonatomic, strong) UIImageView *imageLoction; //

@property (nonatomic, strong) NSString *longtitude;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *seleStr;
@property (nonatomic, strong) NSString *shopidstr;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSString *midStr;
@property (nonatomic, strong) NSString *tokenStr;
@property (nonatomic, strong) NSMutableArray *luoboArr; //轮播图
@property (nonatomic, strong) NSMutableArray *distanceArr; //距离
@property (nonatomic, strong) NSString *beyondCount; //超出范围
@property (nonatomic, assign) NSInteger beCount; //超出范围

@end

/* head */
static NSString *const TCShowHeadViewID = @"TCShowHeadView"; //轮播图的注册ID
static NSString *const TCShopHeadViewID = @"TCShopHeadView";
/* cell */
static NSString *const TCNewActiveCellID = @"TCNewActiveCell";
static NSString *const TCServiceGoodsCellID = @"TCServiceGoodsCell";
static NSString *const TCGoodsHandheldCellID = @"TCGoodsHandheldCell";

/* foot */
static NSString *const TCTitleFootViewID = @"TCTitleFootView";
static NSString *const TCZhanweiFootViewID = @"TCZhanweiFootView";


@implementation TCMainViewController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArr = [NSMutableArray array];
    self.distanceArr = [NSMutableArray array];
    self.luoboArr = [NSMutableArray array];
    //定位当前位置
    [self setUpLoaction];
 }

#pragma mark -- 定位当前位置
- (void)setUpLoaction {
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    
    //没有登录
    if ([self.userDefaults valueForKey:@"userID"] == nil) {
        self.midStr = @"0";
        self.tokenStr = @"0";
    } else {
        self.midStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userID"]];
        self.tokenStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userToken"]];
    }
    
    [ProgressHUD showHUDToView:self.view];
    self.view.userInteractionEnabled = NO;
    //开启定位
    TCLocation *lo = [[TCLocation alloc]init];
    lo.ishomePage = YES;
    [lo getadds:^(NSString *address) {
        self.locationLabel.text = [self.userDefaults valueForKey:@"currentNei"];
        //    创建UI
        [self createUI];
        [ProgressHUD hiddenHUD:self.view];
        self.view.userInteractionEnabled = YES;

    } andMayBeError:^{
        
    }];
    //定位成功后的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadView:) name:@"stop" object:nil];
    
    //添加view
    self.custom_navView = [[UIView alloc] init];
    self.custom_navView.backgroundColor = [UIColor whiteColor];
    self.custom_navView.frame = CGRectMake(0, 0, WIDTH, StatusBarAndNavigationBarHeight);
    [self.view addSubview:self.custom_navView];
    //添加搜索按钮
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:[UIImage imageNamed:@"搜索图标"] forState:(UIControlStateNormal)];
    searchBtn.frame = CGRectMake(WIDTH - 15 * WIDHTSCALE - 19 * WIDHTSCALE, StatusBarHeight + 14, 19 * WIDHTSCALE, 19);
    [searchBtn addTarget:self action:@selector(searchBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.custom_navView addSubview:searchBtn];
    //定位的图标
    self.imageLocate = [[UIImageView alloc] init];
    self.imageLocate.image = [UIImage imageNamed:@"首页定位图标icon"];
    self.imageLocate.contentMode = UIViewContentModeScaleAspectFit;
    self.imageLocate.frame = CGRectMake(16 * WIDHTSCALE, StatusBarHeight + 13, 14 * WIDHTSCALE, 17);
    [self.custom_navView addSubview:self.imageLocate];
    
    
    self.navView =[[UIView alloc] init];
    self.navView.frame=CGRectMake(0, StatusBarHeight + 7, 155 * WIDHTSCALE, StatusBarHeight + 17.5);
    self.navView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapLocition = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLocationView)];
    [self.navView addGestureRecognizer:tapLocition];
    [self.custom_navView addSubview:self.navView];
    
    //地址
    self.locationLabel = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x333333) textAlignment:NSTextAlignmentCenter fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    CGSize size = [self.locationLabel sizeThatFits:CGSizeMake(WIDTH, 30)];
    self.locationLabel.frame = CGRectMake(CGRectGetMaxX(self.imageLocate.frame) + 6 * WIDHTSCALE, 0, size.width, 30);
    [self.navView addSubview:self.locationLabel];
    
    //下标
    self.subscriptImage = [[UIImageView alloc] init];
    self.subscriptImage.frame = CGRectMake(CGRectGetMaxX(self.locationLabel.frame) +4 * WIDHTSCALE , (30 - 4)/2 , 7 * WIDHTSCALE, 4);
    self.subscriptImage.image = [UIImage imageNamed:@"进入定位小三角"];
    [self.navView addSubview:self.subscriptImage];
}

//定位成功后的通知
- (void)reloadView:(NSNotification *)userInfo {
    //如果是第一次打开  定位后没有创建tableview 所以在此要创建在刷新
    if (![self.userDefaults boolForKey:@"firstS"]) {
        //是第一次启动
        [self.userDefaults setBool:YES forKey:@"firstS"];
    }
    NSLog(@"当前位置信息 %@", [self.userDefaults valueForKey:@"currentNei"]);
    self.longtitude = [self.userDefaults valueForKey:@"longitude"];
    self.latitude = [self.userDefaults valueForKey:@"latitude"];
    
    self.locationLabel.text = [self.userDefaults valueForKey:@"currentNei"];
    CGSize size = [self.locationLabel sizeThatFits:CGSizeMake(WIDTH, 30)];
    if (size.width > 200 * WIDHTSCALE){
        self.locationLabel.frame = CGRectMake(CGRectGetMaxX(self.imageLocate.frame) + 6 * WIDHTSCALE, 0, 155 * WIDHTSCALE, 30);
    } else {
        self.locationLabel.frame = CGRectMake(CGRectGetMaxX(self.imageLocate.frame) + 6 * WIDHTSCALE, 0, size.width, 30);
    }
    self.subscriptImage.frame = CGRectMake(CGRectGetMaxX(self.locationLabel.frame) + 4 * WIDHTSCALE, (30 - 4)/2, 7 * WIDHTSCALE, 4);
    self.imageLoction.frame = CGRectMake(self.locationLabel.frame.origin.x - 6 * WIDHTSCALE - 10 * WIDHTSCALE, (30 - 14)/2, 10 * WIDHTSCALE, 14);
    if (size.width > 200){
        self.navView.frame = CGRectMake(0, StatusBarHeight + 7, (200 + 16) * WIDHTSCALE, StatusBarHeight + 17.5);
    } else {
        self.navView.frame = CGRectMake(0, StatusBarHeight + 7, 32 * WIDHTSCALE + size.width + 30 * WIDHTSCALE + 16 * WIDHTSCALE, StatusBarHeight + 17.5);
    }
    
    if ([userInfo.userInfo[@"key"] isEqualToString:@"0"]) {
        [self requestShops];
    } else {
        [self.mainCollectionView.wj_refreshHeader beginRefreshing];
    }
}

//创建UI
- (void)createUI {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - StatusBarAndNavigationBarHeight - TabbarHeight) collectionViewLayout:layout];
    _mainCollectionView.backgroundColor = [UIColor clearColor];
    [_mainCollectionView registerClass:[TCGoodsHandheldCell class] forCellWithReuseIdentifier:TCGoodsHandheldCellID];
    [_mainCollectionView registerClass:[TCNewActiveCell class] forCellWithReuseIdentifier:TCNewActiveCellID];
    [_mainCollectionView registerClass:[TCServiceGoodsCell class] forCellWithReuseIdentifier:TCServiceGoodsCellID];
    [_mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    [_mainCollectionView registerClass:[TCShowHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TCShowHeadViewID];
    [_mainCollectionView registerClass:[TCShopHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TCShopHeadViewID];
    [_mainCollectionView registerClass:[TCTitleFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:TCTitleFootViewID];
     [_mainCollectionView registerClass:[TCZhanweiFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:TCZhanweiFootViewID];
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
    _mainCollectionView.showsVerticalScrollIndicator = NO;
    
    __block int  page = 1;
    _mainCollectionView.wj_refreshHeader = [WJRefreshHeader refreshHeaderWithRefreshBlock:^{
        [self requestShops];
         page = 1;

    }];
        _mainCollectionView.wj_refreshFooter = [WJRefreshFooter refreshFooterWithRefreshBlock:^{
        page ++;
        NSString *pageStr = [NSString stringWithFormat:@"%d",page];
        [self requestShops:pageStr];

    }];
    [self.view addSubview:_mainCollectionView];
}

#pragma mark - 加载数据
- (void)requestShops
{
    //清除sdwebimage 的缓存 商家跟换头像后 首页头像还是之前的
    [[SDImageCache sharedImageCache] clearDisk];
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSDictionary *dic = @{@"timestamp":timeStr,@"latitude":self.latitude,@"longtitude":self.longtitude,@"page":@"1",@"mid":self.midStr,@"token":self.tokenStr,@"deviceid":[TCGetDeviceId getDeviceId]};
    NSString *signStr = [TCServerSecret signStr:dic];
    NSDictionary *paramters = @{@"timestamp":timeStr,@"latitude":self.latitude,@"longtitude":self.longtitude,@"page":@"1",@"mid":self.midStr,@"token":self.tokenStr,@"deviceid":[TCGetDeviceId getDeviceId],@"sign":signStr};
    NSLog(@" %@--",paramters);
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102030"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        if (jsonDic[@"data"]){
            [self.luoboArr removeAllObjects];
            [self.distanceArr removeAllObjects];
            //轮播图
            self.luoboArr = jsonDic[@"data"][@"bannerList"];
            self.distanceArr = jsonDic[@"data"][@"shopList"];
            for (int i = 0; i < self.distanceArr.count; i++) {
                NSString *distypeStr = [NSString stringWithFormat:@"%@",self.distanceArr[i][@"distanceType"]];
                if ([distypeStr isEqualToString:@"1"]) {
                    self.beyondCount = [NSString stringWithFormat:@"%d",i];
                  break;
                }
            }
            //通知传值
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tupianchuanzhi" object:nil userInfo:@{@"imageDic":jsonDic[@"data"][@"twoBanner"]}];
        }
        //刷新界面
        [self.mainCollectionView reloadData];
        [self.mainCollectionView.mj_header endRefreshing];

    } failure:^(NSError *error) {
        nil;
    }];
    [self.mainCollectionView.mj_footer resetNoMoreData];
 }
    
//上拉加载
- (void)requestShops:(NSString *)page{
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSDictionary *dic = @{@"timestamp":timeStr,@"latitude":self.latitude,@"longtitude":self.longtitude,@"page":page,@"mid":self.midStr,@"token":self.tokenStr,@"deviceid":[TCGetDeviceId getDeviceId]};
    NSString *signStr = [TCServerSecret signStr:dic];
    NSDictionary *paramters = @{@"timestamp":timeStr,@"latitude":self.latitude,@"longtitude":self.longtitude,@"page":page,@"mid":self.midStr,@"token":self.tokenStr,@"deviceid":[TCGetDeviceId getDeviceId],@"sign":signStr};
    
    NSLog(@" %@--",paramters);
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102030"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        
        [self.distanceArr addObjectsFromArray:jsonDic[@"data"][@"shopList"]];
    
        for (int i = 0; i < self.distanceArr.count; i++) {
            NSString *distypeStr = [NSString stringWithFormat:@"%@",self.distanceArr[i][@"distanceType"]];
            if ([distypeStr isEqualToString:@"1"]) {
                self.beyondCount = [NSString stringWithFormat:@"%d",i];
                break;
            }
        }
        [self.mainCollectionView.mj_header endRefreshing];
        [self.mainCollectionView reloadData];
        
    } failure:^(NSError *error) {
        nil;
    }];
    [self.mainCollectionView.mj_footer resetNoMoreData];
}

#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.distanceArr.count + 1;
}
//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) { //属性
        return 1;
    }
    return [self.distanceArr[section - 1][@"goodsList"] count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;

    if (indexPath.section == 0) {
        TCNewActiveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TCNewActiveCellID forIndexPath:indexPath];
        cell.ActiveAction = ^(NSInteger tagStr) {
            NSLog(@"%ld",(long)tagStr);
            if (tagStr == 0) {
                TCSpecialViewController *specialVC = [[TCSpecialViewController alloc] init];
                specialVC.latitudeStr = self.latitude;
                specialVC.longtitudeStr = self.longtitude;
                specialVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:specialVC animated:YES];
            } else if (tagStr == 1) {
                TCAllServeViewController *allServeVC = [[TCAllServeViewController alloc] init];
                allServeVC.latitudeStr = self.latitude;
                allServeVC.longtitudeStr = self.longtitude;
                allServeVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:allServeVC animated:YES];
            } else {
                [TCProgressHUD showMessage:@"敬请期待"];
            }
        };
        gridcell = cell;
    } else {
        TCGoodsHandheldCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TCGoodsHandheldCellID forIndexPath:indexPath];
        if (self.distanceArr.count != 0){
            cell.goodsLabel.text = self.distanceArr[indexPath.section - 1][@"goodsList"][indexPath.row][@"name"];
            [cell.topImage sd_setImageWithURL:[NSURL URLWithString:self.distanceArr[indexPath.section - 1][@"goodsList"][indexPath.row][@"src"]] placeholderImage:[UIImage imageNamed:@"商品详情页占位"]];
            cell.monthLabel.text = self.distanceArr[indexPath.section - 1][@"goodsList"][indexPath.row][@"price"];
            cell.backgroundColor = [UIColor clearColor];
            gridcell = cell;
        }
    }
    return gridcell;
}
//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//广告
        return CGSizeMake(WIDTH, kScaledValue(154));
    }
    return CGSizeMake((WIDTH - 36)/ 3, 179);
}

/** section的margin*/
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 12, 0, 12);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return (section == 0) ? 0 : 6;
}
//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return (section == 0) ? 0 : 0;
}
//通过设置SupplementaryViewOfKind 来设置头部或者底部的view，其中 ReuseIdentifier 的值必须和 注册是填写的一致，本例都为 “reusableView”
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        
        if (indexPath.section == 0) {
            TCShowHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TCShowHeadViewID forIndexPath:indexPath];
            //判断是否为空
            if (self.luoboArr.count != 0) {
                NSMutableArray *urlArr = [NSMutableArray array];
                for (int i = 0; i < self.luoboArr.count; i++) {
                    [urlArr addObject:self.luoboArr[i][@"images"]];
                    headerView.imageGroupArray = urlArr;
                }
            }
            headerView.LunboAction = ^(NSInteger tagStr) {
                //跳转页面
                [self jumpPageController:self.luoboArr andIndex:tagStr];
            };
            reusableview = headerView;
        } else {
            TCShopHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TCShopHeadViewID forIndexPath:indexPath];
            
            if (self.beyondCount != nil) {
                NSInteger i = [self.beyondCount integerValue];
                if (indexPath.section == 1 + i) {
                    headerView.adressView.hidden = NO;
                } else {
                    headerView.adressView.hidden = YES;
                }
            }
            //地址
            headerView.adressAction = ^{
                [self tapLocationView];
            };
            
            if (self.distanceArr.count != 0){
                [headerView.imageIcon sd_setImageWithURL:[NSURL URLWithString:self.distanceArr[indexPath.section - 1][@"headPic"]] placeholderImage:[UIImage imageNamed:@"商品详情页占位"]];
                headerView.shopLabel.text = self.distanceArr[indexPath.section - 1][@"name"];
                headerView.disceLabel.text = self.distanceArr[indexPath.section - 1][@"distance"];
                
                //店铺
                headerView.headAction = ^{
                    TCShopMessageViewController *shopMessageVC = [[TCShopMessageViewController alloc] init];
                    shopMessageVC.shopID = [NSString stringWithFormat:@"%@",self.distanceArr[indexPath.section - 1][@"shopid"]];
                    shopMessageVC.goodsID = @"0";
                    shopMessageVC.goodCateID = @"0";
                    [self.navigationController pushViewController:shopMessageVC animated:YES];
                };
                
                reusableview = headerView;
            }
        }
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        if (indexPath.section == 0) {
            TCTitleFootView *footview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:TCTitleFootViewID forIndexPath:indexPath];
            reusableview = footview;
        } else {
            TCZhanweiFootView *footview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:TCZhanweiFootViewID forIndexPath:indexPath];
            reusableview = footview;
        }
        
    }
     return reusableview;
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (self.beyondCount != nil) {
        NSInteger i = [self.beyondCount integerValue];
        if (section == 1 + i) {
            return CGSizeMake(WIDTH, 80); //图片滚动的宽高
        }
    }
    
    if (section == 0) {
        return CGSizeMake(WIDTH, 154); //图片滚动的宽高
    }
    return CGSizeMake(WIDTH, 40); //图片滚动的宽高
}

#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        if (self.beyondCount != nil) {
            NSInteger i = [self.beyondCount integerValue];
            if (i == 0) {
                return CGSizeMake(WIDTH, 38);
            }
        }
        return CGSizeMake(WIDTH, 38);
    } else {
        if (self.beyondCount != nil) {
            NSInteger i = [self.beyondCount integerValue];
            if (section == i) {
                return CGSizeMake(WIDTH, 0);
            }
        }
        return CGSizeMake(WIDTH, 8);
    }
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TCShopMessageViewController *shopMessageVC = [[TCShopMessageViewController alloc] init];
    shopMessageVC.shopID = [NSString stringWithFormat:@"%@",self.distanceArr[indexPath.section - 1][@"goodsList"][indexPath.row][@"shopid"]];
    shopMessageVC.isShouCang = YES;
    shopMessageVC.goodsID = [NSString stringWithFormat:@"%@",self.distanceArr[indexPath.section - 1][@"goodsList"][indexPath.row][@"goodsid"]];
    shopMessageVC.goodCateID = [NSString stringWithFormat:@"%@",self.distanceArr[indexPath.section - 1][@"goodsList"][indexPath.row][@"goodscateid"]];
    [self.navigationController pushViewController:shopMessageVC animated:YES];
}

#pragma mark -- 加手势
- (void)tapLocationView
{
    NSLog(@"手势");
    TCLocationViewController *locationVC = [[TCLocationViewController alloc] init];
    locationVC.typeStr = self.shopidstr;
    locationVC.hidesBottomBarWhenPushed = YES;
    locationVC.chooseBlock = ^(NSString *addStr, NSString *longla, NSString *latitu,NSString *typeStr) {
        self.locationLabel.text = addStr;
        self.longtitude = longla;
        self.latitude = latitu;
        if (typeStr == nil){
            self.seleStr = @"";
        } else {
            self.seleStr = typeStr;
        }
        CGSize size = [self.locationLabel sizeThatFits:CGSizeMake(WIDTH, 30)];
        if (size.width > 200 * WIDHTSCALE){
            self.locationLabel.frame = CGRectMake(CGRectGetMaxX(self.imageLocate.frame) + 6 * WIDHTSCALE, 0, 155 * WIDHTSCALE, 30);
        } else {
            self.locationLabel.frame = CGRectMake(CGRectGetMaxX(self.imageLocate.frame) + 6 * WIDHTSCALE, 0, size.width, 30);
        }
        //    self.locationLabel.frame = CGRectMake(32, 0, size.width, 30);
        self.subscriptImage.frame = CGRectMake(CGRectGetMaxX(self.locationLabel.frame) + 4 * WIDHTSCALE, (30 - 4)/2, 7 * WIDHTSCALE, 4);
        self.imageLoction.frame = CGRectMake(self.locationLabel.frame.origin.x - 6 * WIDHTSCALE - 10 * WIDHTSCALE, (30 - 14)/2, 10 * WIDHTSCALE, 14);
        if (size.width > 200 * WIDHTSCALE){
            self.navView.frame = CGRectMake(0, StatusBarHeight + 7, 200 * WIDHTSCALE + 16 * WIDHTSCALE, StatusBarHeight + 17.5);
        } else {
            self.navView.frame = CGRectMake(0, StatusBarHeight + 7, 32 * WIDHTSCALE + size.width + 30 * WIDHTSCALE + 16 * WIDHTSCALE, StatusBarHeight + 17.5);
        }
        [self.mainCollectionView.wj_refreshHeader beginRefreshing];
    };
    locationVC.locaStr = self.locationLabel.text;
    [self.navigationController pushViewController:locationVC animated:YES];
}

#pragma mark -- 搜索的点击事件
-(void)searchBtn:(UIButton *)sender
{
    NSLog(@"搜索");
    TCSearchController *searchVC = [[TCSearchController alloc] init];
    searchVC.latStr = self.latitude;
    searchVC.longStr = self.longtitude;
    searchVC.isAllfuwu = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark -- 点击轮播图跳转
- (void)jumpPageController:(NSArray *)lunboArr andIndex:(NSInteger)tagStr
{
    
    if ([lunboArr[tagStr][@"redirectTo"] isEqualToString:@"1"]){
        
    } else if ([lunboArr[tagStr][@"redirectTo"] isEqualToString:@"2"]){
        
    } else {
        //跳
//        TCHtmlViewController * htmlVC = [[TCHtmlViewController alloc]init];
//        htmlVC.html = lunboArr[tagStr][@"url"];
//        htmlVC.titles = lunboArr[tagStr][@"title"];
//        self.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:htmlVC animated:YES];
//        self.hidesBottomBarWhenPushed = NO;
    }
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

@end
