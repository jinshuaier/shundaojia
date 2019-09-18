//
//  TCWallTableViewCell.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/23.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCWallTableViewCell.h"

@implementation TCWallTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _setLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 16, WIDTH/2, 22)];
        _setLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _setLabel.textColor = TCUIColorFromRGB(0x4C4C4C);
        _setLabel.textAlignment = NSTextAlignmentLeft;
        
        [self.contentView addSubview:_setLabel];
        
        _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/3 * 2 - 12, 12, WIDTH/3, 20)];
        _messageLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _messageLabel.textColor = TCUIColorFromRGB(0x999999);
        _messageLabel.textAlignment = NSTextAlignmentRight;
        
        [self.contentView addSubview:_messageLabel];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
