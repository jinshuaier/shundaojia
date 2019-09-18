//
//  TCWithdrawalsViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/5.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCWithdrawalsViewController.h"
#import "DCPaymentView.h"
#import "TCChooseBankInfo.h"
#import "TCWithdrawTableViewCell.h"
#import "TCMyBankCardViewController.h"
#import "TCProtocolViewController.h"

@interface TCWithdrawalsViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *chongzhiBtn;
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, assign) NSString *money;
@property (nonatomic, strong) NSUserDefaults *userdefaults;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) UIButton *grayBtn;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSString *typeStr;
@property (nonatomic, strong) NSDictionary *dicMes;
@property (nonatomic, strong) UIButton *cardBtn;
@property (nonatomic, strong) NSMutableArray *arr;
@property (nonatomic, strong) UITextField *moneyField;

@end

@implementation TCWithdrawalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"余额提现";
    self.userdefaults = [NSUserDefaults standardUserDefaults];
    self.dataArr = [NSMutableArray array];
    self.arr = [NSMutableArray array];
    self.view.backgroundColor = TCBgColor;
    self.dicMes = [NSDictionary dictionary];
    [self request];
    [self creatUI];
    
    // Do any additional setup after loading the view.
}
-(void)request{
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
        self.money = [NSString stringWithFormat:@"%@",jsonDic[@"data"][@"max"]];
        int money = [self.money intValue];
        if (money > 0) {
            [self.grayBtn setTitleColor:TCUIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
            self.grayBtn.userInteractionEnabled = YES;
        }
        self.moneyLabel.text = [NSString stringWithFormat:@"可提现余额￥%@",self.money];
        [ProgressHUD hiddenHUD:self.view];

        [self requestBank];
        //成功后返回更新
    } failure:^(NSError *error) {
        nil;
    }];
}

-(void)creatUI{

    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(12, 12 + StatusBarAndNavigationBarHeight, WIDTH - 24, 165)];
    bgView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:bgView];
    
    UILabel *rechLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 12, 56, 20)];
    rechLabel.text = @"提现方式";
    rechLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    rechLabel.textColor = TCUIColorFromRGB(0x4C4C4C);
    rechLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:rechLabel];
    
    UIButton *CardnewBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(rechLabel.frame) + 40, 12, WIDTH - 40 - 56 - 24 - 36, 20)];
    self.cardBtn = CardnewBtn;
    [CardnewBtn setTitleColor:TCUIColorFromRGB(0x0276FF) forState:(UIControlStateNormal)];
    CardnewBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    CardnewBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [CardnewBtn addTarget:self action:@selector(clickCardnew:) forControlEvents:(UIControlEventTouchUpInside)];
    [bgView addSubview:CardnewBtn];
    
    UIImageView *sanimage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 24 - 5 - 12, 18, 5, 8)];
    sanimage.image = [UIImage imageNamed:@"进入小三角（灰）"];
    [bgView addSubview:sanimage];
    
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(CardnewBtn.frame) + 12, WIDTH - 24 - 16, 1)];
    line1.backgroundColor = TCUIColorFromRGB(0xEDEDED);
    [bgView addSubview:line1];
    
    UILabel *amountLAbel = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(line1.frame) + 12, 60, 20)];
    amountLAbel.textAlignment = NSTextAlignmentLeft;
    amountLAbel.text = @"提现金额";
    amountLAbel.textColor = TCUIColorFromRGB(0x4C4C4C);
    amountLAbel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [bgView addSubview:amountLAbel];
    
    UILabel *moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(amountLAbel.frame) + 5, 15, 33)];
    moneyLab.text = @"¥";
    moneyLab.textColor = TCUIColorFromRGB(0x333333);
    moneyLab.textAlignment = NSTextAlignmentCenter;
    moneyLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:24];
    [bgView addSubview:moneyLab];
    
    self.moneyField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(moneyLab.frame) + 12, CGRectGetMaxY(amountLAbel.frame) + 5, WIDTH - 24 - 36 - 15, 33)];
    self.moneyField.borderStyle = UITextBorderStyleNone;
    self.moneyField.keyboardType = UIKeyboardTypeNumberPad;
    self.moneyField.textAlignment = NSTextAlignmentLeft;
    self.moneyField.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    self.moneyField.delegate = self;
    self.moneyField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:24];
    [self.moneyField addTarget:self  action:@selector(alueChange:)  forControlEvents:UIControlEventAllEditingEvents];
    self.moneyField.textColor = TCUIColorFromRGB(0x333333);
    [bgView addSubview:self.moneyField];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(self.moneyField.frame) + 5, WIDTH - 24 - 16, 1)];
    line2.backgroundColor = TCUIColorFromRGB(0xEDEDED);
    [bgView addSubview:line2];
    
    
    UILabel *quotaLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(line2.frame) + 12, WIDTH - 24 - 36 - 48, 17)];
    self.moneyLabel = quotaLabel;
