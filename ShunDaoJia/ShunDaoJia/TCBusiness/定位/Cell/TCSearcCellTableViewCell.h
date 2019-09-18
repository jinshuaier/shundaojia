//
//  TCSearcCellTableViewCell.h
//  顺道嘉(新)
//
//  Created by 某某 on 16/9/24.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCSearcCellTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *currentlb;
@property (nonatomic, strong) UILabel *citylb;
@property (nonatomic, strong) UIImageView *im;
@property (nonatomic, strong) UILabel *qikong;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andWidth:(CGFloat)wid  andheight:(CGFloat)hei;
@end
