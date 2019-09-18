//
//  TCShopCarView.h
//  购物车解析
//
//  Created by 胡高广 on 2017/9/5.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^dismiss)(void);
typedef void(^shuaxin)(void);


@interface TCShopCarView : UIView

@property (nonatomic, strong) dismiss block;

@property (nonatomic, strong) shuaxin shuaxinBlock;

@property (nonatomic, strong) UIImageView *im1;
@property (nonatomic, strong) NSString *shopidStr; //传过来的ID

- (id)initWithFrame:(CGRect)frame andData:(NSMutableArray *)arr andqisong:(NSString *)qisong andPeisong:(NSString *)peison  andShop:(NSString *)shopID;

- (void)disBackView:(dismiss)blocks;
- (void)shuaxin:(shuaxin)shuaxinBlock;
@end
