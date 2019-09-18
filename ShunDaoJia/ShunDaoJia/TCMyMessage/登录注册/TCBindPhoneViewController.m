//
//  TCBindPhoneViewController.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/11/20.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCBindPhoneViewController.h"
#import "TCProtocolViewController.h" //用户协议页面
#import "TCExchangeViewController.h" //换绑手机页面
#import "TCLoginViewController.h" //登录页面
#import "TCNavController.h"
#import "TCTabBarController.h"
#import "TCCouponView.h" //弹出优惠券
#import "JPUSHService.h"

@interface TCBindPhoneViewController () <UITextFieldDelegate>
{
    UIButton *loginBtn; //登录按钮
    UIButton *codeBtn; //验证码的按钮
    NSTimer *timer;
    NSInteger timeCount;
    //获取当前版本号
    NSString *currentVersion;
}
@property (nonatomic, strong) NSString *pushID; //推送的id
@property (nonatomic, strong) NSUserDefaults *userdefault;
@end

@implementation TCBindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机";
    self.view.backgroundColor = [UIColor whiteColor];
    self.userdefault = [NSUserDefaults standardUserDefaults];
    //获取当前版本号
    currentVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    //添加返回按钮
    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [releaseButton setBackgroundImage:[UIImage imageNamed:@"返回系统"] forState:normal];
    [releaseButton addTarget:self action:@selector(releaseInfo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.leftBarButtonItem = releaseButtonItem;
    //创建视图
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
            codeBtn.backgroundColor = TCUIColorFromRGB(0xF99E20);
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
            [loginBtn setTitle:@"登录" forState:(UIControlStateNormal)];
            loginBtn.backgroundColor = TCUIColorFromRGB(0xCCCCCC);
            [loginBtn addTarget:self action:@selector(login:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.view addSubview:loginBtn];
        }
    }
}

//textfield的协议
-(void)alueChange:(UITextField *)textField{
    
    UITextField *textfieldPhone = (UITextField *)[self.view viewWithTag:1000];
    UITextField *textfieldCode = (UITextField *)[self.view viewWithTag:1001];
    
    if (textfieldPhone.text.length == 0  ) {
        if (textfieldCode.text.length != 0){
            codeBtn.backgroundColor = TCUIColorFromRGB(0xF99E20);
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
        [ProgressHUD showHUDToView:self.view];
        [self keybodedown];
        NSString *Timestr = [TCGetTime getCurrentTime];
        
        NSDictionary *dic = @{@"mobile":textfieldPhone.text,@"type":@"10",@"timestamp":Timestr};
        NSString *singStr = [TCServerSecret signStr:dic];
        NSDictionary *paramters = @{@"mobile":textfieldPhone.text,@"timestamp":Timestr,@"type":@"10",@"sign":singStr};
        [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"103001"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
            
            NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
            if ([codeStr isEqualToString:@"1"]) {
                timeCount = 60;
                sender.userInteractionEnabled = NO;
                sender.backgroundColor = TCUIColorFromRGB(0xF99E20);
                timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime:) userInfo:nil repeats:YES];
            }
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
        codeBtn.backgroundColor = TCUIColorFromRGB(0xF99E20);
        codeBtn.userInteractionEnabled = NO;
    }
}

#pragma mark -- 用户协议点击事件
- (void)checkProtocloVC
{
    NSLog(@"用户协议");
    [self keybodedown];
    TCProtocolViewController *protolVC = [[TCProtocolViewController alloc] init];
    [self.navigationController pushViewController:protolVC animated:YES];
}

