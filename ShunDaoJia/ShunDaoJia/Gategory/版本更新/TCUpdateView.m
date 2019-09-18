//
//  TCUpdateView.m
//  顺道嘉(新)
//
//  Created by 某某 on 16/10/26.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "TCUpdateView.h"
#import "AppDelegate.h"

static TCUpdateView *upview = nil;
@interface TCUpdateView()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *verBtn; //立刻更新按钮
@property (nonatomic, strong) UIButton *delBtn; //删除的按钮
@property (nonatomic, strong) UIImageView *verImage; //更新图
@property (nonatomic, strong) UILabel *lb_verContent;
@property (nonatomic, strong) NSArray *versionArr;
@end

@implementation TCUpdateView

+ (id)upDateView:(NSArray *)Message{
    if (upview == nil) {
        upview = [[TCUpdateView alloc] initMessage:Message];
    }
    return upview;
}

- (id)initMessage:(NSArray *)Message{
    if(self == [super init]){
        self.versionArr = Message;
        [self create];
    }
    return self;
}

- (void)create{
    _backView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    _backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hah)];
    [_backView addGestureRecognizer:tap];
    [[UIApplication sharedApplication].keyWindow addSubview: _backView];

    _verImage = [[UIImageView alloc] init];
    _verImage.image = [UIImage imageNamed:@"更新图"];
    _verImage.userInteractionEnabled = YES;
    _verImage.frame = CGRectMake(72, 159 *HEIGHTSCALE, WIDTH - 144, 292);
    [_backView addSubview:_verImage];

    //更新内容的title
    UILabel *title_ver = [[UILabel alloc] init];
    title_ver.frame = CGRectMake(36, 136, 80, 21);
    title_ver.text = @"更新内容";
    title_ver.textColor = TCUIColorFromRGB(0x666666);
    title_ver.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    [_verImage addSubview:title_ver];
    
    //更新的内容
    for (int i = 0; i < self.versionArr.count; i ++) {
        _lb_verContent = [[UILabel alloc] init];
        _lb_verContent.frame = CGRectMake(36, CGRectGetMaxY(title_ver.frame) + 6 + 20 * i, WIDTH - 144 - 46, 17);
        _lb_verContent.text = self.versionArr[i];
        _lb_verContent.textColor = TCUIColorFromRGB(0x999999);
        _lb_verContent.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [_verImage addSubview:_lb_verContent];
    }

    //立即更新的按钮
    _verBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _verBtn.frame = CGRectMake((WIDTH - 144 - 132)/2, CGRectGetMaxY(_lb_verContent.frame) + 20, 132, 40);
    [_verBtn setTitle:@"立即更新" forState:(UIControlStateNormal)];
    [_verBtn setTitleColor:TCUIColorFromRGB(0xF9B52C) forState:(UIControlStateNormal)];
    _verBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    _verBtn.layer.cornerRadius = 20;
    _verBtn.layer.masksToBounds = YES;
    _verBtn.layer.borderColor = TCUIColorFromRGB(0xFAB228).CGColor;
    _verBtn.layer.borderWidth = 1;
    [_verBtn addTarget:self action:@selector(verBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [_verImage addSubview:_verBtn];
    
    _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_delBtn setBackgroundImage:[UIImage imageNamed:@"更新取消"] forState:(UIControlStateNormal)];
    _delBtn.frame = CGRectMake((WIDTH - 42)/2, CGRectGetMaxY(_verImage.frame) + 65, 42,42);
    [_delBtn addTarget:self action:@selector(mis) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview: _delBtn];
}

- (void)hah{
    NSLog(@"123");
}

- (void)mis{
    [_backView removeFromSuperview];
}

- (void)verBtnClick {
    [_backView removeFromSuperview];
    NSString *url = @"https://itunes.apple.com/cn/app/id1120901620?mt=8";
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
}

@end
