//
//  TCReportBussViewController.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/7.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCReportBussViewController.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TCTextView.h"
#import <objc/runtime.h>
#import <objc/message.h>


#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"

#import "TCStyleViewController.h"//举报类型
#import "TCCommitOKViewController.h"//提交后
#import "AFNetworking.h"

@interface TCReportBussViewController ()<UITextFieldDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,TZImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
    UILabel *nameLab;
    UITextView *inputView;
}
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) LxGridViewFlowLayout *layout;
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) UILabel *stringLabel;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSMutableArray *mesArr;
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic,strong) NSString *path;


@end

@implementation TCReportBussViewController

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = NO;
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    //删除通知中心监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"举报商家";
    self.view.backgroundColor = TCBgColor;
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.mesArr = [NSMutableArray array];
    // Do any additional setup after loading the view.
    //初始化数组
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    
    // 通过运行时，发现UITextView有一个叫做“_placeHolderLabel”的私有变量
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([UITextView class], &count);
    
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSString *objcName = [NSString stringWithUTF8String:name];
        NSLog(@"%d : %@",i,objcName);
    }
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, 64)];
    topView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:topView];
    
    UIImageView *shopImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 8, 48, 48)];
    [shopImage sd_setImageWithURL:[NSURL URLWithString:self.imageStr] placeholderImage:[UIImage imageNamed:@"商品详情页占位"]];
    [topView addSubview:shopImage];
    
    UILabel *shopName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(shopImage.frame) + 12, 21, WIDTH - 36 - 48, 22)];
    nameLab = shopName;
    shopName.textColor = TCUIColorFromRGB(0x1D1D1D);
    shopName.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    shopName.text = self.nameStr;
    
    [topView addSubview:shopName];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame) + 8, WIDTH, 192)];
    bgView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:bgView];
    
    self.dataArr = @[@"举报类型",@"联系电话",@"相关照片"];
    self.images = [[NSMutableArray alloc]initWithObjects: nil];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 52)];
    view1.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    //为View1添加点击事件
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseStyle:)];
    
    [view1 addGestureRecognizer:singleRecognizer];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(12, 16, 60, 20)];
    label1.text = @"举报类型";
    label1.textColor = TCUIColorFromRGB(0x666666);
    label1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    label1.textAlignment = NSTextAlignmentLeft;
    
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame) + 12, 16, WIDTH - 48 - 60 - 5, 20)];
    textField.tag = 200;
    textField.delegate = self;
    textField.placeholder = @"选择举报的类型";
    textField.textAlignment = NSTextAlignmentLeft;
    textField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    textField.textColor = TCUIColorFromRGB(0x333333);
    textField.userInteractionEnabled = NO;
    [textField addTarget:self  action:@selector(alueChange:)  forControlEvents:UIControlEventAllEditingEvents];
    
    UIImageView *sanImage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 12 - 5, 22, 5, 8)];
    sanImage.image = [UIImage imageNamed:@"进入小三角（灰）"];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(12, 51, WIDTH - 24, 1)];
    line1.backgroundColor = TCUIColorFromRGB(0xEDEDED);
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view1.frame), WIDTH,52)];
    view2.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(12, 16, 60, 20)];
    label2.text = @"联系电话";
    label2.textColor = TCUIColorFromRGB(0x666666);
    label2.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    label2.textAlignment = NSTextAlignmentLeft;
    
    UITextField *phoneField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label2.frame) + 12, 16, WIDTH - 36 - 60, 20)];
    phoneField.delegate = self;
    phoneField.tag = 101;
    phoneField.borderStyle = UITextBorderStyleNone;
    phoneField.keyboardType = UIKeyboardTypeNumberPad;
    phoneField.placeholder = @"仅工作人员可见";
    phoneField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    phoneField.textColor = TCUIColorFromRGB(0x333333);
    phoneField.textAlignment = NSTextAlignmentLeft;
    [phoneField addTarget:self  action:@selector(alueChange:)  forControlEvents:UIControlEventAllEditingEvents];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(12, 51, WIDTH - 24, 1)];
    line2.backgroundColor = TCUIColorFromRGB(0xEDEDED);
    
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view2.frame), WIDTH, 88)];
    view3.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(12, 34, 60, 20)];
    label3.text = @"相关照片";
    label3.textColor = TCUIColorFromRGB(0x666666);
    label3.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    label3.textAlignment = NSTextAlignmentLeft;
    
    //创建图片选择器
    _layout = [[LxGridViewFlowLayout alloc]init];
    _margin = 24;
    
    _itemWH = 56;
    
    _layout.itemSize = CGSizeMake(56, 56);
    _layout.minimumInteritemSpacing = _margin;
    _layout.minimumLineSpacing = _margin;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label3.frame) + 12, 0, 216, 88) collectionViewLayout:_layout];
    _layout.panGestureRecognizerEnable = NO;
    _collectionView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    _collectionView.contentInset = UIEdgeInsetsMake(16, 0, 16, 0) ;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [view3 addSubview:_collectionView];
    
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    
    [view3 addSubview:label3];
    [bgView addSubview:view3];
    [view2 addSubview:line2];
    [view2 addSubview:phoneField];
    [view2 addSubview:label2];
    [bgView addSubview:view2];
    
    [view1 addSubview:line1];
    [view1 addSubview:label1];
    [view1 addSubview:sanImage];
    [view1 addSubview:textField];
    [bgView addSubview:view1];
    
    
    UIView *textBGView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame) + 8, WIDTH, 164)];
    textBGView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    inputView = [[UITextView alloc] initWithFrame:CGRectMake(12, 12, WIDTH - 24, 140)];
    inputView.tag = 201;
    inputView.delegate = self;
    inputView.returnKeyType = UIReturnKeyDone;
    [inputView setBackgroundColor:TCUIColorFromRGB(0xFFFFFF)];
    //_placeholderLabel
    UILabel *placeHolderLabel = [[UILabel alloc]init];
    placeHolderLabel.text = @"请详细描述举报内容（选填）";
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = TCUIColorFromRGB(0x999999);
    
    [placeHolderLabel sizeToFit];
    [inputView addSubview:placeHolderLabel];
    
    //same font
    placeHolderLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    inputView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    inputView.textColor = TCUIColorFromRGB(0x333333);
    
    [inputView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    _stringLabel = [[UILabel alloc]initWithFrame:CGRectMake(inputView.frame.size.width - 50, inputView.frame.size.height - 14, 50, 14)];
    _stringLabel.textColor = TCUIColorFromRGB(0x999999);
    _stringLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    _stringLabel.textAlignment = NSTextAlignmentLeft;
    _stringLabel.text = @"0/150";
    
    [inputView addSubview:_stringLabel];
    
    [textBGView addSubview:inputView];
    [self.view addSubview:textBGView];
    
    //提交按钮
    _commitBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(textBGView.frame)  + 24, WIDTH - 24, 48)];
    _commitBtn.userInteractionEnabled = NO;
    _commitBtn.layer.masksToBounds = YES;
    _commitBtn.layer.cornerRadius = 4;
    [_commitBtn setBackgroundColor:TCUIColorFromRGB(0xCCCCCC)];
    [_commitBtn setTitle:@"提交" forState:(UIControlStateNormal)];
    [_commitBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    _commitBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    _commitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_commitBtn addTarget:self action:@selector(clickCommit:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:_commitBtn];
    
    UILabel *teLabel = [[UILabel alloc]initWithFrame:CGRectMake((WIDTH - 168)/2, CGRectGetMaxY(_commitBtn.frame) + 4, 168, 17)];
    teLabel.textAlignment = NSTextAlignmentCenter;
    teLabel.text = @"您提交的信息将会得到严格保密";
    teLabel.textColor = TCUIColorFromRGB(0x999999);
    teLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [self.view addSubview:teLabel];
    
    
    //请求接口
    [self createquest];
    
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark -- 请求接口
- (void)createquest
{
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userToken"]];
    
    NSDictionary *dic1 = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"shopid":self.shopID};
        NSString *signStr1 = [TCServerSecret signStr:dic1];
    
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"shopid":self.shopID,@"sign":signStr1};
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102023"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        NSString *nameStr = [NSString stringWithFormat:@"%@",jsonDic[@"data"][@"name"]];
        nameLab.text = nameStr;
        self.mesArr = jsonDic[@"data"][@"complainType"];
        
      
    } failure:^(NSError *error) {
        nil;
    }];
}

