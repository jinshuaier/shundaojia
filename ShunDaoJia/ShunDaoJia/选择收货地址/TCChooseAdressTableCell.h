//
//  TCChooseAdressTableCell.h
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/18.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCChooseAdressTableCell : UITableViewCell
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *addRessLabel;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIButton *deleBtn;
@property (nonatomic, assign) CGFloat cellHeight;
@end
