//
//  TCModifyViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/22.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCModifyViewController.h"

@interface TCModifyViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@end

@implementation TCModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改用户名";
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    //确定按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    rightBtn.frame = CGRectMake(WIDTH - 130 - 12, 12, 30, 20);
    [rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [rightBtn setTitleColor:TCUIColorFromRGB(0x4C4C4C) forState:(UIControlStateNormal)];
    rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
   
    self.view.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    
    [self creatUI];
    // Do any additional setup after loading the view.
}

-(void)creatUI{
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(12, 12 + StatusBarAndNavigationBarHeight, WIDTH -24, 40)];
    textView.backgroundColor = TCUIColorFromRGB(0xF5F5F5);
    [self.view addSubview:textView];
    
    UILabel *label = [UILabel publicLab:@"用户名：" textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:16 numberOfLines:0];
    label.frame = CGRectMake(12, 9, 64,22);
    [textView addSubview:label];
    
    UITextField *nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 9, WIDTH - 24 - (CGRectGetMaxX(label.frame)), 22)];
    nameTextField.tag = 201;
    nameTextField.delegate = self;
    nameTextField.placeholder = @"请输入您的用户名";
    nameTextField.textColor = TCUIColorFromRGB(0x666666);
    nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameTextField.textAlignment = NSTextAlignmentLeft;
    nameTextField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [textView addSubview:nameTextField];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(textView.frame) + 18, WIDTH - 24, 17)];
    textLabel.text = @"字母或汉字开头,限4-16个字符";
    textLabel.textColor = TCUIColorFromRGB(0x999999);
    textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [self.view addSubview:textLabel];
    
}

#pragma mark -- 点击确定按钮
-(void)clickRightBtn:(UIButton *)sender{
    
    UITextField *textField = (UITextField *)[self.view viewWithTag:201];
    if (textField.text.length != 0) {
        //请求接口
        NSString *timeStr = [TCGetTime getCurrentTime];
        NSString *midStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userID"]];
        NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userToken"]];
        NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"NewNickName":textField.text,@"timestamp":timeStr};
        NSLog(@"%@",dic);
        NSString *signStr = [TCServerSecret signStr:dic];
        
        NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"NewNickName":textField.text,@"timestamp":timeStr,@"sign":signStr};
        
        [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102005"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
            NSLog(@"%@,%@",jsonDic,jsonStr);
            NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
            if ([codeStr isEqualToString:@"1"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeNice" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            [TCProgressHUD showMessage:jsonDic[@"msg"]];
        } failure:^(NSError *error) {
            nil;
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"用户名不能为空" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITextField *textField = (UITextField *)[self.view viewWithTag:201];
    [textField resignFirstResponder];
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
