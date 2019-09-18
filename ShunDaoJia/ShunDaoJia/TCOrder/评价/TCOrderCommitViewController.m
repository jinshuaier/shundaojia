//
//  TCOrderCommitViewController.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/13.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCOrderCommitViewController.h"
#import "XHStarRateView.h"
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

@interface TCOrderCommitViewController ()<XHStarRateViewDelegate,UITextViewDelegate,TZImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate>
{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
    CGFloat score1;
    CGFloat score2;
    CGFloat score3;
    UITextView *inputView;
}
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) LxGridViewFlowLayout *layout;
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) UILabel *stringLabel;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSArray *titleS;
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *isAnonymityStr;

@end

@implementation TCOrderCommitViewController


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
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
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    //删除通知中心监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价";
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    rightBtn.frame = CGRectMake(12, 12, 30, 20);
    [rightBtn addTarget:self action:@selector(clickLeftBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [rightBtn setTitleColor:TCUIColorFromRGB(0x666666) forState:(UIControlStateNormal)];
    rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.leftBarButtonItem = rightBtnItem;
    
    self.view.backgroundColor = TCBgColor;
    [self creatUI];
    // Do any additional setup after loading the view.
}

-(void)creatUI{
    _titleS = @[@"商品评价",@"服务评价",@"物流评价"];
    self.isAnonymityStr = @"0";
    UIView *bgView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 1 + StatusBarAndNavigationBarHeight, WIDTH, 64)];
    bgView1.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:bgView1];
    
    UIImageView *shopPic = [[UIImageView alloc]initWithFrame:CGRectMake(12, 8, 48, 48)];
    [shopPic sd_setImageWithURL:[NSURL URLWithString:self.shopImageStr] placeholderImage:[UIImage imageNamed:@"商品详情页占位"]];
    [bgView1 addSubview:shopPic];
    
    UILabel *shopName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(shopPic.frame) + 12, 21, WIDTH - 36 - 48 , 22)];
    shopName.textAlignment = NSTextAlignmentLeft;
    shopName.text = self.shopNameStr;
    shopName.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    shopName.textColor = TCUIColorFromRGB(0x1D1D1D);
    [bgView1 addSubview:shopName];
    
    UIView *bgView2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView1.frame) + 8, WIDTH, 144)];
    bgView2.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:bgView2];
    
    for (int i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(12,i*40 + 24, 64, 16);
        label.text = _titleS[i];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        [bgView2 addSubview:label];
    
        XHStarRateView *starContro = [[XHStarRateView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + 16, i*40 + 24, 144, 16) numberOfStars:5 rateStyle:(WholeStar) isAnination:YES finish:^(CGFloat currentScore) {
            NSLog(@"商品 %.1f",currentScore);
            if (i == 0) {
                score1 = currentScore;
            }else if (i == 1){
                score2 = currentScore;
            }else{
                score3 = currentScore;
            }
        }];
        [bgView2 addSubview:starContro];
        
        UIView *textBGView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView2.frame) + 8, WIDTH, 164)];
        textBGView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
       
        inputView = [[UITextView alloc] initWithFrame:CGRectMake(12, 12, WIDTH - 24, 140)];
        inputView.tag = 201;
        inputView.delegate = self;
        inputView.returnKeyType = UIReturnKeyGo;
        [inputView setBackgroundColor:TCUIColorFromRGB(0xFFFFFF)];
        //_placeholderLabel
        UILabel *placeHolderLabel = [[UILabel alloc]init];
        placeHolderLabel.text = @"分享你的购买心得";
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.textColor = TCUIColorFromRGB(0x999999);
        
        [placeHolderLabel sizeToFit];
        [inputView addSubview:placeHolderLabel];
        
        //same font
        placeHolderLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        inputView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        inputView.textColor = TCUIColorFromRGB(0x000000);
        
        [inputView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
        _stringLabel = [[UILabel alloc]initWithFrame:CGRectMake(inputView.frame.size.width - 50, inputView.frame.size.height - 14, 50, 14)];
        _stringLabel.textColor = TCUIColorFromRGB(0x999999);
        _stringLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _stringLabel.textAlignment = NSTextAlignmentLeft;
        _stringLabel.text = @"0/150";
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, 163, WIDTH - 24, 1)];
        line.backgroundColor = TCBgColor;
        [textBGView addSubview:line];
        
        [inputView addSubview:_stringLabel];
        
        [textBGView addSubview:inputView];
        
        [self.view addSubview:textBGView];
        
        UIView *bgView3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(textBGView.frame), WIDTH, 88)];
        bgView3.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
        bgView3.hidden = YES;
        [self.view addSubview:bgView3];
        
        
        //创建图片选择器
        _layout = [[LxGridViewFlowLayout alloc]init];
        _margin = 24;
        
        _itemWH = 56;
        
        _layout.itemSize = CGSizeMake(56, 56);
        _layout.minimumInteritemSpacing = _margin;
        _layout.minimumLineSpacing = _margin;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(12, 16, 56, 56) collectionViewLayout:_layout];
        _layout.panGestureRecognizerEnable = NO;
        _collectionView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0) ;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [bgView3 addSubview:_collectionView];
        
        [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
        
        UIView *bomView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - 48, WIDTH, 48)];
        bomView.backgroundColor = TCUIColorFromRGB(0xFFFFFFF);
        [self.view addSubview:bomView];
        
        _checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, 14, 20, 20)];
        [_checkBtn setBackgroundImage:[UIImage imageNamed:@"商品选中框"] forState:(UIControlStateNormal)];
        [_checkBtn setBackgroundImage:[UIImage imageNamed:@"商品选中框（黄）"] forState:(UIControlStateSelected)];
        [_checkBtn addTarget:self action:@selector(clickcheck:) forControlEvents:(UIControlEventTouchUpInside)];
        [bomView addSubview:_checkBtn];
        
        UILabel *anonymous = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_checkBtn.frame) + 8, 17, 56, 14)];
        anonymous.text = @"匿名评价";
        anonymous.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        anonymous.textColor = TCUIColorFromRGB(0x666666);
        anonymous.textAlignment = NSTextAlignmentLeft;
        [bomView addSubview:anonymous];
        
        _commitBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 120, 0, 120, 48)];
        [_commitBtn setTitle:@"提交评价" forState:(UIControlStateNormal)];
        [_commitBtn setBackgroundColor:TCUIColorFromRGB(0xF99E20)];
        [_commitBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
        _commitBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _commitBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_commitBtn addTarget:self action:@selector(clickCommit:) forControlEvents:(UIControlEventTouchUpInside)];
        [bomView addSubview:_commitBtn];
    }
}

