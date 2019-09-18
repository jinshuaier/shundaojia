//
//  TCPayStateTableViewCell.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/21.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCPayStateTableViewCell.h"

@implementation TCPayStateTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDic:(NSDictionary *)messDic{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self create:messDic];
        self.dicc = messDic;
        
        self.backView = [[UIView alloc] init];
        self.backView.frame = CGRectMake(8, 0, WIDTH - 16, 84);
        self.backView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
        [self.contentView addSubview:self.backView];
        //等待的状态
        NSString *stautaStr = [NSString stringWithFormat:@"%@",messDic[@"status"]];
        NSString *issueStatus = [NSString stringWithFormat:@"%@",messDic[@"issueStatus"]];
        NSString *commentStatus = [NSString stringWithFormat:@"%@",messDic[@"commentStatus"]];
        
        self.payStateLabel = [UILabel publicLab:messDic[@"status_name"] textColor:TCUIColorFromRGB(0x333333) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
        if ([stautaStr isEqualToString:@"0"]){
            self.payStateLabel.frame = CGRectMake(16, 24, WIDTH - 16 - 20 - 74, 14);
        } else {
            self.payStateLabel.frame = CGRectMake(16, 0, WIDTH - 16 - 20 - 74, 84);
        }
        
        [self.backView addSubview:self.payStateLabel];
        //占位图
        self.zhanweiImage = [[UIImageView alloc] init];
        
        // 申诉中
        if ([issueStatus isEqualToString:@"1"]){
            self.zhanweiImage.image = [UIImage imageNamed:@"售后插图"];
        } else if ([issueStatus isEqualToString:@"issueStatus"]){ // 订单已完成
            self.zhanweiImage.image = [UIImage imageNamed:@"支付成功 插图"];
        } else if ([stautaStr isEqualToString:@"0"]){ //待付款
            self.zhanweiImage.image = [UIImage imageNamed:@"待付款插图"];
        } else if ([stautaStr isEqualToString:@"1"]){ //待接单
            self.zhanweiImage.image = [UIImage imageNamed:@"待付款插图"];
        } else if ([stautaStr isEqualToString:@"2"]){ // 待发货
            self.zhanweiImage.image = [UIImage imageNamed:@"待发货插图"];
        } else if ([stautaStr isEqualToString:@"3"] || [stautaStr isEqualToString:@"4"]){ //待收货
            self.zhanweiImage.image = [UIImage imageNamed:@"配送中插图"];
        } else if ([stautaStr isEqualToString:@"5"] && [commentStatus isEqualToString:@"0"]){ // 待评价
            self.zhanweiImage.image = [UIImage imageNamed:@"支付成功 插图"];
        } else if ([stautaStr isEqualToString:@"5"] && [commentStatus isEqualToString:@"1"]){ //订单已完成
            self.zhanweiImage.image = [UIImage imageNamed:@"支付成功 插图"];
        } else if ([stautaStr intValue] < 0){ //订单已取消
            self.zhanweiImage.image = [UIImage imageNamed:@"订单取消插图"];
        }
        self.zhanweiImage.frame = CGRectMake(WIDTH - 16 - 20 - 74, 3, 74, 78);
        [self.backView addSubview:self.zhanweiImage];
        //支付剩余
        if ([stautaStr isEqualToString:@"0"]){
            [self setTime];
            self.timeLabel = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x333333) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
            self.timeLabel.frame = CGRectMake(16, CGRectGetMaxY(self.payStateLabel.frame) + 8, WIDTH - 16 - 20 - 74, 14);
            [self.backView addSubview:self.timeLabel];
        }
    }
    return self;
}

- (void)setTime{
    //获取当前时间
    NSDate *datanow = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //获取当前时间戳
    int curTime = (int)[datanow timeIntervalSince1970];
    //获取结束的时间
    NSString *strend = self.dicc[@"endTime"];
    int orderTimeend = [strend intValue];
    
    //获取时间差
    int cha = orderTimeend - curTime;
    
    if (cha > 0) {
        _timeCount = cha;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime:) userInfo:nil repeats:YES];
    }else{
        
    }
}

//倒计时
- (void)reduceTime:(NSTimer *)coderTimer{
    self.timeCount--;
    if (self.timeCount == 0) {
        //停止定时器
        [self.timer invalidate];
        
        //如果myButtonWillTap被实现啦，此时我们就实现myButtonWillTapf方法
        if ([self.delegate respondsToSelector:@selector(sendValue:)]) {
            [self.delegate  sendValue:self.dicc[@"orderid"]];
        }
        
    }else{
        NSString *timeStr = [NSString stringWithFormat:@"%ld",self.timeCount];
        self.residueTimes = [self getMMSSFromSS:timeStr];
        self.timeLabel.text = [NSString stringWithFormat:@"支付剩余时间：%@",self.residueTimes];
        
    }
}


//定时器的方法
-(NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    return format_time;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
