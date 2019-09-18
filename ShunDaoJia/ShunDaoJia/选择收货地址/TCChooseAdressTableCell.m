//
//  TCChooseAdressTableCell.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/18.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCChooseAdressTableCell.h"

@implementation TCChooseAdressTableCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, 37, 20, 20)];
        [_checkBtn setBackgroundImage:[UIImage imageNamed:@"选中框（灰）"] forState:(UIControlStateNormal)];
        [_checkBtn setBackgroundImage:[UIImage imageNamed:@"选中框（黄）"] forState:(UIControlStateSelected)];
        [self.contentView addSubview:_checkBtn];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(44, 16, 48, 22)];
        _nameLabel.text = @"某先生";
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _nameLabel.textColor = TCUIColorFromRGB(0x333333);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.numberOfLines = 0;
        _nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize size1 = [_nameLabel sizeThatFits:CGSizeMake(MAXFLOAT, 22)];
        if (size1.width <=  WIDTH - 104 - 24 - 44 - 16) {
            _nameLabel.frame = CGRectMake(44, 16, size1.width, 22);
        }else{
            _nameLabel.frame = CGRectMake(44, 16, WIDTH - 104 - 24 - 44 - 16, 22);
        }
        [self.contentView addSubview:_nameLabel];
        
        _addRessLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_checkBtn.frame) + 12, CGRectGetMaxY(_nameLabel.frame) + 4, WIDTH - 24 - 20 - 16, 16)];
        _addRessLabel.text = @"北京市通州区 新华大街人民商场万达广场各种商场一号楼一单元1702";
        _addRessLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _addRessLabel.textColor = TCUIColorFromRGB(0x666666);
        _addRessLabel.textAlignment = NSTextAlignmentLeft;
        _addRessLabel.numberOfLines = 0;
        _addRessLabel.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize size = [_addRessLabel sizeThatFits:CGSizeMake(WIDTH - 24 - 20 - 16, MAXFLOAT)];//根据文字的长度返回一个最佳宽度和高度
        _addRessLabel.frame = CGRectMake(CGRectGetMaxX(_checkBtn.frame) + 12, CGRectGetMaxY(_nameLabel.frame) + 4, WIDTH - 24 - 20 - 16, size.height);
        [self.contentView addSubview:_addRessLabel];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(44, CGRectGetMaxY(_addRessLabel.frame) + 15, WIDTH - 44, 1)];
        line.backgroundColor = TCLineColor;
        [self.contentView addSubview:line];
        
        _editBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 12 - 47 - 24 - 47, CGRectGetMaxY(line.frame) + 12, 47, 18)];
        [_editBtn setImage:[UIImage imageNamed:@"修改"] forState:(UIControlStateNormal)];
        _editBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0,0,31);
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        //button标题的偏移量，这个偏移量是相对于图片的
        _editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [_editBtn setTitleColor:TCUIColorFromRGB(0x999999) forState:UIControlStateNormal];
        _editBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        [self.contentView addSubview:_editBtn];
        
        _deleBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 12 - 47, CGRectGetMaxY(line.frame) + 12, 47, 18)];
        [_deleBtn setImage:[UIImage imageNamed:@"删除"] forState:(UIControlStateNormal)];
        _deleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0,0,31);
        [_deleBtn setTitle:@"删除" forState:UIControlStateNormal];
        //button标题的偏移量，这个偏移量是相对于图片的
        _deleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [_deleBtn setTitleColor:TCUIColorFromRGB(0x999999) forState:UIControlStateNormal];
        _deleBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        [self.contentView addSubview:_deleBtn];
        
        
        _cellHeight = CGRectGetMaxY(_deleBtn.frame) + 12;
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
