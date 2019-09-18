//
//  TCCommonProblemCell.h
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/29.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol tapDelegete <NSObject>

@optional
// 当手势点击后做的事情
- (void)sendValue_one:(UITapGestureRecognizer *)tap_one;
- (void)sendValue_two:(UITapGestureRecognizer *)tap_two;
@end

@interface TCCommonProblemCell : UITableViewCell
@property (nonatomic, strong) UILabel *problemName;
@property (nonatomic, strong) UILabel *problemOne;
@property (nonatomic, strong) UILabel *problemTwo;

@property (nonatomic, strong) UITapGestureRecognizer *tap_one;
@property (nonatomic, strong) UITapGestureRecognizer *tap_two;

//委托回调接口
@property (nonatomic, weak) id <tapDelegete> delegate;
@end
