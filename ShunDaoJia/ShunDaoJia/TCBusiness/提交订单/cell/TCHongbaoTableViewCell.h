//
//  TCHongbaoTableViewCell.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/4/19.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^Blocktap)(void);

@interface TCHongbaoTableViewCell : UITableViewCell
@property (nonatomic, strong) Blocktap tap;

@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, strong) UILabel *user_Label;
@property (nonatomic, strong) UILabel *youhuiLabel;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andmes:(NSArray *)arr andmoney:(NSString *)moneyStr;
@end
