//
//  TCShopInfoViewController.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/7.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCShopInfoViewController : UIViewController

@property (nonatomic, strong) UIImage *shopImage; //商铺的图片传过来
@property (nonatomic, strong) NSString *shopTitle;

@property (nonatomic, strong) NSString *shopID;

@property (nonatomic, strong) NSDictionary *mesDic; //传过来的字典


@end
