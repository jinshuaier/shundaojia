//
//  TCSearchViewController.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/11/23.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCSearchViewController.h"
#import "TwoViewController.h"
@interface TCSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UIView *topView;
    UIView *footView;
    UIView *searchRecordView;
    UIView *remenview;
    UIView *hotToryView;
    
    UIView *backSearchView; //搜索框
    UIButton *searchBtn; //搜索的按钮
    UIButton *BackBtn; //返回按钮
    UIScrollView *ScrollView;
    
    UIView *headerView; //头部的view
}

@property (nonatomic, strong) NSMutableArray *hisArray;
@property (nonatomic, strong) NSMutableArray *searchArr;
@property (nonatomic, strong) UITableView *searchTable;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSUserDefaults *userdefaluts;
@property (nonatomic, strong) UITableView *historyTableView;
@property (nonatomic, strong) UITextField *searchField;

@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) NSMutableArray *searchRecordArr;
@property (nonatomic, strong) NSUserDefaults *userdefaults;
@property (nonatomic, strong) UIView *remenView;

@property (nonatomic, strong) UITableView *shopGoodTabelView;
@property (nonatomic, strong) UIButton *lastButton; //最后的btn
@property (nonatomic, strong) UIView *lineView; //线



@end

@implementation TCSearchViewController

