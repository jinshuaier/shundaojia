//
//  TCIdentityPhoneViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/27.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCIdentityPhoneViewController.h"
#import "TCextanceAddVController.h"
#import "TCResePhoneViewController.h"
#import "TCProtocolViewController.h"

@interface TCIdentityPhoneViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) NSUserDefaults *userdefaults;
@end

@implementation TCIdentityPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"身份验证";
    self.userdefaults = [NSUserDefaults standardUserDefaults];
   
    self.view.backgroundColor = TCBgColor;
    [self creatUI];
    // Do any additional setup after loading the view.
}

-(void)creatUI{
    NSArray *titleArr = @[@"银行卡",@"卡号",@"手机号"];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 12 + StatusBarAndNavigationBarHeight, WIDTH, 162)];
    bgView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:bgView];
    
    for (int i = 0; i < titleArr.count; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 54 * i + 16, 48, 22)];
        label.text = titleArr[i];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.textColor = TCUIColorFromRGB(0x4C4C4C);
        label.textAlignment = NSTextAlignmentLeft;
        [bgView addSubview:label];

        UITextField *textfield = [[UITextField alloc] init];
        textfield.frame = CGRectMake(CGRectGetMaxX(label.frame) + 12, 54 * i + 16, WIDTH - 48 - 36, 22);
        textfield.delegate = self;
        textfield.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        textfield.textColor = TCUIColorFromRGB(0x4c4c4c);
        textfield.textAlignment = NSTextAlignmentLeft;
        if (i == 0){
            textfield.text = [NSString stringWithFormat:@"中国%@",self.bankname];
            textfield.enabled = NO;
        } else if (i == 1){
            textfield.text = [NSString stringWithFormat:@"%@",self.banknum];
            textfield.enabled = NO;
        } else if (i == 2){
            textfield.frame = CGRectMake(CGRectGetMaxX(label.frame) + 12, 54*i + 16, WIDTH - 48 - 48 - 24, 22);
            textfield.placeholder = @"银行预留手机号";
            textfield.tag = 3007;
            textfield.delegate = self;
            textfield.keyboardType = UIKeyboardTypeNumberPad;
            [textfield addTarget:self  action:@selector(alueChange:)  forControlEvents:UIControlEventAllEditingEvents];
            
            UIButton *question = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(textfield.frame) + 12, 54 * i + 19, 16, 16)];
            [question setBackgroundImage:[UIImage imageNamed:@"黄问号"] forState:UIControlStateNormal];
            [question addTarget:self action:@selector(clickQuestion:) forControlEvents:(UIControlEventTouchUpInside)];
            [bgView addSubview:question];
            
        }
        if (i < 2) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12,CGRectGetMaxY(label.frame) + 15,  WIDTH - 24, 1)];
            line.backgroundColor = TCBgColor;
            [bgView addSubview:line];
        }
        [bgView addSubview:textfield];
        
        _checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(bgView.frame) + 9, 16, 16)];
        _checkBtn.tag = 2001;
        _checkBtn.selected = YES;
        _checkBtn.layer.cornerRadius = 4;
        _checkBtn.layer.masksToBounds = YES;
        [_checkBtn setBackgroundImage:[UIImage imageNamed:@"不同意"] forState:UIControlStateNormal];
        [_checkBtn setBackgroundImage:[UIImage imageNamed:@"选择同意"] forState:(UIControlStateSelected)];
        [_checkBtn addTarget:self action:@selector(clickCheck:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self.view addSubview:_checkBtn];


        UIButton *accountBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_checkBtn.frame), CGRectGetMaxY(bgView.frame) + 9, 135, 17)];
        [accountBtn setTitle:@"同意《用户服务协议》" forState:(UIControlStateNormal)];
        [accountBtn setTitleColor:TCUIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
        
        accountBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        accountBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [accountBtn addTarget:self action:@selector(clickAccount:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:accountBtn];


        _sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(accountBtn.frame) + 40, WIDTH - 24, 48)];
        [_sureBtn setTitle:@"下一步" forState:(UIControlStateNormal)];
        [_sureBtn setBackgroundColor:TCUIColorFromRGB(0xCCCCCC)];
        _sureBtn.layer.masksToBounds = YES;
        _sureBtn.layer.cornerRadius = 4;
        _sureBtn.titleLabel.textColor = TCUIColorFromRGB(0xFFFFFF);
        _sureBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
        [_sureBtn addTarget:self action:@selector(clickSure:) forControlEvents:(UIControlEventTouchUpInside)];
        _sureBtn.userInteractionEnabled = NO;

        [self.view addSubview:_sureBtn];
    }
}

