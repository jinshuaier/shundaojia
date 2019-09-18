//
//  TCAccountViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/22.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCAccountViewController.h"
#import "TCAccountTableViewCell.h"
#import "TCModifyViewController.h"
#import "TCPaymentViewController.h"
#import "AFNetworking.h"
#import "TCModiViewController.h"
#import "TCTradePhoneViewController.h"
#import "TCBindPhoneViewController.h"
//#import "TCbingdingmobileViewController.h"


@interface TCAccountViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UIImageView *topImage;
@property (nonatomic,strong) CAGradientLayer *gradientLayer;
@property (nonatomic,strong) NSData *imageData;//将图片打包成data
@property (nonatomic,strong) NSString *path;
@property (nonatomic,strong) NSUserDefaults *userdefaults;
@property (nonatomic, strong) UIImageView *imageV; //头像
@property (nonatomic, strong) NSDictionary *dataDIC;
@property (nonatomic, strong) NSString *pushID;
//获取当前版本号
@property (nonatomic, strong) NSString *currentVersion;


@end

@implementation TCAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户信息";
    self.view.backgroundColor = TCBgColor;
    self.userdefaults = [NSUserDefaults standardUserDefaults];
    
    _pushID = [self.userdefaults valueForKey:@"registrationID"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNice) name:@"changeNice" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acountshuaxin) name:@"shuaxinAccount" object:nil];

    //获取当前版本号
    self.currentVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    
    [self creatUI];
    //请求接口
    [self createQuest];
    
    // Do any additional setup after loading the view.
}


#pragma mark -- 修改完
- (void)changeNice
{
     [self createQuest];
}
-(void)acountshuaxin{
    [self createQuest];
}

//请求接口
- (void)createQuest
{
    [ProgressHUD showHUDToView:self.view];
    //请求接口
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"sign":signStr};
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"101008"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        self.dataDIC = jsonDic[@"data"];
        [self.mainTableView reloadData];
        [ProgressHUD hiddenHUD:self.view];
        //成功后返回更新
    } failure:^(NSError *error) {
        nil;
    }];
}

-(void)creatUI{
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - StatusBarAndNavigationBarHeight - TabbarSafeBottomMargin)];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.scrollEnabled = NO;
    AdjustsScrollViewInsetNever(self,self.mainTableView);
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.backgroundColor = TCBgColor;
    [self.mainTableView registerClass:[TCAccountTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.mainTableView];
}

-(void)viewDidLayoutSubviews {
    
    if ([self.mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mainTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.mainTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.mainTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return 3;
    }else if (section == 2){
        return 1;
    }
    return 3;
}
//预防ios11错误
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.qh_width, 0)];
        headerView.backgroundColor = TCBgColor;
        return headerView;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
        if (indexPath.row == 0) {
            return 86;
        }else {
            return 46;
        }
    }else if(indexPath.section == 1){
        return 46;
    }else{
        return 46;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    TCAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[TCAccountTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
        cell.tag = indexPath.section*10 + indexPath.row;
        cell.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    }
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.sanImage.hidden = YES;
                cell.setLabel.text = @"头像";
                cell.setLabel.frame = CGRectMake(12, (cell.contentView.frame.size.height - 22)/2, WIDTH/2, 22);
                self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(cell.contentView.frame.size.width - 72, (cell.contentView.frame.size.height - 60)/2, 60, 60)];
