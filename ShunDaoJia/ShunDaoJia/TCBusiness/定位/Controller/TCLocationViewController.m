//
//  TCLocationViewController.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/11/22.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCLocationViewController.h"
#import "TCDTopTableViewCell.h"
#import "TCMyAddTableViewCell.h"
#import "TCSearcCellTableViewCell.h"
#import "TCAddressViewController.h" //新增地址

#import "TCNearbyTableViewCell.h" //附近的地址
#import "TCHisTableViewCell.h" //历史记录
#import "HggManager.h"
#import "TCNearAddInfo.h"
#import "TCLocation.h" //定位


#import "HeadView.h" //城市列表View

@interface TCLocationViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate>
{
    UIView *seachView; //创建输入框的view
    UIButton *locatBtn; // 地理位置
    UIButton *seacrhBtn; //搜索的按钮
    UIView *searchView; //搜索框
    UITextField *searchField;
    
    HeadView    *_CellHeadView; //城市列表的View
    NSMutableArray * _locationCity; //定位当前城市
    
    NSMutableArray *_dataArray; //定位，最近，热门数据原
    
    NSMutableDictionary *_allCitysDictionary; //所有数据字典
    NSMutableArray *_keys; //城市首字母
}

@property (nonatomic, strong)NSMutableArray *searchList; //搜索结果的数组
@property(strong,nonatomic)NSMutableArray *allCityArray;  //所有城市数组

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UITableView *cityTableView;
@property (nonatomic, strong) UITableView *searchTableView;
@property (nonatomic, strong) UITableView *historyTableView;
@property (nonatomic, strong) UITableView *nearbyTableView; //附近的地址
//@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) NSUserDefaults *userdefaults;
@property (nonatomic, strong) NSString *selectCity;//用来记录手动选择的城市
@property (nonatomic, strong) NSMutableArray *searchMuArr;//请求到的位置信息
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSMutableArray *plistMuArr;//记录plist文件数据
@property (nonatomic, strong) UIView *nothingsView;
@property (nonatomic, strong) NSMutableArray *arrMuArr;
@property (nonatomic, strong) UIButton *searchBtn; //搜索按钮

@property (nonatomic, strong) UIView *headView; //定位地址的头部view
@property (nonatomic, strong) NSArray *myArray;//搜索记录的数组
@property (nonatomic, strong) NSString *cityStr;
@property (nonatomic, strong) NSMutableArray *addArr;//接口返回的收获地址
@property (nonatomic, strong) NSMutableArray *nearaddArr;



@end

@implementation TCLocationViewController

#pragma mark - 懒加载一些内容
-(NSMutableArray *)allCityArray
{
    if (!_allCityArray) {
        _allCityArray = [NSMutableArray array];
    }
    return _allCityArray;
}
- (NSMutableArray *)searchList
{
    if (!_searchList) {
        _searchList = [NSMutableArray array];
    }
    return _searchList;
}


- (void)viewWillAppear:(BOOL)animated
{
    self.addArr = [NSMutableArray array];
    self.nearaddArr = [NSMutableArray array];
    _userdefaults = [NSUserDefaults standardUserDefaults];
    [self readNSUserDefaults];
    [self request];
}

