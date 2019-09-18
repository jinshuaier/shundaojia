//
//  TCNoMessageView.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/21.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CheckNetworkDelegate <NSObject>
@optional

/** 重新加载数据 */
- (void)reloadData;

@end

@interface TCNoMessageView : UIView
@property (nonatomic,weak) id<CheckNetworkDelegate> delegate;
@property (nonatomic, strong) UIImageView *plImage;
@property (nonatomic, strong) UILabel *plLabel;
@property (nonatomic, strong) UIButton *plButton;


- (instancetype)initWithFrame:(CGRect)frame AndImage:(NSString *)image AndLabel:(NSString *)disLabel andButton:(NSString *)clickBtn;

@end
