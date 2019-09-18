//
//  TCAllPriceTableViewCell.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/4/19.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCAllPriceTableViewCell.h"

@implementation TCAllPriceTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andallp:(float)allP andGoodsNum:(NSString *)goodsnum andAllNum:(NSString *)allNum andStyle:(NSString *)styles
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = TCBgColor;
        [self create:allP andGoodsNum:goodsnum andAllNum:allNum andStyle:styles];
    }
    return self;
}

- (void)create:(float)allp andGoodsNum:(NSString *)goodsnum andAllNum:(NSString *)allNum andStyle:(NSString *)style{
    
    //添加背景颜色
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.frame = CGRectMake(8, 0, WIDTH - 16, 68);
    [self addSubview:backView];
    
    //总价
    UILabel *totalPricelabel = [UILabel publicLab:nil textColor:TCUIColorFromRGB(0x333333) textAlignment:NSTextAlignmentRight fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    totalPricelabel.text = [NSString stringWithFormat:@"总计：¥%.2f",allp];
    totalPricelabel.frame =CGRectMake(0, 16, WIDTH - 16 - 8, 16);
    NSString *str;
    str = [NSString stringWithFormat:@"%@",totalPricelabel.text];
    [self fuwenbenLabel:totalPricelabel FontNumber:[UIFont fontWithName:@"PingFangSC-Medium" size:16] AndRange:NSMakeRange(3, str.length - 3) AndColor:TCUIColorFromRGB(0xFF3355)];
    [backView addSubview:totalPricelabel];
    
    //商品的数量
    UILabel *numGoodsLabel = [UILabel publicLab:[NSString stringWithFormat:@"%@种商品共计%@件",nil,nil] textColor:TCUIColorFromRGB(0x999999) textAlignment:NSTextAlignmentRight fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    numGoodsLabel.text = [NSString stringWithFormat:@"%@种商品共计%@件",[NSString stringWithFormat:@"%@",allNum],[NSString stringWithFormat:@"%@",goodsnum]];
    numGoodsLabel.frame =CGRectMake(0, CGRectGetMaxY(totalPricelabel.frame) + 8, WIDTH - 16 - 8, 12);
    [backView addSubview:numGoodsLabel];
}

//设置不同字体颜色
-(void)fuwenbenLabel:(UILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labell.text];
    
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    
    labell.attributedText = str;
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
