//
//  TCReaddressViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/30.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCReaddressViewController.h"
#import "TCReaddressTableViewCell.h"
#import "TCAddressViewController.h"
#import "TCReaddressInfo.h"

@interface TCReaddressViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSUserDefaults *userdefaults;
@property (nonatomic, strong) NSMutableArray *adressArr; //地址传值

@end

@implementation TCReaddressViewController

#pragma mark -- 懒加载数组
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableArray *)adressArr {
    if (!_adressArr) {
        _adressArr = [NSMutableArray array];
    }
    return _adressArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"收货地址";
    self.view.backgroundColor = TCBgColor;
    self.userdefaults = [NSUserDefaults standardUserDefaults];

    //添加地址或者修改地址通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shuaxinadress) name:@"shuaxinadress" object:nil];
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateadress) name:@"updateadress" object:nil];
    
    [self tableListView];
    //请求接口
    [self requestAdress];
   
    [self bottomView];
    
    // Do any additional setup after loading the view.
}
//刷新
- (void)shuaxinadress
{
    [self requestAdress];
}
//刷新页面
- (void)updateadress
{
   [self requestAdress];
}

//创建tableView
- (void)tableListView {
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,StatusBarAndNavigationBarHeight, WIDTH, HEIGHT -  48 - TabbarSafeBottomMargin - StatusBarAndNavigationBarHeight) style:(UITableViewStyleGrouped)];
    self.mainTableView.bounces = YES;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.rowHeight = 126;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    AdjustsScrollViewInsetNever(self,self.mainTableView);
    //ios11解决点击刷新跳转的问题
    self.mainTableView.estimatedRowHeight = 0;
    self.mainTableView.estimatedSectionHeaderHeight = 0;
    self.mainTableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:self.mainTableView];
}

// 创建底部视图
- (void)bottomView {
    
    UIView *addView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - 48 - TabbarSafeBottomMargin, WIDTH, 48 + TabbarSafeBottomMargin)];
    addView.backgroundColor = TCUIColorFromRGB(0xF99E20);
    //为addView添加单击手势
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAdd:)];
    
    [addView addGestureRecognizer:singleRecognizer];
    
    [self.view addSubview:addView];
    
    UIImageView *addImage = [[UIImageView alloc]initWithFrame:CGRectMake((WIDTH - 88)/2, 19, 16, 16)];
    addImage.image = [UIImage imageNamed:@"添加白色"];
    [addView addSubview:addImage];
    
    UILabel *addLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(addImage.frame) + 8, 16, 64, 22)];
    addLabel.text = @"新增地址";
    addLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    addLabel.textColor = TCUIColorFromRGB(0xFFFFFF);
    [addView addSubview:addLabel];
}
- (void)requestAdress{
    
    [ProgressHUD showHUDToView:self.view];
    
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];

    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];

    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"sign":signStr};
    NSLog(@"%@",paramters);

    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102006"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
       
        [ProgressHUD hiddenHUD:self.view];
        if (jsonDic[@"data"]){
            [self.dataArr removeAllObjects];
            [self.adressArr removeAllObjects];
            for (NSDictionary *infoDic in jsonDic[@"data"]) {
                TCReaddressInfo *model = [TCReaddressInfo readdressInfoWithDictionary:infoDic];
                [self.dataArr addObject:model];
                [self.adressArr addObject:infoDic];
            }
        } else {
            [TCProgressHUD showMessage:jsonDic[@"msg"]];
        }
        //占位图
        [self NeedResetNoView];
        [self.mainTableView reloadData];
    } failure:^(NSError *error) {
        nil;
    }];
}
- (void)NeedResetNoView{
    if (self.dataArr.count >0) {
        [self.mainTableView dismissNoView];
    }else{
        [self.mainTableView showNoView:@"暂无收货地址" image: [UIImage imageNamed:@"暂无店铺插图"] certer:CGPointZero];
    }
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TCReaddressInfo *model = self.dataArr[indexPath.section];
     return model.cellHight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return 12;
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
    TCReaddressTableViewCell *cell = [[TCReaddressTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    //删除
    [cell.delebuton addTarget:self action:@selector(dele:) forControlEvents:(UIControlEventTouchUpInside)];
    //编辑
    [cell.buton addTarget:self action:@selector(change:) forControlEvents:(UIControlEventTouchUpInside)];
    if (self.dataArr.count != 0){
        TCReaddressInfo *model = self.dataArr[indexPath.section];
        cell.model = model;
    } else {
        NSLog(@"无数据");
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%lu",indexPath.section);
    if ([self.typeStr isEqualToString:@"1"]) {
        //发送通知 将地址信息返回
        [[NSNotificationCenter defaultCenter]postNotificationName:@"shopbackaddress" object:nil userInfo:@{@"addarr":self.adressArr[indexPath.section]}];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
    }
   
}
#pragma mark -- 点击编辑
- (void)change:(UIButton *)sender{
    //请求接口
    UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
    // 获取cell的indexPath
    NSIndexPath *indexPath = [self.mainTableView indexPathForCell:cell];
    TCReaddressInfo *model = self.dataArr[indexPath.section];
    TCAddressViewController *AddressVC = [[TCAddressViewController alloc]init];
    
    AddressVC.dic = model.dicMess;
    
    AddressVC.isChange = YES;
    [self.navigationController pushViewController:AddressVC animated:YES];
}

#pragma mark -- 点击删除
- (void)dele:(UIButton *)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"收货地址删除后不可恢复,是否确认删除?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //请求删除的接口
        //请求接口
        UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
        // 获取cell的indexPath
        NSIndexPath *indexPath = [self.mainTableView indexPathForCell:cell];
        TCReaddressInfo *model = self.dataArr[indexPath.section];
        
        NSString *timeStr = [TCGetTime getCurrentTime];
        NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
        NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
        
        NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"addressId":model.messId};
        NSString *signStr = [TCServerSecret signStr:dic];
        
        NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"sign":signStr,@"addressId":model.messId};
        [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102007"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
            NSLog(@"%@,%@",jsonDic,jsonStr);
            NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
            if ([codeStr isEqualToString:@"1"]) {
                if (self.dataArr.count != 0) {
                    [self.dataArr removeObjectAtIndex:indexPath.section];
                }
                [self.mainTableView deselectRowAtIndexPath:indexPath animated:YES];
                [self requestAdress];
            } else {
                [TCProgressHUD showMessage:jsonDic[@"msg"]];
            }
          //成功后返回更新
        } failure:^(NSError *error) {
            nil;
        }];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

#pragma mark -- 点击添加
-(void)clickAdd:(UIGestureRecognizer *)sender{
    NSLog(@"点击进入添加地址页面");
    TCAddressViewController *AddressVC = [[TCAddressViewController alloc]init];
    AddressVC.enterStr = @"1";
    AddressVC.typeStr = self.typeStr;
    AddressVC.isChange = NO;
    [self.navigationController pushViewController:AddressVC animated:YES];
    
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
