//
//  TCShopCarViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/12.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCShopCarViewController.h"
#import "TCShoppingCarCell.h"
#import "TCGroupDataBase.h"
#import "TCSubmitViewController.h"
#import "TCGroupInfoModel.h"
#import "TCLoginViewController.h"
#import "TCGroupViewController.h"

@interface TCShopCarViewController ()<UITableViewDelegate,UITableViewDataSource,CheckNetworkDelegate>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSString *allpriceStr; //全部的价钱
@property (nonatomic, strong) TCGroupDataBase *groupDataBase;
@property (nonatomic, strong) TCGroupInfoModel *groupModel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) TCNoMessageView *nomessageView; //占位
@property (nonatomic, strong) NSUserDefaults *userDefaults; //保存本地


@end

@implementation TCShopCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物车";
    self.dataArr = [NSMutableArray array];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    //初始化数据库
    self.groupDataBase = [[TCGroupDataBase alloc] initTCDataBase];
    
    self.groupModel = [TCGroupInfoModel groupInfoWithDictionary:self.dicGroup[@"data"]];
    //遍历数据库
    [self bianLiFMDB];
    
    //创建View
    [self createUI];
    //创建tableView
    [self createTableView];
}

//遍历数据库
- (void)bianLiFMDB
{
    
    [self.dataArr removeAllObjects];
    
    NSMutableArray *groupArr = [self.groupDataBase bianliFMDB:self.shopID];
    NSLog(@"--%@",groupArr);
    if (groupArr.count == 0){
        [self.dataArr removeAllObjects];
    } else {
        for (NSDictionary *dic in groupArr) {
            TCShoppingCarInfo *goodsModel = [[TCShoppingCarInfo alloc]initWithDict:dic];
            [self.dataArr addObject:goodsModel];
        }
    }
    
    if (groupArr.count == 0){
        if (self.nomessageView){
            [self.nomessageView removeFromSuperview];
            self.nomessageView = [[TCNoMessageView alloc] initWithFrame:CGRectMake(0, 42 + StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - 42 - TabbarHeight - StatusBarAndNavigationBarHeight) AndImage:@"暂无商品插图" AndLabel:@"购物车暂无商品" andButton:@"去逛逛"];
            self.nomessageView.delegate = self;
            [self.view addSubview:self.nomessageView];
            
        } else {
            self.nomessageView = [[TCNoMessageView alloc] initWithFrame:CGRectMake(0, 42 + StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - 42 - TabbarHeight - StatusBarAndNavigationBarHeight) AndImage:@"暂无商品插图" AndLabel:@"购物车暂无商品" andButton:@"去逛逛"];
            self.nomessageView.delegate = self;
            [self.view addSubview:self.nomessageView];
        }
    }
    
    CGFloat x = 0.0;
    int y = 0;
    //获取商品的总价格
    for (int i = 0; i < groupArr.count ; i++) {
        float price = 0.0;
        if ([groupArr[i][@"shopSpec"] isEqualToString:@""]) {
            price = [groupArr[i][@"shopPrice"] floatValue];
        } else {
            price = [groupArr[i][@"shopSpecPrice"] floatValue];
        }
        x += [groupArr[i][@"shopCount"] floatValue] * price;
        y += [groupArr[i][@"shopCount"] intValue];
    }
    self.allpriceStr = [NSString stringWithFormat:@"%.2f", x];
    self.moneyLabel.text = [NSString stringWithFormat:@"¥ %@",self.allpriceStr];
    
}


#pragma mark -- 点击去逛逛
- (void)reloadData{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[TCGroupViewController class]]) {
            [self.navigationController.tabBarController setSelectedIndex:0];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
    }
}

//创建UI
- (void)createUI
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"删除"] forState:(UIControlStateNormal)];
    [rightBtn setTitle:@"清空" forState:(UIControlStateNormal)];
    rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    [rightBtn setTitleColor:TCUIColorFromRGB(0x666666) forState:(UIControlStateNormal)];
    [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0,20)];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0,50, 0, 0)];
    
    rightBtn.frame = CGRectMake(WIDTH - 30 - 12 - 20, 12, 70, 20);
    [rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    self.view.backgroundColor = TCBgColor;
}

