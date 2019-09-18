//
//  TCShopHeadView.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/6/7.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>
//block点击事件
typedef void(^adressClick)(void);
typedef void(^headClick)(void);


@interface TCShopHeadView : UICollectionReusableView

@property (nonatomic, strong) UIImageView *imageIcon; //icon
@property (nonatomic, strong) UILabel *shopLabel; //商店名
@property (nonatomic, strong) UILabel *disceLabel; //距离

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *adressView;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *totleLabel;
@property (nonatomic, strong) UILabel *disLabel;
@property (nonatomic, strong) UIImageView *goImage;

@property (nonatomic,copy) adressClick adressAction;
@property (nonatomic,copy) headClick headAction;


@end