//                imageV = self.topImage;
                self.imageV.layer.masksToBounds = YES;
                self.imageV.layer.cornerRadius = 30;
                [self.imageV sd_setImageWithURL:[NSURL URLWithString:self.dataDIC[@"headPic"]] placeholderImage:[UIImage imageNamed:@"头像"]];
                [cell.contentView addSubview:self.imageV];
                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(12, cell.contentView.frame.size.height - 2, cell.contentView.frame.size.width - 30, 2)];
                lineView.backgroundColor = TCUIColorFromRGB(0xF5F5F5);
                [cell.contentView addSubview:lineView];
            }else if(indexPath.row == 1){
                cell.setLabel.text = @"用户名";
                cell.messageLabel.text = self.dataDIC[@"nickname"];
            }
            
        }else if (indexPath.section == 1 ){
            if (indexPath.row == 0) {
                cell.setLabel.text = @"手机号";
                cell.messageLabel.text = self.dataDIC[@"mobile"];
                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(12, cell.contentView.frame.size.height - 2, cell.contentView.frame.size.width - 30, 2)];
                lineView.backgroundColor = TCUIColorFromRGB(0xF5F5F5);
                [cell.contentView addSubview:lineView];
            }else if (indexPath.row == 1){
                cell.setLabel.text = @"微信";
                NSString *weixinStr = [NSString stringWithFormat:@"%@",self.dataDIC[@"weixin"]];
                
                if ([weixinStr isEqualToString:@"0"]){
                    cell.messageLabel.text = @"未绑定";
                } else if ([weixinStr isEqualToString:@"1"]){
                    cell.messageLabel.text = @"已绑定";
                }
                
                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(12, cell.contentView.frame.size.height - 2, cell.contentView.frame.size.width - 30, 2)];
                lineView.backgroundColor = TCUIColorFromRGB(0xF5F5F5);
                [cell.contentView addSubview:lineView];
            }else if(indexPath.row == 2){
                cell.setLabel.text = @"QQ";
                NSString *qqStr = [NSString stringWithFormat:@"%@",self.dataDIC[@"qq"]];
                if ([qqStr isEqualToString:@"0"]){
                    cell.messageLabel.text = @"未绑定";
                } else if ([qqStr isEqualToString:@"1"]){
                    cell.messageLabel.text = @"已绑定";
                }
            }
        }else if (indexPath.section == 2 ){
            cell.setLabel.text = @"支付密码";
            NSString *setStr = [NSString stringWithFormat:@"%@",self.dataDIC[@"isPass"]];
            if ([setStr isEqualToString:@"0"]){
                cell.messageLabel.text = @"未设置";
            } else if ([setStr isEqualToString:@"1"]){
                cell.messageLabel.text = @"可修改";
            }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
                             
}