#pragma mark -- UITextFieldDelegate
- (void)alueChange:(UITextField *)textField{
    UITextField *phone_textField = (UITextField *)[self.view viewWithTag:3007];
    _sureBtn.enabled = (phone_textField.text.length != 0);
    if (_sureBtn.enabled == YES) {
        _sureBtn.userInteractionEnabled = YES;
        [_sureBtn setBackgroundColor:TCUIColorFromRGB(0xF99E20)];
    }else{
        _sureBtn.userInteractionEnabled = NO;
        [_sureBtn setBackgroundColor:TCUIColorFromRGB(0xCCCCCC)];
    }
}

#pragma mark -- 点击问号
-(void)clickQuestion:(UIButton *)sender{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"手机号" message:@"银行预留手机号是在银行办卡时填写的手机号，若遗忘、换号可联系银行客服电话处理" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -- 点击勾选框
-(void)clickCheck:(UIButton *)sender{
    NSLog(@"点击勾选框");
    sender.selected = !sender.selected; 
}
#pragma mark -- 用户服务协议
-(void)clickAccount:(UIButton *)sender{
    NSLog(@"点击了用户协议");
    TCProtocolViewController *protolVC = [[TCProtocolViewController alloc] init];
    [self.navigationController pushViewController:protolVC animated:YES];
}

-(void)clickSure:(UIButton *)sender{
    NSLog(@"点击会到存在银行卡的充值界面");
     UITextField *phone_textField = (UITextField *)[self.view viewWithTag:3007];
    [phone_textField resignFirstResponder];
    if (phone_textField.text.length < 11 || ![BSUtils checkTelNumber:phone_textField.text]){
        [TCProgressHUD showMessage:@"请输入正确的手机号"];
    }else if (_checkBtn.selected == NO){
        NSLog(@"%id",_checkBtn.selected);
        [TCProgressHUD showMessage:@"如果不同意用户服务协议的话，是不行的"];
    }
    else{
        [self request];
    }
}
-(void)request{
    UITextField *phonefield = (UITextField *)[self.view viewWithTag:3007];
    [ProgressHUD showHUDToView:self.view];
    //请求接口
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    NSString *cardno = self.banknum;
    NSString *bankCode = self.bankCode;
    NSString *bankName = self.bankname;
    
    NSString *mobile = phonefield.text;
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"cardno":cardno,@"bankCode":bankCode,@"bankName":bankName,@"mobile":mobile};
    NSLog(@"dic:%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"sign":signStr,@"cardno":cardno,@"bankCode":bankCode,@"bankName":bankName,@"mobile":mobile};
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"103010"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if ([codeStr isEqualToString:@"1"]){
            
            //发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"bankBnagding" object:nil];
            
            UIViewController *viewCtl = self.navigationController.viewControllers[2];
            [self.navigationController popToViewController:viewCtl animated:YES];
        }
        [TCProgressHUD showMessage:jsonDic[@"msg"]];
        [ProgressHUD hiddenHUD:self.view];
        //成功后返回更新
    } failure:^(NSError *error) {
        nil;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITextField *phonefield = (UITextField *)[self.view viewWithTag:3007];
    [phonefield resignFirstResponder];
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