-(void)createTableView{
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - 48 - StatusBarAndNavigationBarHeight - TabbarSafeBottomMargin) style:(UITableViewStyleGrouped)];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.backgroundColor = TCBgColor;
    AdjustsScrollViewInsetNever(self,self.mainTableView);
    [self.view addSubview:self.mainTableView];
    
    UIView *priceView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - 48, WIDTH - 120, 48)];
    priceView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:priceView];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.frame = CGRectMake(18, 13, 48, 22);
    priceLabel.text = @"金额：";
    priceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    priceLabel.textColor = TCUIColorFromRGB(0x4C4C4C);
    priceLabel.textAlignment = NSTextAlignmentLeft;
    [priceView addSubview:priceLabel];
    
    self.moneyLabel = [[UILabel alloc] init];
    self.moneyLabel.frame = CGRectMake(CGRectGetMaxX(priceLabel.frame), 13, WIDTH - 120 - 48 - 18 - 12, 22);
    self.moneyLabel.text = [NSString stringWithFormat:@"¥ %@",self.allpriceStr];
    self.moneyLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    self.moneyLabel.textColor = TCUIColorFromRGB(0xFF3355);
    self.moneyLabel.textAlignment = NSTextAlignmentLeft;
    [priceView addSubview:self.moneyLabel];
    
    UIButton *payBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(priceView.frame), HEIGHT - 48, 120, 48)];
    [payBtn setBackgroundColor:TCUIColorFromRGB(0xF99E20)];
    [payBtn setTitle:@"去支付" forState:(UIControlStateNormal)];
    [payBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    payBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    payBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [payBtn addTarget:self action:@selector(clickPay) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:payBtn];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//预防ios11错误
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.qh_width, 8)];
        headerView.backgroundColor = TCBgColor;
        return headerView;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 8;
    }
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TCShoppingCarCell *cell = [[TCShoppingCarCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shopCarcell" andModel:self.groupModel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TCShoppingCarInfo *model = self.dataArr[indexPath.section];
    cell.shopCarModel = model;
    __weak typeof(self) weakself = self;
    cell.needReloadData = ^{
        __strong typeof(weakself) strongself = weakself;
        //计算总金额
        [strongself getALLPrice];
    };
    
    [cell reloadTableview:^{
        __strong typeof(weakself) strongself = weakself;
        //遍历数据库
        [strongself getALLPrice];
        [self.mainTableView reloadData];
    }];
    
    return cell;
}

//重新计算总金额
- (void)getALLPrice {
    [self bianLiFMDB];
}

-(void)clickRightBtn:(UIButton *)sender{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清除购物车商品?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //清空购物车
        [self.groupDataBase deleteShops:self.shopID];
        [self.dataArr removeAllObjects];
        [self.mainTableView reloadData];
        
        //遍历数据库
        [self bianLiFMDB];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

-(void)clickPay{
    NSLog(@"去支付");
    if ([self.userDefaults valueForKey:@"userID"] == nil){
        TCLoginViewController *loginVC = [[TCLoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    } else {
        //遍历
        NSMutableArray *groupArr = [self.groupDataBase bianliFMDB:self.shopID];
        if (groupArr.count == 0){
            [TCProgressHUD showMessage:@"请选择您想要的商品"];
        } else {
            TCSubmitViewController *submitVC = [[TCSubmitViewController alloc] init];
           
            if (self.listGroup == YES){
                submitVC.disPriceStr = self.distributionPrice;
                submitVC.listGroup = YES;
            } else {
                submitVC.orderDisDic = self.dicGroup;
                submitVC.disPriceStr = self.dicGroup[@"data"][@"distributionPrice"];

            }
            submitVC.shopIDStr = self.shopID;
            submitVC.shopMuArr = groupArr;
            
            submitVC.typeStr = @"1";
            [self.navigationController pushViewController:submitVC animated:YES];
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
