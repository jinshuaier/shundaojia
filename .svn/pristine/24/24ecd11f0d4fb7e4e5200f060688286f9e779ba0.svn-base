//
//  YYSearchView.m
//  YYSearchView
//
//  Created by mac on 16/7/12.
//  Copyright © 2016年 Jack YY. All rights reserved.
//

#import "YYSearchView.h"

@implementation YYSearchView


-(void)awakeFromNib
{
    self.YYBgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navi"]];
    self.YYSearch.leftView = [self leftView];
    self.YYSearch.rightView = [self rightView];
    [self.YYSearch setValue:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.8] forKeyPath:@"_placeholderLabel.textColor"];
    self.YYSearch.leftViewMode = UITextFieldViewModeAlways;
    self.YYSearch.rightViewMode = UITextFieldViewModeWhileEditing;
    self.YYSearch.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.8];
    self.YYSearch.layer.borderWidth = 1.0f;
    self.YYSearch.layer.cornerRadius = 4;
    self.YYSearch.layer.borderColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1].CGColor;
}

+(instancetype)creatView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"YYSearchView" owner:nil options:nil]lastObject];
}

-(UIView *)leftView
{
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(18, 8, 24, 24)];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(8, 4, 16, 16);
    [button setImage:[UIImage imageNamed:@"搜索中"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(searchTile) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:button];
    return leftView;
}
-(UIView *)rightView
{
    UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(100, 8, 24, 24)];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 4, 16, 16);
    [button setImage:[UIImage imageNamed:@"小叉"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(searchtitle) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:button];
    return rightView;
}
-(void)searchTile
{
    [self.YYSearch resignFirstResponder];
    self.YYGetTitle(self.YYSearch.text);
}
-(void)searchtitle
{
    self.YYSearch.text = @"";
}




@end
