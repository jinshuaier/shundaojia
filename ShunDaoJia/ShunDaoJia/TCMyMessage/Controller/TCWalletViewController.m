//
//  TCWalletViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/23.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCWalletViewController.h"
#import "TCWallTableViewCell.h"
#import "TCModiViewController.h"
#import "TCBalanceViewController.h"
#import "TCMyBankCardViewController.h"
#import "TCTransDetailViewController.h"
#import "TCCZViewController.h"

@interface TCWalletViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSUserDefaults *userdefaults;
@property (nonatomic, strong) UIButton *acBtn;
@property (nonatomic, strong) NSString *acmin;
@end

@implementation TCWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的钱包";
    self.view.backgroundColor = TCBgColor;
    self.userdefaults = [NSUserDefaults standardUserDefaults];
    [self request];
    [self createQuest];
    [self creatUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(banlance:)name:@"banlance" object:nil];
    // Do any additional setup after loading the view.
}
-(void)banlance:(NSNotification *)tap{
    [self createQuest];
}
-(void)createQuest{
    [ProgressHUD showHUDToView:self.view];
    //请求接口
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"sign":signStr};
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"104006"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        
        self.messDic = jsonDic[@"data"];
        [self.mainTableView reloadData];
        
        [ProgressHUD hiddenHUD:self.view];
        //成功后返回更新
    } failure:^(NSError *error) {
        nil;
    }];
}
-(void)request{
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];

    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"sign":signStr};

    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"101023"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@  %@",jsonDic,jsonStr);
        NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if ([codeStr isEqualToString:@"1"]) {
            self.acBtn.hidden = NO;
            NSString *titleStr = [NSString stringWithFormat:@"%@",jsonDic[@"data"][@"actTitle"]];
            NSString *actmin = [NSString stringWithFormat:@"%@",jsonDic[@"data"][@"actMin"]];
            self.acmin = actmin;
            [self.acBtn setTitle:titleStr forState:(UIControlStateNormal)];
        }
    } failure:^(NSError *error) {
        nil;
    }];
}

-(void)creatUI{
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - StatusBarAndNavigationBarHeight) style:(UITableViewStyleGrouped)];
    
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.scrollEnabled = NO;
    
    [self.mainTableView registerClass:[TCWallTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.mainTableView];
    AdjustsScrollViewInsetNever(self,self.mainTableView);
    
    UIButton *activeBt = [[UIButton alloc]initWithFrame:CGRectMake(12, HEIGHT - 170, WIDTH - 24, 48)];
    self.acBtn = activeBt;
    activeBt.backgroundColor = TCUIColorFromRGB(0xF99E20);
    activeBt.layer.masksToBounds = YES;
    activeBt.layer.cornerRadius = 4;
    [activeBt setTitle:@"充800返1000元" forState:(UIControlStateNormal)];
    [activeBt setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    activeBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [activeBt addTarget:self action:@selector(clickactive:) forControlEvents:(UIControlEventTouchUpInside)];
    activeBt.hidden = YES;
    [self.view addSubview:activeBt];
}

#pragma mark -- UITableViewDataSouce
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else{
        return 1;
    }
}
//预防ios11错误
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.qh_width, 12)];
        headerView.backgroundColor = TCBgColor;
        return headerView;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    TCWallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TCWallTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.setLabel.text = @"我的余额";
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(cell.setLabel.frame) + 14, WIDTH - 24, 0.5)];
            line.backgroundColor = TCUIColorFromRGB(0xDADADA);
            [cell.contentView addSubview:line];
            UIImageView *triangleImage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 12 - 5, 23, 5, 8)];
            triangleImage.image = [UIImage imageNamed:@"进入小三角（灰）"];
            [cell.contentView addSubview:triangleImage];
        }else if (indexPath.row == 1){
            if (self.messDic != nil) {
                cell.setLabel.text = [NSString stringWithFormat:@"¥%@",self.messDic[@"balance"]];
            } else {
                cell.setLabel.text = @"¥";
            }
            cell.messageLabel.text = @"不可提现";
            cell.messageLabel.hidden = YES;
        }
    }else if (indexPath.section == 1){
        cell.setLabel.text = @"绑定银行卡";
        UIImageView *triangleImage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 12 - 5, 23, 5, 8)];
        triangleImage.image = [UIImage imageNamed:@"进入小三角（灰）"];
        [cell.contentView addSubview:triangleImage];
    }else if (indexPath.section == 2){
        cell.setLabel.text = @"交易明细";
        UIImageView *triangleImage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 12 - 5, 23, 5, 8)];
        triangleImage.image = [UIImage imageNamed:@"进入小三角（灰）"];
        [cell.contentView addSubview:triangleImage];
    }else{
        cell.setLabel.text = @"设置支付密码";
        UIImageView *triangleImage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 12 - 5, 23, 5, 8)];
        triangleImage.image = [UIImage imageNamed:@"进入小三角（灰）"];
        [cell.contentView addSubview:triangleImage];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSLog(@"跳转进入我的余额");
        TCBalanceViewController *balanceVC = [[TCBalanceViewController alloc]init];
        balanceVC.mobile = self.mobile;
        balanceVC.isPay = self.isPay;
        balanceVC.messDic = self.messDic;
        [self.navigationController pushViewController:balanceVC animated:YES];
    }else if (indexPath.section == 1){
        NSLog(@"绑定银行卡接");
        TCMyBankCardViewController *mybankCVC = [[TCMyBankCardViewController alloc]init];
        mybankCVC.isPay = self.isPay;
        mybankCVC.mobile = self.mobile;
        [self.navigationController pushViewController:mybankCVC animated:YES];
    }else if (indexPath.section == 2){
        NSLog(@"交易明细界面");
        TCTransDetailViewController *tranVC = [[TCTransDetailViewController alloc]init];
        [self.navigationController pushViewController:tranVC animated:YES];
    }else{
        NSLog(@"设置支付密码");
        TCModiViewController *setPayVC = [[TCModiViewController alloc]init];
        if (self.isPay == YES) {
            setPayVC.titleStr = @"修改支付密码";
        }else{
            setPayVC.titleStr = @"设置支付密码";
        }
        setPayVC.entranceTypeStr = @"3";
        setPayVC.mobile = self.mobile;
        [self.navigationController pushViewController:setPayVC animated:YES];
    }
}

-(void)clickactive:(UIButton *)sender{
    TCCZViewController *czVC = [[TCCZViewController alloc]init];
    czVC.money = self.acmin;
    [self.navigationController pushViewController:czVC animated:YES];
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
