//
//  TCMapViewController.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/11/30.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCNearAddInfo.h"
@interface TCMapViewController : UIViewController
typedef void(^dizhiBlo)(NSString*address,NSString*latitude,NSString *longtitude);
@property (nonatomic, copy) dizhiBlo diBlock;
@property (nonatomic, copy) AMapGeoPoint *maplocation;

@end