-(void)request{
    
    [ProgressHUD showHUDToView:self.view];
    //请求接口
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"sign":signStr};
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102006"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        for (NSDictionary *infoDic in jsonDic[@"data"]) {
            TCAddInfo *model = [TCAddInfo orderInfoWithDictionary:infoDic];
            [self.addArr addObject:model];
        }
        [self.tableview reloadData];
        [ProgressHUD hiddenHUD:self.view];
    } failure:^(NSError *error) {
        nil;
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData]; //城市选择
    
    self.title = @"选择收货地址";
    self.view.backgroundColor = TCUIColorFromRGB(0xF5F5F5);
    
    //新增地址
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addButton.frame = CGRectMake(WIDTH - 12 - 65, StatusBarHeight + 11, 65, 22);
    addButton.titleLabel.textAlignment = NSTextAlignmentRight;
    addButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    [addButton setTitleColor:TCUIColorFromRGB(0x4C4C4C) forState:(UIControlStateNormal)];
    [addButton setTitle:@"新增地址" forState:normal];
    [addButton addTarget:self action:@selector(releaseInfo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
    
    _searchMuArr = [NSMutableArray array];
    
    
    //建表历史搜索
    _plistMuArr = [NSMutableArray array];
    
    self.path = [TCCreatePlist createPlistFile:@"SearchHistory"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:self.path];
    [self.plistMuArr addObjectsFromArray: arr];
    
    //创建头部搜索框
    [self headerSearchView];
    
    //    //创建View
    //    [self createUI];
    
    //创建tableView
    [self createtableView];
    
    // Do any additional setup after loading the view.
}

-(void)loadData
{
    _dataArray=[NSMutableArray array];
    //定位城市
    _locationCity=[NSMutableArray arrayWithObject:@"北京市"];
    [_dataArray addObject:_locationCity];
    
    //索引城市
    NSString *path=[[NSBundle mainBundle] pathForResource:@"citydict" ofType:@"plist"];
    _allCitysDictionary=[NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    //将所有城市放到一个数组里
    for (NSArray *array in _allCitysDictionary.allValues) {
        for (NSString *citys in array) {
            [self.allCityArray addObject:citys];
        }
    }
    _keys=[NSMutableArray array];
    [_keys addObjectsFromArray:[[_allCitysDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    [_keys insertObject:@"#" atIndex:0];
    [_allCitysDictionary setObject:_locationCity forKey:@"#"];
}

// 创建SearchView
//头部搜索框
- (void)headerSearchView{
    seachView = [[UIView alloc]init];
    seachView.frame = CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, 48);
    seachView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:seachView];
    
    locatBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    locatBtn.frame = CGRectMake(0, 12, WIDTH - 267 - 12 - 12, 21);
    locatBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [locatBtn setTitleColor:TCUIColorFromRGB(0x4C4C4C) forState:(UIControlStateNormal)];
    [locatBtn setImage:[UIImage imageNamed:@"下拉三角（灰）"] forState:(UIControlStateNormal)];
    [locatBtn setImage:[UIImage imageNamed:@"上拉三角（灰）"] forState:(UIControlStateSelected)];
    locatBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    if ([_userdefaults valueForKey:@"currentCity"]) {
        [locatBtn setTitle:[_userdefaults valueForKey:@"currentCity"] forState:(UIControlStateNormal)];
    }else{
        [locatBtn setTitle:@"北京市" forState:(UIControlStateNormal)];
    }
    /******* 以下方法是让图片靠右，文字靠左 *******/
    CGFloat imageWidth = locatBtn.imageView.bounds.size.width;
    CGFloat labelWidth = locatBtn.titleLabel.bounds.size.width;
    locatBtn.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth - 10);
    locatBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
    [locatBtn addTarget:self action:@selector(choosecity:) forControlEvents:UIControlEventTouchUpInside];
    [seachView addSubview:locatBtn];
    
    //添加搜索框
    searchView = [[UIView alloc] init];
    searchView.frame = CGRectMake(CGRectGetMaxX(locatBtn.frame) + 12, 8, 267, 32);
    searchView.backgroundColor = TCUIColorFromRGB(0xEDEDED);
    [seachView addSubview:searchView];
    
    //icon
    UIImageView *searchImage = [[UIImageView alloc] init];
    searchImage.image = [UIImage imageNamed:@"首页搜索icon"];
    searchImage.frame = CGRectMake(12, 8, 16, 15.5);
    [searchView addSubview:searchImage];
    
    //textfield
    searchField = [[UITextField alloc] init];
    searchField.frame = CGRectMake(CGRectGetMaxX(searchImage.frame) + 8,6,267 - 54 - 30, 21);
    searchField.clearButtonMode = UITextFieldViewModeAlways;
    searchField.placeholder = @"请输入地址";
    [searchField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    searchField.returnKeyType = UIReturnKeySearch;
    searchField.textColor = TCUIColorFromRGB(0x333333);
    searchField.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    searchField.textAlignment = NSTextAlignmentLeft;
    [searchField setValue:TCUIColorFromRGB(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    [searchField setValue:[UIFont fontWithName:@"PingFangSC-Regular" size:15] forKeyPath:@"_placeholderLabel.font"];
    searchField.delegate = self;
    [searchView addSubview:searchField];
    
    //搜索的按钮
    seacrhBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    seacrhBtn.frame = CGRectMake(WIDTH - 15 - 30, 8, 30, 32);
    [seacrhBtn setTitle:@"取消" forState:UIControlStateNormal];
    [seacrhBtn setTitleColor:TCUIColorFromRGB(0xF99E20) forState:(UIControlStateNormal)];
    seacrhBtn.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    seacrhBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    seacrhBtn.hidden = YES;
    [seacrhBtn addTarget:self action:@selector(seacrch) forControlEvents:(UIControlEventTouchUpInside)];
    [seachView addSubview:seacrhBtn];
}

//创建tableView
- (void)createtableView
{
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, seachView.frame.origin.y + seachView.frame.size.height, WIDTH, HEIGHT - seachView.frame.origin.y  - seachView.frame.size.height) style:UITableViewStyleGrouped];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = TCBgColor;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview: _tableview];
    
    _cityTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, seachView.frame.origin.y + seachView.frame.size.height, WIDTH, HEIGHT - seachView.frame.origin.y  - seachView.frame.size.height) style:UITableViewStylePlain];
    _cityTableView.delegate = self;
    _cityTableView.dataSource = self;
    _cityTableView.hidden = YES;
    _cityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _cityTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _cityTableView.sectionIndexColor = TCUIColorFromRGB(0x999999);
    [self.view addSubview: _cityTableView];
    
    
    //附近的tableView
    self.nearbyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, seachView.frame.origin.y + seachView.frame.size.height, WIDTH, HEIGHT - seachView.frame.origin.y  - seachView.frame.size.height - TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
    self.nearbyTableView.delegate = self;
    self.nearbyTableView.dataSource = self;
    self.nearbyTableView.hidden = YES;
    self.nearbyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.nearbyTableView.backgroundColor = TCBgColor;
    [self.view addSubview: self.nearbyTableView];
    
    //创建历史记录的tableView
    self.historyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, seachView.frame.origin.y + seachView.frame.size.height, WIDTH, HEIGHT - seachView.frame.origin.y  - seachView.frame.size.height - TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
    self.historyTableView.delegate = self;
    self.historyTableView.dataSource = self;
    self.historyTableView.hidden = YES;
    self.historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.historyTableView.backgroundColor = TCBgColor;
    [self.view addSubview: self.historyTableView];
    
    
    //解决ios11的导航栏布局的问
    AdjustsScrollViewInsetNever (self,_tableview);
    AdjustsScrollViewInsetNever (self,_cityTableView);
    AdjustsScrollViewInsetNever (self,_historyTableView);
    AdjustsScrollViewInsetNever (self,self.nearbyTableView);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _tableview) {
        return 2;
    }else if(tableView == _cityTableView){
        return _keys.count;
    }else{
        return 1; //历史记录和附近商家都为1
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableview) {
        if (section == 0) {
            return 1;
        }else{
            return self.addArr.count;
        }
    }else if(tableView == _cityTableView){
        if (section<1) {
            return 1;
        }else{
            
            NSArray *array=[_allCitysDictionary objectForKey:[_keys objectAtIndex:section]];
            
            return array.count;
        }
        
        return 0;
        
    } else if (tableView == self.nearbyTableView){
        return self.nearaddArr.count;
    }else if (tableView == self.historyTableView){
        return _myArray.count;
    }else{
        return 10;
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _tableview) {
        if (section == 0) {
            UIView *viewHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 24 + 18)];
            UILabel *currentLabel = [UILabel publicLab:@"当前位置" textColor:TCUIColorFromRGB(0x999999) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
            
            currentLabel.frame = CGRectMake(12, 0, WIDTH - 12, 24 + 18);
            [viewHead addSubview:currentLabel];
            
            return viewHead;
        } else {
            UIView *viewHead_two = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 24 + 18)];
            UILabel *currentLabel_two = [UILabel publicLab:@"收货地址" textColor:TCUIColorFromRGB(0x999999) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
            currentLabel_two.frame = CGRectMake(12, 0, WIDTH - 12, 24 + 18);
            [viewHead_two addSubview:currentLabel_two];
            if (self.addArr.count == 0) {
                currentLabel_two.hidden = YES;
            }else{
                currentLabel_two.hidden = NO;
            }
            
            return viewHead_two;
        }
    } else if (tableView == self.nearbyTableView){
        UIView *viewnearby = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 12)];
        viewnearby.backgroundColor = TCBgColor;
        return viewnearby;
        
    } else if (tableView == _historyTableView){
        UIView *viewhistory = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 24 + 18)];
        UILabel *historyLabel = [UILabel publicLab:@"历史记录" textColor:TCUIColorFromRGB(0x999999) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
        historyLabel.frame = CGRectMake(12, 0, WIDTH - 12, 24 + 18);
        [viewhistory addSubview:historyLabel];
        
        //删除按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(KScreenWidth - 12 - 20, 13, 28, 16);
        [btn setImage:[UIImage imageNamed:@"删除图标"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clearnSearchHistory:) forControlEvents:UIControlEventTouchUpInside];
        [viewhistory addSubview:btn];
        return viewhistory;
    } else if (tableView == _cityTableView){
        _CellHeadView=[[HeadView alloc]init];
        _CellHeadView.TitleLable.textColor = TCUIColorFromRGB(0x999999);
        _CellHeadView.TitleLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        
        if (section==0) {
            
            _CellHeadView.TitleLable.text=@"当前定位城市";
            
        }else{
            
            _CellHeadView.TitleLable.text=_keys[section];
        }
        
        return _CellHeadView;
    }
    else{
        return nil;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.qh_width, 0)];
    footerView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _tableview) {
        return 24 + 18;
    } else if(tableView == _cityTableView){
        return 42;
    } else if (tableView == self.nearbyTableView){
        return 12;
    } else if (tableView == self.historyTableView){
        return 42;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableview) { //定位收货地址
        if (indexPath.section == 0){
            TCDTopTableViewCell *cell = [[TCDTopTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.loctionLabel.hidden = NO;
            cell.loctionLabel.text = self.locaStr;
            cell.tag = 1005;
            return cell;
        } else {
            TCMyAddTableViewCell *addcell = [[TCMyAddTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addcell"];
            if (self.addArr.count != 0) {
                addcell.model = self.addArr[indexPath.row];
                
            }
            [addcell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return addcell;
        }
    } else if (tableView == _cityTableView) { //城市选择
        if (indexPath.section == 0){
            TCDTopTableViewCell *cell = [[TCDTopTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            return cell;
        } else {
            static NSString *identfire=@"cellID";
            UITableViewCell *cellcity=[tableView dequeueReusableCellWithIdentifier:identfire];
            if (!cellcity) {
                cellcity=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfire];
            }
            cellcity.selectionStyle=UITableViewCellSelectionStyleNone;
            NSArray *array=[_allCitysDictionary objectForKey:[_keys objectAtIndex:indexPath.section]];
            cellcity.textLabel.text=array[indexPath.row];
            return cellcity;
        }
    } else if (tableView == self.nearbyTableView) { //附近的地址
        TCNearbyTableViewCell *nearcell = [[TCNearbyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nearcell"];
        nearcell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.nearaddArr.count != 0) {
            TCNearAddInfo *model = self.nearaddArr[indexPath.row];
            nearcell.model = model;
        }
           return nearcell;
        
    } else if (tableView == _historyTableView){ //历史记录
        TCHisTableViewCell *Hiscell = [[TCHisTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Hiscell"];
        NSArray* reversedArray = [[_myArray reverseObjectEnumerator] allObjects];
        Hiscell.titleLabel.text = reversedArray[indexPath.row];
        return Hiscell;
    }
     return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableview) {
        if (indexPath.section == 0) {
            return 48;
        }else{
            if (self.addArr.count != 0) {
                TCAddInfo *model = self.addArr[indexPath.row];
                return model.cellhight;
            }
            return 48;
        }
    }else if(tableView == _cityTableView){
        if (indexPath.section<1) {
            
            return 48;
        }else{
            return 52;
        }
    } else if (tableView == self.nearbyTableView){
        if (self.nearaddArr.count != 0) {
            TCNearAddInfo *model = self.nearaddArr[indexPath.row];
            return model.cellHeight;
        }else{
            return 74 ;
        }
       
    } else if (tableView == self.historyTableView) {
        return 52;
    }else{
        return 50;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //历史记录
    if (tableView == self.historyTableView){
        NSArray *arr;
        arr = [[_myArray reverseObjectEnumerator] allObjects];
        searchField.text = arr[indexPath.row];
        [self creatQuest:searchField.text];
        self.historyTableView.hidden = YES;
        self.nearbyTableView.hidden = NO;
        [self.plistMuArr removeAllObjects];
        searchView.frame = CGRectMake(CGRectGetMaxX(locatBtn.frame) + 12, 8, 267 - 15 - 30, 32);
        seacrhBtn.hidden = NO;
        [HggManager SearchText:_myArray[indexPath.row]];//缓存搜索记录
        [self readNSUserDefaults];
    }else if (tableView == self.cityTableView){
        NSArray *arr = [_allCitysDictionary objectForKey:[_keys objectAtIndex:indexPath.section]];
        self.cityStr = arr[indexPath.row];
        [locatBtn setTitle:[NSString stringWithFormat:@"%@",self.cityStr] forState:(UIControlStateNormal)];
        self.cityTableView.hidden = YES;
        self.tableview.hidden = NO;
    }else if (tableView == self.tableview){
        if (indexPath.section == 0) {
            NSLog(@"1");
            //开启定位
            TCLocation *lo = [[TCLocation alloc]init];
            [lo getadds:^(NSString *address) {
                //先请求轮播图 之后再加载主页数据
                NSLog(@"%@",address);
                TCDTopTableViewCell *cell = (TCDTopTableViewCell *)[self.view viewWithTag:1005];
                cell.loctionLabel.text = address;
              NSString *latitude =  [self.userdefaults valueForKey:@"latitude"];
              NSString * longitude= [self.userdefaults valueForKey:@"longitude"];
                self.chooseBlock(address, longitude, latitude,self.typeStr);
                [self.navigationController popViewControllerAnimated:YES];
//                self.locaBlock(address);
                lo.ishomePage = NO;
            } andMayBeError:^{
                
            }];

        }else{
            NSLog(@"%ld",(long)indexPath.row);
            if (self.addArr.count != 0) {
                TCAddInfo *model = self.addArr[indexPath.row];
                self.chooseBlock(model.locaddress, model.longtitude, model.latitude,self.typeStr);
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
    }else if (tableView == self.nearbyTableView){
        NSLog(@"%ld",(long)indexPath.row);
        TCNearAddInfo *model = self.nearaddArr[indexPath.row];
        self.chooseBlock(model.name, model.longitude, model.latitude,self.typeStr);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//- (void)getadds:(addBlock)blocks{
//    _addblock = blocks;
//}

#pragma mark -- 新增地址
- (void)releaseInfo:(UIButton *)sender
{
    NSLog(@"新增地址");
    TCAddressViewController *addressVC = [[TCAddressViewController alloc] init];
    addressVC.enterStr = @"0";
    addressVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addressVC animated:YES];
}

#pragma mark -- 选择城市
//选择城市
- (void)choosecity:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        _tableview.hidden = YES;
        _cityTableView.hidden = NO;
        _searchTableView.hidden = YES;
        _historyTableView.hidden = YES;
        [_cityTableView reloadData];
    }else{
        _tableview.hidden = NO;
        _cityTableView.hidden = YES;
        _searchTableView.hidden = YES;
        _historyTableView.hidden = YES;
    }
}

//监听文本框刚开始的变化
-(void)valueChanged:(UITextField *)textField{
    
    if (textField.text.length != 0) {
        searchView.frame = CGRectMake(CGRectGetMaxX(locatBtn.frame) + 12, 8, 267 - 15 - 30, 32);
        seacrhBtn.hidden = NO;
        //        self.nearbyTableView.hidden = NO;
        
    } else {
        if (_myArray.count == 0){
            NSLog(@"kong");
            self.historyTableView.hidden = YES;
        } else {
            _historyTableView.hidden = NO;
            [_historyTableView reloadData];
        }
        
        searchView.frame = CGRectMake(CGRectGetMaxX(locatBtn.frame) + 12, 8, 267, 32);
        seacrhBtn.hidden = YES;
        self.nearbyTableView.hidden = YES;
        _cityTableView.hidden = YES;
        _tableview.hidden = YES;
    }
}

#pragma mark -- 取消的点击事件
- (void)seacrch
{
    searchField.text = nil;
    self.nearbyTableView.hidden = YES;
    self.searchBtn.userInteractionEnabled = YES;
    _historyTableView.hidden = YES;
    [searchField resignFirstResponder];
//    if (searchField.text.length != 0) {
        _nothingsView.hidden = YES;
        _cityTableView.hidden = YES;
        _historyTableView.hidden = YES;
        _tableview.hidden = NO;
        _searchTableView.hidden = YES;
        //        [TCAnimateLoadView  loads];
        [_searchMuArr removeAllObjects];
        if ([_selectCity isEqualToString:@"未知"]) {
            _selectCity = @"";
        }else{
            _selectCity = locatBtn.titleLabel.text;//获取当前手动选择的城市
        }
        self.searchBtn.userInteractionEnabled = YES;
//        [HggManager SearchText:searchField.text];//缓存搜索记录
//        [self readNSUserDefaults];
//    }
}

//即将消失
-(void)viewWillDisappear:(BOOL)animated{
    [searchField resignFirstResponder];
    [self.historyTableView reloadData];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [searchField resignFirstResponder];
}

#pragma mark -- 去掉历史记录
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
        [HggManager removeAllArray];
        _myArray = nil;
        self.historyTableView.hidden = YES;
        [self.historyTableView reloadData];
    }
    
    //index为-1则是取消，
}

- (void)dismisss{
    //    [TCAnimateLoadView miss];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [searchField resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击搜索键盘的事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.nearbyTableView.hidden = NO;
    self.searchBtn.userInteractionEnabled = NO;
    _historyTableView.hidden = NO;
    [searchField resignFirstResponder];
    if (searchField.text.length != 0) {
        _nothingsView.hidden = YES;
        _cityTableView.hidden = YES;
        _historyTableView.hidden = YES;
        _tableview.hidden = YES;
        _searchTableView.hidden = NO;
        //        [TCAnimateLoadView  loads];
        [_searchMuArr removeAllObjects];
        if ([_selectCity isEqualToString:@"未知"]) {
            _selectCity = @"";
        }else{
            _selectCity = locatBtn.titleLabel.text;//获取当前手动选择的城市
        }
        self.searchBtn.userInteractionEnabled = YES;
        
        [self creatQuest:textField.text];
        
        [HggManager SearchText:textField.text];//缓存搜索记录
        [self readNSUserDefaults];
    }

    return YES;
}

-(void)creatQuest:(NSString *)text{
    [self.nearaddArr removeAllObjects];
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString*location =  [self.userdefaults valueForKey:@"latitude"];
    NSString *reg = locatBtn.titleLabel.text;
    NSDictionary *dic = @{@"location":location,@"key":text,@"reg":reg,@"timestamp":timeStr};
    NSString *signStr = [TCServerSecret signStr:dic];
    NSDictionary * paramters = @{@"timestamp":timeStr,@"sign":signStr,@"location":location,@"key":text,@"reg":reg};
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"103005"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        for (NSDictionary *infoDic in jsonDic[@"data"]) {
            TCNearAddInfo *model = [TCNearAddInfo orderInfoWithDictionary:infoDic];
            [self.nearaddArr addObject:model];
        }
        [self.nearbyTableView reloadData];
    } failure:^(NSError *error) {
        nil;
    }];
}


-(void)readNSUserDefaults{//取出缓存的数据
   
    //读取数组NSArray类型的数据
    NSArray * myArray = [self.userdefaults arrayForKey:@"myArray"];
    self.myArray = myArray;
    [self.historyTableView reloadData];
    NSLog(@"myArray======%@",myArray);
}

-(void)SelectCityNameInCollectionBy:(NSString *)cityName
{
    [self popRootViewControllerWithName:cityName];
}

-(void)returnText:(ReturnCityName)block
{
    self.returnBlock=block;
}

//右边的索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView == _cityTableView) {
        return _keys;
    }else{
        return nil;
    }
}

- (void)popRootViewControllerWithName:(NSString *)cityName
{
    self.returnBlock(cityName);
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
