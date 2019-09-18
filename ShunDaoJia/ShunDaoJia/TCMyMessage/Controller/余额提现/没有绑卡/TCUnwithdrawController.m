//
//  TCUnwithdrawController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/5.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCUnwithdrawController.h"
#import "TCAddBankCardViewController.h"
#import "TCNoSetPassViewController.h"
#import "TCWithAlSetViewController.h"
#import "TCModiViewController.h"
@interface TCUnwithdrawController ()<UITextFieldDelegate>
@property (nonatomic, assign) BOOL isSet;
@property (nonatomic, strong) UITextField *numTextfied;
@property (nonatomic, strong) NSUserDefaults * userdefaults;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) UILabel *tiLabel;

@end

@implementation TCUnwithdrawController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userdefaults = [NSUserDefaults standardUserDefaults];
    self.isSet = YES;
    self.title = @"余额提现";
    self.view.backgroundColor = TCBgColor;
    [self request];
    [self creatUI];
    // Do any additional setup after loading the view.
}

-(void)creatUI{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(12, 12 + StatusBarAndNavigationBarHeight, WIDTH - 24, 118)];
    bgView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:bgView];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(24, 24, 56, 20)];
    textLabel.text = @"提现金额";
    textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    textLabel.textColor = TCUIColorFromRGB(0x999999);
    textLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:textLabel];
    
    UILabel *iconlabel = [[UILabel alloc]initWithFrame:CGRectMake(24, CGRectGetMaxY(textLabel.frame) + 12, 22, 50)];
    iconlabel.textAlignment = NSTextAlignmentLeft;
    iconlabel.textColor = TCUIColorFromRGB(0x333333);
    iconlabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:36];
    iconlabel.text = @"¥";
    [bgView addSubview:iconlabel];
    
    self.numTextfied = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconlabel.frame) + 12, CGRectGetMaxY(textLabel.frame) + 12, WIDTH - 22 - 24, 50)];
    self.numTextfied.font = [UIFont fontWithName:@"PingFangSC-Regular" size:38];
    self.numTextfied.textColor = TCUIColorFromRGB(0x333333);
    self.numTextfied.delegate = self;
    self.numTextfied.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:self.numTextfied];
    
    UILabel *teLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, CGRectGetMaxY(bgView.frame) + 16, WIDTH - 26, 17)];
    self.tiLabel = teLabel;
    teLabel.textColor = TCUIColorFromRGB(0x666666);
    teLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    teLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:teLabel];
    
    
    UIButton *withDrawBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(teLabel.frame) + 40, WIDTH - 24, 48)];
    [withDrawBtn addTarget:self action:@selector(addBank:) forControlEvents:(UIControlEventTouchUpInside)];
    [withDrawBtn setTitle:@"绑定储蓄卡提现" forState:(UIControlStateNormal)];
    [withDrawBtn setBackgroundColor:TCUIColorFromRGB(0xF99E20)];
    withDrawBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    withDrawBtn.titleLabel.textColor = TCUIColorFromRGB(0xFFFFFF);
    withDrawBtn.layer.masksToBounds = YES;
    withDrawBtn.layer.cornerRadius = 4;
    [self.view addSubview:withDrawBtn];
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
        self.tiLabel.text = [NSString stringWithFormat:@"可提现余额￥%@",self.money];
        [ProgressHUD hiddenHUD:self.view];
        //成功后返回更新
    } failure:^(NSError *error) {
        nil;
    }];
}


#pragma mark -- 点击绑定添加银行卡
-(void)addBank:(UIButton *)sender{
    [self.numTextfied resignFirstResponder];
    if (![BSUtils checkMoneyNum:self.numTextfied.text]) {
        [TCProgressHUD showMessage:@"请输入正确的金额"];
    } else {
        if (self.isPay == YES) {
            TCWithAlSetViewController *alSet = [[TCWithAlSetViewController alloc]init];
            alSet.entranceTypeStr = @"4";
            [self.navigationController pushViewController:alSet animated:YES];
        }else{
            TCModiViewController *noset = [[TCModiViewController alloc]init];
            noset.mobile = self.mobile;
            noset.titleStr = @"设置支付密码";
            noset.entranceTypeStr = @"4";
            [self.navigationController pushViewController:noset animated:YES];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.numTextfied resignFirstResponder];
}
//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
