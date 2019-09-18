//
//  TCSearchMapViewController.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/1.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCNearAddInfo.h"
typedef void(^ReturnCityName)(NSString *cityname);
typedef void(^addressBlo)(AMapPOI *model);
typedef void(^addressNearAddInfo)(TCNearAddInfo *model);

@interface TCSearchMapViewController : UIViewController
@property (nonatomic, copy) ReturnCityName returnBlock;
@property (nonatomic, copy) addressBlo addressBlock;
@property (nonatomic, copy) addressNearAddInfo addressNearAddInfoBlock;

- (void)returnText:(ReturnCityName)block;

@property (nonatomic, strong) NSMutableArray *adressArr; //地址
@end