//    quotaLabel.text = [NSString stringWithFormat:@"可提现余额%@",self.money];
    quotaLabel.textColor = TCUIColorFromRGB(0x666666);
    quotaLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    
    [bgView addSubview:quotaLabel];
    
    UIButton *grayBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 24 - 48 - 12, CGRectGetMaxY(line2.frame) + 12, 48, 17)];
    self.grayBtn = grayBtn;
    [grayBtn setTitle:@"全部提现" forState:(UIControlStateNormal)];
    [grayBtn addTarget:self action:@selector(clickGray:) forControlEvents:(UIControlEventTouchUpInside)];
    grayBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    grayBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    if (self.money > 0) {
        [grayBtn setTitleColor:TCUIColorFromRGB(0x0276FF) forState:(UIControlStateNormal)];
        grayBtn.userInteractionEnabled = YES;
        
    }else{
        [grayBtn setTitleColor:TCUIColorFromRGB(0xCCCCCC) forState:(UIControlStateNormal)];
        grayBtn.userInteractionEnabled = NO;
    }
    [bgView addSubview:grayBtn];
   
    _checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(bgView.frame) + 9, 16, 16)];
    _checkBtn.tag = 2001;
    _checkBtn.selected = YES;
    _checkBtn.layer.cornerRadius = 4;
    _checkBtn.layer.masksToBounds = YES;
    [_checkBtn setBackgroundImage:[UIImage imageNamed:@"不同意"] forState:UIControlStateNormal];
    [_checkBtn setBackgroundImage:[UIImage imageNamed:@"选择同意"] forState:(UIControlStateSelected)];
    [_checkBtn addTarget:self action:@selector(clickCheck:) forControlEvents:(UIControlEventTouchUpInside)];
    _checkBtn.hidden = YES;
    
    [self.view addSubview:_checkBtn];
    
    UIButton *accountBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_checkBtn.frame), CGRectGetMaxY(bgView.frame) + 9, 135, 17)];
    [accountBtn setTitle:@"同意《用户服务协议》" forState:(UIControlStateNormal)];
    [accountBtn setTitleColor:TCUIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
    accountBtn.hidden = YES;
    accountBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    accountBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [accountBtn addTarget:self action:@selector(clickAccou:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:accountBtn];
    
    _chongzhiBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(accountBtn.frame) + 40, WIDTH - 24, 48)];
    _chongzhiBtn.layer.masksToBounds = YES;
    _chongzhiBtn.layer.cornerRadius = 4;
    [_chongzhiBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    [_chongzhiBtn setTitle:@"24小时到账，确认提现" forState:UIControlStateNormal];
    [_chongzhiBtn setBackgroundColor:TCUIColorFromRGB(0xF99E20)];
    _chongzhiBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _chongzhiBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    [_chongzhiBtn addTarget:self action:@selector(clickChong:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_chongzhiBtn];
}

-(void)clickGray:(UIButton *)sender{
    self.moneyField.text = self.money;
}

- (void)alueChange:(UITextField *)textField{
    _chongzhiBtn.enabled = (self.moneyField.text.length != 0);
    if (_chongzhiBtn.enabled == YES) {
        _chongzhiBtn.userInteractionEnabled = YES;
        [_chongzhiBtn setBackgroundColor:TCUIColorFromRGB(0xF99E20)];
    }else{
        _chongzhiBtn.userInteractionEnabled = NO;
        [_chongzhiBtn setBackgroundColor:TCUIColorFromRGB(0xF99E20)];
    }
}

#pragma mark -- 弹出框选择
-(void)clickCardnew:(UIButton *)sender{
    NSLog(@"前面还差一个弹窗呢,弹窗选择已经添加的银行卡");
    self.bgView = [[UIView alloc] init];
    self.bgView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    self.bgView.backgroundColor = [TCUIColorFromRGB(0x000000) colorWithAlphaComponent:0.4];
    [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,240, 135)];
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = 8;
    contentView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.bgView addSubview:contentView];
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 240, 55)];
    topView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [contentView addSubview:topView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((240 - 90)/2, 16, 90, 22)];
    titleLabel.text = @"选择银行卡";
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    titleLabel.textColor = TCUIColorFromRGB(0x333333);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:titleLabel];
    
    UIButton *closebtn = [[UIButton alloc]initWithFrame:CGRectMake(240 - 12 - 12, 21, 12, 12)];
    [closebtn setBackgroundImage:[UIImage imageNamed:@"错"] forState:(UIControlStateNormal)];
    [closebtn addTarget:self action:@selector(clickClose) forControlEvents:(UIControlEventTouchUpInside)];
    [topView addSubview:closebtn];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 15, 240, 1)];
    line.backgroundColor = TCLineColor;
    [topView addSubview:line];
    
    NSLog(@"%lu",self.dataArr.count);
    
    self.mainTableView = [[UITableView alloc]init];
    if (self.dataArr.count <= 3) {
        self.mainTableView.frame = CGRectMake(0, CGRectGetMaxY(topView.frame), 240, (self.dataArr.count + 1) *40);
        self.mainTableView.scrollEnabled = NO;
    }else{
        self.mainTableView.frame = CGRectMake(0, CGRectGetMaxY(topView.frame), 240, 160);
        self.mainTableView.scrollEnabled = YES;
    }
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [contentView addSubview:self.mainTableView];
    
    contentView.frame = CGRectMake(0, 0,240, CGRectGetMaxY(self.mainTableView.frame));
    contentView.center = CGPointMake(WIDTH/2, HEIGHT/2);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count + 1;
}


