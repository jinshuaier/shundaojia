//
//  TCSubmitViewController.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/14.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCSubmitViewController.h"
#import "TCSeleAdressTableViewCell.h"
#import "TCOrderGoodsTableViewCell.h"
#import "TCSpecialTableViewCell.h"
#import "TCPaymentTableViewCell.h"
#import "TCAllPriceTableViewCell.h" //全部的总价
#import "TCPeisongTableViewCell.h" //配送
#import "TCYouhuiTableViewCell.h" //优惠活动
#import "TCHongbaoTableViewCell.h" //红包
#import "TCReaddressViewController.h"
#import "TCReaddressInfo.h"
#import "TCShopDataBase.h"
#import "TCGroupDataBase.h"
#import "TCGoodsInfo.h"
#import "TCShierViewController.h"  //支付
#import "TCChooseDiscountController.h" //优惠券
#import "AppDelegate.h"

@interface TCSubmitViewController ()<UITableViewDelegate,UITableViewDataSource,tapkeyWordDelegete,adressDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UITableView *listTabelView;
@property (nonatomic, strong) NSString *nameStr; //姓名
@property (nonatomic, strong) NSString *telStr; //电话
@property (nonatomic, strong) NSString *adressStr; //地址
@property (nonatomic, strong) NSDictionary *adressDic; //地址传值
@property (nonatomic, strong) FMDatabase *database;
@property (nonatomic, strong) TCGroupDataBase *groupDataBase;
@property (nonatomic, strong) NSMutableArray *shopGoodsArray;
@property (nonatomic, strong) NSMutableArray *hongbaoArray; //红包的优惠券的数组
@property (nonatomic, strong) NSMutableArray *activeArr; //活动的数组
@property (nonatomic, strong) NSArray *shopArr;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *allP; //总价
@property (nonatomic, strong) NSString *numGoods; //商品数量
@property (nonatomic, strong) NSString *goodTypes; //商品类型
@property (nonatomic, strong) NSString *remarkStr;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, assign) float allSPrice;
@property (nonatomic, strong) NSString *timeStr; //时间

@property (nonatomic, strong) NSString *youhuiMoney; //红包
@property (nonatomic, strong) NSString *youhuiID;
@property (nonatomic, strong) NSString *you_MoneyStr; //优惠券的传值
@end

@implementation TCSubmitViewController


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //通知回传的地址
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getadd:) name:@"shopbackaddress" object:nil];
    //通知回传的备注信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remake:) name:@"remakeNoti" object:nil];
    //如果不是再来一单
    if (!_zailai) {
        //团购
        if ([self.typeStr isEqualToString:@"1"]){
            //初始化数据库
            self.groupDataBase = [[TCGroupDataBase alloc] initTCDataBase];
            [self jisuantuangou]; //计算团购的 后台返回数据真乱 没办法
        } else {
            [self bianliSQL];//遍历数据库
        }
    }else{
        //用来获取记录的值
        [self jisuanyuanjia];
    }
    //请求红包的接口
    [self createHongBao];
    //请求商品详情啊
//    [self createGoodsDis];
//    [self.listTabelView reloadData];
}

//备注信息
- (void)remake:(NSNotification *)not
{
    NSLog(@"%@",not.userInfo);
    self.remarkStr = not.userInfo[@"remak"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TCBgColor;
    self.title = @"提交订单";
    self.shopGoodsArray = [NSMutableArray array];
    self.activeArr = [NSMutableArray array];
    self.hongbaoArray = [NSMutableArray array];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    _database = [FMDatabase databaseWithPath:SqlPath];
    //请求商品详情啊
    [self createGoodsDis];
    //再来一单传过来的
    if (_zailai){
        //再来一单传过来的
        self.adressDic = self.messDic[@"address"];
        self.remarkStr = self.messDic[@"remark"];
    }
    //创建历史记录的tableView
    self.listTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - StatusBarAndNavigationBarHeight - TabbarSafeBottomMargin - 48) style:UITableViewStyleGrouped];
    self.listTabelView.delegate = self;
    self.listTabelView.dataSource = self;
    self.listTabelView.backgroundColor = TCBgColor;
    self.listTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview: self.listTabelView];
    //解决ios11的导航栏布局的问
    AdjustsScrollViewInsetNever (self,self.listTabelView);
    // Do any additional setup after loading the view.
}

