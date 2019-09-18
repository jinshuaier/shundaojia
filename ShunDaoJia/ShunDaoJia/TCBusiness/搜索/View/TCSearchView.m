//
//  TCSearchView.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/11/25.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCSearchView.h"

@interface TCSearchView ()<UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *hotArray;
@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic, strong) UIView *searchHistoryView;
@property (nonatomic, strong) UIView *hotSearchView;

@end
@implementation TCSearchView

- (instancetype)initWithFrame:(CGRect)frame hotArray:(NSMutableArray *)hotArr historyArray:(NSMutableArray *)historyArr
{
    if (self = [super initWithFrame:frame]) {
        self.historyArray = historyArr;
        self.hotArray = hotArr;
        [self addSubview:self.searchHistoryView];
        [self addSubview:self.hotSearchView];
    }
    return self;
}


//- (UIView *)hotSearchView
//{
//    if (!_hotSearchView) {
//        self.hotSearchView = [self setViewWithOriginY:CGRectGetHeight(_searchHistoryView.frame) title:@"热门搜索" textArr:self.hotArray];
//        self.hotSearchView.backgroundColor = [UIColor whiteColor];
//    }
//    return _hotSearchView;
//}


- (UIView *)searchHistoryView
{
    if (!_searchHistoryView) {
        if (_historyArray.count > 0) {
            self.searchHistoryView = [self setViewWithOriginY:0 title:@"历史搜索" textArr:self.historyArray];
            self.searchHistoryView.backgroundColor = [UIColor whiteColor];
        } else {
            self.searchHistoryView = [self setNoHistoryView];
        }
    }
    return _searchHistoryView;
}



- (UIView *)setViewWithOriginY:(CGFloat)riginY title:(NSString *)title textArr:(NSMutableArray *)textArr
{
    
    UIView *view = [[UIView alloc] init];
    
    UIView *garyView = [[UIView alloc] init];
    garyView.frame = CGRectMake(0, 0, WIDTH, 42);
    garyView.backgroundColor = TCBgColor;
    [view addSubview:garyView];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, KScreenWidth - 30 - 45, 18)];
    titleL.text = title;
    titleL.font = [UIFont systemFontOfSize:14];
    titleL.textColor = TCUIColorFromRGB(0x666666);
    titleL.textAlignment = NSTextAlignmentLeft;
    [garyView addSubview:titleL];
    
    
    
    if ([title isEqualToString:@"历史搜索"]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(KScreenWidth - 35, 4, 28, 30);
        [btn setImage:[UIImage imageNamed:@"删除图标"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clearnSearchHistory:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    
    CGFloat y = 16 + 40;
    CGFloat letfWidth = 12;
    for (int i = 0; i < textArr.count; i++) {
        NSString *text = textArr[i];
        CGFloat width = [self getWidthWithStr:text] + 24;
        if (letfWidth + width + 12 > KScreenWidth) {
            if (y >= 130 && [title isEqualToString:@"最近搜索"]) {
                [self removeTestDataWithTextArr:textArr index:i];
                break;
            }
            y += 40;
            letfWidth = 12;
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(letfWidth, y, width, 32)];
        label.userInteractionEnabled = YES;
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        label.text = text;
        label.layer.borderWidth = 1;
        label.layer.cornerRadius = 4;
        label.textAlignment = NSTextAlignmentCenter;
        if (i % 2 == 0 && [title isEqualToString:@"热门搜索"]) {
            label.layer.borderColor = TCUIColorFromRGB(0xDEDEDE).CGColor;
            label.textColor = TCUIColorFromRGB(0x666666);
        } else {
            label.textColor = TCUIColorFromRGB(0x666666);
            label.layer.borderColor = TCUIColorFromRGB(0xDEDEDE).CGColor;
        }
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidCLick:)]];
        [view addSubview:label];
        letfWidth += width + 12;
    }
    view.frame = CGRectMake(0, riginY, KScreenWidth, y + 40 + 4);
    view.backgroundColor = [UIColor redColor];
    return view;
}


- (UIView *)setNoHistoryView
{
    UIView *historyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 0)];
    //    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, KScreenWidth - 30, 30)];
    //    titleL.text = @"最近搜索";
    //    titleL.font = [UIFont systemFontOfSize:15];
    //    titleL.textColor = [UIColor blackColor];
    //    titleL.textAlignment = NSTextAlignmentLeft;
    //
    //    UILabel *notextL = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(titleL.frame) + 10, 100, 20)];
    //    notextL.text = @"无搜索历史";
    //    notextL.font = [UIFont systemFontOfSize:12];
    //    notextL.textColor = [UIColor blackColor];
    //    notextL.textAlignment = NSTextAlignmentLeft;
    //    [historyView addSubview:titleL];
    //    [historyView addSubview:notextL];
    return historyView;
}

- (void)tagDidCLick:(UITapGestureRecognizer *)tap
{
    UILabel *label = (UILabel *)tap.view;
    if (self.tapAction) {
        self.tapAction(label.text);
    }
}

- (CGFloat)getWidthWithStr:(NSString *)text
{
    CGFloat width = [text boundingRectWithSize:CGSizeMake(KScreenWidth, 40) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil].size.width;
    return width;
}


- (void)clearnSearchHistory:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"清除历史记录?"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
    [alert show];
}
//按钮点击事件的代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"clickButtonAtIndex:%d",(int)buttonIndex);
    if (buttonIndex == 1){
        [self.searchHistoryView removeFromSuperview];
        self.searchHistoryView = [self setNoHistoryView];
        [_historyArray removeAllObjects];
        if (self.isShopGoodsSearch == YES){
            [NSKeyedArchiver archiveRootObject:_historyArray toFile:SGSearchPath];
        } else {
            [NSKeyedArchiver archiveRootObject:_historyArray toFile:KHistorySearchPath];
        }
        [self addSubview:self.searchHistoryView];
        CGRect frame = _hotSearchView.frame;
        frame.origin.y = CGRectGetHeight(_searchHistoryView.frame);
        _hotSearchView.frame = frame;
    }
    //index为-1则是取消，
}



- (void)removeTestDataWithTextArr:(NSMutableArray *)testArr index:(int)index
{
    NSRange range = {index, testArr.count - index - 1};
    [testArr removeObjectsInRange:range];
    if (self.isShopGoodsSearch == YES){
        [NSKeyedArchiver archiveRootObject:testArr toFile:SGSearchPath];
    } else {
        [NSKeyedArchiver archiveRootObject:testArr toFile:KHistorySearchPath];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
