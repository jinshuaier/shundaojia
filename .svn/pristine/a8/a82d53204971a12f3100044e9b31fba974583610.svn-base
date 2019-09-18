//
//  TCGrouppurchaseCell.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/11.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCGrouppurchaseCell.h"
#import "UIImage+ImgSize.h"
@implementation TCGrouppurchaseCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self crecteUI];
    }
    return self;
}

//创建View
- (void)crecteUI
{
    _commodityImage = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, WIDTH - 16, 172)];
    //        _commodityImage.image = [UIImage imageNamed:@"3"];
//    _commodityImage.layer.masksToBounds = YES;
//    _commodityImage.layer.cornerRadius = 4;
//    _commodityImage.layer.shadowColor = TCUIColorFromRGB(0x000000).CGColor;
//    _commodityImage.layer.shadowOffset = CGSizeMake(0, 4);
//    _commodityImage.layer.shadowOpacity = 0.9;
    
    [self.contentView addSubview:_commodityImage];
    
    _recommendLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(_commodityImage.frame) + 16, 82, 20)];
    _recommendLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    _recommendLabel.textColor = TCUIColorFromRGB(0xFFFFFF);
    _recommendLabel.text = @"某某推荐商品";
    _recommendLabel.textAlignment = NSTextAlignmentCenter;
    _recommendLabel.numberOfLines = 0;
    _recommendLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [_recommendLabel sizeThatFits:CGSizeMake(MAXFLOAT, 20)];
    _recommendLabel.frame = CGRectMake(12, CGRectGetMaxY(_commodityImage.frame) + 16, size.width, 20);
    
    self.GradientLayer = [CAGradientLayer layer];
    self.GradientLayer.frame = CGRectMake(0,0,size.width,20);
    [_recommendLabel.layer addSublayer:self.GradientLayer];
    self.GradientLayer.colors = [NSArray arrayWithObjects:(id)TCUIColorFromRGB(0xFF884c).CGColor,(id)TCUIColorFromRGB(0xFF4C79).CGColor,nil];
    self.GradientLayer.locations = @[@(0.1f), @(1.1f)];
    [_recommendLabel.layer insertSublayer:self.GradientLayer atIndex:0];
    
    self.GradientLayer.cornerRadius = 2;
    self.GradientLayer.masksToBounds = YES;
    
    [self.contentView addSubview: _recommendLabel];
    
    _commodityName = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(_recommendLabel.frame) + 16, WIDTH - 24, 16)];
    _commodityName.textColor = TCUIColorFromRGB(0x333333);
    _commodityName.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    _commodityName.text = @"这是商品名称这是商品名称这是商品名称这是比较失败的机会吧时";
    _commodityName.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_commodityName];
    
    _SalesvolumeLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(_commodityName.frame) + 12, WIDTH, 12)];
    _SalesvolumeLabel.textAlignment = NSTextAlignmentLeft;
    _SalesvolumeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    _SalesvolumeLabel.textColor = TCUIColorFromRGB(0x666666);
    _SalesvolumeLabel.text = @"这是销量";
    [self.contentView addSubview:_SalesvolumeLabel];
    
    _grouppurLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(_SalesvolumeLabel.frame) + 18, 40, 12)];
    _grouppurLabel.textAlignment = NSTextAlignmentLeft;
    _grouppurLabel.text = @"团购价:";
    _grouppurLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    _grouppurLabel.textColor = TCUIColorFromRGB(0x333333);
    [self.contentView addSubview:_grouppurLabel];
    
    _Presentpricelabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_grouppurLabel.frame), CGRectGetMaxY(_SalesvolumeLabel.frame) + 12, 40, 18)];
    _Presentpricelabel.textAlignment = NSTextAlignmentLeft;
    _Presentpricelabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    _Presentpricelabel.textColor = TCUIColorFromRGB(0xFF3355);
    _Presentpricelabel.text = @"￥36";
    _Presentpricelabel.numberOfLines = 0;
    _Presentpricelabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size1 = [_Presentpricelabel sizeThatFits:CGSizeMake(MAXFLOAT, 18)];
    _Presentpricelabel.frame = CGRectMake(CGRectGetMaxX(_grouppurLabel.frame), CGRectGetMaxY(_SalesvolumeLabel.frame) + 12, size1.width, 18);
    [self.contentView addSubview:_Presentpricelabel];
    
    _OriginalpriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_Presentpricelabel.frame) + 8, CGRectGetMaxY(_SalesvolumeLabel.frame) + 18, 27, 12)];
    _OriginalpriceLabel.textColor = TCUIColorFromRGB(0x999999);
    _OriginalpriceLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    _OriginalpriceLabel.text = @"￥40";
    _OriginalpriceLabel.textAlignment = NSTextAlignmentLeft;
    
    _OriginalpriceLabel.numberOfLines = 0;
    _OriginalpriceLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size2 = [_OriginalpriceLabel sizeThatFits:CGSizeMake(MAXFLOAT, 12)];
    _OriginalpriceLabel.frame = CGRectMake(CGRectGetMaxX(_Presentpricelabel.frame) + 8, CGRectGetMaxY(_SalesvolumeLabel.frame) + 18, size2.width, 12);
    [self.contentView addSubview:_OriginalpriceLabel];  
}

