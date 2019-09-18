//
//  TCbingdingmobileViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2018/5/25.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCbingdingmobileViewController.h"
#import "TCProtocolViewController.h"

@interface TCbingdingmobileViewController ()<UITextFieldDelegate>
{
    UIButton *loginBtn; //登录按钮
    UIButton *codeBtn; //验证码的按钮
    NSTimer *timer;
    NSInteger timeCount;
    //获取当前版本号
    NSString *currentVersion;
}
@property (nonatomic, strong) NSUserDefaults *userdefaults;

@end

@implementation TCbingdingmobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机号";
    self.view.backgroundColor = [UIColor whiteColor];
    self.userdefaults = [NSUserDefaults standardUserDefaults];

    [self createUI];
    // Do any additional setup after loading the view.
}

//创建视图
- (void) createUI {
    
    UILabel *hintLabel = [UILabel publicLab:@"为了您的账户安全，请绑定手机号" textColor:TCUIColorFromRGB(0xFF4C79) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    hintLabel.frame = CGRectMake(12, StatusBarAndNavigationBarHeight + 12, WIDTH - 24, 18);
    [self.view addSubview:hintLabel];
    
    //创建textField
    NSArray *textfieldArr = @[@"手机号",@"验证码"];
    NSArray *placeArr = @[@"请输入您的手机号",@"请输入验证码"];
    for (int i = 0; i < textfieldArr.count; i ++) {
        //创建背景View
        UIView *backView = [[UIView alloc] init];
        backView.frame = CGRectMake(12, CGRectGetMaxY(hintLabel.frame) + 24 + i * (12 + 40), WIDTH - 24, 40);
        backView.backgroundColor = TCUIColorFromRGB(0xF5F5F5);
        [self.view addSubview:backView];
        
        //创建label
        UILabel *headerLabel = [UILabel publicLab:textfieldArr[i] textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
        headerLabel.frame = CGRectMake(12, 0, 48, 40);
        [backView addSubview:headerLabel];
        
        //创建textfield
        UITextField *textField = [[UITextField alloc] init];
        textField.frame = CGRectMake(CGRectGetMaxX(headerLabel.frame) + 12, 0, WIDTH - 24 - 24 - 48 - 10, 40);
        if (i == 0){
            textField.keyboardType = UIKeyboardTypeNamePhonePad;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        }
        if (i == 1){
            textField.frame = CGRectMake(CGRectGetMaxX(headerLabel.frame) + 12, 0, 131, 40);
            textField.keyboardType = UIKeyboardTypeNamePhonePad;
        }
        textField.placeholder = placeArr[i];
        textField.delegate = self;
        textField.tag = i + 1000;
        [textField addTarget:self  action:@selector(alueChange:)  forControlEvents:UIControlEventAllEditingEvents];
        textField.font = [UIFont systemFontOfSize:16];
        //修改placeholder颜色字体
        [textField setValue:TCUIColorFromRGB(0xC4C4C4) forKeyPath:@"_placeholderLabel.textColor"];
        [textField setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
        [backView addSubview:textField];
        
        if (i == 1){
            backView.frame = CGRectMake(12, CGRectGetMaxY(hintLabel.frame) + 24 + i * (12 + 40), WIDTH - 94 - 24 - 12, 40);
            
            //获取验证码的按钮
            codeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            codeBtn.frame = CGRectMake(CGRectGetMaxX(backView.frame) + 12, CGRectGetMaxY(hintLabel.frame) + 24 + i * (12 + 40), 94, 40);
            codeBtn.backgroundColor = TCUIColorFromRGB(0xCCCCCC);
            codeBtn.tag = 10000;
            codeBtn.userInteractionEnabled = NO;
            [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [codeBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
            [codeBtn addTarget:self action:@selector(codeBtn:) forControlEvents:(UIControlEventTouchUpInside)];
            codeBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
            [self.view addSubview:codeBtn];
            
            PCBClickLabel *label = [[PCBClickLabel alloc]initLabelViewWithLab:@"登录即代表您已同意《用户服务协议》" clickTextRange:NSMakeRange(9, 8) clickAtion:^{
                NSLog(@"点击了");
                //点击跳转
                [self checkProtocloVC];
            }];
            label.frame = CGRectMake(12, CGRectGetMaxY(codeBtn.frame) + 8, WIDTH - 24 - 16 - 4, 16);
            [self.view addSubview:label];
            //登录按钮
            loginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            loginBtn.frame = CGRectMake(12, CGRectGetMaxY(label.frame) + 40, WIDTH - 24, 48);
            [loginBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
            loginBtn.userInteractionEnabled = NO;
            [loginBtn setTitle:@"绑定" forState:(UIControlStateNormal)];
            loginBtn.backgroundColor = TCUIColorFromRGB(0xCCCCCC);
            [loginBtn addTarget:self action:@selector(login:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.view addSubview:loginBtn];
        }
    }
}

#pragma mark -- 用户协议点击事件
- (void)checkProtocloVC
{
    NSLog(@"用户协议");
    [self keybodedown];
    TCProtocolViewController *protocloVC = [[TCProtocolViewController alloc] init];
    TCNavController *navVC = [[TCNavController alloc] initWithRootViewController:protocloVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

//textfield的协议
-(void)alueChange:(UITextField *)textField{
    
    UITextField *textfieldPhone = (UITextField *)[self.view viewWithTag:1000];
    UITextField *textfieldCode = (UITextField *)[self.view viewWithTag:1001];
    
    if (textfieldPhone.text.length == 0  ) {
        if (textfieldCode.text.length != 0){
            codeBtn.backgroundColor = TCUIColorFromRGB(0xCCCCCC);
            codeBtn.userInteractionEnabled = NO;
        } else {
            codeBtn.backgroundColor = TCUIColorFromRGB(0xF99E20);
            codeBtn.userInteractionEnabled = YES;
        }
    }
    loginBtn.enabled = (textfieldPhone.text.length != 0 && textfieldCode.text.length != 0);
    if(loginBtn.enabled == YES){
        loginBtn.userInteractionEnabled = YES;
        loginBtn.backgroundColor = TCUIColorFromRGB(0xF99E20);
        
    }else{
        loginBtn.backgroundColor = TCUIColorFromRGB(0xCCCCCC);
        loginBtn.userInteractionEnabled = NO;
    }
}

#pragma mark -- 获取验证码的点击事件
- (void)codeBtn:(UIButton *)sender
{
    UITextField *textfieldPhone = (UITextField *)[self.view viewWithTag:1000];
    
    if(textfieldPhone.text.length < 11 || ![BSUtils checkTelNumber:textfieldPhone.text]){
        [TCProgressHUD showMessage:@"请输入正确的11位手机号码"];
    } else {
        timeCount = 60;
        [ProgressHUD showHUDToView:self.view];
        sender.userInteractionEnabled = NO;
        sender.backgroundColor = TCUIColorFromRGB(0xCCCCCC);
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime:) userInfo:nil repeats:YES];
        [self keybodedown];
        NSString *Timestr = [TCGetTime getCurrentTime];
        
        NSDictionary *dic = @{@"mobile":textfieldPhone.text,@"type":@"10",@"timestamp":Timestr};
        NSString *singStr = [TCServerSecret signStr:dic];
        NSDictionary *paramters = @{@"mobile":textfieldPhone.text,@"timestamp":Timestr,@"type":@"10",@"sign":singStr};
        [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"103001"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
            [TCProgressHUD showMessage:jsonDic[@"msg"]];
            [ProgressHUD hiddenHUD:self.view];
            NSLog(@"%@",jsonDic);
        } failure:^(NSError *error) {
            nil;
        }];
    }
    
    [self keybodedown];
    NSLog(@"验证码点击事件");
}

//定时器触发事件
- (void)reduceTime:(NSTimer *)coderTimer{
    timeCount--;
    if (timeCount == 0) {
        [codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        [codeBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        codeBtn.backgroundColor = TCUIColorFromRGB(0xF99E20);
        codeBtn.userInteractionEnabled = YES;
        //停止定时器
        [timer invalidate];
    }else{
        NSString *str = [NSString stringWithFormat:@"%lus", (long)timeCount];
        [codeBtn setTitle:str forState:UIControlStateNormal];
        codeBtn.backgroundColor = TCUIColorFromRGB(0xCCCCCC);
        codeBtn.userInteractionEnabled = NO;
    }
}

//键盘下落
- (void)keybodedown
{
    UITextField *textfieldPhone = (UITextField *)[self.view viewWithTag:1000];
    UITextField *textfieldCode = (UITextField *)[self.view viewWithTag:1001];
    
    [textfieldPhone resignFirstResponder];
    [textfieldCode resignFirstResponder];
}

//限制字数
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    UITextField *textfieldPhone = (UITextField *)[self.view viewWithTag:1000];
    if(textField == textfieldPhone){
        if(range.length + range.location > textfieldPhone.text.length){
            return NO;
        }
        NSInteger newLenght = [textfieldPhone.text length] + [string length] - range.length;
        return newLenght <= 11;
    }
    else{
        return YES;
    }
}
#pragma mark -- 绑定按钮点击事件
-(void)login:(UIButton *)sender{
    UITextField *textfieldPhone = (UITextField *)[self.view viewWithTag:1000];
    UITextField *textfieldCode = (UITextField *)[self.view viewWithTag:1001];
    [BQActivityView showActiviTy];
    //请求接口
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"mobile":textfieldPhone.text,@"code":textfieldCode.text};
    NSString *signStr = [TCServerSecret signStr:dic];
    NSDictionary *paramaters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"mobile":textfieldPhone.text,@"code":textfieldCode.text,@"sign":signStr};
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102029"] paramter:paramaters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        
        NSLog(@"jsonDic:%@  jsonStr:%@",jsonDic,jsonDic);
        NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if ([codeStr isEqualToString:@"1"]) {
            [TCProgressHUD showMessage:[NSString stringWithFormat:@"%@",jsonDic[@"msg"]]];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shuaxinAccount" object:nil];
        }
     [BQActivityView hideActiviTy];
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
