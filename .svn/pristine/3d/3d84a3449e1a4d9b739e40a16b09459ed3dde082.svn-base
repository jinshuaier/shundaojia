//
//  TCOrderStatusView.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/12.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCOrderStatusView.h"
#import "TCCanceView.h"
@implementation TCOrderStatusView

- (instancetype)initWithFrame:(CGRect)frame andDic:(NSDictionary *)dic
{
    if (self = [super initWithFrame:frame]) {
        [self create:dic];
    }
    return self;
}
//创建View
- (void)create:(NSDictionary *)dic
{
    NSLog(@"%@",dic);
    //底部的状态
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.frame = CGRectMake(0, 0,WIDTH, HEIGHT);
    [self addSubview:bottomView];
    
    //加条线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TCLineColor;
    lineView.frame = CGRectMake(0, 0, WIDTH, 1);
    [bottomView addSubview:lineView];
    
    self.statusStr = [NSString stringWithFormat:@"%@", dic[@"status"]];
    self.issueStr = [NSString stringWithFormat:@"%@", dic[@"issue"]];
    self.commentStatus = [NSString stringWithFormat:@"%@",dic[@"commentStatus"]];
    self.typeStr = [NSString stringWithFormat:@"%@",dic[@"type"]];
    self.wuliuStr = [NSString stringWithFormat:@"%@",dic[@"hasExpress"]];
    
    if ([self.wuliuStr isEqualToString:@"1"]){
        self.stateArr = @[@"查看物流"];
    } else if ([self.statusStr isEqualToString:@"0"]){
        self.stateArr = @[@"去支付",@"取消订单"];
    } else if ([self.statusStr isEqualToString:@"1"]){
        self.stateArr = @[@"催发货",@"取消订单"];
    } else if ([self.statusStr isEqualToString:@"2"]){
        self.stateArr = @[@"催发货"];
    } else if ([self.statusStr isEqualToString:@"3"] || [self.statusStr isEqualToString:@"4"]){
        //上门服务
        if ([self.typeStr isEqualToString:@"2"]){
            self.stateArr = @[@"确认完成"];
        } else {
            self.stateArr = @[@"确认收货"];
        }
    } else if ([self.statusStr isEqualToString:@"5"] && [self.commentStatus isEqualToString:@"0"] && [self.issueStr isEqualToString:@"1"]){
        self.stateArr = @[@"申诉",@"去评价",@"再来一单"];
    } else if ([self.statusStr isEqualToString:@"5"] && [self.commentStatus isEqualToString:@"0"] && ![self.issueStr isEqualToString:@"1"]) {
        self.stateArr = @[@"去评价",@"再来一单"];
    } else if ([self.statusStr isEqualToString:@"5"] && ![self.commentStatus isEqualToString:@"0"]){
        self.stateArr = @[@"再来一单"];
    } else if ([self.statusStr isEqualToString:@"-2"]){
        self.stateArr = @[@"再来一单"];
    } else if ([self.issueStr isEqualToString:@"1"] || [self.issueStr isEqualToString:@"2"]){
        self.stateArr = @[@"申诉"];
    }
    
    for (int i = 0; i < self.stateArr.count; i++) {
        self.stateBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.stateBtn.frame = CGRectMake(WIDTH - 12 - 72 - i * 72 - 12*i, 10, 72, 28);
        [self.stateBtn setTitle:self.stateArr[i] forState:(UIControlStateNormal)];
        self.stateBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        self.stateBtn.layer.cornerRadius = 4;
        self.stateBtn.layer.masksToBounds = YES;
        [self.stateBtn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        self.stateBtn.tag = 1000 + i;
        
        if ([self.statusStr isEqualToString:@"0"]){
            if(i == 1){
                [self.stateBtn setTitleColor:TCUIColorFromRGB(0x999999) forState:(UIControlStateNormal)];
                self.stateBtn.layer.borderWidth = 0.5;
                self.stateBtn.layer.borderColor = TCUIColorFromRGB(0xDEDEDE).CGColor;
            } else if (i == 0){
                [self.stateBtn setTitleColor:TCUIColorFromRGB(0xFF3355) forState:(UIControlStateNormal)];
                self.stateBtn.layer.borderWidth = 0.5;
                self.stateBtn.layer.borderColor = TCUIColorFromRGB(0xFF3355).CGColor;
            }
        }
        
        //催发货
        if ([self.statusStr isEqualToString:@"1"]){
            if (i == 0){
                [self.stateBtn setTitleColor:TCUIColorFromRGB(0x666666) forState:(UIControlStateNormal)];
                self.stateBtn.layer.borderWidth = 0.5;
                self.stateBtn.layer.borderColor = TCUIColorFromRGB(0x999999).CGColor;
            } else if (i == 1){
                [self.stateBtn setTitleColor:TCUIColorFromRGB(0x999999) forState:(UIControlStateNormal)];
                self.stateBtn.layer.borderWidth = 0.5;
                self.stateBtn.layer.borderColor = TCUIColorFromRGB(0xDEDEDE).CGColor;
            }
        }
        //待发货
        if ([self.statusStr isEqualToString:@"2"]){
            if (i == 0){
                [self.stateBtn setTitleColor:TCUIColorFromRGB(0x999999) forState:(UIControlStateNormal)];
                self.stateBtn.layer.borderWidth = 0.5;
                self.stateBtn.layer.borderColor = TCUIColorFromRGB(0xDEDEDE).CGColor;
            }
        }
        
        //待评价
        if ([self.statusStr isEqualToString:@"3"] || [self.statusStr isEqualToString:@"4"]){
            if (i == 0){
                [self.stateBtn setTitleColor:TCUIColorFromRGB(0xF99E20) forState:(UIControlStateNormal)];
                self.stateBtn.layer.borderWidth = 0.5;
                self.stateBtn.layer.borderColor = TCUIColorFromRGB(0xF99E20).CGColor;
            }
        }
        
        //已完成
        if ([self.statusStr isEqualToString:@"5"] && [self.commentStatus isEqualToString:@"0"]){
            if (i == 0){
                [self.stateBtn setTitleColor:TCUIColorFromRGB(0xF99E20) forState:(UIControlStateNormal)];
                self.stateBtn.layer.borderWidth = 0.5;
                self.stateBtn.layer.borderColor = TCUIColorFromRGB(0xF99E20).CGColor;
            } else if (i == 1){
                [self.stateBtn setTitleColor:TCUIColorFromRGB(0x666666) forState:(UIControlStateNormal)];
                self.stateBtn.layer.borderWidth = 0.5;
                self.stateBtn.layer.borderColor = TCUIColorFromRGB(0x999999).CGColor;
            }
        }
        //
        if ([self.statusStr isEqualToString:@"5"] && ![self.commentStatus isEqualToString:@"0"]){
            [self.stateBtn setTitleColor:TCUIColorFromRGB(0x666666) forState:(UIControlStateNormal)];
            self.stateBtn.layer.borderWidth = 0.5;
            self.stateBtn.layer.borderColor = TCUIColorFromRGB(0x999999).CGColor;
        }
        
        if ([self.statusStr isEqualToString:@"-2"]){
            [self.stateBtn setTitleColor:TCUIColorFromRGB(0xF99E20) forState:(UIControlStateNormal)];
            self.stateBtn.layer.borderWidth = 0.5;
            self.stateBtn.layer.borderColor = TCUIColorFromRGB(0xF99E20).CGColor;
        }
        
        if ([self.issueStr isEqualToString:@"1"]){
            [self.stateBtn setTitleColor:TCUIColorFromRGB(0x666666) forState:(UIControlStateNormal)];
            self.stateBtn.layer.borderWidth = 0.5;
            self.stateBtn.layer.borderColor = TCUIColorFromRGB(0x999999).CGColor;
        }
        
        if ([self.stateBtn.titleLabel.text isEqualToString:@"取消订单"] || [self.stateBtn.titleLabel.text isEqualToString:@"申请退款"]) {
            self.stateBtn.layer.borderWidth = 0.5;
            self.stateBtn.layer.borderColor = TCUIColorFromRGB(0xDEDEDE).CGColor;
            self.stateBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
            [self.stateBtn setTitleColor:TCUIColorFromRGB(0x999999) forState:(UIControlStateNormal)];
        }else if ([self.stateBtn.titleLabel.text isEqualToString:@"确认收货"]){
            self.stateBtn.layer.borderColor = TCUIColorFromRGB(0xF99E20).CGColor;
            [self.stateBtn setTitleColor:TCUIColorFromRGB(0xF99E20) forState:(UIControlStateNormal)];
        }
        
        [bottomView addSubview:self.stateBtn];
    }
}

-(void)clickBtn:(UIButton *)btn{
    [self.orderdelegate clickBtn:btn];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}

@end
