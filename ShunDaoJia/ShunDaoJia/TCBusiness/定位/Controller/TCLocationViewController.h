//
//  TCLocationViewController.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/11/22.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^locationBlo)(NSString *str);
typedef void(^ReturnCityName)(NSString *cityname);
typedef void(^chooseAddBlo)(NSString *addStr,NSString *longla,NSString *latitu,NSString *typeStr);
@interface TCLocationViewController : UIViewController
@property (nonatomic, copy) ReturnCityName returnBlock;
@property (nonatomic, copy) locationBlo locaBlock;
@property (nonatomic, copy) chooseAddBlo chooseBlock;
@property (nonatomic, strong) NSString *locaStr;

@property (nonatomic, strong) NSString *typeStr; //这是类型


- (void)returnText:(ReturnCityName)block;
@end