#pragma mark -- 通知
- (void)keyboardWillHide:(NSNotification *)notification{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@ "ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    //恢复屏幕
    self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    [self.view endEditing:YES];
}

#pragma mark -- 点击提交
-(void)clickCommit:(UIButton *)sender{
    UITextField *phoneField = (UITextField *)[self.view viewWithTag:101];
    if (phoneField.text.length == 0) {
        [self createCommitQuest:@""];
    }else{
    if (![BSUtils checkTelNumber:phoneField.text]) {
        NSLog(@"请输入正确的手机号");
    }else{
        if (_selectedPhotos.count != 0) {
//           for (int i = 0; i < _selectedPhotos.count; i++) {
                UIImage *image = _selectedPhotos[0];
                //放入全局队列中保存头像
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    //将头像写入沙盒
     NSData* imageData = UIImageJPEGRepresentation(image, 0.5);
     self.path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"newHeade.png"];
    NSLog(@"当前的路径 %@", _path);
    [imageData writeToFile:self.path atomically:NO];
        [self createCommitQuest:imageData];
                                            });
    
//            }
        }else{
            [self createCommitQuest:@""];
        }
    }
    }
}

#pragma mark -- createCommit
- (void)createCommitQuest:(NSData *)imageData
{
    UITextField *phoneField = (UITextField *)[self.view viewWithTag:101];
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userToken"]];
    NSString *type = [NSString stringWithFormat:@"%@",self.idStr];
    NSString *shopid = [NSString stringWithFormat:@"%@",self.shopID];
    if (phoneField.text.length != 0 && inputView.text.length != 0 && _selectedPhotos.count == 0) {
        NSDictionary *dic1 = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"shopid":shopid,@"type":type,@"mobile":phoneField.text,@"content":inputView.text};
        NSString *signStr1 = [TCServerSecret signStr:dic1];
        
        NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"shopid":shopid,@"sign":signStr1,@"type":type,@"mobile":phoneField.text,@"content":inputView.text};
        [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102024"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
            NSLog(@"%@---%@",jsonDic,jsonStr);
            NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
            if ([codeStr isEqualToString:@"1"]) {
                [TCProgressHUD showMessage:jsonDic[@"msg"]];
                TCCommitOKViewController *commitVC = [[TCCommitOKViewController alloc]init];
                [self.navigationController pushViewController:commitVC animated:YES];
            }else{
                [TCProgressHUD showMessage:jsonDic[@"msg"]];
            }
        } failure:^(NSError *error) {
            nil;
        }];

    }else if (phoneField.text.length == 0 && inputView.text.length == 0 && _selectedPhotos.count == 0){
        NSDictionary *dic1 = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"shopid":shopid,@"type":type};
        NSString *signStr1 = [TCServerSecret signStr:dic1];
        
        NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"shopid":shopid,@"sign":signStr1,@"type":type};
        [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102024"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
            NSLog(@"%@---%@",jsonDic,jsonStr);
            NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
            if ([codeStr isEqualToString:@"1"]) {
                [TCProgressHUD showMessage:jsonDic[@"msg"]];
                TCCommitOKViewController *commitVC = [[TCCommitOKViewController alloc]init];
                [self.navigationController pushViewController:commitVC animated:YES];
            }else{
                [TCProgressHUD showMessage:jsonDic[@"msg"]];
            }
        } failure:^(NSError *error) {
            nil;
        }];
        
    }else if (phoneField.text.length != 0 && inputView.text.length == 0 && _selectedPhotos.count == 0){
        NSDictionary *dic1 = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"shopid":shopid,@"type":type,@"mobile":phoneField.text};
        NSString *signStr1 = [TCServerSecret signStr:dic1];
        
        NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"shopid":shopid,@"sign":signStr1,@"type":type,@"mobile":phoneField.text};
        [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102024"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
            NSLog(@"%@---%@",jsonDic,jsonStr);
            NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
            if ([codeStr isEqualToString:@"1"]) {
                [TCProgressHUD showMessage:jsonDic[@"msg"]];
                TCCommitOKViewController *commitVC = [[TCCommitOKViewController alloc]init];
                [self.navigationController pushViewController:commitVC animated:YES];
            }else{
                [TCProgressHUD showMessage:jsonDic[@"msg"]];
            }
        } failure:^(NSError *error) {
            nil;
        }];
        
    }else if (phoneField.text.length == 0 && inputView.text.length != 0 && _selectedPhotos.count == 0){
        NSDictionary *dic1 = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"shopid":shopid,@"type":type,@"content":inputView.text};
        NSString *signStr1 = [TCServerSecret signStr:dic1];
        
        NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"shopid":shopid,@"sign":signStr1,@"type":type,@"content":inputView.text};
        [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102024"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
            NSLog(@"%@---%@",jsonDic,jsonStr);
            NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
            if ([codeStr isEqualToString:@"1"]) {
                [TCProgressHUD showMessage:jsonDic[@"msg"]];
                TCCommitOKViewController *commitVC = [[TCCommitOKViewController alloc]init];
                [self.navigationController pushViewController:commitVC animated:YES];
            }else{
                [TCProgressHUD showMessage:jsonDic[@"msg"]];
            }
        } failure:^(NSError *error) {
            nil;
        }];

    }else if (phoneField.text.length == 0 && inputView.text.length == 0 && _selectedPhotos.count != 0){
        NSDictionary *dic1 = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"shopid":shopid,@"type":type};
        NSString *signStr1 = [TCServerSecret signStr:dic1];
        
        NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"shopid":shopid,@"sign":signStr1,@"type":type};
        //提交修改，上传图片至服务器
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:[TCServerSecret loginAndRegisterSecretOffline:@"102024"] parameters:paramters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            //开始滚动
            if (imageData) {
                [formData appendPartWithFileData:imageData  name:@"image" fileName:@"newHeade.png" mimeType:@"image/png"];
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            [TCProgressHUD showMessage:dic[@"msg"]];
            NSString *codeStr = [NSString stringWithFormat:@"%@",dic[@"code"]];
            if ([codeStr isEqualToString:@"1"]) {
                TCCommitOKViewController *commitVC = [[TCCommitOKViewController alloc]init];
                [self.navigationController pushViewController:commitVC animated:YES];
            }

            NSLog(@"提交图片的返回结果 %@", dic[@"msg"]);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"shuaxinmineview" object:nil];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            nil;
            }];
        
        
    }else if (phoneField.text.length == 0 && inputView.text.length != 0 && _selectedPhotos.count != 0){
        NSDictionary *dic1 = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"shopid":shopid,@"type":type,@"content":inputView.text};
        NSString *signStr1 = [TCServerSecret signStr:dic1];
        
        NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"shopid":shopid,@"sign":signStr1,@"type":type,@"content":inputView.text};
        //提交修改，上传图片至服务器
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:[TCServerSecret loginAndRegisterSecretOffline:@"102024"] parameters:paramters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            //开始滚动
            if (imageData) {
                [formData appendPartWithFileData:imageData  name:@"image" fileName:@"newHeade.png" mimeType:@"image/png"];
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            [TCProgressHUD showMessage:dic[@"msg"]];
            NSString *codeStr = [NSString stringWithFormat:@"%@",dic[@"code"]];
            if ([codeStr isEqualToString:@"1"]) {
                TCCommitOKViewController *commitVC = [[TCCommitOKViewController alloc]init];
                [self.navigationController pushViewController:commitVC animated:YES];
            }

            NSLog(@"提交图片的返回结果 %@", dic[@"msg"]);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"shuaxinmineview" object:nil];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            nil;
        }];
        
    }else if (phoneField.text.length != 0 && inputView.text.length == 0 && _selectedPhotos.count != 0){
        NSDictionary *dic1 = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"shopid":shopid,@"type":type,@"mobile":phoneField.text};
        NSString *signStr1 = [TCServerSecret signStr:dic1];
        
        NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"shopid":shopid,@"sign":signStr1,@"type":type,@"mobile":phoneField.text};
        //提交修改，上传图片至服务器
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:[TCServerSecret loginAndRegisterSecretOffline:@"102024"] parameters:paramters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            //开始滚动
            if (imageData) {
                [formData appendPartWithFileData:imageData  name:@"image" fileName:@"newHeade.png" mimeType:@"image/png"];
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            [TCProgressHUD showMessage:dic[@"msg"]];
            NSString *codeStr = [NSString stringWithFormat:@"%@",dic[@"code"]];
            if ([codeStr isEqualToString:@"1"]) {
                TCCommitOKViewController *commitVC = [[TCCommitOKViewController alloc]init];
                [self.navigationController pushViewController:commitVC animated:YES];
            }
            NSLog(@"提交图片的返回结果 %@", dic[@"msg"]);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"shuaxinmineview" object:nil];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            nil;
        }];
        
    }else if (phoneField.text.length != 0 && inputView.text.length != 0 && _selectedPhotos.count != 0){
        NSDictionary *dic1 = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"shopid":shopid,@"type":type,@"mobile":phoneField.text,@"content":inputView.text};
        NSString *signStr1 = [TCServerSecret signStr:dic1];
        
        NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"shopid":shopid,@"sign":signStr1,@"type":type,@"mobile":phoneField.text,@"content":inputView.text};
        //提交修改，上传图片至服务器
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:[TCServerSecret loginAndRegisterSecretOffline:@"102024"] parameters:paramters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            //开始滚动
            if (imageData) {
                [formData appendPartWithFileData:imageData  name:@"image" fileName:@"newHeade.png" mimeType:@"image/png"];
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            [TCProgressHUD showMessage:dic[@"msg"]];
            NSString *codeStr = [NSString stringWithFormat:@"%@",dic[@"code"]];
            if ([codeStr isEqualToString:@"1"]) {
                TCCommitOKViewController *commitVC = [[TCCommitOKViewController alloc]init];
                [self.navigationController pushViewController:commitVC animated:YES];
            }
            NSLog(@"提交图片的返回结果 %@", dic[@"msg"]);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"shuaxinmineview" object:nil];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            nil;
        }];
    }
    
    
    
  
}


