//
//  TCLoginViewController.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/11/20.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCLoginViewController.h"
#import "TCBindPhoneViewController.h"
#import "TCTabBarController.h"
#import "TCExchangeViewController.h"
#import "TCProtocolViewController.h"
#import "AFNetworking.h"
#import "TCServerSecret.h"
#import "TCMyMessageViewController.h"
#import "TCCouponView.h" //优惠券
#import "JPUSHService.h"

@interface TCLoginViewController () <UITextFieldDelegate,WXApiDelegate,TencentSessionDelegate>
{
    UIButton *loginBtn; //登录按钮
    UIButton *codeBtn; //验证码的安妮
    NSTimer *timer;
    NSInteger timeCount;
    //获取当前版本号
    NSString *currentVersion;
}
@property (nonatomic, strong) NSUserDefaults *userdefault;
@property (nonatomic, strong) NSString *pushID; //推送的id
@property (nonatomic, strong) UIImageView *phoneImage;
@property (nonatomic, strong) UIImageView *cardImage;
@end

@implementation TCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.userdefault = [NSUserDefaults standardUserDefaults];
    _pushID = [_userdefault valueForKey:@"registrationID"];
    //获取当前版本号
    currentVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    //创建视图
    [self createUI];
    // Do any additional setup after loading the view.
}

