//
//  TCStyleViewController.h
//  举报商家
//
//  Created by 吕松松 on 2017/12/7.
//  Copyright © 2017年 吕松松. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^Blo)(NSString *str);
typedef void (^Blos)(NSString *idStr);

@interface TCStyleViewController : UIViewController
@property (nonatomic, copy) Blo block;
@property (nonatomic, copy) Blos blocks;
@property (nonatomic, strong) NSMutableArray *messArr;

@end
