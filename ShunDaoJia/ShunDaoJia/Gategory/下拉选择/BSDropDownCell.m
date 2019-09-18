//
//  BSDropDownCell.m
//  com.bagemanager.bgm
//
//  Created by 张平 on 2017/11/16.
//  Copyright © 2017年 www.bagechuxing.cn. All rights reserved.
//

#import "BSDropDownCell.h"

@implementation BSDropDownCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.contextLbl];
    [self.contentView addSubview:self.selectImgView];
    
    self.selectImgView.frame = CGRectMake(WIDTH - 27 - 20, 20, 20, 20);
    
    self.contextLbl.frame = CGRectMake(32, 20, WIDTH - 60, 20);
    self.contextLbl.text = @"ni";
    self.contextLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    self.contextLbl.textColor = TCUIColorFromRGB(0x666666);
    
    
//    _lineView = [[UIView alloc] init];
//    [self.contentView addSubview:_lineView];
//    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.contentView).mas_offset(-0.5);
//        make.width.mas_equalTo(SCREEN_WIDTH - 16 * 2);
//        make.height.mas_equalTo(0.5f);
//        make.left.equalTo(self.contentView.left).offset(16);
//    }];
//    _lineView.backgroundColor = RGBA(232, 232, 232, 1);
}

#pragma mark - lazy

- (UILabel *)contextLbl {
    if (!_contextLbl) {
        
        _contextLbl = [[UILabel alloc] init];
        
    }
    return _contextLbl;
}

- (UIImageView *)selectImgView {
    if (!_selectImgView) {
        _selectImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"选中的对号"]];
        _selectImgView.hidden = YES;
    }
    
    return _selectImgView;
}

@end