//预防ios11错误
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.qh_width, 0)];
        return headerView;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TCWithdrawTableViewCell *cell = [[TCWithdrawTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    if (self.dataArr.count != 0) {
        if (indexPath.row < self.dataArr.count) {
            cell.model = self.dataArr[indexPath.row];
            cell.checkBtn.tag = 1000 + indexPath.row;
            [cell.checkBtn addTarget:self action:@selector(clickChe:) forControlEvents:(UIControlEventTouchUpInside)];
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 39, 240, 1)];
            line.backgroundColor = TCLineColor;
            [cell.contentView addSubview:line];
        }else if (indexPath.row == self.dataArr.count){
            cell.txtLabel.hidden = YES;
            UILabel *txtLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 15, 80, 10)];
             txtLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
             txtLabel.textColor = TCUIColorFromRGB(0x333333);
             txtLabel.textAlignment = NSTextAlignmentLeft;
            txtLabel.text = @"添加银行卡";
            [cell.contentView addSubview:txtLabel];
            [cell.checkBtn setBackgroundImage:[UIImage imageNamed:@"黄色添加"] forState:(UIControlStateNormal)];
            cell.checkBtn.userInteractionEnabled = NO;
        }
    }
   
   cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击的是%ld行",(long)indexPath.row);
    
    [UIView animateWithDuration:0.3f animations:^{
    }completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        self.bgView = nil;
    }];
    if (indexPath.row == self.dataArr.count) {
        
        TCMyBankCardViewController *bankVC = [[TCMyBankCardViewController alloc]init];
        [self.navigationController pushViewController:bankVC animated:YES];
        
    }else{
//        TCWithdrawTableViewCell *cell = (TCWithdrawTableViewCell*)[self.view viewWithTag:1000 + indexPath.row];
//        cell.checkBtn.selected = !cell.checkBtn.selected;
        NSString *last_4 = self.bankArr[indexPath.row][@"last_4"];
        NSString *str = self.bankArr[indexPath.row][@"str"];
        NSString *type = self.bankArr[indexPath.row][@"typeS"];
        [self.cardBtn setTitle:[NSString stringWithFormat:@"%@%@（%@）",str,type,last_4] forState:(UIControlStateNormal)];
        [self clickClose];
    }
}

-(void)clickChe:(UIButton *)sender{
    sender.selected = !sender.selected;
    [UIView animateWithDuration:0.3f animations:^{
    }completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        self.bgView = nil;
    }];
}


-(void)clickClose{
    [UIView animateWithDuration:0.3f animations:^{
    }completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        self.bgView = nil;
    }];
}

