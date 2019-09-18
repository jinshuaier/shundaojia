//
//  TCMymessageCell.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/22.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCMymessageCell.h"

@implementation TCMymessageCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _namelabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 16, 60, 20)];
        _namelabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        _namelabel.textColor = TCUIColorFromRGB(0x4C4C4C);
        [self.contentView addSubview:_namelabel];
        
        _Triangleimage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 12 - 5 - 12, (self.contentView.frame.size.height - 8)/2, 5, 8)];
        _Triangleimage.image = [UIImage imageNamed:@"进入小三角(灰)"];
        [self.contentView addSubview:_Triangleimage];
        

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