#pragma mark -- cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//点击cell后恢复成原来颜色
    NSLog(@"第%ld组第%ld行",(long)indexPath.section,(long)indexPath.row);
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIActionSheet *menu = [[UIActionSheet alloc]initWithTitle:@"设置头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机相册选择", nil];
            menu.delegate = self;
            menu.actionSheetStyle = UIActionSheetStyleDefault;
            [menu showInView:self.view];
        }else if (indexPath.row == 1){
            NSLog(@"编辑昵称");
            TCModifyViewController *modifyVC = [[TCModifyViewController alloc]init];
            [self.navigationController pushViewController:modifyVC animated:YES];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            NSLog(@"绑的手机号");
//            if (self.isbinding == YES) {
                TCTradePhoneViewController *exchang = [[TCTradePhoneViewController alloc] init];
                exchang.phoneStr = self.dataDIC[@"phone"];
                [self.navigationController pushViewController:exchang animated:YES];
//            }else{
//                TCbingdingmobileViewController *bingPhoneVC = [[TCbingdingmobileViewController alloc]init];
////                [self.navigationController pushViewController:bingPhoneVC animated:YES];
//            }
            
            
        }else if (indexPath.row == 1){
            NSLog(@"绑定微信");
            
            NSString *weixinStr = [NSString stringWithFormat:@"%@",self.dataDIC[@"weixin"]];
            
            if ([weixinStr isEqualToString:@"0"]){
                NSLog(@"未绑定");
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"“顺道嘉”想要打开“微信”" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //授权之前取消授权
                    [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
                    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
                           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
                     {
                         if (state == SSDKResponseStateSuccess)
                         {
                             
                             NSLog(@"uid=%@",user.uid);
                             NSLog(@"%@",user.credential);
                             NSLog(@"token=%@",user.credential.token);
                             NSLog(@"nickname=%@",user.nickname);
                             
                             [self questOpenId:user.uid AndOpenType:@"1" AndHeadPic:user.icon Andnickname:user.nickname Andpushid:_pushID Anddeviceid:[TCGetDeviceId getDeviceId] AnddeviceSysInfo:[TCDeviceName getDeviceName] AndversionId:self.currentVersion Andtimestamp:[TCGetTime getCurrentTime]];
                             
                             
                         } else { NSLog(@"%@",error); } }];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                [self.navigationController presentViewController:alert animated:YES completion:nil];
                
                    //[self bindSkip];
                
                
                
            } else if ([weixinStr isEqualToString:@"1"]){
                if (self.isbinding == YES) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"解除绑定" message:@"确定要解除账号与微信的关联吗？解除后将无法使用微信登录此账号" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self unbunding:@"1"];
                        
                    }]];
                    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                    [self.navigationController presentViewController:alert animated:YES completion:nil];
                }else{
                    [TCProgressHUD showMessage:@"请先绑定手机号"];
                }
                
            }
            
        }else if (indexPath.row == 2){
            
            NSString *qqStr = [NSString stringWithFormat:@"%@",self.dataDIC[@"qq"]];
            
            if ([qqStr isEqualToString:@"0"]){
                NSLog(@"未绑定");
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"“顺道嘉”想要打开“QQ”" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
                    
                    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
                           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
                     {
                         if (state == SSDKResponseStateSuccess)
                         {
                             
                             NSLog(@"uid=%@",user.icon);
                             NSLog(@"%@",user.credential);
                             NSLog(@"token=%@",user.credential.token);
                             NSLog(@"nickname=%@",user.nickname);
                             
                             //请求接口 第三方qq登录
                             [self questOpenId:user.uid AndOpenType:@"2" AndHeadPic:user.icon Andnickname:user.nickname Andpushid:_pushID Anddeviceid:[TCGetDeviceId getDeviceId] AnddeviceSysInfo:[TCDeviceName getDeviceName] AndversionId:self.currentVersion Andtimestamp:[TCGetTime getCurrentTime]];
                             
                         } else { NSLog(@"%@",error); } }];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                [self.navigationController presentViewController:alert animated:YES completion:nil];
                
            } else if ([qqStr isEqualToString:@"1"]){
                if (self.isbinding == YES) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"解除绑定" message:@"确定要解除账号与QQ的关联吗？解除后将无法使用QQ登录此账号" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self unbunding:@"2"];
                        
                    }]];
                    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                    [self.navigationController presentViewController:alert animated:YES completion:nil];
                }else{
                    [TCProgressHUD showMessage:@"请先绑定手机号"];
                }
                
            }
        }
    }else if (indexPath.section == 2){
    
        NSString *setStr = [NSString stringWithFormat:@"%@",self.dataDIC[@"isPass"]];
        if ([setStr isEqualToString:@"0"]){
            TCModiViewController *payVC = [[TCModiViewController alloc]init];
            payVC.titleStr = @"设置支付密码";
            payVC.entranceTypeStr = @"1";
            payVC.isSetPass = NO;
            [self.navigationController pushViewController:payVC animated:YES];
        } else if ([setStr isEqualToString:@"1"]){
            TCModiViewController *payVC = [[TCModiViewController alloc]init];
            payVC.entranceTypeStr = @"1";
            payVC.titleStr = @"修改支付密码";
            payVC.isSetPass = YES;
            [self.navigationController pushViewController:payVC animated:YES];
        }
    }
}