#pragma mark -- 店铺活动的接口
- (void)createShopDiscounts
{
    [self.activeArr removeAllObjects];
    //请求接口
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userToken"]];
    
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"shopid":self.shopIDStr,@"order_money":self.allP};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    NSDictionary *paramers = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"shopid":self.shopIDStr,@"order_money":self.allP,@"sign":signStr};
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102016"] paramter:paramers success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        if (jsonDic[@"data"]){
             [self.activeArr addObject:jsonDic[@"data"]];
            //用来获取记录的值
            [self jisuanyuanjia];
        } else {
            NSLog(@"无活动");
        }
        NSLog(@"%@--%@",jsonDic,jsonStr);
//        //请求红包的接口
//        [self createHongBao];
        [self.listTabelView reloadData];
        
    } failure:^(NSError *error) {
        nil;
    }];
}

#pragma mark -- 请求红包的接口
- (void) createHongBao
{
    [ProgressHUD showHUDToView:self.view];

    [self.hongbaoArray removeAllObjects];
    //请求接口
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userToken"]];
    
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"money":self.you_MoneyStr};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    NSDictionary *paramers = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"money":self.you_MoneyStr,@"sign":signStr};
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102025"] paramter:paramers success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@--%@",jsonDic,jsonStr);
        
        NSArray *arr = jsonDic[@"data"];
        for (NSDictionary *dic in arr) {
            [self.hongbaoArray addObject:dic];
        }
        NSLog(@"--这里是红包的接口%@",self.hongbaoArray);
        [self.listTabelView reloadData];
        [ProgressHUD hiddenHUD:self.view];

    } failure:^(NSError *error) {
        nil;
    }];
}

//选择地址返回信息
- (void)getadd:(NSNotification *)not{
    
    self.adressDic = not.userInfo[@"addarr"];
    [self.listTabelView reloadData];
}

//订单详情的接口啊
- (void)createGoodsDis
{
    [ProgressHUD showHUDToView:self.view];
    //请求接口
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userToken"]];
    
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"shopid":self.shopIDStr};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    NSDictionary *paramers = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"shopid":self.shopIDStr,@"sign":signStr};
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"101005"] paramter:paramers success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@--%@",jsonDic,jsonStr);
        if ([self.typeStr isEqualToString:@"1"]){
            
        } else {
            self.orderDisDic = jsonDic[@"data"];
        }
        //下单时可以使用的店铺优惠的接口
        [self createShopDiscounts];
        
        [self.listTabelView reloadData];

        [ProgressHUD hiddenHUD:self.view];
    } failure:^(NSError *error) {
        nil;
    }];
}

