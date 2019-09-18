//
//  TCPeisongTableViewCell.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/4/19.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCPeisongTableViewCell.h"

@implementation TCPeisongTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andPeisong:(NSString *)peisong{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = TCBgColor;
        //添加背景
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor whiteColor];
        backView.frame = CGRectMake(8, 0, WIDTH - 16, 46);
        [self addSubview:backView];
        
        //配送费的标题
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, (WIDTH - 16)/2, 46)];
        lb.text = @"配送费";
        lb.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        lb.textColor = TCUIColorFromRGB(0x666666);
        lb.textAlignment = NSTextAlignmentLeft;
        [backView addSubview: lb];
        
        //价格
        UILabel *pr = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH - 16 - 16 - (WIDTH - 16)/2, 0, (WIDTH - 16)/2, 46)];
        pr.text = [NSString stringWithFormat:@"¥%@", peisong];
        pr.font = [UIFont systemFontOfSize:14];
        pr.textColor = TCUIColorFromRGB(0x333333);
        pr.textAlignment = NSTextAlignmentRight;
        [backView addSubview: pr];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
