//
//  TCHomeMenuCell.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/10/10.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMJScrollTextView.h"


@protocol BaseViewButtonDelegete <NSObject>

@optional
// 当button点击后做的事情
- (void)sendValue:(NSInteger)tag;
- (void)upDate;

@end

@interface TCHomeMenuCell : UITableViewCell

//委托回调接口
@property (nonatomic, weak) id <BaseViewButtonDelegete> delegate;

+(instancetype)cellWithTableView:(UITableView *)tableView menuArray:(NSArray *)menuArray; //此处是定义有多少的数量

@property (nonatomic, strong)  UIView *lampView;
@property (nonatomic, strong) UIView *garyView; //灰色背景
@property (nonatomic, strong) LMJScrollTextView *paoma;
@property (nonatomic, strong) UIImageView *paomaImage; //跑马灯的image
@end
