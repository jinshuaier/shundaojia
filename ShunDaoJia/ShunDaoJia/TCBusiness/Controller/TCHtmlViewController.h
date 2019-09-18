//
//  TCHtmlViewController.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/1/25.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCHtmlViewController : UIViewController
@property (nonatomic, strong) NSString *titles;
@property (nonatomic, strong) NSString *html;
@property (nonatomic, assign) BOOL whereLogin;

@property (nonatomic, assign) BOOL isPacket;
@property (nonatomic, strong) NSDictionary *mesDic;
@property (nonatomic, strong) NSString *titlestr;

@end
