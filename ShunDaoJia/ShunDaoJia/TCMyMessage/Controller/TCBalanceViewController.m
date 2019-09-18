//
//  TCBalanceViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/23.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCBalanceViewController.h"
#import "TCDetailedViewController.h"
#import "TCRechargeViewController.h"
#import "TCextanceAddVController.h"
#import "TCAddBankCardViewController.h"
#import "TCWithdrawalsViewController.h"
#import "TCUnwithdrawController.h"
#import "TCFirstVerViewController.h"
#import "TCFistinputPassController.h"
#import "TCUnCardViewController.h"
#import "TCWalletViewController.h"
#import "TCHelpViewController.h"

@interface TCBalanceViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) BOOL isSet;
@property (nonatomic, strong) NSUserDefaults *userdefaults;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *numLabel;

@end

@implementation TCBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSet = NO;
    self.title = @"我的余额";
    
    //确定按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"余额明细" forState:(UIControlStateNormal)];
    rightBtn.frame = CGRectMake(WIDTH - 60 - 12, 12, 60, 20);
    [rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [rightBtn setTitleColor:TCUIColorFromRGB(0x4C4C4C) forState:(UIControlStateNormal)];
    rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    self.view.backgroundColor = TCBgColor;
    
    self.dataArr = [NSMutableArray array];
    self.userdefaults = [NSUserDefaults standardUserDefaults];
    [self createQuest];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(banlance:)name:@"banlance" object:nil];
    
    [self creatUI];
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
        NSString *str = [NSString stringWithFormat:@"%@",jsonDic[@"data"][@"balance"]];
        self.numLabel.text = str;
        [ProgressHUD hiddenHUD:self.view];
        //成功后返回更新
    } failure:^(NSError *error) {
        nil;
    }];
}


-(void)creatUI{
    UILabel *currentLabel = [[UILabel alloc]initWithFrame:CGRectMake((WIDTH - 64)/2, 104, 64, 22)];
    currentLabel.text = @"当前余额";
    currentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    currentLabel.textColor = TCUIColorFromRGB(0x4C4C4C);
    currentLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:currentLabel];
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(currentLabel.frame) + 40, WIDTH, 48)];
    self.numLabel = numLabel;
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.textColor = TCUIColorFromRGB(0x4C4C4C);
    numLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:48];
    [self.view addSubview:numLabel];
    
    UIButton *rechargeBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(numLabel.frame) + 112, WIDTH - 24, 48)];
    [rechargeBtn setTitle:@"充值" forState:(UIControlStateNormal)];
    rechargeBtn.layer.masksToBounds = YES;
    rechargeBtn.layer.cornerRadius = 4;
    rechargeBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    [rechargeBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    [rechargeBtn setBackgroundColor:TCUIColorFromRGB(0xFF884C)];
    [rechargeBtn addTarget:self action:@selector(clickRecharge:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:rechargeBtn];
    
    UIButton *reflectBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(rechargeBtn.frame) + 20, WIDTH - 24, 48)];
    [reflectBtn setTitle:@"提现" forState:(UIControlStateNormal)];
    reflectBtn.layer.masksToBounds = YES;
    reflectBtn.layer.cornerRadius = 4;
    reflectBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    [reflectBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    [reflectBtn setBackgroundColor:TCUIColorFromRGB(0xFFAF40)];
    [reflectBtn addTarget:self action:@selector(clickReflect:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:reflectBtn];
    
    UIButton *problemBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, HEIGHT - 32, WIDTH, 32)];
    [problemBtn setTitle:@"常见问题" forState:UIControlStateNormal];
    [problemBtn setTitleColor:TCUIColorFromRGB(0x4CA6FF) forState:(UIControlStateNormal)];
    problemBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    [problemBtn addTarget:self action:@selector(clickProble:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:problemBtn];
}

#pragma mark -- 余额明细
-(void)clickRightBtn:(UIButton *)sender{
    NSLog(@"点击余额明细");
    TCDetailedViewController *detailVC = [[TCDetailedViewController alloc]init];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark -- 常见问题
-(void)clickProble:(UIButton *)sender{
    NSLog(@"进入常见问题页面");
    TCHelpViewController *helpVC = [[TCHelpViewController alloc]init];
    [self.navigationController pushViewController:helpVC animated:YES];
}

#pragma mark -- 充值
-(void)clickRecharge:(UIButton *)sender{
    TCUnCardViewController *unCard = [[TCUnCardViewController alloc]init];
    [self.navigationController pushViewController:unCard animated:YES];
}

#pragma mark -- 提现
-(void)clickReflect:(UIButton *)sender{
    [self request];
}
//获取是否绑定银行卡
-(void)request{
    [self.dataArr removeAllObjects];
    [ProgressHUD showHUDToView:self.view];
    //请求接口
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"sign":signStr};
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102020"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        [ProgressHUD hiddenHUD:self.view];
        for (NSDictionary *infoDic in jsonDic[@"data"]) {
            NSString *str = infoDic[@"bank"];
            NSString *last_4 = [NSString stringWithFormat:@"%@",infoDic[@"last_cart_4"]];
            NSString *typeS;
            NSString *type = [NSString stringWithFormat:@"%@",infoDic[@"type"]];
            if ([type isEqualToString:@"0"]) {
                typeS = @"借记卡";
            }else if ([type isEqualToString:@"1"]){
                typeS = @"借贷卡";
            }else{
                typeS = @"其他卡";
            }
            NSDictionary *micD = @{@"str":str,@"last_4":last_4,@"typeS":typeS};
            [self.dataArr addObject:micD];
        }
        if (self.dataArr.count != 0) {
            TCWithdrawalsViewController *withDrawVC = [[TCWithdrawalsViewController alloc]init];
            withDrawVC.isPay = self.isPay;
            withDrawVC.bankArr = self.dataArr;
            [self.navigationController pushViewController:withDrawVC animated:YES];
        }else{
            TCUnwithdrawController *unWithDrawVC = [[TCUnwithdrawController alloc]init];
            unWithDrawVC.isPay = self.isPay;
            unWithDrawVC.mobile = self.mobile;
            [self.navigationController pushViewController:unWithDrawVC animated:YES];
        }
        //成功后返回更新
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