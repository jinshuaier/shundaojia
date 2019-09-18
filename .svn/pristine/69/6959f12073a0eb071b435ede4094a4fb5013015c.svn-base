//
//  TCProblemDetileController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/29.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCProblemDetileController.h"
#import "SDAutoLayout.h"

@interface TCProblemDetileController ()

@end

@implementation TCProblemDetileController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"问题详情";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:18],NSForegroundColorAttributeName:TCUIColorFromRGB(0x333333)}];
    
    
    [self creatUI];
    
    
    self.view.backgroundColor = TCBgColor;
    // Do any additional setup after loading the view.
}

-(void)creatUI{
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 206)];
    self.bgView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    
    self.Problemlabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 16, WIDTH - 24, 20)];
    self.Problemlabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    self.Problemlabel.textColor = TCUIColorFromRGB(0x4C4C4C);
    self.Problemlabel.textAlignment = NSTextAlignmentLeft;
    self.Problemlabel.text = @"已提交的信息，能否修改？";
    
    self.answerLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(self.Problemlabel.frame) + 8, WIDTH - 24, 36)];
    self.answerLabel.textAlignment = NSTextAlignmentLeft;
    self.answerLabel.textColor = TCUIColorFromRGB(0x666666);
    self.answerLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    self.answerLabel.text = @"已提交的信息暂不支持修改，如需更改可在审核驳回后修改。固请您在点击提交之前复查所有信息。";
    self.answerLabel.numberOfLines = 0;
    self.answerLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [self.answerLabel sizeThatFits:CGSizeMake(WIDTH - 24, MAXFLOAT)];//根据文字的长度返回一个最佳宽度和高度
    self.answerLabel.frame = CGRectMake(12, CGRectGetMaxY(self.Problemlabel.frame) + 8, WIDTH - 24, size.height);
    
    
    
    self.line = [[UIView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(self.answerLabel.frame) + 16, WIDTH - 24, 2)];
    self.line.backgroundColor = TCUIColorFromRGB(0xEDEDED);
    
    self.texLabel = [[UILabel alloc]initWithFrame:CGRectMake((WIDTH - 168)/2, CGRectGetMaxY(_line.frame) + 24, 168, 20)];
    self.texLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    self.texLabel.textColor = TCUIColorFromRGB(0x999999);
    self.texLabel.textAlignment = NSTextAlignmentLeft;
    self.texLabel.text = @"此回答是否解决您的问题：";
    
    self.solveBtn = [[UIButton alloc]initWithFrame:CGRectMake(98, CGRectGetMaxY(self.texLabel.frame) + 16, 60, 24)];
    self.solveBtn.layer.masksToBounds = YES;
    self.solveBtn.layer.cornerRadius = 4;
    [self.solveBtn setTitle:@"已解决" forState:(UIControlStateNormal)];
    [self.solveBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    [self.solveBtn addTarget:self action:@selector(clickSolve:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.solveBtn setBackgroundColor:TCUIColorFromRGB(0xF99E20)];
    self.solveBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    self.solveBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.unsolveBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.solveBtn.frame) + 45, CGRectGetMaxY(self.texLabel.frame) + 16, 60, 24)];
    self.unsolveBtn.layer.masksToBounds = YES;
    self.unsolveBtn.layer.cornerRadius = 4;
    self.unsolveBtn.layer.borderWidth = 1;
    self.unsolveBtn.layer.borderColor = TCUIColorFromRGB(0x999999).CGColor;
    [self.unsolveBtn setTitle:@"未解决" forState:(UIControlStateNormal)];
    [self.unsolveBtn setTitleColor:TCUIColorFromRGB(0x999999) forState:(UIControlStateNormal)];
    [self.unsolveBtn addTarget:self action:@selector(clickUnSolve:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.unsolveBtn setBackgroundColor:TCUIColorFromRGB(0xFFFFFF)];
    self.unsolveBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    self.unsolveBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(92, CGRectGetMaxY(self.texLabel.frame) + 15, 14, 14)];
    self.rightImage.image = [UIImage imageNamed:@"Fill 1"];
    self.rightImage.hidden = YES;
    
    self.evaluateLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.rightImage.frame) + 8, CGRectGetMaxY(self.texLabel.frame) + 12, 154, 20)];
    self.evaluateLabel.textColor = TCUIColorFromRGB(0x4C4C4C);
    self.evaluateLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    self.evaluateLabel.text = @"评价成功，感谢您的支持";
    self.evaluateLabel.textAlignment = NSTextAlignmentLeft;
    self.evaluateLabel.hidden = YES;
    
    [self.view addSubview:self.bgView];
    [self.bgView sd_addSubviews:@[self.Problemlabel,self.answerLabel,self.line,self.texLabel,self.solveBtn,self.unsolveBtn,self.evaluateLabel,self.rightImage]];
    
}



-(void)clickSolve:(UIButton *)sender{
    self.solveBtn.hidden = YES;
    self.unsolveBtn.hidden = YES;
    self.evaluateLabel.hidden = NO;
    self.rightImage.hidden = NO;
}
-(void)clickUnSolve:(UIButton *)sender{
    self.solveBtn.hidden = YES;
    self.unsolveBtn.hidden = YES;
    self.evaluateLabel.hidden = NO;
    self.rightImage.hidden = NO;
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