-(void)clickLeftBtn:(UIButton *)sender{
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"放弃评价？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //返回到上一层
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"点错了" style:UIAlertActionStyleCancel handler:nil]];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

#pragma mark -- 点击勾选框
-(void)clickcheck:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected){
        self.isAnonymityStr = @"0";
    } else {
        self.isAnonymityStr = @"1";
    }
}

-(void)clickCommit:(UIButton *)sender{
    NSLog(@"提交");
    NSLog(@"%.f,%.f,%.f",score1,score2,score3);
    if (score3 != 0 && score2 != 0 && score1 != 0) {
        NSLog(@"提交");
        NSString *timeStr = [TCGetTime getCurrentTime];
        NSString *midStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userID"]];
        NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userToken"]];
        //评分
        NSString *str1 = [NSString stringWithFormat:@"%.f",score1];
        NSString *str2 = [NSString stringWithFormat:@"%.f",score2];
        NSString *str3 = [NSString stringWithFormat:@"%.f",score3];
        //    NSString *pageStr = [NSString stringWithFormat:@"%d",page];
        NSDictionary *dic;
        NSDictionary *paramters;
        //没有评价文字
        if (inputView.text.length == 0){
            dic = @{@"mid":midStr,@"token":tokenStr,@"orderid":self.orderid,@"timestamp":timeStr,@"goodsScore":str1,@"serviceScore":str2,@"deliverScore":str3,@"type":self.isAnonymityStr};
            NSString *signStr = [TCServerSecret signStr:dic];
            paramters = @{@"mid":midStr,@"token":tokenStr,@"orderid":self.orderid,@"timestamp":timeStr,@"goodsScore":str1,@"serviceScore":str2,@"deliverScore":str3,@"type":self.isAnonymityStr,@"sign":signStr};
        } else {
            dic = @{@"mid":midStr,@"token":tokenStr,@"orderid":self.orderid,@"timestamp":timeStr,@"goodsScore":str1,@"serviceScore":str2,@"deliverScore":str3,@"type":self.isAnonymityStr,@"comment":inputView.text};
            NSString *signStr1 = [TCServerSecret signStr:dic];
            paramters = @{@"mid":midStr,@"token":tokenStr,@"orderid":self.orderid,@"timestamp":timeStr,@"goodsScore":str1,@"serviceScore":str2,@"deliverScore":str3,@"type":self.isAnonymityStr,@"sign":signStr1,@"comment":inputView.text};
        }
        
        [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102019"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
            NSLog(@"%@--%@",jsonDic,jsonStr);
            NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
            if ([codeStr isEqualToString:@"1"]){
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"orderShuaxincomm" object:nil];
            }
            [TCProgressHUD showMessage:jsonDic[@"msg"]];
        } failure:^(NSError *error) {
            nil;
        }];
    }else{
        [TCProgressHUD showMessage:@"您还未进行星级评价"];
    }
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_selectedPhotos.count >= 1) {
        return _selectedPhotos.count + 1;
    }else{
        return _selectedPhotos.count + 1;
    }
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


-(void)pickPhotoButtonClick:(UIButton *)sender{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
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
                // BOOL allowCrop = YES;
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                        //                        }
                    }];
                }];
            }
        }];
    }
}
- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    [_selectedAssets addObject:asset];
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

#pragma mark Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    _layout.itemCount = _selectedPhotos.count;
    
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}

#pragma mark -- UITextViewDelegate
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
#pragma mark -- UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{

    self.stringLabel.text = [NSString stringWithFormat:@"%lu/%@",(unsigned long)textView.text.length,@"150"];
    if(textView.text.length >= 150){
        //截取字符串
        textView.text = [textView.text substringToIndex:150];
        self.stringLabel.text = @"150/150";
    }else{

    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@ "ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        //恢复屏幕
        self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        [self.view endEditing:YES];
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
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