//隐藏导航栏
-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = TCBgColor;
    
    //创建navView
    UIView *navView = [[UIView alloc] init];
    navView.frame = CGRectMake(0, 0, WIDTH, StatusBarAndNavigationBarHeight);
    navView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:navView];
    
    ScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - StatusBarAndNavigationBarHeight)];
    ScrollView.showsVerticalScrollIndicator = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    ScrollView.backgroundColor = TCBgColor;
    _scrollview = ScrollView;
    _scrollview.contentSize = CGSizeMake(0, HEIGHT);
    [self.view addSubview:ScrollView];
    
    //返回按钮
    BackBtn = [[UIButton alloc] init];
    BackBtn.frame = CGRectMake(12, StatusBarHeight + 10, 24, 24);
    [BackBtn setImage:[UIImage imageNamed:@"返回按钮（黑）"] forState:(UIControlStateNormal)];
    [BackBtn addTarget:self action:@selector(backBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [navView addSubview:BackBtn];
    
    //搜索view
    backSearchView = [[UIView alloc] init];
    backSearchView.frame = CGRectMake(CGRectGetMaxX(BackBtn.frame) + 12, StatusBarHeight + 6, WIDTH - (CGRectGetMaxX(BackBtn.frame) + 12) - 14, 32);
    backSearchView.backgroundColor = TCUIColorFromRGB(0xF5F5F5);
    [navView addSubview:backSearchView];
    
    //搜索的按钮
    searchBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    searchBtn.frame = CGRectMake(WIDTH - 8 - 59, StatusBarHeight + 6, 59, 32);
    searchBtn.backgroundColor = TCUIColorFromRGB(0xFF884C);
    [searchBtn setTitle:@"搜索" forState:(UIControlStateNormal)];
    [searchBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    searchBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    searchBtn.hidden = YES;
    [searchBtn addTarget:self action:@selector(searchBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [navView addSubview:searchBtn];
    
    
    
    
    //搜索icon
    UIImageView *searchIcon = [[UIImageView alloc] init];
    searchIcon.image = [UIImage imageNamed:@"首页搜索icon"];
    searchIcon.frame = CGRectMake(12, 8, 16, 15.5);
    [backSearchView addSubview:searchIcon];
    
    //搜索框
    self.searchField = [[UITextField alloc] init];
    self.searchField.frame = CGRectMake(CGRectGetMaxX(searchIcon.frame) + 8, 6, WIDTH - (CGRectGetMaxX(BackBtn.frame) + 12) - 14 - (CGRectGetMaxX(searchIcon.frame) + 8), 21);
    self.searchField.clearButtonMode = UITextFieldViewModeAlways;
    self.searchField.delegate = self;
    self.searchField.placeholder = @"输入您要的商品名称";
    [self.searchField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    [self.searchField setValue:TCUIColorFromRGB(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    [self.searchField setValue:[UIFont fontWithName:@"PingFangSC-Medium" size:15] forKeyPath:@"_placeholderLabel.font"];
    self.searchField.textColor = TCUIColorFromRGB(0x333333);
    self.searchField.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    [backSearchView addSubview:self.searchField];
    
    //一条细线
    UIView *lineNavcView = [[UIView alloc] init];
    lineNavcView.frame = CGRectMake(0, StatusBarAndNavigationBarHeight - 1, WIDTH, 1);
    lineNavcView.backgroundColor = TCBgColor;
    [navView addSubview:lineNavcView];
    
    
    _path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:[@"homePageSearchHistory" stringByAppendingFormat:@"%@", @".plist"]];
    _searchRecordArr = [NSMutableArray array];
    NSArray *myarr = [NSArray arrayWithContentsOfFile: _path];
    [_searchRecordArr addObjectsFromArray: myarr];
    self.searchArr = [[NSMutableArray alloc]init];
    self.userdefaults = [NSUserDefaults standardUserDefaults];
    
    //搜索记录
    [self searchhistory];
    
    //按钮
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, self.view.qh_width, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    headerView.hidden = YES;
    
    NSArray *titleArray = @[@"全部类型",@"销量最高",@"距离最近"];
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(WIDTH / titleArray.count * i, 0, WIDTH / titleArray.count, 40);
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:TCUIColorFromRGB(0x666666) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        [btn setTitleColor:TCUIColorFromRGB(0xFF884C) forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(typeSelect:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1000 + i;
        [headerView addSubview:btn];
        
        //添加细线
        if (i < 2){
            self.lineView = [[UIView alloc] init];
            self.lineView.frame = CGRectMake(WIDTH/3 * i + WIDTH/3, 0, 1, 40);
            self.lineView.backgroundColor = TCUIColorFromRGB(0xEDEDED);
            [headerView addSubview:self.lineView];
        }
        UIView *bottom_Line = [[UIView alloc] init];
        bottom_Line.frame = CGRectMake(0, 40, WIDTH, 1);
        bottom_Line.backgroundColor = TCUIColorFromRGB(0xEDEDED);
        [headerView addSubview:bottom_Line];
        
        
        if (i == 0) {
            btn.selected = YES;
            self.lastButton = btn;
        }
    }
    
    //创建tableView
    self.shopGoodTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 200) style:UITableViewStylePlain];
    self.shopGoodTabelView.delegate = self;
    self.shopGoodTabelView.dataSource = self;
    [self.view addSubview: self.shopGoodTabelView];
    
}





//搜索记录
- (void)searchhistory{
    
    searchRecordView = [[UIView alloc]init];
    searchRecordView.frame = CGRectMake(0, 0, WIDTH, 300);
    searchRecordView.tag = 10001;
    searchRecordView.backgroundColor = [UIColor whiteColor];
    [_scrollview addSubview:searchRecordView];
    
    //历史记录的view
    UIView *hisBgView = [[UIView alloc] init];
    hisBgView.frame = CGRectMake(0, 0, WIDTH, 42);
    hisBgView.backgroundColor = TCBgColor;
    [searchRecordView addSubview:hisBgView];
    
    UILabel *searchRecordlb = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 56, 42)];
    searchRecordlb.text = @"历史搜索";
    searchRecordlb.textAlignment = NSTextAlignmentLeft;
    searchRecordlb.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    searchRecordlb.textColor = TCUIColorFromRGB(0x666666);
    [hisBgView addSubview: searchRecordlb];
    
    //删除按钮
    UIButton *deleBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    deleBtn.frame = CGRectMake(WIDTH - 12 - 15, 13, 15, 16);
    [deleBtn addTarget:self action:@selector(deleBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [deleBtn setImage:[UIImage imageNamed:@"删除图标"] forState:(UIControlStateNormal)];
    [hisBgView addSubview:deleBtn];
    
    //装历史的View
    UIView *hisToryView = [[UIView alloc] init];
    hisToryView.backgroundColor = [UIColor whiteColor];
    hisToryView.frame = CGRectMake(0, CGRectGetMaxY(searchRecordlb.frame), WIDTH, 300 - 42);
    [searchRecordView addSubview:hisToryView];
    
    NSUInteger count = 0;
    //搜索记录显示10个
    if (_searchRecordArr.count <= 10) {
        count = _searchRecordArr.count;
    }else{
        count = 10;
    }
    for (int i = 0; i < count; i++) {
        NSString *namestr = _searchRecordArr[i];
        static UIButton *searchrecordBtn = nil;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        CGRect newRect = [namestr boundingRectWithSize:CGSizeMake(WIDTH - 24, 32) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:button.titleLabel.font} context:nil];
        if (i == 0) {
            button.frame = CGRectMake(12, 16, newRect.size.width + 12, 32);
        }else{
            CGFloat newwidth = WIDTH - 12 - searchrecordBtn.frame.origin.x - searchrecordBtn.frame.size.width - 24;
            if (newwidth >= newRect.size.width) {
                button.frame = CGRectMake(searchrecordBtn.frame.origin.x + searchrecordBtn.frame.size.width + 12, searchrecordBtn.frame.origin.y, newRect.size.width + 12, 32);
            }else{
                button.frame = CGRectMake(12, searchrecordBtn.frame.origin.y + 32 + 16, newRect.size.width +12, 32);
            }
        }
//        _scrollview.contentSize = CGSizeMake(self.view.frame.size.width, searchRecordView.frame.size.height + searchRecordView.frame.origin.y + 10);
        button.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
        [button setTitle:_searchRecordArr[i] forState:UIControlStateNormal];
        [button setTitleColor:TCUIColorFromRGB(0x666666) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [button addTarget:self action:@selector(recordBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        button.layer.cornerRadius = 4;
        button.layer.masksToBounds = YES;
        button.layer.borderColor = TCUIColorFromRGB(0xDEDEDE).CGColor;
        button.layer.borderWidth = 1;
        //代表前一个按钮 用来记录前一个按钮的位置与大小
        searchrecordBtn = button;
        [hisToryView addSubview: button];
        
        if (i == count - 1) {
            
            hisToryView.frame = CGRectMake(0, CGRectGetMaxY(searchRecordlb.frame), WIDTH, CGRectGetMaxY(button.frame) + 16);
            
            searchRecordView.frame = CGRectMake(0,0, WIDTH, CGRectGetMaxY(hisToryView.frame));
        }
    }
    
    //热门搜索
    remenview = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(searchRecordView.frame), WIDTH, 160 + 42)];
    remenview.backgroundColor = [UIColor whiteColor];
    remenview.tag = 10000;
    _remenView = remenview;
    [_scrollview addSubview: remenview];

    //热门框
    UIView *hotView = [[UIView alloc] init];
    hotView.frame = CGRectMake(0, 0, WIDTH, 42);
    hotView.backgroundColor = TCBgColor;
    [remenview addSubview:hotView];

    //装热门的View
    hotToryView = [[UIView alloc] init];
    hotToryView.backgroundColor = [UIColor whiteColor];
    hotToryView.frame = CGRectMake(0, CGRectGetMaxY(hotView.frame), WIDTH, 300 - 42);
    [remenview addSubview:hotToryView];
//
    UILabel *hotlb = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 56, 42)];
    hotlb.text = @"热门搜索";
    hotlb.textAlignment = NSTextAlignmentLeft;
    hotlb.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    hotlb.textColor = TCUIColorFromRGB(0x666666);
    [hotView addSubview: hotlb];
    
    NSArray *arr = @[@"恰恰瓜子",@"恰恰瓜子",@"恰恰瓜子",@"恰恰瓜子",@"恰恰瓜子",@"恰恰瓜子",@"恰恰瓜子",@"恰恰瓜子",@"恰恰瓜子"];
    for (int i = 0; i < arr.count; i++) {
        NSString *namestr1 = arr[i];
        static UIButton *hotBtn = nil;
        UIButton *button_Hot = [UIButton buttonWithType:UIButtonTypeSystem];
        CGRect newRect = [namestr1 boundingRectWithSize:CGSizeMake(WIDTH - 24, 32) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:button_Hot.titleLabel.font} context:nil];
        if (i == 0) {
            button_Hot.frame = CGRectMake(12, 16, newRect.size.width + 12, 32);
        }else{
            CGFloat newwidth = WIDTH - 12 - hotBtn.frame.origin.x - hotBtn.frame.size.width - 24;
            if (newwidth >= newRect.size.width) {
                button_Hot.frame = CGRectMake(hotBtn.frame.origin.x + hotBtn.frame.size.width + 12, hotBtn.frame.origin.y, newRect.size.width + 12, 32);
            }else{
                button_Hot.frame = CGRectMake(12, hotBtn.frame.origin.y + 32 + 16, newRect.size.width +12, 32);
            }
        }
        //        _scrollview.contentSize = CGSizeMake(self.view.frame.size.width, searchRecordView.frame.size.height + searchRecordView.frame.origin.y + 10);
        button_Hot.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
        [button_Hot setTitle:arr[i] forState:UIControlStateNormal];
        [button_Hot setTitleColor:TCUIColorFromRGB(0x666666) forState:UIControlStateNormal];
        button_Hot.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [button_Hot addTarget:self action:@selector(button_Hot:) forControlEvents:(UIControlEventTouchUpInside)];
        button_Hot.layer.cornerRadius = 4;
        button_Hot.layer.masksToBounds = YES;
        button_Hot.layer.borderColor = TCUIColorFromRGB(0xDEDEDE).CGColor;
        button_Hot.layer.borderWidth = 1;
        //代表前一个按钮 用来记录前一个按钮的位置与大小
        hotBtn = button_Hot;
        [hotToryView addSubview: button_Hot];
        
        if (i == count - 1) {
            
            hotToryView.frame = CGRectMake(0, CGRectGetMaxY(hotView.frame), WIDTH, CGRectGetMaxY(button_Hot.frame) + 16);
            
            remenview.frame = CGRectMake(0,CGRectGetMaxY(searchRecordView.frame), WIDTH, CGRectGetMaxY(hotToryView.frame));
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *viewHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 24 + 18)];
        viewHead.backgroundColor = TCBgColor;
        
        UILabel *currentLabel = [UILabel publicLab:@"联系人" textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
        
        currentLabel.frame = CGRectMake(12, 0, WIDTH - 12, 24 + 18);
        [viewHead addSubview:currentLabel];
        
        return viewHead;
    }
    return nil;
}



-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.qh_width, 0)];
    footerView.backgroundColor = TCBgColor;
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 42;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
      TCPhoneTableViewCell *cell = [[TCPhoneTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 54 * 3;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark -- 删除历史记录
- (void)deleBtn:(UIButton *)sender
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
   message:@"清除历史记录?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {

  }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
         //响应事件
      NSLog(@"action = %@", action);
        //响应事件
        NSLog(@"action = %@", action);
        NSLog(@"删除历史记录");
        searchRecordView.hidden = YES;
        remenview.frame = CGRectMake(0,0, WIDTH, CGRectGetMaxY(hotToryView.frame));
        
        NSFileManager *manager = [NSFileManager defaultManager];
        [manager removeItemAtPath:_path error:nil];
        [_searchRecordArr removeAllObjects];
        [searchRecordView removeFromSuperview];
     }];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -- 热门搜索
