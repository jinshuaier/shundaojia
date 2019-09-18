//
//  TCagainPayVerController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/24.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCagainPayVerController.h"
#import "TPPasswordTextView.h"
#import "TCextanceAddVController.h"

@interface TCagainPayVerController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong)  TPPasswordTextView *textView;

@end

@implementation TCagainPayVerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加银行卡";

    self.view.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    
    [self creatUI];
    // Do any additional setup after loading the view.
}

-(void)creatUI{

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 48, 180, 20)];
    label.text = @"请再次输入，已确认密码";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    label.textColor = TCUIColorFromRGB(0x4C4C4C);
    [self.view addSubview:label];
    
    //设置六位密码框
    self.textView = [[TPPasswordTextView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(label.frame) + 16, WIDTH - 24, 46)];
    self.textView.backgroundColor = TCUIColorFromRGB(0xF5F5F5);
    self.textView.elementCount = 6;
    self.textView.elementBorderColor = TCUIColorFromRGB(0xF5F5F5);
    self.textView.elementMargin = 12;
    CGFloat pading = (self.textView.frame.size.width - 60)/6;
    [self.view addSubview:self.textView];
    
    for (int i = 0; i < 5; i ++) {
        UIView *padView = [[UIView alloc]initWithFrame:CGRectMake(pading *(i + 1) + 12*i, 0, 12, 46)];
        
        //为textView添加点击事件
        UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getIntoAccount:)];
        UITapGestureRecognizer *singleRecognizer1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gettanchu:)];;
        
        [self.textView addGestureRecognizer:singleRecognizer1];
        
        [padView addGestureRecognizer:singleRecognizer];
        padView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
        [self.textView addSubview:padView];
    }
    self.textView.passwordDidChangeBlock = ^(NSString *password) {
        NSLog(@"%@",password);

        if (password.length != 0) {
            _sureBtn.userInteractionEnabled = YES;
            [_sureBtn setBackgroundColor:TCUIColorFromRGB(0xF99E20)];
            
        }else{
            _sureBtn.userInteractionEnabled = NO;
            [_sureBtn setBackgroundColor:TCUIColorFromRGB(0xCCCCCC)];
        }
    };
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(self.textView.frame) + 12, WIDTH - 24, 34)];
    textLabel.text = @"本密码用来充值，提现，支付订单等。支付验证密码不等同于取钱密码。";
    textLabel.numberOfLines = 2;
    textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    textLabel.textColor = TCUIColorFromRGB(0x999999);
    textLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:textLabel];
    
    
    
    _sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(textLabel.frame) + 40, WIDTH - 24, 48)];
    [_sureBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    [_sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    _sureBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    _sureBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_sureBtn addTarget:self action:@selector(clickSure:) forControlEvents:(UIControlEventTouchUpInside)];
    _sureBtn.userInteractionEnabled = NO;
    _sureBtn.backgroundColor = TCUIColorFromRGB(0xCCCCCC);
    [self.view addSubview:_sureBtn];
    
}

#pragma mark -- UIGesturecognizerDelegate
-(void)getIntoAccount:(UIGestureRecognizer *)sender{
    NSLog(@"蛇么都没有");
}

-(void)gettanchu:(UITapGestureRecognizer *)sender{
    NSLog(@"什么都没有");
}


#pragma mark -- 点击确定
-(void)clickSure:(UIButton *)sender{
    [self.textView resignFirstResponder];
    
    TCextanceAddVController *extanceVC = [[TCextanceAddVController alloc]init];
    [self.navigationController pushViewController:extanceVC animated:YES];
    
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
