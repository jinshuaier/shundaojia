//
//  TCSeleAdressTableViewCell.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/14.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol adressDelegate <NSObject>
@optional

/** 重新加载数据 */
- (void)adressTap;
/** 时间选择 */
- (void)timeSecletTap:(NSString *)timeStr;

@end
@interface TCSeleAdressTableViewCell : UITableViewCell

@property (strong, nonatomic) UIView *backView; //背景
@property (strong, nonatomic) UIView *clickView; //能点击选择的View
@property (strong, nonatomic) UIView *timeSelectView; //能点击的时间选择的View
@property (nonatomic, strong) UIImageView *locationImage; //定位的图标
@property (nonatomic, strong) UILabel *adressLabel; //选择收货地址的label
@property (nonatomic, strong) UIImageView *triangleImage; //进入的小三角
@property (nonatomic, strong) UIView *lineView; //中间的线
@property (nonatomic, strong) UIImageView *timeImage; //时间
@property (nonatomic, strong) UILabel *sendTimeLabel; //预计送达的时间
@property (nonatomic, strong) UIImageView *triangle_twoImage; //进入的小三角
@property (nonatomic, strong) NSString *timeSeleStr; //时间


@property (nonatomic, strong) UILabel *nameLabel; //
@property (nonatomic, strong) UILabel *telphoneLabel;
@property (nonatomic, strong) UILabel *adressNetLabel; //地址

@property (nonatomic,weak) id<adressDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDic:(NSDictionary *)dic andType:(NSString *)typeStr;

@end
