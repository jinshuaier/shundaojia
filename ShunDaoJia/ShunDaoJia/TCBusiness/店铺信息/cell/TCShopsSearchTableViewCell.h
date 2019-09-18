//
//  TCShopsSearchTableViewCell.h
//  顺道嘉(新)
//
//  Created by 某某 on 16/9/30.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^bianli)(void);
@interface TCShopsSearchTableViewCell : UITableViewCell

@property (nonatomic, copy) bianli bianliBlock;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andData:(NSDictionary *)muDic andSQLArr:(NSMutableArray *)sqlArr;

- (void)bianli:(bianli)bianli;

@end
