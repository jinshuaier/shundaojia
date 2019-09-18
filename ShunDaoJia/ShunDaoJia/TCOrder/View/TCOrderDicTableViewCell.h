//
//  TCOrderDicTableViewCell.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/21.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCOrderDicTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *tapView; //能点击的View
@property (nonatomic, strong) UIImageView *stateImage; //订单的icon
@property (nonatomic, strong) UILabel *stateLabel; //订单状态
@property (nonatomic, strong) UILabel *timeLabel; //时间
@property (nonatomic, strong) UIImageView *sanjiaoImage; //三角
@property (nonatomic, strong) UIView *line_oneView; //细线
@property (nonatomic, strong) UIImageView *locaImage; //定位的icon
@property (nonatomic, strong) UILabel *nameLabel; //名字
@property (nonatomic, strong) UILabel *phoneLabel; //电话
@property (nonatomic, strong) UILabel *adressLabel; //地址
@property (nonatomic, strong) UIView *line_twoView;
@property (nonatomic, strong) UIImageView *totleImage; //备注icon
@property (nonatomic, strong) UILabel *totleLabel; //备注
@property (nonatomic, strong) UILabel *totlePlaLabel; //备注的虚


@end
