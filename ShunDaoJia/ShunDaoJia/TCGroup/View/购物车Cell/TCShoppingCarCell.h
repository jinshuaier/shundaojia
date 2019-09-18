//
//  TCShoppingCarCell.h
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/12.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCShoppingCarInfo.h"
#import "TCGroupInfoModel.h"

typedef void(^reloadBlock)(void);

@interface TCShoppingCarCell : UITableViewCell
@property (nonatomic, strong) UIImageView *shoppingPic;
@property (nonatomic, strong) UILabel *goodsName;
@property (nonatomic, strong) UILabel *salesLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *minusBtn;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, copy) reloadBlock block;
@property (nonatomic, strong) TCShoppingCarInfo *shopCarModel;
@property (nonatomic, strong) TCGroupInfoModel *model;
@property (nonatomic, copy) void (^needReloadData)(void);

- (void)reloadTableview:(reloadBlock)reload;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andModel:(TCGroupInfoModel *)gruopModel;
@end
