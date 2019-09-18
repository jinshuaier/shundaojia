//
//  TCSpecialTableViewCell.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/15.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCSpecialTableViewCell.h"

@implementation TCSpecialTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andtypeStr:(NSString *)typeStr andorderDic:(NSString *)dicty andAgain:(NSDictionary *)dic
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self create:typeStr andorderDic:dicty andAgain:dic];
    }
    return self;
}

//创建视图
- (void)create:(NSString *)typeStr andorderDic:(NSString *)dicty andAgain:(NSDictionary *)dic
{
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    self.backView.frame = CGRectMake(8, 0, WIDTH - 16, 46);
    self.backView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.backView];
    
    
    self.specialLabel = [UILabel publicLab:nil textColor:TCUIColorFromRGB(0xFFFFFF) textAlignment:NSTextAlignmentCenter fontWithName:@"PingFangSC-Regular" size:10 numberOfLines:0];
    self.specialLabel.frame = CGRectMake(8, (46 - 14)/2, 14, 14);
    self.specialLabel.layer.cornerRadius = 4;
    self.specialLabel.layer.masksToBounds = YES;
    self.specialLabel.backgroundColor = TCUIColorFromRGB(0xF99E20);
    [self.backView addSubview:self.specialLabel];
    //title
    self.titlespLabel = [UILabel publicLab:nil textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    self.titlespLabel.frame = CGRectMake(CGRectGetMaxX(self.specialLabel.frame) + 8, 0, 56, 46);
    [self.backView addSubview:self.titlespLabel];
    
    //价格
    self.priceLabel = [UILabel publicLab:[NSString stringWithFormat:@""] textColor:TCUIColorFromRGB(0x333333) textAlignment:NSTextAlignmentRight fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    self.priceLabel.frame = CGRectMake(CGRectGetMaxX(self.titlespLabel.frame), 0, WIDTH - 16 - 8 - (CGRectGetMaxX(self.titlespLabel.frame)), 46);
    [self.backView addSubview:self.priceLabel];
    
    if ([typeStr isEqualToString:@"1"]){  //红包不可点击
        self.hongbaoPrice = [UILabel publicLab:[NSString stringWithFormat:@"%@",@""] textColor:TCUIColorFromRGB(0x333333) textAlignment:NSTextAlignmentRight fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
        self.hongbaoPrice.frame = CGRectMake(CGRectGetMaxX(self.titlespLabel.frame), 0, WIDTH - 16 - 8 - (CGRectGetMaxX(self.titlespLabel.frame)), 46);
        [self.backView addSubview:self.hongbaoPrice];
}
    
    if ([typeStr isEqualToString:@"4"]){
        CGFloat x = 0.0;
        int y = 0;
        CGFloat h = 0.0;
        if (dic){
            self.arr = dic[@"goods"];
            for (int i = 0; i < self.arr.count; i++) {
                
                float price = [self.arr[i][@"new_price"] floatValue];
                
                x += [self.arr[i][@"amount"] floatValue] * price;
                y += [self.arr[i][@"amount"] intValue];
                h = [dic[@"distributionPrice"] floatValue];
            }
        }
        self.totalPricelabel = [UILabel publicLab:[NSString stringWithFormat:@"总计：¥%@",@"200"] textColor:TCUIColorFromRGB(0x333333) textAlignment:NSTextAlignmentRight fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
        //从再来一单进来的
        NSString *str;
        if (dic){
            self.totalPricelabel.text = [NSString stringWithFormat:@"总计：¥%@",[NSString stringWithFormat:@"%@", dic[@"actualPrice"]]];
            str = [NSString stringWithFormat:@"%@",self.totalPricelabel.text];
            [self fuwenbenLabel:self.totalPricelabel FontNumber:[UIFont fontWithName:@"PingFangSC-Medium" size:16] AndRange:NSMakeRange(3, str.length - 3) AndColor:TCUIColorFromRGB(0xFF3355)];
        }
    
        self.backView.frame = CGRectMake(8, 0, WIDTH - 16, 68);
        self.totalPricelabel.frame = CGRectMake(0, 16, WIDTH - 16 - 8, 16);
        [self.backView addSubview:self.totalPricelabel];
        self.titlespLabel.hidden = YES;
        self.numGoodsLabel = [UILabel publicLab:[NSString stringWithFormat:@"%@种商品共计%@件",nil,nil] textColor:TCUIColorFromRGB(0x999999) textAlignment:NSTextAlignmentRight fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        if (dic){
            self.numGoodsLabel.text = [NSString stringWithFormat:@"%@种商品共计%@件",[NSString stringWithFormat:@"%lu", (unsigned long)self.arr.count],[NSString stringWithFormat:@"%d",y]];
        }
        self.numGoodsLabel.frame =CGRectMake(0, CGRectGetMaxY(self.totalPricelabel.frame) + 8, WIDTH - 16 - 8, 12);
        self.specialLabel.hidden = YES;
        [self.backView addSubview:self.numGoodsLabel];
    }
}

- (void)setModel:(TCDiscountsModel *)model
{
    _model = model;
    
    if ([model.typeStr isEqualToString:@"1"]){
        //满减优惠
        self.specialLabel.frame = CGRectMake(8, (46 - 14)/2, 14, 14);
        self.specialLabel.text = @"减";
        self.titlespLabel.text = model.type_nameStr;
        self.titlespLabel.frame = CGRectMake(CGRectGetMaxX(self.specialLabel.frame) + 8, 0, 56, 46);
        
    } else if ([model.typeStr isEqualToString:@"0"]){
        self.specialLabel.hidden = YES;
        self.titlespLabel.text = model.type_nameStr;
        self.titlespLabel.frame = CGRectMake(8, 0, 56, 46);
    } else {
        self.specialLabel.hidden = YES;
        self.titlespLabel.text = model.type_nameStr;
        self.titlespLabel.frame = CGRectMake(8, 0, 56, 46);
    }
    self.priceLabel.text = model.priceStr;
}

#pragma mark -- 红包
- (void)tap_three
{
    NSLog(@"红包");
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
