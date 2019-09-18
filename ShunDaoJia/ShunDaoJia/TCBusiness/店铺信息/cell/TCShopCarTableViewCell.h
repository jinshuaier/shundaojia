//
//  TCShopCarTableViewCell.h
//  顺道嘉(新)
//
//  Created by 某某 on 16/9/29.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SQLBlock)(void);
typedef void(^reloadBlock)(void);
@interface TCShopCarTableViewCell : UITableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andData:(NSDictionary *)dic andShopID:(NSString *)ShopID;
@property (nonatomic, strong) NSDictionary *dics;
@property (nonatomic, strong) UILabel *lb2;
@property (nonatomic, strong) UILabel *specLb;
@property (nonatomic, strong) NSString *shopID; //店铺的id
@property (nonatomic, strong) FMDatabase *database;
@property (nonatomic, copy) SQLBlock sqlBlock;
@property (nonatomic, copy) reloadBlock block;
- (void)bianliSQL:(SQLBlock)sql;
- (void)reloadTableview:(reloadBlock)reload;
@end
