//
//  TCExchangeViewController.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/11/20.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCExchangeViewController.h"


@interface TCExchangeViewController () <UITextFieldDelegate>

{
    UIButton *codeBtn; //获取验证码
    UIButton *loginBtn; //登录按钮
    NSTimer *timer;
    NSInteger timeCount;
}
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@end

@implementation TCExchangeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"换绑手机";
    self.userDefaults = [NSUserDefaults standardUserDefaults];

    //添加返回按钮
    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [releaseButton setBackgroundImage:[UIImage imageNamed:@"返回按钮1.5"] forState:normal];
    [releaseButton addTarget:self action:@selector(releaseInfo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.leftBarButtonItem = releaseButtonItem;
    //创建UI
    [self createUI];
    // Do any additional setup after loading the view.
}

//创建UI
- (void)createUI {
    
    //创建textField
    NSArray *textfieldArr = @[@"旧手机号",@"新手机号",@"验证码"];
    NSArray *placeArr = @[@"输入您的旧手机号",@"输入您的新手机号",@"输入验证码"];
    for (int i = 0; i < textfieldArr.count; i ++) {
        //创建背景View
        UIView *backView = [[UIView alloc] init];
        backView.frame = CGRectMake(12, StatusBarAndNavigationBarHeight + 24 + i * (12 + 40), WIDTH - 24, 40);
        backView.backgroundColor = TCUIColorFromRGB(0xF5F5F5);
        [self.view addSubview:backView];
        
        //创建label
        UILabel *headerLabel = [UILabel publicLab:textfieldArr[i] textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
        [backView addSubview:headerLabel];
        
        //创建textfield
        UITextField *textField = [[UITextField alloc] init];
        textField.frame = CGRectMake(CGRectGetMaxX(headerLabel.frame) + 12, 0, WIDTH - 24 - 12, 40);
        //[textField addTarget:self  action:@selector(alueChange:)  forControlEvents:UIControlEventAllEditingEvents];
        if (i == 0 || i== 1){
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        }
        if (i == 2){
            textField.frame = CGRectMake(CGRectGetMaxX(headerLabel.frame) + 12, 0, 100, 40);
        }
        textField.keyboardType = UIKeyboardTypeNamePhonePad;
        textField.placeholder = placeArr[i];
        textField.delegate = self;
        textField.tag = i + 1000;
        textField.font = [UIFont systemFontOfSize:16];
        [textField addTarget:self  action:@selector(alueChange:)  forControlEvents:UIControlEventAllEditingEvents];
        //修改placeholder颜色字体
        [textField setValue:TCUIColorFromRGB(0xC4C4C4) forKeyPath:@"_placeholderLabel.textColor"];
        [textField setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
        [backView addSubview:textField];
        
        if (i == 2){
            backView.frame = CGRectMake(12, StatusBarAndNavigationBarHeight + 24 + i * (12 + 40), WIDTH - 24 - 12 - 94, 40);
            //获取验证码的按钮
            codeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            codeBtn.frame = CGRectMake(CGRectGetMaxX(backView.frame) + 12, StatusBarAndNavigationBarHeight + 24 + i * (12 + 40), 94, 40);
            codeBtn.backgroundColor = TCUIColorFromRGB(0xCCCCCC);
            codeBtn.tag = 10000;
            codeBtn.userInteractionEnabled = NO;
            [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [codeBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
            [codeBtn addTarget:self action:@selector(codeBtn:) forControlEvents:(UIControlEventTouchUpInside)];
            codeBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
            [self.view addSubview:codeBtn];
            
            //登录按钮
            loginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            loginBtn.frame = CGRectMake(12, CGRectGetMaxY(codeBtn.frame) + 40, WIDTH - 24, 48);
            [loginBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
            loginBtn.userInteractionEnabled = NO;
            [loginBtn setTitle:@"提交审核" forState:(UIControlStateNormal)];
            loginBtn.backgroundColor = TCUIColorFromRGB(0xCCCCCC);
            [loginBtn addTarget:self action:@selector(login:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.view addSubview:loginBtn];
        }
    }
}

//textfield的协议
-(void)alueChange:(UITextField *)textField{
    
    UITextField *textfieldPhone = (UITextField *)[self.view viewWithTag:1000];
    UITextField *textfieldOld = (UITextField *)[self.view viewWithTag:1001];
    UITextField *textfieldCode = (UITextField *)[self.view viewWithTag:1002];
    
    if (textfieldOld.text.length != 0) {
        codeBtn.backgroundColor = TCUIColorFromRGB(0xF99E20);
        codeBtn.userInteractionEnabled = YES;
    }
    
    loginBtn.enabled = (textfieldPhone.text.length != 0 && textfieldOld.text.length != 0 && textfieldCode.text.length != 0);
    if(loginBtn.enabled == YES){
        loginBtn.userInteractionEnabled = YES;
        loginBtn.backgroundColor = TCUIColorFromRGB(0xF99E20);
        
    }else{
        loginBtn.backgroundColor = TCUIColorFromRGB(0xCCCCCC);
        loginBtn.userInteractionEnabled = NO;
    }
}

#pragma mark -- 验证码点击事件
- (void)codeBtn:(UIButton *)sender
{
    [self keybodedown];
    
    UITextField *textfieldPhone = (UITextField *)[self.view viewWithTag:1000];
    UITextField *textfieldOld = (UITextField *)[self.view viewWithTag:1001];
    
    if(textfieldPhone.text.length < 11 || ![BSUtils checkTelNumber:textfieldPhone.text]){
        [TCProgressHUD showMessage:@"请输入正确的旧手机号码"];
    } else {
        if(textfieldOld.text.length < 11 || ![BSUtils checkTelNumber:textfieldOld.text]){
            [TCProgressHUD showMessage:@"请输入正确的新手机号码"];
        } else {
                timeCount = 60;
                //[SVProgressHUD showWithStatus:@"获取中..."];
                sender.userInteractionEnabled = NO;
                timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime:) userInfo:nil repeats:YES];
            
            NSString *Timestr = [TCGetTime getCurrentTime];
            
            NSDictionary *dic = @{@"mobile":textfieldOld.text,@"type":@"5",@"timestamp":Timestr};
            NSString *singStr = [TCServerSecret signStr:dic];
            NSDictionary *paramters = @{@"mobile":textfieldOld.text,@"timestamp":Timestr,@"type":@"5",@"sign":singStr};
            [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"103001"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
                NSString *codeStr = [NSString stringWithFormat:@"%@", jsonDic[@"code"]];
                if ([codeStr isEqualToString:@"1"]){
                    [TCProgressHUD showMessage:jsonDic[@"msg"]];
                } else {
                    [TCProgressHUD showMessage:jsonDic[@"msg"]];
                }
                [ProgressHUD hiddenHUD:self.view];
                NSLog(@"%@",jsonDic);
            } failure:^(NSError *error) {
                nil;
            }];
        }
    }

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
        codeBtn.userInteractionEnabled = NO;
    }
}

#pragma mark -- 左边按钮返回事件
- (void)releaseInfo:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 登录按钮点击事件
- (void)login:(UIButton *)sender
{
    [self keybodedown];
    
    UITextField *textfieldPhone = (UITextField *)[self.view viewWithTag:1000];
    UITextField *textfieldOld = (UITextField *)[self.view viewWithTag:1001];
    UITextField *codefield = (UITextField *)[self.view viewWithTag:1002];
    
    if(textfieldPhone.text.length < 11 || ![BSUtils checkTelNumber:textfieldPhone.text]){
        [TCProgressHUD showMessage:@"请输入正确的旧手机号码"];
    } else {
        if(textfieldOld.text.length < 11 || ![BSUtils checkTelNumber:textfieldOld.text]){
            [TCProgressHUD showMessage:@"请输入正确的新手机号码"];
        } else {
            NSLog(@"提交审核按钮事件");
            //指示器
            [ProgressHUD showHUDToView:self.view];
            NSString *timeStr = [TCGetTime getCurrentTime];
            NSString *midStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userID"]];
            NSLog(@"%@",timeStr);
            NSDictionary *dic;
            NSDictionary *paramters;
           NSString *currentVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
        
            if ([self.userDefaults valueForKey:@"userID"] == nil){
                dic = @{@"old_mobile":textfieldPhone.text,@"new_mobile":textfieldOld.text, @"code":codefield.text,@"versionId":currentVersion,@"deviceid":[TCGetDeviceId getDeviceId],@"deviceSysInfo":[TCDeviceName getDeviceName],@"timestamp":timeStr};
                NSString *signStr = [TCServerSecret signStr:dic];
                paramters = @{@"old_mobile":textfieldPhone.text,@"new_mobile":textfieldOld.text, @"code":codefield.text,@"versionId":currentVersion,@"deviceid":[TCGetDeviceId getDeviceId],@"deviceSysInfo":[TCDeviceName getDeviceName],@"timestamp":timeStr,@"sign":signStr};
                
            } else {
                dic = @{@"mid":midStr,@"old_mobile":textfieldPhone.text,@"new_mobile":textfieldOld.text, @"code":codefield.text,@"versionId":currentVersion,@"deviceid":[TCGetDeviceId getDeviceId],@"deviceSysInfo":[TCDeviceName getDeviceName],@"timestamp":timeStr};
                NSString *signStr1 = [TCServerSecret signStr:dic];
                paramters = @{@"mid":midStr,@"old_mobile":textfieldPhone.text,@"new_mobile":textfieldOld.text, @"code":codefield.text,@"versionId":currentVersion,@"deviceid":[TCGetDeviceId getDeviceId],@"deviceSysInfo":[TCDeviceName getDeviceName],@"timestamp":timeStr,@"sign":signStr1};
            }
            [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102027"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
                NSLog(@"%@,%@",jsonDic,jsonStr);
                [ProgressHUD hiddenHUD:self.view];
                NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
                if ([codeStr isEqualToString:@"1"]){
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                
                [TCProgressHUD showMessage:jsonDic[@"msg"]];
            } failure:^(NSError *error) {
                nil;
            }];
        }
    }
}

//键盘下落
- (void)keybodedown
{
    UITextField *textfieldPhone = (UITextField *)[self.view viewWithTag:1000];
    UITextField *textfieldOld = (UITextField *)[self.view viewWithTag:1001];
    UITextField *textfieldCode = (UITextField *)[self.view viewWithTag:1002];
    
    [textfieldPhone resignFirstResponder];
    [textfieldOld resignFirstResponder];
    [textfieldCode resignFirstResponder];
}

//点击空白键盘下落
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self keybodedown];
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