-(void)setModel:(TCGroupGoodsModel *)model{
    _model = model;
    if ([model.image isEqual:[NSNull null]]){
        _commodityImage.image = [UIImage imageNamed:@"团购占位图"];
    } else {
        _commodityImage.image = [UIImage imageCompressForWidthScale:_commodityImage.image targetWidth:WIDTH];
        [_commodityImage sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"团购占位图"]];
        
        _commodityImage.contentMode = UIViewContentModeScaleAspectFill;
        _commodityImage.clipsToBounds = YES;
        [_commodityImage setContentScaleFactor:[[UIScreen mainScreen] scale]];//缩放图片的分辨率
    }
    
    //推荐的商品
    _recommendLabel.text = model.remark;
    CGSize size = [_recommendLabel sizeThatFits:CGSizeMake(MAXFLOAT, 20)];
    _recommendLabel.frame = CGRectMake(12, CGRectGetMaxY(_commodityImage.frame) + 16, size.width + 8, 20);
    self.GradientLayer.frame = CGRectMake(0,0,size.width + 8,20);
    _recommendLabel.textAlignment = NSTextAlignmentCenter;

    
    self.commodityName.text = model.name;
    self.SalesvolumeLabel.text = [NSString stringWithFormat:@"销量：%@单",model.saleCount];
    self.Presentpricelabel.text = [NSString stringWithFormat:@"￥%@",model.price];
    self.OriginalpriceLabel.text = [NSString stringWithFormat:@"￥%@",model.markPrice];
    self.OriginalpriceLabel.numberOfLines = 0;
    self.OriginalpriceLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size1 = [self.Presentpricelabel sizeThatFits:CGSizeMake(MAXFLOAT, 12)];
    self.Presentpricelabel.frame = CGRectMake(CGRectGetMaxX(_grouppurLabel.frame), CGRectGetMaxY(_SalesvolumeLabel.frame) + 12, size1.width, 18);
    
    CGSize size2 = [self.OriginalpriceLabel sizeThatFits:CGSizeMake(MAXFLOAT, 12)];
    self.OriginalpriceLabel.frame = CGRectMake(CGRectGetMaxX(_Presentpricelabel.frame) + 8, CGRectGetMaxY(_SalesvolumeLabel.frame) + 18, size2.width, 12);
    self.OriginalpriceLabel.textAlignment = NSTextAlignmentLeft;
    UIView *line = [[UIView alloc]init];
    line.frame = CGRectMake(0,(12 - 1)/2, size2.width, 1);
    line.backgroundColor = TCUIColorFromRGB(0x999999);
    [_OriginalpriceLabel addSubview:line];
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
