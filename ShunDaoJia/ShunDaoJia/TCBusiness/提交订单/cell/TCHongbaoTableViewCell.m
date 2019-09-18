//
//  TCHongbaoTableViewCell.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/4/19.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCHongbaoTableViewCell.h"

@implementation TCHongbaoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andmes:(NSArray *)arr andmoney:(NSString *)moneyStr{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _arr = arr;
        [self create:arr andMoney:moneyStr];
    }
    return self;
}

- (void)create:(NSArray *)arr andMoney:(NSString *)moneyStr{
    
    self.backgroundColor = TCBgColor;
    //添加背景
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.frame = CGRectMake(8, 0, WIDTH - 16, 46);
    backView.userInteractionEnabled = YES;
    [self addSubview:backView];
    
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_label)];
    [backView addGestureRecognizer:tap];
    
    UILabel *hong_Label = [[UILabel alloc] init];
    hong_Label.frame = CGRectMake(8, 0, WIDTH/2, 46);
    hong_Label.textAlignment = NSTextAlignmentLeft;
    hong_Label.textColor = TCUIColorFromRGB(0x666666);
    hong_Label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    hong_Label.text = @"红包";
    [backView addSubview:hong_Label];
    
    //小箭头
    UIImageView *image_go = [[UIImageView alloc] init];
    image_go.frame = CGRectMake(WIDTH - 16 - 8 - 5, (46 - 8)/2, 5, 8);
    image_go.image = [UIImage imageNamed:@"进入三角"];
    [backView addSubview:image_go];
    
    //循环遍历
    NSMutableArray *arr_user = [NSMutableArray array];
    for (int i = 0; i < arr.count; i++){
        NSString *str = [NSString stringWithFormat:@"%@",arr[i][@"status"]];
        if ([str isEqualToString:@"1"]){
            [arr_user addObject:str];
        }
    }
    NSLog(@"%lu %@",(unsigned long)arr_user.count,arr_user);
    
    NSString *monStr = [NSString stringWithFormat:@"%@",moneyStr];
    if (moneyStr == nil || [monStr isEqualToString:@"0"]){
        //可用卷
        _user_Label = [[UILabel alloc] init];
        _user_Label.frame = CGRectMake(image_go.frame.origin.x - 12 - 55, (46 - 18)/2, 55, 18);
        _user_Label.text = [NSString stringWithFormat:@"%lu张可用",(unsigned long)arr_user.count];
        _user_Label.textAlignment = NSTextAlignmentCenter;
        _user_Label.textColor = TCUIColorFromRGB(0xFF3355);
        _user_Label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        _user_Label.layer.cornerRadius = 2;
        _user_Label.layer.borderColor = TCUIColorFromRGB(0xFF3355).CGColor;
        _user_Label.layer.borderWidth = 0.5;
        _user_Label.layer.masksToBounds = YES;
        [backView addSubview:_user_Label];
    } else {
        NSLog(@"哈哈");
        //有优惠券
        self.youhuiLabel = [[UILabel alloc] init];
        self.youhuiLabel.frame = CGRectMake(image_go.frame.origin.x - 12 - WIDTH/2, 0, WIDTH/2, 46);
        self.youhuiLabel.text = [NSString stringWithFormat:@"-¥%@",moneyStr];
        self.youhuiLabel.textAlignment = NSTextAlignmentRight;
        self.youhuiLabel.textColor = TCUIColorFromRGB(0x333333);
        self.youhuiLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [backView addSubview:self.youhuiLabel];
    }
}

#pragma mark -- 点击红包
- (void)tap_label
{
    self.tap();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
