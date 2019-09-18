//
//  TCMyAddTableViewCell.h
//  顺道嘉(新)
//
//  Created by 某某 on 16/9/23.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCAddInfo.h"

@interface TCMyAddTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *namelb;
@property (nonatomic, strong) UILabel *phone;
@property (nonatomic, strong) UILabel *address;

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) TCAddInfo *model;

@end
