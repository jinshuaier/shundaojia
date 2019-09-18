//
//  TCYouhuiTableViewCell.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/4/19.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCYouhuiTableViewCell.h"

@implementation TCYouhuiTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andmes:(NSDictionary *)dic{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _dic = dic;
        self.backgroundColor = TCBgColor;
        [self create];
    }
    return self;
}

- (void)create{
    
    //添加背景
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.frame = CGRectMake(8, 0, WIDTH - 16, 46);
    [self addSubview:backView];
    
    
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(8, (46 - 14) / 2, 14, 14)];
    if ([[NSString stringWithFormat:@"%@", _dic[@"type"]] isEqualToString:@"1"]) {
        lb.backgroundColor = TCUIColorFromRGB(0xF99E20);
        lb.text = @"满";
    }else if ([[NSString stringWithFormat:@"%@", _dic[@"type"]] isEqualToString:@"2"]){
        lb.backgroundColor = TCUIColorFromRGB(0xF99E20);
        lb.text = @"折";
    }else if ([[NSString stringWithFormat:@"%@", _dic[@"type"]] isEqualToString:@"3"]){
        lb.backgroundColor = TCUIColorFromRGB(0xF99E20);
        lb.text = @"首";
    }
    lb.font = [UIFont systemFontOfSize:10];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.textColor = [UIColor whiteColor];
    lb.layer.cornerRadius = 4;
    lb.layer.masksToBounds = YES;
    [backView addSubview: lb];
    
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lb.frame) + 8, 0, WIDTH / 3, 46)];
    text.text = _dic[@"type_name"];
    text.textAlignment = NSTextAlignmentLeft;
    text.textColor = TCUIColorFromRGB(0x666666);
    text.font = [UIFont systemFontOfSize:14];
    [backView addSubview: text];
    
    UILabel *pr = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH - 16 - 8 - 80 , 0, 80, 46)];
    pr.text = [NSString stringWithFormat:@"-¥%@", _dic[@"reduce"]];
    pr.font = [UIFont systemFontOfSize:15 * HEIGHTSCALE];
    pr.textColor = TCUIColorFromRGB(0x333333);
    pr.font = [UIFont systemFontOfSize:14];
    pr.textAlignment = NSTextAlignmentRight;
    [backView addSubview: pr];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