//创建视图
- (void) createUI {
    
    //创建自定义的导航栏
    UIView *navView = [[UIView alloc] init];
    navView.frame = CGRectMake(0, 0, WIDTH, StatusBarAndNavigationBarHeight);
    navView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:navView];
    
    //叉
    UIButton *ReturnBtn = [[UIButton alloc]initWithFrame:CGRectMake(12 * WIDHTSCALE,(StatusBarAndNavigationBarHeight - 24 * HEIGHTSCALE)/2 + 10 * HEIGHTSCALE, 24 * WIDHTSCALE, 24 * WIDHTSCALE)];
    [ReturnBtn setImage:[UIImage imageNamed:@"关闭按钮"] forState:(UIControlStateNormal)];
    ReturnBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [ReturnBtn addTarget:self action:@selector(navBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [navView addSubview:ReturnBtn];
    
    UIButton *skipBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 18 * WIDHTSCALE - 28 * WIDHTSCALE,(StatusBarAndNavigationBarHeight - 20 * HEIGHTSCALE)/2 + 10 * HEIGHTSCALE, 28 * WIDHTSCALE, 20 * HEIGHTSCALE)];
    [skipBtn setTitleColor:TCUIColorFromRGB(0x6D6D6D) forState:(UIControlStateNormal)];
    [skipBtn setTitle:@"跳过" forState:(UIControlStateNormal)];
    skipBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    skipBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [skipBtn addTarget:self action:@selector(clickSkip) forControlEvents:(UIControlEventTouchUpInside)];
    [navView addSubview:skipBtn];
    
    //第一次
    if (self.isFirst == YES) {
        ReturnBtn.hidden = YES;
        skipBtn.hidden = NO;
    } else {
        ReturnBtn.hidden = NO;
        skipBtn.hidden = YES;
    }
    
    
    UIImageView *logoImage = [[UIImageView alloc]initWithFrame:CGRectMake((WIDTH - 54)/2,CGRectGetMaxY(navView.frame) + 10, 54, 54)];
    logoImage.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:logoImage];
    
    //创建textField
    NSArray *textfieldArr = @[@"输入手机号图标",@"输入验证码图标"];
    NSArray *placeArr = @[@"请输入您的手机号",@"请输入验证码"];
    for (int i = 0; i < textfieldArr.count; i ++) {
        //创建背景View
        UIView *backView = [[UIView alloc] init];
        backView.frame = CGRectMake(40, CGRectGetMaxY(logoImage.frame) + 40  + i * 55 , WIDTH - 80, 55);
        backView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
        [self.view addSubview:backView];
    
        UIImageView *iconimage = [[UIImageView alloc]initWithFrame:CGRectMake(2 ,(55 - 18)/2 , 14 , 18)];
        iconimage.image = [UIImage imageNamed:textfieldArr[i]];
        [backView addSubview:iconimage];
        
        //线
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 54, WIDTH - 80, 0.5)];
        line.backgroundColor = TCUIColorFromRGB(0xDEDEDE);
        line.alpha = 0.6;
        [backView addSubview:line];
        //创建textfield
        UITextField *textField = [[UITextField alloc] init];
        textField.frame = CGRectMake(CGRectGetMaxX(iconimage.frame) + 10, 20, WIDTH - 42 - 14 - 10 - 83 - 40, 15);
        [textField addTarget:self  action:@selector(alueChange:)  forControlEvents:UIControlEventAllEditingEvents];
        if (i == 0){
            self.phoneImage = iconimage;
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            //获取验证码的按钮
            codeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            codeBtn.frame = CGRectMake(WIDTH - 40 - 83 - 40,(55 - 26)/2 - 1, 83, 26);
            codeBtn.layer.masksToBounds = YES;
            codeBtn.layer.cornerRadius = 2;
            codeBtn.tag = 10000;
            codeBtn.userInteractionEnabled = NO;
            [codeBtn setBackgroundImage:[UIImage imageNamed:@"验证背景"] forState:(UIControlStateNormal)];
            [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [codeBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
            codeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [codeBtn addTarget:self action:@selector(codeBtn:) forControlEvents:(UIControlEventTouchUpInside)];
            codeBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
            [backView addSubview:codeBtn];
        }
        if (i == 1){
            self.cardImage = iconimage;
            textField.frame = CGRectMake(CGRectGetMaxX(iconimage.frame) + 10, 20 , WIDTH - (42 + 10 + 14 + 40 + 10), 15);
            textField.keyboardType = UIKeyboardTypeNamePhonePad;
        }
        textField.placeholder = placeArr[i];
        textField.delegate = self;
        textField.tag = i + 1000;
        textField.font = [UIFont systemFontOfSize:16];
        [backView addSubview:textField];
    }
    //在线申诉的label
    PCBClickLabel *appealLabel = [[PCBClickLabel alloc]initLabelViewWithLab:@"如号码已不用或丢失请选择在线申诉" clickTextRange:NSMakeRange(12, 4) clickAtion:^{
    NSLog(@"点击了");
    //在线申诉
    [self onlinePage];
    }];
    appealLabel.frame =  CGRectMake(41,CGRectGetMaxY(logoImage.frame) + (40 + 55 * 2 + 15), 192, 16);
    [self.view addSubview:appealLabel];
    
    //登录按钮
    loginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    loginBtn.frame = CGRectMake(40, (CGRectGetMaxY(appealLabel.frame) + 67) *WIDHTSCALE, WIDTH - 80 , 44);
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 6;
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"登录按钮背景"] forState:(UIControlStateNormal)];
    [loginBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    loginBtn.userInteractionEnabled = YES;
    [loginBtn setTitle:@"登录" forState:(UIControlStateNormal)];
    [loginBtn addTarget:self action:@selector(login:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:loginBtn];
    
    //第三方登录的标线
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake((WIDTH - 84)/2, HEIGHT - (15 + 17 + 80 + 20) * HEIGHTSCALE, 84, 20 * HEIGHTSCALE);
    titleLabel.text = @"其他方式登录";
    titleLabel.textColor = TCUIColorFromRGB(0x999999);
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14 ];
    [self.view addSubview:titleLabel];
    
    //两条线
    UILabel *line_one = [[UILabel alloc] init];
    line_one.frame = CGRectMake(((WIDTH - 70)/2 - 15 - 40), HEIGHT - (15 + 17 + 90) * HEIGHTSCALE, 40, 1 * HEIGHTSCALE);
    line_one.backgroundColor = TCUIColorFromRGB(0xEDEDED);
    [self.view addSubview:line_one];
    
    UILabel *line_two = [[UILabel alloc] init];
    line_two.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame) + 15 , HEIGHT - (15 + 17 + 90) * HEIGHTSCALE, 40, 1 * HEIGHTSCALE);
    line_two.backgroundColor = TCUIColorFromRGB(0xEDEDED);
    [self.view addSubview:line_two];
    
    //微信登录 && qq登录
    UIButton *weixinBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    weixinBtn.frame = CGRectMake((WIDTH - 30* WIDHTSCALE - 30 * WIDHTSCALE- 66* WIDHTSCALE)/2 , CGRectGetMaxY(titleLabel.frame) + 20 * HEIGHTSCALE, 30 * HEIGHTSCALE, 30 * HEIGHTSCALE);
    [weixinBtn setBackgroundImage:[UIImage imageNamed:@"微信1"] forState:(UIControlStateNormal)];
    [weixinBtn addTarget:self action:@selector(weixinBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:weixinBtn];
    
    UIButton *qqBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    qqBtn.frame = CGRectMake(CGRectGetMaxX(weixinBtn.frame) + 66 * WIDHTSCALE, CGRectGetMaxY(titleLabel.frame) + 20 * HEIGHTSCALE, 30 * HEIGHTSCALE, 30 *HEIGHTSCALE);
    [qqBtn setBackgroundImage:[UIImage imageNamed:@"QQ1"] forState:(UIControlStateNormal)];
    [qqBtn addTarget:self action:@selector(qqBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:qqBtn];

    UIButton *xieyiBtn = [[UIButton alloc]initWithFrame:CGRectMake((WIDTH - 200 * WIDHTSCALE)/2 + 3 * WIDHTSCALE, HEIGHT - 15  * HEIGHTSCALE- 17 * HEIGHTSCALE, 200 * WIDHTSCALE, 17 * HEIGHTSCALE)];
    [xieyiBtn setTitle:@"登录即同意《用户服务协议》" forState:(UIControlStateNormal)];
    [xieyiBtn setTitleColor:TCUIColorFromRGB(0x797979) forState:(UIControlStateNormal)];
    xieyiBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    xieyiBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12 * HEIGHTSCALE];
    [xieyiBtn addTarget:self action:@selector(checkProtocloVC) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:xieyiBtn];
}

