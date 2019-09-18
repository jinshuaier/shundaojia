//
//  TCPayStateTableViewCell.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/21.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PayStateDelegete <NSObject>

@optional
// 当button点击后做的事情
- (void)sendValue:(NSString *)orderID;

@end

@interface TCPayStateTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *payStateLabel; //等待的状态
@property (nonatomic, strong) UIImageView *zhanweiImage;//时间
@property (nonatomic, strong) UILabel *timeLabel; //倒计时
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) NSString *residueTimes;  //剩余时间
//设置定时器
@property (nonatomic, strong) NSDictionary *dicc; 
@property (nonatomic, strong) NSTimer *timer;
@property (assign, nonatomic) long int timeCount;

@property (nonatomic, weak) id <PayStateDelegete> delegate;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDic:(NSDictionary *)messDic;
@end