//创建底部的View
- (void)createBottomView
{
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    bottomView.frame = CGRectMake(0, HEIGHT - 48, WIDTH, 48);
    [self.view addSubview:bottomView];
    
    //金额
    UILabel *moneyTitleLabel = [UILabel publicLab:[NSString stringWithFormat:@"金额：¥%.2f",_allSPrice] textColor:TCUIColorFromRGB(0x4C4C4C) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    [self fuwenbenLabel:moneyTitleLabel FontNumber:[UIFont fontWithName:@"PingFangSC-Semibold" size:16] AndRange:NSMakeRange(3, self.allP.length + 1) AndColor:TCUIColorFromRGB(0xFF3355)];
    moneyTitleLabel.frame = CGRectMake(18, 0, WIDTH - 120, 48);
    [bottomView addSubview:moneyTitleLabel];
    
    //去支付按钮
    UIButton *goPayBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    goPayBtn.frame = CGRectMake(WIDTH - 120, 0, 120, 48);
    goPayBtn.backgroundColor = TCUIColorFromRGB(0xF99E20);
    [goPayBtn setTitle:@"去支付" forState:(UIControlStateNormal)];
    [goPayBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    goPayBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [goPayBtn addTarget:self action:@selector(goPat:) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:goPayBtn];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1){
        return _shopMuArr.count;
    } else if (section == 2){
        if (_hongbaoArray.count > 0){
            return 1 + 1 + _activeArr.count + 1;
        } else {
            return 1 + 1 + _activeArr.count;
        }
    } else {
        return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //商铺信息
    if (section == 1){
        UIView *headView = [[UIView alloc] init];
        headView.frame = CGRectMake(0, 0, WIDTH, 48 + 8);
        headView.backgroundColor = TCBgColor;
        //店铺View
        UIView *shopheadView = [[UIView alloc] init];
        shopheadView.frame = CGRectMake(8, 8, WIDTH - 16, 48);
        shopheadView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
        [headView addSubview:shopheadView];
        //店铺的图片
       UIImageView *shopImage = [[UIImageView alloc] init];
        //从再来一单进来的
        if (self.agianDic){
            [shopImage sd_setImageWithURL:[NSURL URLWithString:self.agianDic[@"shop"][@"headPic"]] placeholderImage:[UIImage imageNamed:@"商品详情页占位"]];
        } else {
            //团购和普通订单
            if ([self.typeStr isEqualToString:@"1"]){
                shopImage.image = [UIImage imageNamed:@"167"];
            } else {
            [shopImage sd_setImageWithURL:[NSURL URLWithString:self.messDic[@"headPic"]] placeholderImage:[UIImage imageNamed:@"商品详情页占位"]];
            }
        }
        
        shopImage.frame = CGRectMake(8, (48 - 24)/2, 24, 24);
        shopImage.layer.cornerRadius = 2;
        shopImage.layer.masksToBounds = YES;
        [shopheadView addSubview:shopImage];
        
        //店铺名称
        UILabel *shopTitleLabel = [UILabel publicLab:nil textColor:TCUIColorFromRGB(0x333333) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
        //团购和普通订单
        if (self.agianDic){
            shopTitleLabel.text = self.agianDic[@"shop"][@"name"];
        } else {
            //从再来一单进来的
            if ([self.typeStr isEqualToString:@"1"]) {
                //团购
                shopTitleLabel.text = @"顺道嘉团购";
            } else {
                shopTitleLabel.text = self.messDic[@"name"];
            }
        }
        shopTitleLabel.frame = CGRectMake(CGRectGetMaxX(shopImage.frame) + 8, 0, WIDTH - 12 - (CGRectGetMaxX(shopImage.frame) + 8), 48);
        [shopheadView addSubview:shopTitleLabel];
        return headView;
        
    } else if (section == 2){
        UIView *headView_two = [[UIView alloc] init];
        headView_two.frame = CGRectMake(0, 0, WIDTH, 3);
        headView_two.backgroundColor = TCBgColor;
        
        UIView *writhheadView = [[UIView alloc] init];
        writhheadView.frame = CGRectMake(8, 0, WIDTH - 16, 3);
        writhheadView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
        [headView_two addSubview:writhheadView];
        return headView_two;
    }
    return [[UIView alloc] init];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 3){
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.qh_width, 40)];
        footerView.backgroundColor = TCBgColor;
        return footerView;
    }
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1){
        return 48 + 8;
    } else if (section == 2){
        return 1;
    }
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 3){
        return 40;
    }
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 定义唯一标识
    static NSString *CellIdentifier = @"Cell";
    // 通过indexPath创建cell实例 每一个cell都是单独的
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = TCBgColor;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;//设置cell点击效果
    
    if (indexPath.section == 0){
        //选择收货地址
        NSString *typeStr;
        if (self.listGroup == YES || [self.typeStr isEqualToString:@"1"]){
            typeStr = @"1";
        } else if (self.agianDic){
            typeStr = [NSString stringWithFormat:@"%@",self.agianDic[@"type"]];
        } else {
            typeStr = [NSString stringWithFormat:@"%@",self.orderDisDic[@"data"][@"type"]];
        }
        TCSeleAdressTableViewCell *adresscell = [[TCSeleAdressTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"adresscell" andDic:self.adressDic andType:typeStr];
        
        adresscell.selectionStyle = UITableViewCellSelectionStyleNone;
        adresscell.delegate = self;
        adresscell.locationImage.frame = CGRectMake(8,(adresscell.clickView.frame.size.height - 20)/2 , 14, 16);
        adresscell.backgroundColor = TCBgColor;
       
        return adresscell;
    } else if (indexPath.section == 1){
        //店铺信息
        TCOrderGoodsTableViewCell *Goodscell = [[TCOrderGoodsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Goodscell"];
        
        if (self.shopMuArr.count == 0){
            NSLog(@"无");
        } else {
            for (int i = 0; i < _shopMuArr.count; i++) {
                TCGoodsInfo *model;
                if ([self.typeStr isEqualToString:@"1"] && _zailai == NO){
                   model = [TCGoodsInfo orderInfoWithDictionary:_shopMuArr[i] andType:@"4"];
                } else if ([self.typeStr isEqualToString:@"1"] && _zailai == YES){
                    //再来，这反的
                    model = [TCGoodsInfo orderInfoWithDictionary:_shopMuArr[i] andType:@"5"];
                } else {
                   model = [TCGoodsInfo orderInfoWithDictionary:_shopMuArr[i] andType:@"1"];
                }
               
                [self.shopGoodsArray addObject:model];
            }
            TCGoodsInfo *model = self.shopGoodsArray[indexPath.row];
            Goodscell.model = model;
        }
        Goodscell.selectionStyle = UITableViewCellSelectionStyleNone;
        Goodscell.backgroundColor = TCBgColor;
        return Goodscell;
    } else if (indexPath.section == 2){
        if (indexPath.row == 0){
            //配送
            //团购
            TCPeisongTableViewCell *cell;
            if ([self.typeStr isEqualToString:@"1"]){
               cell = [[TCPeisongTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2" andPeisong:self.disPriceStr];
            } else {
               cell = [[TCPeisongTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2" andPeisong:_messDic[@"distributionPrice"]];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return  cell;
        } else if (indexPath.row == 1){
            if (_activeArr.count != 0 && _hongbaoArray.count == 0){
                //优惠活动
                TCYouhuiTableViewCell *cellYouhui = [[TCYouhuiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3" andmes:_activeArr[indexPath.row - 1]];
                cellYouhui.selectionStyle = UITableViewCellSelectionStyleNone;
                return cellYouhui;
            } else if (_activeArr.count == 0 && _hongbaoArray.count != 0){
                //红包
                TCHongbaoTableViewCell *Hongbaocell = [[TCHongbaoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell4" andmes:_hongbaoArray andmoney:self.youhuiMoney];
                Hongbaocell.tap = ^{
                    TCChooseDiscountController *mydisVC = [[TCChooseDiscountController alloc] init];
                    mydisVC.hidesBottomBarWhenPushed = YES;
                    mydisVC.myBlock = ^(NSString *valueStr, NSString *valueID) {
                        NSLog(@"%@ %@",valueStr,valueID);
                        self.youhuiMoney = valueStr;
                        self.youhuiID = valueID;
                        [self.listTabelView reloadData];
                    };
                    mydisVC.moneyStr = self.allP;
                    [self.navigationController pushViewController:mydisVC animated:YES];
                };
                Hongbaocell.selectionStyle = UITableViewCellSelectionStyleNone;
                return Hongbaocell;
            } else if (_activeArr.count != 0 && _hongbaoArray.count != 0){
                //优惠活动
                TCYouhuiTableViewCell *cellYouhui = [[TCYouhuiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3" andmes:_activeArr[indexPath.row - 1]];
                cellYouhui.selectionStyle = UITableViewCellSelectionStyleNone;
                return cellYouhui;
            } else {
                //总价
                TCAllPriceTableViewCell *Pricecell = [[TCAllPriceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell5" andallp:_allSPrice andGoodsNum:self.numGoods andAllNum:self.goodTypes andStyle:@"1"];
                Pricecell.selectionStyle = UITableViewCellSelectionStyleNone;
                return Pricecell;
            }
        } else if (indexPath.row == 2){
             if (_activeArr.count != 0 && _hongbaoArray.count != 0){
                 //红包
                 TCHongbaoTableViewCell *Hongbaocell = [[TCHongbaoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell4" andmes:_hongbaoArray andmoney:self.youhuiMoney];
                 Hongbaocell.tap = ^{
                     TCChooseDiscountController *mydisVC = [[TCChooseDiscountController alloc] init];
                     mydisVC.hidesBottomBarWhenPushed = YES;
                     mydisVC.myBlock = ^(NSString *valueStr, NSString *valueID) {
                         NSLog(@"%@ %@",valueStr,valueID);
                         self.youhuiMoney = valueStr;
                         self.youhuiID = valueID;
                         [self.listTabelView reloadData];
                     };
                     mydisVC.moneyStr = self.allP;
                     [self.navigationController pushViewController:mydisVC animated:YES];
                 };
                 Hongbaocell.selectionStyle = UITableViewCellSelectionStyleNone;
                 return Hongbaocell;
             } else {
                 //总价
                 TCAllPriceTableViewCell *Pricecell = [[TCAllPriceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell5" andallp:_allSPrice andGoodsNum:self.numGoods andAllNum:self.goodTypes andStyle:@"1"];
                 Pricecell.selectionStyle = UITableViewCellSelectionStyleNone;
                 return Pricecell;
             }
        } else {
            //总价
            TCAllPriceTableViewCell *Pricecell = [[TCAllPriceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell5" andallp:_allSPrice andGoodsNum:self.numGoods andAllNum:self.goodTypes andStyle:@"1"];
            Pricecell.selectionStyle = UITableViewCellSelectionStyleNone;
            return Pricecell;
        }
    } else if (indexPath.section == 3){
        TCPaymentTableViewCell *paymentscell = [[TCPaymentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"paymentscell"];
        //再来一单进来的
        if (self.agianDic){
            paymentscell.textView.text = self.agianDic[@"remark"];
            paymentscell.placLabel.hidden = YES;
        }
        paymentscell.delegate = self;
        paymentscell.selectionStyle = UITableViewCellSelectionStyleNone;
        paymentscell.backgroundColor = TCBgColor;
        return paymentscell;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        if (self.adressDic == nil){
            return 46 + 50;
        } else {
            return 46 + 90;
        }
    } else if (indexPath.section == 1){
        return 84;
    } else if (indexPath.section == 2){
        if (self.hongbaoArray.count != 0 && self.activeArr.count != 0){
            if (indexPath.row < 3){
                return 46;
            } else {
                return 68;
            }
        } else if (self.hongbaoArray.count == 0 && self.activeArr.count != 0) {
            if (indexPath.row < 2){
                return 46;
            } else {
                return 68;
            }
        } else if (self.hongbaoArray.count != 0 && self.activeArr.count == 0){
            if (indexPath.row < 2){
                return 46;
            } else {
                return 68;
            }
        } else {
            if (indexPath.row == 0){
                return 46;
            } else {
                return 68;
            }
        }
        return 68;
    } else if (indexPath.section == 3){
        return 46 + 68;
    }
    return 46 + 50;
}

//遍历数据库
- (void)bianliSQL{
    //获取之前先移除之前数据
    [_shopMuArr removeAllObjects];
    //遍历数据库  更改底部购物车view的数据
    if ([_database open]) {
        FMResultSet *res = [_database executeQuery:@"select *from newShopCar where storeid = ?", self.shopIDStr];
        while ([res next]) {
            NSDictionary *dic = @{@"id":[res stringForColumn:@"shopid"], @"price":[res stringForColumn:@"shopprice"], @"amount":[res stringForColumn:@"shopcount"], @"name":[res stringForColumn:@"shopname"], @"pic":[res stringForColumn:@"shopPic"], @"stockcount":[res stringForColumn:@"stockcount"]};
            [_shopMuArr addObject: dic];
        }
    }
    
    //去除数组中数量为0的元素
    NSMutableArray *muarr = [NSMutableArray array];
    for (int i = 0; i < _shopMuArr.count; i++) {
        if ([_shopMuArr[i][@"amount"] intValue] != 0) {
            //如果不等于0  取出
            [muarr addObject:_shopMuArr[i]];
        }
    }
    [_shopMuArr removeAllObjects];
    //重新赋值
    _shopMuArr = muarr;
    [_listTabelView reloadData];
    
    //计算原价
    [self jisuanyuanjia];
}

//计算团购的价格  字段都不一样（艹）
- (void)jisuantuangou
{
    //获取不打折时总价
    _allSPrice = 0.00;
    int y = 0;
    for (int i = 0; i < _shopMuArr.count; i++) {
        _allSPrice += [_shopMuArr[i][@"shopCount"] floatValue] * [_shopMuArr[i][@"shopSpecPrice"] floatValue];
        y += [_shopMuArr[i][@"shopCount"] intValue];
    }
    //加上配送费
    _allSPrice = _allSPrice + [self.disPriceStr floatValue];
    self.allP = [NSString stringWithFormat:@"%.2f",_allSPrice];
    
    //几种商品共计几件
    self.numGoods = [NSString stringWithFormat:@"%d",y];
    self.goodTypes = [NSString stringWithFormat:@"%lu", (unsigned long)_shopMuArr.count];
}

//计算原价
- (void)jisuanyuanjia
{
    //获取不打折时总价
    _allSPrice = 0.00;
    int y = 0;
    for (int i = 0; i < _shopMuArr.count; i++) {
        _allSPrice += [_shopMuArr[i][@"amount"] floatValue] * [_shopMuArr[i][@"price"] floatValue];
        y += [_shopMuArr[i][@"amount"] intValue];
    }
    
    if (self.activeArr != 0){
        for (int i = 0; i < _activeArr.count; i++) {
            _allSPrice -= [_activeArr[i][@"reduce"] floatValue];
        }
    }
    //传入的优惠券的值
    self.you_MoneyStr = [NSString stringWithFormat:@"%.2f",_allSPrice];
    
    if (self.youhuiMoney){
        _allSPrice -= [self.youhuiMoney floatValue];
    }
    
    //加上配送费
    _allSPrice = _allSPrice + [self.messDic[@"distributionPrice"] floatValue];
    self.allP = [NSString stringWithFormat:@"%.2f",_allSPrice];

    //几种商品共计几件
    self.numGoods = [NSString stringWithFormat:@"%d",y];
    self.goodTypes = [NSString stringWithFormat:@"%lu", (unsigned long)_shopMuArr.count];
    
    [self createBottomView];
}
#pragma mark -- 键盘上下滑
- (void)sendGlideValue
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@ "ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    //恢复屏幕
    self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    [self.view endEditing:YES];
}

- (void)upglideValue
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@ "ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    //将视图的Y坐标向上移动，以使下面腾出地方用于软键盘的显示
    /*屏幕上移的高度，可以自己定*/
    self.view.frame = CGRectMake(0.0f,- 216 + 40, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@ "ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    //恢复屏幕
    self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    [self.view endEditing:YES];
}

//设置不同字体颜色
-(void)fuwenbenLabel:(UILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labell.text];
    
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    
    labell.attributedText = str;
}

#pragma mark -- 选择地址
- (void)adressTap
{
    TCReaddressViewController *ReaddressVC = [[TCReaddressViewController alloc] init];
    
    ReaddressVC.typeStr = @"1";
    [self.navigationController pushViewController:ReaddressVC animated:YES];
}

#pragma mark -- 选择上门服务的时间
- (void)timeSecletTap:(NSString *)timeStrss
{
    NSLog(@"%@",timeStrss);
    self.timeStr = timeStrss;
}

#pragma mark -- 去支付
- (void)goPat:(UIButton *)sender
{
    NSLog(@"去支付");
    if (self.adressDic == nil){
        [TCProgressHUD showMessage:@"请选择您的地址"];
    } else {
        //上门服务
        NSString *typeStr = [NSString stringWithFormat:@"%@",self.orderDisDic[@"data"][@"type"]];
        if ([typeStr isEqualToString:@"2"]){
            [self creteOrder:typeStr];
        } else {
            //请求创建订单的接口
            [self creteOrder:self.typeStr];
        }
    }
}

//创建订单的接口
- (void)creteOrder:(NSString *)typeStr
{
    [ProgressHUD showHUDToView:self.view];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userToken"]];
    NSString *timeStr = [TCGetTime getCurrentTime];
    
    NSMutableArray *commitArr = [NSMutableArray array];
    NSDictionary *jsonDic;
   
     //从团购和普通来的
    for (int i = 0; i < self.shopMuArr.count ; i++) {
        //无规格，订单传值0
        if ([typeStr isEqualToString:@"0"] || [typeStr isEqualToString:@"2"] ){ //普通商超的
            //此处应传specID
            jsonDic = @{@"goodsid":self.shopMuArr[i][@"id"], @"amount":self.shopMuArr[i][@"amount"], @"specid":@"0",@"name":self.shopMuArr[i][@"name"]};
        } else {
            if (_zailai == YES){
                //此处应传specID //团购再来一单
                jsonDic = @{@"goodsid":self.shopMuArr[i][@"id"], @"amount":self.shopMuArr[i][@"amount"], @"specid":self.shopMuArr[i][@"specID"],@"name":self.shopMuArr[i][@"name"]};
            } else {
                //此处应传specID
                jsonDic = @{@"goodsid":self.shopMuArr[i][@"shopID"], @"amount":self.shopMuArr[i][@"shopCount"], @"specid":self.shopMuArr[i][@"shopSpecID"],@"name":self.shopMuArr[i][@"name"]};
            }
        }
        [commitArr addObject: jsonDic];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:commitArr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strs = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];

    //好多判断
    //判断有无备注
    NSDictionary *messDic;
    NSDictionary *paramters;
    NSString *signStr;
    NSString *activeID;
    NSString *youhuiIDStr; //优惠券的ID
    
    //活动ID  红包ID
    if (self.activeArr.count != 0){
        for (int i = 0; i < _activeArr.count; i++) {
            activeID = _activeArr[i][@"id"];
        }
    } else {
        activeID = @"0";
    }
    
    //有无优惠券
    if (self.youhuiID){
        youhuiIDStr = self.youhuiID;
    } else {
        youhuiIDStr = @"0";
    }
    
    if ([self.remarkStr isEqualToString:@""] || self.remarkStr == nil){
        //上门服务订单
        if ([typeStr isEqualToString:@"2"]){
            messDic = @{@"tillTime":self.timeStr,@"timestamp":timeStr,@"mid":midStr,@"token":tokenStr,@"shopid":self.shopIDStr,@"price":self.allP,@"goods":strs,@"deviceid":[TCGetDeviceId getDeviceId],@"addressid":self.adressDic[@"id"],@"type":typeStr,@"actid":activeID,@"cpid":youhuiIDStr};
            signStr = [TCServerSecret signStr:messDic];
            paramters = @{@"tillTime":self.timeStr,@"timestamp":timeStr,@"mid":midStr,@"token":tokenStr,@"shopid":self.shopIDStr,@"price":self.allP,@"goods":strs,@"deviceid":[TCGetDeviceId getDeviceId],@"addressid":self.adressDic[@"id"],@"type":typeStr,@"sign":signStr,@"actid":activeID,@"cpid":youhuiIDStr};
        } else {
            //商超订单
            messDic = @{@"timestamp":timeStr,@"mid":midStr,@"token":tokenStr,@"shopid":self.shopIDStr,@"price":self.allP,@"goods":strs,@"deviceid":[TCGetDeviceId getDeviceId],@"addressid":self.adressDic[@"id"],@"type":typeStr,@"actid":activeID,@"cpid":youhuiIDStr};
            signStr = [TCServerSecret signStr:messDic];
            paramters = @{@"timestamp":timeStr,@"mid":midStr,@"token":tokenStr,@"shopid":self.shopIDStr,@"price":self.allP,@"goods":strs,@"deviceid":[TCGetDeviceId getDeviceId],@"addressid":self.adressDic[@"id"],@"type":typeStr,@"sign":signStr,@"actid":activeID,@"cpid":youhuiIDStr};
            }
        } else {
            messDic = @{@"timestamp":timeStr,@"mid":midStr,@"token":tokenStr,@"shopid":self.shopIDStr,@"price":self.allP,@"goods":strs,@"remark":self.remarkStr,@"deviceid":[TCGetDeviceId getDeviceId],@"addressid":self.adressDic[@"id"],@"type":typeStr,@"actid":activeID,@"cpid":youhuiIDStr};
            signStr = [TCServerSecret signStr:messDic];
            paramters = @{@"timestamp":timeStr,@"mid":midStr,@"token":tokenStr,@"shopid":self.shopIDStr,@"price":self.allP,@"goods":strs,@"remark":self.remarkStr,@"deviceid":[TCGetDeviceId getDeviceId],@"addressid":self.adressDic[@"id"],@"type":typeStr,@"sign":signStr,@"actid":activeID,@"cpid":youhuiIDStr};
    }
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"101009"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"Dic = %@,Str = %@",jsonDic,jsonStr);
        NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        NSString *orderidStr = [NSString stringWithFormat:@"%@",jsonDic[@"data"][@"orderid"]];
        if ([codeStr isEqualToString:@"1"]){
            TCShierViewController *shierVC = [[TCShierViewController alloc] init];
            shierVC.orderidStr = orderidStr;
            shierVC.priceGoods = self.allP;
            shierVC.headImageStr = self.agianDic[@"shop"][@"headPic"];
            shierVC.shopName = self.agianDic[@"shop"][@"name"];
            shierVC.rmakStr = self.remarkStr;
            shierVC.adressDic = self.adressDic;
            shierVC.typeStr = self.typeStr;
            [self.navigationController pushViewController:shierVC animated:YES];
            
            //支付成功后清除购物车
            if ([self.typeStr isEqualToString:@"1"]){
                [self.groupDataBase deleteShops:self.shopIDStr];
            } else {
                //要求前一个页面刷新数据
                BOOL success = [_database executeUpdate:@"delete from newShopCar where storeid = ?", self.shopIDStr];
                if (success) {
                    NSLog(@"成功清除购物车");
                    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                    delegate.iscate = NO;
              }
           }
        }
        [TCProgressHUD showMessage:jsonDic[@"msg"]];
        [ProgressHUD hiddenHUD:self.view];
    } failure:^(NSError *error) {
        nil;
    }];
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