//textfield的协议
-(void)alueChange:(UITextField *)textField{
    
    UITextField *textfieldPhone = (UITextField *)[self.view viewWithTag:1000];
    UITextField *textfieldCode = (UITextField *)[self.view viewWithTag:1001];
    
    if (textfieldPhone.text.length != 0) {
        self.phoneImage.image = [UIImage imageNamed:@"输入手机号图标（输入的）"];
        codeBtn.userInteractionEnabled = YES;
    }else{
        self.phoneImage.image = [UIImage imageNamed:@"输入手机号图标"];
    }
    if (textfieldCode.text.length != 0) {
        self.cardImage.image = [UIImage imageNamed:@"输入验证码图标（输入后的）"];
    }else{
        self.cardImage.image = [UIImage imageNamed:@"输入验证码图标"];
    }
    
    loginBtn.enabled =  textfieldCode.text.length != 0;
    if(loginBtn.enabled == YES){
        loginBtn.userInteractionEnabled = YES;
    }else{
        loginBtn.userInteractionEnabled = NO;
    }
}

-(void)clickSkip{
    NSLog(@"跳过");
    if (self.isFirst == YES) {
        TCTabBarController *tabbar = [TCTabBarController new];
        [[[UIApplication sharedApplication] delegate] window]. rootViewController = tabbar;
    } else {
        self.tabBarController.selectedIndex = 0;
    }
}

#pragma mark -- 获取验证码的点击事件
- (void)codeBtn:(UIButton *)sender
{
    [self keybodedown];
    
    UITextField *textfieldPhone = (UITextField *)[self.view viewWithTag:1000];
    
    if(textfieldPhone.text.length < 11 || ![BSUtils checkTelNumber:textfieldPhone.text]){
        [TCProgressHUD showMessage:@"请输入正确的11位手机号码"];
    }else {
        timeCount = 60;
        [ProgressHUD showHUDToView:self.view];
        sender.userInteractionEnabled = NO;
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime:) userInfo:nil repeats:YES];
        [self keybodedown];
        NSString *Timestr = [TCGetTime getCurrentTime];
        
        NSDictionary *dic = @{@"mobile":textfieldPhone.text,@"type":@"3",@"timestamp":Timestr};
        NSString *singStr = [TCServerSecret signStr:dic];
        NSDictionary *paramters = @{@"mobile":textfieldPhone.text,@"timestamp":Timestr,@"type":@"3",@"sign":singStr};
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
        NSString *str = [NSString stringWithFormat:@"%luS重新获取", (long)timeCount];
        [codeBtn setTitle:str forState:UIControlStateNormal];
//        codeBtn.backgroundColor = TCUIColorFromRGB(0xCCCCCC);
        codeBtn.userInteractionEnabled = NO;
    }
}

