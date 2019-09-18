//
//  TCHistoryTableViewCell.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/11/23.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCHistoryTableViewCell.h"

@implementation TCHistoryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self create];
    }
    return self;
}

- (void)create{
    
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, 0, WIDTH, 42);
    backView.backgroundColor = TCBgColor;
    [self.contentView addSubview:backView];
    
    //
    self.headLabel = [UILabel publicLab:@"历史搜索" textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    self.headLabel.frame = CGRectMake(12, 12, 56, 18);
    [self.contentView addSubview:self.headLabel];
    
    //
    self.deleBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.deleBtn.frame = CGRectMake(WIDTH - 12 - 15, 13, 15, 16);
    [self.deleBtn setImage:[UIImage imageNamed:@"删除图标"] forState:(UIControlStateNormal)];
    [self.deleBtn addTarget:self action:@selector(deleBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:self.deleBtn];
    
    
    self.goodArr = @[@"恰恰瓜子",@"恰恰瓜子",@"恰恰瓜子",@"恰恰瓜子",@"恰恰瓜子",@"恰恰瓜子",@"恰恰瓜子",@"恰恰瓜子",@"恰恰瓜子"];
    for (int i = 0; i < self.goodArr.count; i++) {
        NSString *namestr1 = self.goodArr[i];
        static UIButton *hotBtn = nil;
        self.searchBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        CGRect newRect = [namestr1 boundingRectWithSize:CGSizeMake(WIDTH - 24, 32) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.searchBtn.titleLabel.font} context:nil];
        if (i == 0) {
            self.searchBtn.frame = CGRectMake(12, CGRectGetMaxY(backView.frame) + 16, newRect.size.width + 12, 32);
        }else{
            CGFloat newwidth = WIDTH - 12 - hotBtn.frame.origin.x - hotBtn.frame.size.width - 24;
            if (newwidth >= newRect.size.width) {
                self.searchBtn.frame = CGRectMake(hotBtn.frame.origin.x + hotBtn.frame.size.width + 12, hotBtn.frame.origin.y, newRect.size.width + 12, 32);
            }else{
                self.searchBtn.frame = CGRectMake(12, CGRectGetMaxY(backView.frame) + 32 + 32, newRect.size.width +12, 32);
            }
        }
        self.searchBtn.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
        [self.searchBtn setTitle:self.goodArr[i] forState:UIControlStateNormal];
        [self.searchBtn setTitleColor:TCUIColorFromRGB(0x666666) forState:UIControlStateNormal];
        self.searchBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        [self.searchBtn addTarget:self action:@selector(button_Hot:) forControlEvents:(UIControlEventTouchUpInside)];
        self.searchBtn.layer.cornerRadius = 4;
        self.searchBtn.layer.masksToBounds = YES;
        self.searchBtn.layer.borderColor = TCUIColorFromRGB(0xDEDEDE).CGColor;
        self.searchBtn.layer.borderWidth = 1;
        //代表前一个按钮 用来记录前一个按钮的位置与大小
        hotBtn = self.searchBtn;
        [self.contentView addSubview: self.searchBtn];
        
//        if (i == count - 1) {
//
//            hotToryView.frame = CGRectMake(0, CGRectGetMaxY(hotView.frame), WIDTH, CGRectGetMaxY(button_Hot.frame) + 16);
//
//            remenview.frame = CGRectMake(0,CGRectGetMaxY(searchRecordView.frame), WIDTH, CGRectGetMaxY(hotToryView.frame));
//        }
    }
    

}

#pragma mark -- 按钮点击事件
- (void)button_Hot:(UIButton *)sender
{
    NSLog(@"点击");
}

#pragma mark -- 删除的按钮
- (void)deleBtn:(UIButton *)sedner
{
    NSLog(@"删除");
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
