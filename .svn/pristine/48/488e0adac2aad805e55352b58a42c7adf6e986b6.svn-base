//
//  BSDropDownView.m
//  com.bagemanager.bgm
//
//  Created by 张平 on 2017/11/16.
//  Copyright © 2017年 www.bagechuxing.cn. All rights reserved.
//

#import "BSDropDownView.h"
#import "BSDropDownCell.h"
static NSString *const identifier = @"CellReuseID";
@implementation BSDropDownView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        
    }
    return self;
}

- (void)setupUI {

    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self addSubview:self.tableView];
    
}

-(void)setType:(showTableStyleType)type
{
    if (type == showTableStyleTypeFromUpToBottom) {
        
        self.tableView.frame = CGRectMake(0, 0, self.frame.size.width, 0);
        
    }else if (type == showTableStyleTypeFromBottomToUp)
    {
        self.tableView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 0);
        
    }
    _type = type;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BSDropDownCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    cell.selectImgView.hidden = YES;
        
        cell.contextLbl.textColor = [UIColor blackColor];
        cell.contextLbl.text = self.dataArr[indexPath.row];
        
    if (indexPath.row == self.dataArr.count - 1) {
        
        cell.lineView.hidden = YES;
    }else
    {
        cell.lineView.hidden = NO;

    }

    //默认选中第一个,然后切换行之后刷新tableView,继续走这里判断哪一行显示绿色和选中标志
    if ([self.selectTitle isEqualToString:cell.contextLbl.text]) {
        
        cell.selectImgView.hidden = NO;
        cell.contextLbl.textColor = TCUIColorFromRGB(0xF99E20);
        
    }else {
        cell.selectImgView.hidden = YES;
        cell.contextLbl.textColor = TCUIColorFromRGB(0x666666);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectTitle = self.dataArr[indexPath.row];
    [self.tableView reloadData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didselectRow:indexPath:selectView:modelIndex:)]) {
        [self.delegate didselectRow:self.selectTitle indexPath:indexPath selectView:self modelIndex:self.index];
    }
    
//       列表收起
    if (self.type == showTableStyleTypeFromUpToBottom) {
        [UIView animateWithDuration:0.3 animations:^{
            
           self.tableView.frame = CGRectMake(0, 0, self.frame.size.width, 0);

        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        
    }else if (self.type == showTableStyleTypeFromBottomToUp)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            self.tableView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 0);

        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        
    }
   
    
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[BSDropDownCell class] forCellReuseIdentifier:identifier];
        _tableView.rowHeight = 47.5;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [UIView animateWithDuration:0.3 animations:^{
        if (self.type == showTableStyleTypeFromUpToBottom) {
            
            self.tableView.frame = CGRectMake(0, 0, self.frame.size.width, 0);

        }else if (self.type == showTableStyleTypeFromBottomToUp)
        {
            self.tableView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 0);

        }
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(sendValue)]) {
            [self.delegate  sendValue];
        }
        [self removeFromSuperview];
    }];
}

-(void)setIndex:(NSInteger)index
{
    _index = index;
}

@end
