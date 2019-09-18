//
//  TCSpecifView.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/25.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCShopModel.h"

@interface TCSpecifView : UIView

@property (nonatomic, copy) void (^reloadData)(void);
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *guigeView;
@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *SortView;
@property (nonatomic, strong) UIButton *lastBtn;//记录按钮
//@property (nonatomic, strong) UIButton *selectBtn;//记录按钮
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) NSArray *btnArr;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *shopcarBtn;
@property (nonatomic, strong) UIButton *addBtn; //添加按钮
@property (nonatomic, strong) UILabel *numLabel; //数量
@property (nonatomic, readonly) NSInteger count;
@property (nonatomic, strong) UIButton *cutBtn; //减号按钮
@property (nonatomic, strong) NSMutableArray *messArrs;
@property (nonatomic, strong) NSString *idGoodsStr;

-(id)initWithFrame:(CGRect)frame andArr:(TCShopModel *)shopModel;
@end