//actionsheet的代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            __block UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
            ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
            ipc.delegate = self;
            ipc.allowsEditing = YES;
            [self presentViewController:ipc animated:YES completion:^{
                ipc = nil;
            }];
        }
    }else if(buttonIndex == 1){
        //相册
        __block UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //设置选择后的图片可被编辑，即可以选定任意的范围
        picker.allowsEditing = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:^{
            picker = nil;
        }];
    }
    
}

//picker.delegate代理方法  选择完图片后调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //image保存的是info里面被编辑过的图片
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    
    //放入全局队列中保存头像
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //将头像写入沙盒
        self.imageData = UIImageJPEGRepresentation(image, 0.5);
        self.path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"newHeade.png"];
        NSLog(@"当前的路径 %@", _path);
        [self.imageData writeToFile:self.path atomically:NO];
        //上传服务器
        [self imageQuest];
        dispatch_async(dispatch_get_main_queue(), ^{//回到主队列中更新界面
            self.imageV.image = [[UIImage alloc]initWithContentsOfFile:self.path];
        });
    });
    
    //点击choose后跳转到前一页
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark -- 上传服务器
-(void)imageQuest
{
   
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];

    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"sign":signStr};
    //提交修改，上传图片至服务器
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:[TCServerSecret loginAndRegisterSecretOffline:@"102004"] parameters:paramters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //开始滚动
        if (self.imageData) {
            [formData appendPartWithFileData:self.imageData  name:@"HeadImg" fileName:@"newHeade.png" mimeType:@"image/png"];
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [TCProgressHUD showMessage:dic[@"msg"]];
        NSLog(@"提交图片的返回结果 %@", dic[@"msg"]);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"shuaxinmineview" object:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        nil;
    }];
}


#pragma mark -- 点击绑定微信
//请求第三方登录的接口
- (void)questOpenId:(NSString *)openId AndOpenType:(NSString *)openType AndHeadPic:(NSString *)headpic Andnickname:(NSString *)nickName Andpushid:(NSString *)pushid Anddeviceid:(NSString *)deviceStr AnddeviceSysInfo:(NSString *)info AndversionId:(NSString *)versionID Andtimestamp:(NSString *)times{
    [ProgressHUD showHUDToView:self.view];
    NSString *mid = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *token = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    NSDictionary *dic = @{@"mid":mid,@"token":token,@"openId":openId,@"openType":openType,@"headPic":headpic,@"nickname":nickName,@"timestamp":times};
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mid":mid,@"token":token,@"openId":openId,@"openType":openType,@"headPic":headpic,@"nickname":nickName,@"timestamp":times,@"sign":signStr};
    NSLog(@"%@",paramters);
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102021"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        NSString *jumpStr = [NSString stringWithFormat:@"%@",jsonDic[@"data"][@"jump"]];
        if ([codeStr isEqualToString:@"1"]){
            [self createQuest];
            }
        [ProgressHUD hiddenHUD:self.view];
            [TCProgressHUD showMessage:jsonDic[@"msg"]];
        
        
    } failure:^(NSError *error) {
        nil;
    }];
}

-(void)unbunding:(NSString *)str{
    [ProgressHUD showHUDToView:self.view];
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *mid = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *token = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    NSDictionary *dic = @{@"mid":mid,@"token":token,@"timestamp":timeStr,@"openType":str};
    NSString *signStr = [TCServerSecret signStr:dic];
    
    
    NSDictionary *paramters = @{@"mid":mid,@"token":token,@"timestamp":timeStr,@"sign":signStr,@"openType":str};
    NSLog(@"%@",paramters);
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102022"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        NSString *jumpStr = [NSString stringWithFormat:@"%@",jsonDic[@"data"][@"jump"]];
        if ([codeStr isEqualToString:@"1"]){
            [self createQuest];
        }
        [ProgressHUD hiddenHUD:self.view];
        [TCProgressHUD showMessage:jsonDic[@"msg"]];
        
        
    } failure:^(NSError *error) {
        nil;
    }];
}

//点击取消按钮所执行的方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