#pragma mark -- 登录的点击事件
- (void)login:(UIButton *)sender
{
    [self keybodedown];
    UITextField *textfieldPhone = (UITextField *)[self.view viewWithTag:1000];
    UITextField *textfieldCode = (UITextField *)[self.view viewWithTag:1001];

    if(textfieldPhone.text.length < 11 || ![BSUtils checkTelNumber:textfieldPhone.text]){
        [TCProgressHUD showMessage:@"请输入正确的11位手机号码"];
    } else {
        
        // 2.1.9版本新增获取registration id block接口。
        [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
            if(resCode == 0){
                NSLog(@"极光推送 , registrationID获取成功 =======> %@",registrationID);
                self.pushID = registrationID;
            } else {
                NSLog(@"极光推送 , registrationID获取失败 =======> code：%d",resCode);
            }
        }];
        
        if (self.pushID == nil) {
            self.pushID = @"0";
        }
        
        
        //请求
        [self questAndMobile:textfieldPhone.text Andcode:textfieldCode.text Andpushid:self.pushID AndversionId:currentVersion anddevice:[TCDeviceName getDeviceName] deviceid:[TCGetDeviceId getDeviceId] deviceSysInfo:@"IOS" andOpenID:self.openid];
    }
}

#pragma mark -- 绑定手机接口
- (void)questAndMobile:(NSString *)phone Andcode:(NSString *)code Andpushid:(NSString *)pushid AndversionId:(NSString *)versionStr anddevice:(NSString *)device deviceid:(NSString *)deveiceID deviceSysInfo:(NSString *)SysInfo andOpenID:(NSString *)openidStr
{
    //指示器
    [ProgressHUD showHUDToView:self.view];
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSDictionary *dic = @{@"mobile":phone, @"code":code,@"pushid":pushid,@"versionId":versionStr,@"openId":openidStr,@"deviceid":deveiceID,@"deviceSysInfo":SysInfo,@"timestamp":timeStr};
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mobile":phone, @"code":code,@"pushid":pushid,@"versionId":versionStr,@"openId":openidStr,@"deviceid":deveiceID,@"deviceSysInfo":SysInfo,@"timestamp":timeStr,@"sign":signStr};
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"104002"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        [ProgressHUD hiddenHUD:self.view];
        NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if ([codeStr isEqualToString:@"1"]){
            
            [self.userdefault setValue:[[jsonDic valueForKey:@"data"] valueForKey:@"memberid"] forKey:@"userID"];
            [self.userdefault setValue:[[jsonDic valueForKey:@"data"] valueForKey:@"token"] forKey:@"userToken"];
            //个人信息
            [self.userdefault setValue:[[jsonDic valueForKey:@"data"] valueForKey:@"headPic"] forKey:@"imageHead"];
            [self.userdefault setValue:[[jsonDic valueForKey:@"data"] valueForKey:@"nickname"] forKey:@"nickName"];
            [self.userdefault setValue:[[jsonDic valueForKey:@"data"] valueForKey:@"mobile"] forKey:@"mobileStr"];
            //把数据传给第四页面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"personalMess" object:nil userInfo:jsonDic[@"data"]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"orderShuaxin" object:nil];
            
            //是否弹出优惠券
            NSString *jumpCoupon_Str = [NSString stringWithFormat:@"%@",jsonDic[@"data"][@"tc"]];
            
            //从退出登录进来的
            if (self.isFirst == YES) { //第一次进来的
                KPostNotification(KNotificationLoginStateChange, @YES);
                
                if ([jumpCoupon_Str isEqualToString:@"1"]) {
                    //异步耗时操作
                    [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:4.0];
                }
            } else {
                
                [self dismissViewControllerAnimated:YES completion:nil];
                if ([jumpCoupon_Str isEqualToString:@"1"]) {
                    [TCCouponView jumpCouponView];
                }
            }
            //设置登录状态为登录
            [self.userdefault setValue:@"yes" forKey:@"isLogin"];
        }
        [TCProgressHUD showMessage:jsonDic[@"msg"]];
    } failure:^(NSError *error) {
        nil;
    }];
}

- (void)delayMethod {
    [TCCouponView jumpCouponView];
}

#pragma mark -- 左边按钮返回事件
- (void)releaseInfo:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//键盘下落
- (void)keybodedown
{
    UITextField *textfieldPhone = (UITextField *)[self.view viewWithTag:1000];
    UITextField *textfieldCode = (UITextField *)[self.view viewWithTag:1001];
    
    [textfieldPhone resignFirstResponder];
    [textfieldCode resignFirstResponder];
}

//点击空白键盘下落
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self keybodedown];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
