//
//  TCDiscountTableViewCell.h
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/28.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCDiscountInfo.h"
@protocol ButtonDelegete <NSObject>

@optional
// 当button点击后做的事情
- (void)sendValue:(UIButton *)sender;

@end
@interface TCDiscountTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *bgimageView;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *TitleLabel;
@property (nonatomic, strong) UILabel *conditionLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *countBtn;
@property (nonatomic,strong) TCDiscountInfo *model;
@property (nonatomic, weak) id <ButtonDelegete> delegate;

@end