- (void)button_Hot:(UIButton *)sender
{
    NSLog(@"热门搜索");
}

#pragma mark -- 历史搜索
- (void)recordBtn:(UIButton *)sender
{
    NSLog(@"历史搜索");
}


//监听文本框刚开始的变化
-(void)valueChanged:(UITextField *)textField{
    
    //textfield的协议
    if (textField.text.length != 0) {
        backSearchView.frame = CGRectMake(CGRectGetMaxX(BackBtn.frame) + 12, StatusBarHeight + 6, WIDTH - (CGRectGetMaxX(BackBtn.frame) + 12) - 75 , 32);
        searchBtn.hidden = NO;
        
    } else {
        backSearchView.frame = CGRectMake(CGRectGetMaxX(BackBtn.frame) + 12, StatusBarHeight + 6, WIDTH - (CGRectGetMaxX(BackBtn.frame) + 12) - 14, 32);
        searchBtn.hidden = YES;
        ScrollView.hidden = NO;
        headerView.hidden = YES;
    }
}


#pragma mark -- 返回按钮
- (void)backBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

//点击搜索键盘的事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //发送请求
    
    [textField resignFirstResponder];
    NSLog(@"此处进行网络请求");
    
    //记录搜索词
    [_searchRecordArr removeAllObjects];
    NSArray *myarr = [NSArray arrayWithContentsOfFile: _path];
    [_searchRecordArr addObjectsFromArray:myarr];
    //将新的值插入第一个
    [_searchRecordArr insertObject:textField.text atIndex:0];
    [_searchRecordArr writeToFile:_path atomically:YES];
    return YES;
}

#pragma mark -- 搜索的点击事件
- (void)searchBtn:(UIButton *)sender
{
    ScrollView.hidden = YES;
    headerView.hidden = NO;
}

- (void)typeSelect:(UIButton *)button {
    self.lastButton.selected = NO;
    button.selected = YES;
    self.lastButton = button;
    
    switch (button.tag) {
        case 1000: {
            
        }
            break;
        case 1001: {
            
        }
            break;
        case 1002: {
            
        }
            break;
        default:
            break;
    }
    
    // [listTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
