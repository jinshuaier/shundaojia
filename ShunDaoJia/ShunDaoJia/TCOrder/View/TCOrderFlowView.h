//
//  TCOrderFlowView.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/6/5.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCOrderFlowView : UIView <UITableViewDataSource,UITableViewDelegate>
// 用typef宏定义来减少冗余代码
typedef void(^ButtonClick)(void);

//下一步就是声明属性了，注意block的声明属性修饰要用copy
@property (nonatomic,copy) ButtonClick buttonAction;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *popView;
@property (nonatomic, strong) UIButton *deleBtn;
@property (nonatomic, strong) UITableView *flowTableView;
@property (nonatomic, strong) NSUserDefaults *userDefault;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSDictionary *messDic;

- (instancetype)initWithFrame:(CGRect)frame andOrderId:(NSString *)orderID;


@end