-(void)requestBank{
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
        for (NSDictionary *infoDic in jsonDic[@"data"]) {
            NSString *bank = infoDic[@"bank"];
            [self.arr addObject:bank];
        }
        if (self.arr.count != 0) {
            self.dicMes = jsonDic[@"data"][0];
            self.typeStr = [NSString stringWithFormat:@"%@",self.dicMes[@"type"]];
            if ([self.typeStr isEqualToString:@"0"]) {
                NSString *str = @"借记卡";
                [self.cardBtn setTitle:[NSString stringWithFormat:@"中国%@%@（%@)",self.dicMes[@"bank"],str,self.dicMes[@"last_cart_4"]] forState:(UIControlStateNormal)];
            }else if([self.typeStr isEqualToString:@"1"]){
                NSString *str = @"借贷卡";
                [self.cardBtn setTitle:[NSString stringWithFormat:@"中国%@%@（%@)",self.dicMes[@"bank"],str,self.dicMes[@"last_cart_4"]] forState:(UIControlStateNormal)];
            }else if([self.typeStr isEqualToString:@"2"]){
                NSString *str = @"其他卡";
                [self.cardBtn setTitle:[NSString stringWithFormat:@"中国%@%@（%@)",self.dicMes[@"bank"],str,self.dicMes[@"last_cart_4"]] forState:(UIControlStateNormal)];
            }
            
            NSLog(@"selfdic:%@",self.dicMes);
            for (NSDictionary *infoDic in jsonDic[@"data"]) {
                TCChooseBankInfo *model = [TCChooseBankInfo orderInfoWithDictionary:infoDic];
                [self.dataArr addObject:model];
            }
            NSLog(@"%lu",(unsigned long)self.dataArr.count);
            [self.mainTableView reloadData];
            [ProgressHUD hiddenHUD:self.view];
            //成功后返回更新
        }else{
            
        }
    } failure:^(NSError *error) {
        nil;
    }];
}

#pragma mark -- 点击勾选框
-(void)clickCheck:(UIButton *)sender{
    sender.selected = !sender.selected;
    NSLog(@"点击勾选框 同意");
}
#pragma mark -- 用户协议
-(void)clickAccou:(UIButton *)sender{
    NSLog(@"跳转到用户服务协议");
    TCProtocolViewController *protolVC = [[TCProtocolViewController alloc] init];
    [self.navigationController pushViewController:protolVC animated:YES];
}
#pragma mark -- 充值
-(void)clickChong:(UIButton *)sender{
    NSInteger money = [self.moneyField.text integerValue];
        if (money < 10){
        [TCProgressHUD showMessage:@"提现金额不可小于10元"];
    }
    else{
        DCPaymentView *payAlert = [[DCPaymentView alloc]init];
        payAlert.tag = 3212;
        payAlert.title = @"输入提现密码";
        
        [payAlert show];
        payAlert.completeHandle = ^(NSString *inputPwd) {
            NSLog(@"密码是%@",inputPwd);
            if (inputPwd.length == 6) {
                self.password = inputPwd;
                [self creatRequest];
            }
        };
    }
}
-(void)creatRequest{
    [ProgressHUD showHUDToView:self.view];
    //请求接口
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"payCode":self.password};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"sign":signStr,@"payCode":self.password};
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"101012"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if ([codeStr isEqualToString:@"1"]) {
            [self drawRequest];
           
        }else{
            [TCProgressHUD showMessage:[NSString stringWithFormat:@"%@",jsonDic[@"msg"]]];
        }
        [ProgressHUD hiddenHUD:self.view];
        //成功后返回更新
    } failure:^(NSError *error) {
        nil;
    }];
}

-(void)drawRequest{
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    NSString *money = self.moneyField.text;
    NSString *bankcardid = [NSString stringWithFormat:@"%@",self.dicMes[@"id"]];
    NSString *terminal = @"IOS";
    NSString *mmdid = [TCGetDeviceId getDeviceId];
    NSString *deviceid = [TCDeviceName getDeviceName];
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"money":money,@"terminal":terminal,@"mmdid":mmdid,@"deviceid":deviceid,@"bankcardid":bankcardid};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"money":money,@"terminal":terminal,@"mmdid":mmdid,@"deviceid":deviceid,@"sign":signStr,@"bankcardid":bankcardid};
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"101010"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if ([codeStr isEqualToString:@"1"]) {
             [TCProgressHUD showMessage:[NSString stringWithFormat:@"%@",jsonDic[@"msg"]]];
            UIViewController *viewCtl = self.navigationController.viewControllers[2];
            [self.navigationController popToViewController:viewCtl animated:YES];
        }else{
            [TCProgressHUD showMessage:[NSString stringWithFormat:@"%@",jsonDic[@"msg"]]];
        }
    } failure:^(NSError *error) {
        nil;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.moneyField resignFirstResponder];
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
