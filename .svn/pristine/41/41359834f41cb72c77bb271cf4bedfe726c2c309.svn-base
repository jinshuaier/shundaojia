//
//  BSDropDownView.h
//  com.bagemanager.bgm
//
//  Created by 张平 on 2017/11/16.
//  Copyright © 2017年 www.bagechuxing.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,showTableStyleType) {
    
//    从下往上展示
    showTableStyleTypeFromBottomToUp = 1,
//    从上往下展示
    showTableStyleTypeFromUpToBottom,
  
    
};

@class BSDropDownView;
@protocol selectViewDelegate <NSObject>

/** 选中行 */
- (void)didselectRow:(NSString *)context indexPath:(NSIndexPath *)indexPath selectView:(BSDropDownView *)selectView modelIndex:(NSInteger )index;
- (void)sendValue; //全局手势

@end

@interface BSDropDownView : UIView<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) UITableView *tableView;
/** 选中的内容 */
@property (nonatomic, copy) NSString *selectTitle;

/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic , assign)NSInteger index;

/** delegate */
@property (nonatomic, weak) id <selectViewDelegate> delegate;

@property (nonatomic , assign)showTableStyleType type;

@end