#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"上传图片（举报商家）"];
        cell.deleteBtn.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count) {
        //是否谈出来选择
        BOOL showSheet = YES;
        if (showSheet) {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
            [sheet showInView:self.view];
        } else {
            [self pickPhotoButtonClick:nil];
        }
    } else { // preview photos / 预览照片
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
        imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
        // imagePickerVc.allowPickingOriginalPhoto = NO;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            _selectedPhotos = [NSMutableArray arrayWithArray:photos];
            _selectedAssets = [NSMutableArray arrayWithArray:assets];
            _isSelectOriginalPhoto = isSelectOriginalPhoto;
            _layout.itemCount = _selectedPhotos.count;
            [_collectionView reloadData];
            _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    if (sourceIndexPath.item >= _selectedPhotos.count || destinationIndexPath.item >= _selectedPhotos.count) return;
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    if (image) {
        [_selectedPhotos exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
        [_selectedAssets exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
        [_collectionView reloadData];
    }
}

#pragma mark -- UITextFieldDelegate
- (void)alueChange:(UITextField *)textField{
    UITextField *styleField = (UITextField *)[self.view viewWithTag:200];
    UITextField *phoneField = (UITextField *)[self.view viewWithTag:101];
    if (styleField.text.length != 0) {
        [_commitBtn setBackgroundColor:TCUIColorFromRGB(0xF99E20)];
        _commitBtn.userInteractionEnabled = YES;
    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@ "ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    //恢复屏幕
    self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    [self.view endEditing:YES];
    return YES;
}

#pragma  mark -- UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@ "ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    //将视图的Y坐标向上移动，以使下面腾出地方用于软键盘的显示
    /*屏幕上移的高度，可以自己定*/
    self.view.frame = CGRectMake(0.0f, -100.0f, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    return YES;
}



#pragma mark Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
   // [_selectedAssets removeObjectAtIndex:sender.tag];
    _layout.itemCount = _selectedPhotos.count;
    
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}
-(void)pickPhotoButtonClick:(UIButton *)sender{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 delegate:self];
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    imagePickerVc.selectedAssets = _selectedAssets; // optional, 可选的
    imagePickerVc.allowTakePicture = NO; // 隐藏拍照按钮
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    //     NSLog(@"cancel");
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    
}
/// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    _layout.itemCount = _selectedPhotos.count;
    [_collectionView reloadData];
    _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // take photo / 去拍照
        [self takePhoto];
    } else if (buttonIndex == 1) {
        //选择图片
        [self pickPhotoButtonClick:nil];
    }
}

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self takePhoto];
                    });
                }
            }];
        } else {
            [self takePhoto];
        }
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if ([TZImageManager authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}
// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    //    __weak typeof(self) weakSelf = self;
    //    [[TZLocationManager manager] startLocationWithSuccessBlock:^(CLLocation *location, CLLocation *oldLocation) {
    //        weakSelf.location = location;
    //    } failureBlock:^(NSError *error) {
    //        weakSelf.location = nil;
    //    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [self refreshCollectionViewWithAddedAsset:nil image:image];
                // BOOL allowCrop = YES;
//                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
//                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
//                        [tzImagePickerVc hideProgressHUD];
//                        TZAssetModel *assetModel = [models firstObject];
//                        if (tzImagePickerVc.sortAscendingByModificationDate) {
//                            assetModel = [models lastObject];
//                        }
//                        [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
//                        //                        }
//                    }];
//                }];
            }
        }];
    }
}
- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    //[_selectedAssets addObject:asset];
    [_selectedPhotos addObject:image];
    [_collectionView reloadData];
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        NSLog(@"location:%@",phAsset.location);
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@ "ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    //恢复屏幕
    self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    //    [self.view endEditing:YES];
}

-(void)chooseStyle:(UIGestureRecognizer *)sender{
    NSLog(@"去选择类型");
    
    UITextField *field = (UITextField *)[self.view viewWithTag:200];
    TCStyleViewController *StyleVC = [[TCStyleViewController alloc]init];
    StyleVC.messArr = self.mesArr;
    
    StyleVC.block = ^(NSString *str) {
        field.text = str;
    };
    
    StyleVC.blocks= ^(NSString *idStr){
        self.idStr = idStr;
    };
    
    [self.navigationController pushViewController:StyleVC animated:YES];
}

#pragma mark -- UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    UITextView *texView = (UITextView *)[self.view viewWithTag:201];
    
    
    self.stringLabel.text = [NSString stringWithFormat:@"%lu/150", (unsigned long)texView.text.length];
    //字数限制操作
    if (textView.text.length >= 150) {
        
        textView.text = [textView.text substringToIndex:150];
        self.stringLabel.text = @"150/150";
        
    }
    
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
