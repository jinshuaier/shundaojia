//
//  TCAllCollectionViewCell.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/4/28.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCAllCollectionViewCell.h"

@implementation TCAllCollectionViewCell
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _topImage = [[UIImageView alloc] initWithFrame:CGRectMake(22, 0, 46, 46)];
        
        [self.contentView addSubview:_topImage];
        _botlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topImage.frame) + 8, 90, 12)];
        _botlabel.textAlignment = NSTextAlignmentCenter;
        _botlabel.textColor = TCUIColorFromRGB(0x333333);
        _botlabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [self.contentView addSubview:_botlabel];
    }
    return self;
}


@end
