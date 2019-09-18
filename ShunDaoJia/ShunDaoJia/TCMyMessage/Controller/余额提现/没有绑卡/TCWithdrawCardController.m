//
//  TCWithdrawCardController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/15.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCWithdrawCardController.h"
#import "TCWithaddDController.h"

@interface TCWithdrawCardController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) NSUserDefaults *userdefaults;

@end

@implementation TCWithdrawCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加银行卡";
    self.userdefaults = [NSUserDefaults standardUserDefaults];
    self.view.backgroundColor = TCBgColor;
    
    [self creatUI];
    // Do any additional setup after loading the view.
}
-(void)creatUI{
    UILabel *banglabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 12 + StatusBarAndNavigationBarHeight, 200, 22)];
    banglabel.textAlignment = NSTextAlignmentLeft;
    banglabel.text = @"请绑定账户本人的银行卡";
    banglabel.textColor = TCUIColorFromRGB(0x4C4C4C);
    banglabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [self.view addSubview:banglabel];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(banglabel.frame) + 12, WIDTH, 46)];
    bgView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:bgView];
    
    UILabel*numLabel = [[UILabel alloc]initWithFrame:CGRectMake(24, 12, 32, 22)];
    numLabel.text = @"卡号";
    numLabel.textColor = TCUIColorFromRGB(0x4C4C4C);
    numLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    numLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:numLabel];
    
    UITextField *CardField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(numLabel.frame) + 20, 12, WIDTH - 44 - 48, 22)];
    CardField.tag = 1201;
    CardField.clearButtonMode = UITextFieldViewModeWhileEditing;
    CardField.delegate = self;
    CardField.keyboardType = UIKeyboardTypeNumberPad;
    CardField.borderStyle = UITextBorderStyleNone;
    CardField.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    CardField.textColor = TCUIColorFromRGB(0x4C4C4C);
    CardField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    CardField.textAlignment = NSTextAlignmentLeft;
    CardField.placeholder = @"仅支持储蓄卡";
    [CardField addTarget:self  action:@selector(alueChange:)  forControlEvents:UIControlEventAllEditingEvents];
    [bgView addSubview:CardField];
    
    self.nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(bgView.frame) + 40, WIDTH - 24, 48)];
    self.nextBtn.tag = 1202;
    self.nextBtn.layer.masksToBounds = YES;
    self.nextBtn.layer.cornerRadius = 4;
    [self.nextBtn setTitle:@"下一步" forState:(UIControlStateNormal)];
    [self.nextBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    self.nextBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    [self.nextBtn setBackgroundColor:TCUIColorFromRGB(0xCCCCCC)];
    self.nextBtn.userInteractionEnabled = NO;
    self.nextBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.nextBtn addTarget:self action:@selector(clickNext:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.nextBtn];
}
- (void)alueChange:(UITextField *)textField{
    UITextField *find_textfield = (UITextField *)[self.view viewWithTag:1201];
    self.nextBtn.enabled = find_textfield.text.length != 0;
    if (self.nextBtn.enabled == YES) {
        self.nextBtn.userInteractionEnabled = YES;
        [self.nextBtn setBackgroundColor:TCUIColorFromRGB(0xF99E20)];
    }else{
        self.nextBtn.userInteractionEnabled = NO;
        [self.nextBtn setBackgroundColor:TCUIColorFromRGB(0xCCCCCC)];
    }
}

-(void)clickNext:(UIButton *)sender{
    UITextField *find_textfield = (UITextField *)[self.view viewWithTag:1201];
    if ([BSUtils IsBankCard:find_textfield.text]) {
        [find_textfield resignFirstResponder];
        [self request];
    }else{
        [TCProgressHUD showMessage:@"请输入正确的银行卡号"];
    }
}
-(void)request{
    UITextField *find_textfield = (UITextField *)[self.view viewWithTag:1201];
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *cardno = find_textfield.text;
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"cardno":cardno};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"sign":signStr,@"cardno":cardno};
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"103009"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        [TCProgressHUD showMessage:jsonDic[@"msg"]];
        NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if ([codeStr isEqualToString:@"1"]) {
            TCWithaddDController *addD = [[TCWithaddDController alloc]init];
            addD.cardnum = cardno;
            addD.cardname = jsonDic[@"data"][@"bankname"];
            addD.cardid = jsonDic[@"data"][@"bankCode"];
            addD.entranceTypeStr = self.entranceTypeStr;
            [self.navigationController pushViewController:addD animated:YES];
        }
    } failure:^(NSError *error) {
        nil;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITextField *find_textfield = (UITextField *)[self.view viewWithTag:1201];
    [find_textfield resignFirstResponder];
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