#pragma mark -- 用户协议点击事件
-(void)checkProtocloVC{
    NSLog(@"用户协议");
    [self keybodedown];
    TCProtocolViewController *protocolVC = [[TCProtocolViewController alloc] init];
    protocolVC.isLogin = YES;
    TCNavController *navVC = [[TCNavController alloc] initWithRootViewController:protocolVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

#pragma mark -- 登录的点击事件
- (void)login:(UIButton *)sender
{
    [self keybodedown];
    
    UITextField *textfieldPhone = (UITextField *)[self.view viewWithTag:1000];
    UITextField *textfieldcode = (UITextField *)[self.view viewWithTag:1001];
    
    if(textfieldPhone.text.length < 11 || ![BSUtils checkTelNumber:textfieldPhone.text]){
        [TCProgressHUD showMessage:@"请输入正确的11位手机号码"];
    } else {
        //请求
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
        
        [self questAndMobile:textfieldPhone.text Andcode:textfieldcode.text Andpushid:self.pushID AndversionId:currentVersion anddevice:[TCDeviceName getDeviceName] deviceid:[TCGetDeviceId getDeviceId] deviceSysInfo:@"IOS"];
    }
}

#pragma mark -- 登录成功
- (void)questAndMobile:(NSString *)phone Andcode:(NSString *)code Andpushid:(NSString *)pushid AndversionId:(NSString *)versionStr anddevice:(NSString *)device deviceid:(NSString *)deveiceID deviceSysInfo:(NSString *)SysInfo
{
    //指示器
    [ProgressHUD showHUDToView:self.view];
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSLog(@"%@",timeStr);
    
    NSDictionary *dic = @{@"mobile":phone, @"code":code,@"pushid":pushid,@"versionId":versionStr,@"device":device,@"deviceid":deveiceID,@"deviceSysInfo":SysInfo,@"timestamp":timeStr};
    NSString *signStr = [TCServerSecret signStr:dic];
    NSDictionary *paramters = @{@"mobile":phone, @"code":code,@"pushid":pushid,@"versionId":versionStr,@"device":device,@"deviceid":deveiceID,@"deviceSysInfo":SysInfo,@"timestamp":timeStr,@"sign":signStr};
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102001"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        [ProgressHUD hiddenHUD:self.view];
        NSString *str = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if ([str isEqualToString:@"1"]){
            
            //基本信息保存
            //记录用户ID 和token值  角色类型  是否通过验证
            [self.userdefault setValue:[[jsonDic valueForKey:@"data"] valueForKey:@"memberid"] forKey:@"userID"];
            [self.userdefault setValue:[[jsonDic valueForKey:@"data"] valueForKey:@"token"] forKey:@"userToken"];
            //个人信息
            [self.userdefault setValue:[[jsonDic valueForKey:@"data"] valueForKey:@"src"] forKey:@"imageHead"];
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

#pragma mark -- 微信登录
- (void)weixinBtn:(UIButton *)sender
{
    [self keybodedown];
    //授权之前取消授权
        [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
        [ShareSDK getUserInfo:SSDKPlatformTypeWechat
               onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
         {
             if (state == SSDKResponseStateSuccess)
             {
                 NSLog(@"uid=%@",user.uid);
                 NSLog(@"%@",user.credential);
                 NSLog(@"token=%@",user.credential.token);
                 NSLog(@"nickname=%@",user.nickname);
                 
                 //请求
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
                 
                 [self questOpenId:user.uid AndOpenType:@"1" AndHeadPic:user.icon Andnickname:user.nickname Andpushid:self.pushID Anddeviceid:[TCGetDeviceId getDeviceId] AnddeviceSysInfo:[TCDeviceName getDeviceName] AndversionId:currentVersion Andtimestamp:[TCGetTime getCurrentTime]];
                 
             } else {
                 NSLog(@"%@--- 错误了吗",error);
             }
      }];
}

#pragma mark -- QQ登录
- (void)qqBtn:(UIButton *)sender
{
    [self keybodedown];
    NSLog(@"qq登录");
    [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
    
    [ShareSDK getUserInfo:(SSDKPlatformTypeQQ) onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess){
            NSLog(@"uid=%@",user.icon);
            NSLog(@"%@",user.credential);
            NSLog(@"token=%@",user.credential.token);
            NSLog(@"nickname=%@",user.nickname);
            //请求接口 第三方qq登录
            
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
            
            [self questOpenId:user.uid AndOpenType:@"2" AndHeadPic:user.icon Andnickname:user.nickname Andpushid:self.pushID Anddeviceid:[TCGetDeviceId getDeviceId] AnddeviceSysInfo:[TCDeviceName getDeviceName] AndversionId:currentVersion Andtimestamp:[TCGetTime getCurrentTime]];
            
        } else {
            NSLog(@"%@错误了吗",error);
        }
    }];
}

//请求第三方登录的接口
- (void)questOpenId:(NSString *)openId AndOpenType:(NSString *)openType AndHeadPic:(NSString *)headpic Andnickname:(NSString *)nickName Andpushid:(NSString *)pushid Anddeviceid:(NSString *)deviceStr AnddeviceSysInfo:(NSString *)info AndversionId:(NSString *)versionID Andtimestamp:(NSString *)times{
    
    [ProgressHUD showHUDToView:self.view];
    
    NSDictionary *dic = @{@"openId":openId,@"openType":openType,@"headPic":headpic,@"nickname":nickName,@"deviceid":deviceStr,@"deviceSysInfo":info,@"versionId":versionID,@"timestamp":times,@"pushid":pushid};
    NSString *signStr = [TCServerSecret signStr:dic];
    NSDictionary *paramters = @{@"openId":openId,@"openType":openType,@"headPic":headpic,@"nickname":nickName,@"deviceid":deviceStr,@"deviceSysInfo":info,@"versionId":versionID,@"timestamp":times,@"sign":signStr,@"pushid":pushid};
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"104001"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        NSString *jumpStr = [NSString stringWithFormat:@"%@",jsonDic[@"data"][@"jump"]];
        if ([codeStr isEqualToString:@"1"]){
            if ([jumpStr isEqualToString:@"1"]){
                [self bindSkip:openId];
            } else if ([jumpStr isEqualToString:@"2"]){
                //记录用户ID 和token值  角色类型  是否通过验证
                [self.userdefault setValue:[[jsonDic valueForKey:@"data"] valueForKey:@"memberid"] forKey:@"userID"];
                [self.userdefault setValue:[[jsonDic valueForKey:@"data"] valueForKey:@"token"] forKey:@"userToken"];
                //个人信息
                [self.userdefault setValue:[[jsonDic valueForKey:@"data"] valueForKey:@"headPic"] forKey:@"imageHead"];
                [self.userdefault setValue:[[jsonDic valueForKey:@"data"] valueForKey:@"nickname"] forKey:@"nickName"];
                [self.userdefault setValue:[[jsonDic valueForKey:@"data"] valueForKey:@"mobile"] forKey:@"mobileStr"];
                //把数据传给第四页面
                [[NSNotificationCenter defaultCenter] postNotificationName:@"personalMess" object:nil userInfo:jsonDic[@"data"]];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"orderShuaxin" object:nil];
            
                //设置登录状态为登录
                [self.userdefault setValue:@"yes" forKey:@"isLogin"];
                
                if (self.isFirst == YES) {
                
                    KPostNotification(KNotificationLoginStateChange, @YES);
                } else {
                    //登录成功了
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }
            [ProgressHUD hiddenHUD:self.view];
            [TCProgressHUD showMessage:jsonDic[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        nil;
        [ProgressHUD hiddenHUD:self.view];
    }];
}
-(void)clickRe:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -- 跳过的点击事件
- (void)navBtn:(UIButton *)sender
{
    //第四页跳转
    if (self.isFirst == YES) {
        KPostNotification(KNotificationLoginStateChange, @YES);
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
// 绑定手机页面跳转
- (void)bindSkip:(NSString *)openID {
    TCBindPhoneViewController *bindVC = [[TCBindPhoneViewController alloc] init];
    bindVC.openid = openID;
    bindVC.isFirst = self.isFirst;
    TCNavController *navVC = [[TCNavController alloc] initWithRootViewController:bindVC];
    [self.navigationController pushViewController:navVC animated:YES];
    [self presentViewController:navVC animated:YES completion:nil];
}

//在线申诉
- (void)onlinePage {
    TCExchangeViewController *exchangeVC = [[TCExchangeViewController alloc] init];
    TCNavController *navVC = [[TCNavController alloc] initWithRootViewController:exchangeVC];
    [self presentViewController:navVC animated:YES completion:nil];
}
//键盘下落
- (void)keybodedown
{
    UITextField *textfieldPhone = (UITextField *)[self.view viewWithTag:1000];
    UITextField *textfieldCode = (UITextField *)[self.view viewWithTag:1001];
    
    [textfieldPhone resignFirstResponder];
    [textfieldCode resignFirstResponder];
}

//点击空白处键盘下滑
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITextField *textfieldPhone = (UITextField *)[self.view viewWithTag:1000];
    UITextField *textfieldCode = (UITextField *)[self.view viewWithTag:1001];
    
    [textfieldPhone resignFirstResponder];
    [textfieldCode resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self keybodedown];
}

@end
