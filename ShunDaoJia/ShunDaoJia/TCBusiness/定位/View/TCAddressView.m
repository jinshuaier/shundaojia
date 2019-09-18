//
//  TCAddressView.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/11/27.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCAddressView.h"

@interface TCAddressView ()<UITextFieldDelegate>

@end

@implementation TCAddressView

-(id)initWithFrame:(CGRect)frame andDic:(NSDictionary *)messdic{
    self = [super initWithFrame:frame];
    if(self) {
        //创建View
        [self createUI:messdic];
        self.dic = messdic;
        self.userdefaults = [NSUserDefaults standardUserDefaults];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        if (self.dic.count == 0) {
            self.addressId = @"0";
        } else {
            self.longtitude = self.dic[@"longtitude"];
            self.latitude = self.dic[@"latitude"];
            self.addressId = [NSString stringWithFormat:@"%@",self.dic[@"id"]];
        }
    }
    return self;
}

//创建view
- (void)createUI:(NSDictionary *)messdic
{
    NSLog(@"%@",messdic);
    //联系人
    self.back_phoneLabel = [UILabel publicLab:@"联系人" textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    self.back_phoneLabel.frame = CGRectMake(12, 12, 42, 18);
    [self addSubview:self.back_phoneLabel];
    
    self.back_phone = [[UIView alloc] init];
    self.back_phone.frame = CGRectMake(0, CGRectGetMaxY(self.back_phoneLabel.frame) + 12, WIDTH, 54*3);
    self.back_phone.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self addSubview:self.back_phone];
    
    self.phoneLabel = [UILabel publicLab:@"姓名：" textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
    self.phoneLabel.frame = CGRectMake(12, 18, 48, 20);
    [self.back_phone addSubview:self.phoneLabel];
    
    self.nameTextfiled = [[UITextField alloc] init];
    if (messdic != nil){
        self.nameTextfiled.text = messdic[@"name"];
    }
    self.nameTextfiled.placeholder = @"输入收货人的姓名";
    [self.nameTextfiled addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    self.nameTextfiled.delegate = self;
    self.nameTextfiled.textColor = TCUIColorFromRGB(0x333333);
    self.nameTextfiled.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    self.nameTextfiled.textAlignment = NSTextAlignmentLeft;
    [self.nameTextfiled setValue:TCUIColorFromRGB(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    [self.nameTextfiled setValue:[UIFont fontWithName:@"PingFangSC-Regular" size:15] forKeyPath:@"_placeholderLabel.font"];
    self.nameTextfiled.frame = CGRectMake(CGRectGetMaxX(self.phoneLabel.frame), 17, WIDTH - 38 - 60, 21);
    [self.back_phone addSubview:self.nameTextfiled];
    
    self.viewLine = [[UIView alloc] init];
    self.viewLine.frame = CGRectMake(60, CGRectGetMaxY(self.nameTextfiled.frame) + 16, WIDTH - 60, 1);
    self.viewLine.backgroundColor = TCLineColor;
    [self.back_phone addSubview:self.viewLine];
    
    //button
    for (int i = 0; i < 2; i ++) {
        NSArray *sexArr = @[@"男士",@"女士"];
        self.sexBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.sexBtn.tag = 100 + i;
        self.sexBtn.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
        self.sexBtn.layer.cornerRadius = 4;
        self.sexBtn.layer.masksToBounds = YES;
        self.sexBtn.layer.borderWidth = 1;
        self.sexBtn.layer.borderColor=[[UIColor grayColor] colorWithAlphaComponent:0.4].CGColor;
        [self.sexBtn addTarget:self action:@selector(sex:) forControlEvents:(UIControlEventTouchUpInside)];
        self.sexBtn.frame = CGRectMake(64 + (60 + 32) * i, CGRectGetMaxY(_viewLine.frame) + 14, 60, 26);
        [self.sexBtn setTitle:sexArr[i] forState:(UIControlStateNormal)];
        [self.sexBtn setTitleColor:TCUIColorFromRGB(0x999999) forState:(UIControlStateNormal)];
        [self.sexBtn setTitleColor:TCUIColorFromRGB(0xF99E20) forState:UIControlStateSelected];
        self.sexBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        if ([messdic count] != 0){
            if ([messdic[@"gender"] isEqualToString:@"0"]){
                //男
                if (i == 0){
                    self.sexBtn.selected = YES;
                    self.lastButton = self.sexBtn;
                    self.sexBtn.backgroundColor = [TCUIColorFromRGB(0xF99E20) colorWithAlphaComponent:0.1];
                    self.sexBtn.layer.borderColor=[TCUIColorFromRGB(0xF99E20) colorWithAlphaComponent:0.4].CGColor;
                }
                
            } else if ([messdic[@"gender"] isEqualToString:@"1"]){
                //女
                if (i == 1){
                    self.sexBtn.selected = YES;
                    self.lastButton = self.sexBtn;
                    self.sexBtn.backgroundColor = [TCUIColorFromRGB(0xF99E20) colorWithAlphaComponent:0.1];
                    self.sexBtn.layer.borderColor=[TCUIColorFromRGB(0xF99E20) colorWithAlphaComponent:0.4].CGColor;
                }
            }
        } else {
            if (i == 0){
                self.sexBtn.selected = YES;
                self.lastButton = self.sexBtn;
                self.sexBtn.backgroundColor = [TCUIColorFromRGB(0xF99E20) colorWithAlphaComponent:0.1];
                self.sexBtn.layer.borderColor=[TCUIColorFromRGB(0xF99E20) colorWithAlphaComponent:0.4].CGColor;
            }
        }
        
        [self.back_phone addSubview:self.sexBtn];
    }
    UIView *line_two = [[UIView alloc] init];
    line_two.backgroundColor = TCLineColor;
    line_two.frame = CGRectMake(12, CGRectGetMaxY(self.sexBtn.frame) + 13, WIDTH - 12, 1);
    [self.back_phone addSubview:line_two];
    
    //电话
    self.phoneLabel = [UILabel publicLab:@"电话：" textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
    self.phoneLabel.frame = CGRectMake(12, CGRectGetMaxY(line_two.frame) + 18, 48, 20);
    [self.back_phone addSubview:self.phoneLabel];
    
    //电话
    self.phoneTextfiled = [[UITextField alloc] init];
    if (messdic != nil){
        self.phoneTextfiled.text = messdic[@"mobile"];
    }
    self.phoneTextfiled.placeholder = @"收货人电话";
    [self.phoneTextfiled addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    self.phoneTextfiled.textColor = TCUIColorFromRGB(0x333333);
    self.phoneTextfiled.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    self.phoneTextfiled.delegate = self;
    self.phoneTextfiled.textAlignment = NSTextAlignmentLeft;
    [self.phoneTextfiled setValue:TCUIColorFromRGB(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    [self.phoneTextfiled setValue:[UIFont fontWithName:@"PingFangSC-Regular" size:15] forKeyPath:@"_placeholderLabel.font"];
    self.phoneTextfiled.frame = CGRectMake(CGRectGetMaxX(self.phoneLabel.frame), CGRectGetMaxY(line_two.frame) + 18, WIDTH - 38 - 60, 21);
    [self.back_phone addSubview:self.phoneTextfiled];
    
    self.adressLabel = [UILabel publicLab:@"收货地址" textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    self.adressLabel.frame = CGRectMake(12, CGRectGetMaxY(self.back_phone.frame) + 12, 60, 18);
    [self addSubview:self.adressLabel];
    
    self.back_adress = [[UIView alloc] init];
    self.back_adress.frame = CGRectMake(0, CGRectGetMaxY(self.adressLabel.frame) + 12, WIDTH, 54 * 3);
    self.back_adress.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.back_adress];
    
    UIView *tapView = [[UIView alloc] init];
    tapView.userInteractionEnabled = YES;
    tapView.frame = CGRectMake(0, 0, WIDTH, 54);
    [self.back_adress addSubview:tapView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [tapView addGestureRecognizer:tap];
    
    UILabel *headLabel = [UILabel publicLab:@"地址：" textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
    headLabel.frame = CGRectMake(12, 18, 48, 20);
    [tapView addSubview:headLabel];
    
    self.adressTextfiled = [[UITextField alloc] init];
    if (messdic != nil){
        self.adressTextfiled.text = messdic[@"locaddress"];
    }
    self.adressTextfiled.delegate = self;

    self.adressTextfiled.placeholder = @"选择收货地址";
    [self.adressTextfiled addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    self.adressTextfiled.textColor = TCUIColorFromRGB(0x333333);
    self.adressTextfiled.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    self.adressTextfiled.textAlignment = NSTextAlignmentLeft;
    [self.adressTextfiled setValue:TCUIColorFromRGB(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    [self.adressTextfiled setValue:[UIFont fontWithName:@"PingFangSC-Regular" size:15] forKeyPath:@"_placeholderLabel.font"];
    self.adressTextfiled.frame = CGRectMake(CGRectGetMaxX(headLabel.frame), 17, WIDTH - 38 - 60, 21);
    self.adressTextfiled.enabled = NO;
    [tapView addSubview:self.adressTextfiled];
    
    //小三角
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"进入小三角（灰）"]];
    image.frame = CGRectMake(WIDTH - 13.5 - 5, 54 - 23.5 - 8, 5, 8);
    [tapView addSubview:image];
    
    //线
    UIView *line_three = [[UIView alloc] init];
    line_three.frame = CGRectMake(12, CGRectGetMaxY(tapView.frame), WIDTH - 12, 1);
    line_three.backgroundColor = TCLineColor;
    [self.back_adress addSubview:line_three];
    
    self.dizhiLabel = [UILabel publicLab:@"详细地址：" textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
    self.dizhiLabel.frame = CGRectMake(12, CGRectGetMaxY(line_three.frame) + 18, 82, 20);
    [self.back_adress addSubview:self.dizhiLabel];
    
    self.dizhiTextfiled = [[UITextField alloc] init];
    
    if (messdic != nil){
        self.dizhiTextfiled.text = messdic[@"address"];
    }
    self.dizhiTextfiled.delegate = self;

    self.dizhiTextfiled.placeholder = @"例：5号院56号楼";
    [self.dizhiTextfiled addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    self.dizhiTextfiled.textColor = TCUIColorFromRGB(0x333333);
    self.dizhiTextfiled.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    self.dizhiTextfiled.textAlignment = NSTextAlignmentLeft;
    [self.dizhiTextfiled setValue:TCUIColorFromRGB(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    [self.dizhiTextfiled setValue:[UIFont fontWithName:@"PingFangSC-Regular" size:15] forKeyPath:@"_placeholderLabel.font"];
    self.dizhiTextfiled.frame = CGRectMake(CGRectGetMaxX(self.dizhiLabel.frame), CGRectGetMaxY(line_three.frame) + 18, WIDTH - 4 - 94, 21);
    [self.back_adress addSubview:self.dizhiTextfiled];
    
    //细线
    UIView *line_four = [[UIView alloc] init];
    line_four.frame = CGRectMake(12, CGRectGetMaxY(self.dizhiTextfiled.frame) + 16, WIDTH - 12, 1);
    line_four.backgroundColor = TCLineColor;
    [self.back_adress addSubview:line_four];
    
    //标签
    UILabel *tagLabel = [UILabel publicLab:@"标签：" textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
    tagLabel.frame = CGRectMake(12, CGRectGetMaxY(line_four.frame) + 18, 48, 20);
    [self.back_adress addSubview:tagLabel];
    
    for (int i = 0; i < 3; i ++) {
        NSArray *sexArr = @[@"家",@"公司",@"学校"];
        self.adressBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.adressBtn.tag = 1000 + i;
        
        self.adressBtn.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
        self.adressBtn.layer.cornerRadius = 4;
        self.adressBtn.layer.masksToBounds = YES;
        self.adressBtn.layer.borderWidth = 1;
        self.adressBtn.layer.borderColor=[[UIColor grayColor] colorWithAlphaComponent:0.4].CGColor;;
        self.adressBtn.frame = CGRectMake(64 + (60 + 32) * i, CGRectGetMaxY(line_four.frame) + 16, 60, 26);
        [self.adressBtn addTarget:self action:@selector(adressBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.adressBtn setTitle:sexArr[i] forState:(UIControlStateNormal)];
        [self.adressBtn setTitleColor:TCUIColorFromRGB(0x999999) forState:(UIControlStateNormal)];
        [self.adressBtn setTitleColor:TCUIColorFromRGB(0xF99E20) forState:UIControlStateSelected];
        self.adressBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [self.back_adress addSubview:self.adressBtn];
        if (messdic != nil){
            if ([messdic[@"tag"] isEqualToString:@"家"]){
                if (i == 0){
                    self.adressBtn.selected = YES;
                    self.aressLsButton = self.adressBtn;
                    self.adressBtn.backgroundColor = [TCUIColorFromRGB(0xF99E20) colorWithAlphaComponent:0.1];
                  self.adressBtn.layer.borderColor=[TCUIColorFromRGB(0xF99E20) colorWithAlphaComponent:0.4].CGColor;
                }
            } else if ([messdic[@"tag"] isEqualToString:@"公司"]){
                if (i == 1){
                    self.adressBtn.selected = YES;
                    self.aressLsButton = self.adressBtn;
                    self.adressBtn.backgroundColor = [TCUIColorFromRGB(0xF99E20) colorWithAlphaComponent:0.1];
                    self.adressBtn.layer.borderColor=[TCUIColorFromRGB(0xF99E20) colorWithAlphaComponent:0.4].CGColor;
                }
            } else if ([messdic[@"tag"] isEqualToString:@"学校"]){
                if (i == 2){
                    self.adressBtn.selected = YES;
                    self.aressLsButton = self.adressBtn;
                    self.adressBtn.backgroundColor = [TCUIColorFromRGB(0xF99E20) colorWithAlphaComponent:0.1];
                    self.adressBtn.layer.borderColor=[TCUIColorFromRGB(0xF99E20) colorWithAlphaComponent:0.4].CGColor;
                }
            }
        }
        self.back_adress.frame = CGRectMake(0, CGRectGetMaxY(self.adressLabel.frame) + 12, WIDTH, CGRectGetMaxY(self.adressBtn.frame) + 14);
    }
    
    //确定按钮
    self.okBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.okBtn.frame = CGRectMake(12,CGRectGetMaxY(self.back_adress.frame) + 40 , WIDTH - 24, 48);
    [self.okBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    self.okBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
    self.okBtn.layer.masksToBounds = YES;
    self.okBtn.layer.cornerRadius = 4;
    
    //有数据
     if([messdic count] == 0){
         self.okBtn.userInteractionEnabled = NO;
         self.okBtn.backgroundColor = TCUIColorFromRGB(0xCCCCCC);
    } else {
       self.okBtn.backgroundColor = TCUIColorFromRGB(0xF99E20);
    }
    [self.okBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    [self.okBtn addTarget:self action:@selector(okbtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.okBtn];
}

//textfield的协议
-(void)valueChanged:(UITextField *)textField{
    
    if (textField == self.nameTextfiled){
        if (self.nameTextfiled.text.length > 12){
            [TCProgressHUD showMessage:@"姓名最多输入12字符"];
        }
    }
    
    self.okBtn.enabled = (self.dizhiTextfiled.text.length != 0 && self.adressTextfiled.text.length != 0 && self.phoneTextfiled.text.length != 0 && self.nameTextfiled.text.length != 0);
    if(self.okBtn.enabled == YES){
        self.okBtn.userInteractionEnabled = YES;
        self.okBtn.backgroundColor = TCUIColorFromRGB(0xF99E20);
        
    }else{
        self.okBtn.backgroundColor = TCUIColorFromRGB(0xCCCCCC);
        self.okBtn.userInteractionEnabled = NO;
    }
}

#pragma  mark -- 进入地图
- (void)tap
{
    if ([self.delegate respondsToSelector:@selector(sendValue)]) {
        [self.delegate  sendValue];
    }
}

#pragma mark -- 性别
- (void)sex:(UIButton *)sender
{
    NSLog(@"%ld",sender.tag);
    self.lastButton.selected = NO;
    sender.selected = YES;
    self.lastButton = sender;
    
    UIButton *man_btn = (UIButton *)[self viewWithTag:100];
    UIButton *women_btn = (UIButton *)[self viewWithTag:101];
    
    switch (sender.tag) {
        case 100: {
            man_btn.backgroundColor = [TCUIColorFromRGB(0xF99E20) colorWithAlphaComponent:0.1];
            women_btn.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
             man_btn.layer.borderColor=[TCUIColorFromRGB(0xF99E20) colorWithAlphaComponent:0.4].CGColor;
            women_btn.layer.borderColor=[[UIColor grayColor] colorWithAlphaComponent:0.4].CGColor;
        }
            break;
        case 101: {
            man_btn.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
            women_btn.backgroundColor = [TCUIColorFromRGB(0xF99E20) colorWithAlphaComponent:0.1];
             women_btn.layer.borderColor=[TCUIColorFromRGB(0xF99E20) colorWithAlphaComponent:0.4].CGColor;
            man_btn.layer.borderColor=[[UIColor grayColor] colorWithAlphaComponent:0.4].CGColor;
        }
            
        default:
            break;
    }
}

#pragma mark -- 标签点击
- (void)adressBtn:(UIButton *)sender
{
    NSLog(@"%ld",(long)sender.tag);
    self.aressLsButton.selected = NO;
    sender.selected = YES;
    self.aressLsButton = sender;
    
    UIButton *home_btn = (UIButton *)[self viewWithTag:1000];
    UIButton *p_btn = (UIButton *)[self viewWithTag:1001];
    UIButton *h_btn = (UIButton *)[self viewWithTag:1002];
    
    
    switch (sender.tag) {
        case 1000: {
            home_btn.backgroundColor = [TCUIColorFromRGB(0xF99E20) colorWithAlphaComponent:0.1];
            p_btn.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
            h_btn.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
            home_btn.layer.borderColor=[TCUIColorFromRGB(0xF99E20) colorWithAlphaComponent:0.4].CGColor;
            p_btn.layer.borderColor=[[UIColor grayColor] colorWithAlphaComponent:0.4].CGColor;
            h_btn.layer.borderColor=[[UIColor grayColor] colorWithAlphaComponent:0.4].CGColor;
        }
            break;
        case 1001: {
            home_btn.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
            p_btn.backgroundColor = [TCUIColorFromRGB(0xF99E20) colorWithAlphaComponent:0.1];
            h_btn.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
            p_btn.layer.borderColor=[TCUIColorFromRGB(0xF99E20) colorWithAlphaComponent:0.4].CGColor;
            h_btn.layer.borderColor=[[UIColor grayColor] colorWithAlphaComponent:0.4].CGColor;
            home_btn.layer.borderColor=[[UIColor grayColor] colorWithAlphaComponent:0.4].CGColor;
        }
            break;
        case 1002:{
            home_btn.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
            p_btn.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
            h_btn.backgroundColor = [TCUIColorFromRGB(0xF99E20) colorWithAlphaComponent:0.1];
            h_btn.layer.borderColor=[TCUIColorFromRGB(0xF99E20) colorWithAlphaComponent:0.4].CGColor;
            p_btn.layer.borderColor=[[UIColor grayColor] colorWithAlphaComponent:0.4].CGColor;
            home_btn.layer.borderColor=[[UIColor grayColor] colorWithAlphaComponent:0.4].CGColor;
        }
            
        default:
            break;
    }
}

#pragma mark -- 确定按钮
- (void)okbtn:(UIButton *)sender
{
    NSLog(@"确定按钮");
    if ([self.addressId isEqualToString:@"0"]){
        if (self.aressLsButton.titleLabel.text.length == 0){
            [TCProgressHUD showMessage:@"请选择您的标签位置"];
        } else {
            [self createAddQuest];
        }
    } else {
        //请求修改地址的接口
        [self creatChageQuest:self.addressId];
    }
}

#pragma mark -- xizneng
- (void)createAddQuest
{
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    NSString *aressLStr = self.aressLsButton.titleLabel.text;
    NSString *sexLStr = self.lastButton.titleLabel.text;
    NSString *tagStr;
    if ([sexLStr isEqualToString:@"男士"]){
        tagStr = @"0";
    } else if ([sexLStr isEqualToString:@"女士"]){
        tagStr = @"1";
    }
    
    NSDictionary *dic1 = @{@"mid":midStr,@"token":tokenStr,@"mobile":self.phoneTextfiled.text,@"gender":tagStr,@"address":self.dizhiTextfiled.text,@"name":self.nameTextfiled.text,@"longtitude":self.longtitude,@"latitude":self.latitude,@"locaddress":self.adressTextfiled.text,@"tag":aressLStr,@"timestamp":timeStr};
    NSLog(@"%@",dic1);
    NSString *signStr = [TCServerSecret signStr:dic1];
    NSDictionary *para = @{@"mid":midStr,@"token":tokenStr,@"mobile":self.phoneTextfiled.text,@"gender":tagStr,@"address":self.dizhiTextfiled.text,@"name":self.nameTextfiled.text,@"longtitude":self.longtitude,@"latitude":self.latitude,@"locaddress":self.adressTextfiled.text,@"tag":aressLStr,@"sign":signStr,@"timestamp":timeStr};
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102010"] paramter:para success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@--%@",jsonDic,jsonStr);
        NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if ([codeStr isEqualToString:@"1"]){
            
            UINavigationController *navi = [[UIApplication sharedApplication] visibleNavigationController];
            [navi popViewControllerAnimated:YES];
                
                //通知刷新
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shuaxinadress" object:nil];
        } else {
            [TCProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        nil;
    }];
}

#pragma mark -- 修改地址的接口
- (void)creatChageQuest:(NSString *)addressId
{    
        NSString *timeStr = [TCGetTime getCurrentTime];
        NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
        NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
        NSString *aressLStr = self.aressLsButton.titleLabel.text;
        NSString *sexLStr = self.lastButton.titleLabel.text;
        NSString *tagStr;
        if ([sexLStr isEqualToString:@"男士"]){
                tagStr = @"0";
            } else if ([sexLStr isEqualToString:@"女士"]){
                tagStr = @"1";
            }
    
    NSDictionary *dic1 = @{@"addressId":addressId,@"mid":midStr,@"token":tokenStr,@"mobile":self.phoneTextfiled.text,@"gender":tagStr,@"address":self.dizhiTextfiled.text,@"name":self.nameTextfiled.text,@"longtitude":self.longtitude,@"latitude":self.latitude,@"locaddress":self.adressTextfiled.text,@"tag":aressLStr,@"timestamp":timeStr};
    NSString *signStr = [TCServerSecret signStr:dic1];
    NSDictionary *para = @{@"addressId":addressId,@"mid":midStr,@"token":tokenStr,@"mobile":self.phoneTextfiled.text,@"gender":tagStr,@"address":self.dizhiTextfiled.text,@"name":self.nameTextfiled.text,@"longtitude":self.longtitude,@"latitude":self.latitude,@"locaddress":self.adressTextfiled.text,@"tag":aressLStr,@"sign":signStr,@"timestamp":timeStr};
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102009"] paramter:para success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@--%@",jsonDic,jsonStr);
        NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if ([codeStr isEqualToString:@"1"]){
            
            UINavigationController *navi = [[UIApplication sharedApplication] visibleNavigationController];
            [navi popViewControllerAnimated:YES];
            //通知刷新
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shuaxinadress" object:nil];
        } else {
            [TCProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        nil;
    }];
}

//限制字数
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(textField == self.nameTextfiled){
        if(range.length + range.location > self.nameTextfiled.text.length){
            return NO;
        }
        NSInteger newLenght = [self.nameTextfiled.text length] + [string length] - range.length;
        return newLenght <= 12;
    }else if (textField == self.phoneTextfiled){
        if(range.length + range.location > self.phoneTextfiled.text.length){
            return NO;
        }
        NSInteger newLenght = [self.phoneTextfiled.text length] + [string length] - range.length;
        return newLenght <= 11;
    }
    else{
        return YES;
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    //结束编辑时整个试图返回原位
    [self.dizhiTextfiled resignFirstResponder];
    [self.nameTextfiled resignFirstResponder];
    [self.phoneTextfiled resignFirstResponder];
    [self.adressTextfiled resignFirstResponder];
    
    [UIView beginAnimations:@"down" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.frame = CGRectMake(0,StatusBarAndNavigationBarHeight, WIDTH, HEIGHT );
    [UIView commitAnimations];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.dizhiTextfiled == textField) {
        //开始编辑时使整个视图整体向上移
        [UIView beginAnimations:@"up" context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.frame = CGRectMake(0, -100, self.bounds.size.width, self.bounds.size.height);
        [UIView commitAnimations];
    }
    return YES;
}
#pragma mark -- 点击return 下滑
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    //结束编辑时整个试图返回原位
    [textField resignFirstResponder];
    [UIView beginAnimations:@"down" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.frame = CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, HEIGHT );
    [UIView commitAnimations];

    return YES;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    [self.dizhiTextfiled resignFirstResponder];
    //结束编辑时整个试图返回原位
    [UIView beginAnimations:@"down" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.frame = CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, HEIGHT );
    [UIView commitAnimations];
}

@end
