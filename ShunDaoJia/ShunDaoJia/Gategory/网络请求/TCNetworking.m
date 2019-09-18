//
//  TCNetworking.m
//  顺道嘉商家版
//
//  Created by GeYang on 2016/12/5.
//  Copyright © 2016年 北京同创共享网络科技有限公司. All rights reserved.
//

#import "TCNetworking.h"
#import "AFNetworking.h"
#import "DeleteNull.h"
#import "TCLoginViewController.h"
#import "AppDelegate.h"

@implementation TCNetworking

+ (NSString*)convertToJSONData:(id)infoDict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return jsonString;
}

+ (void)postWithTcUrlString:(NSString *)urlString paramter:(id)paramter success:(void (^)(NSString *, NSDictionary *))success failure:(void (^)(NSError *))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = nil;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    [manager POST:urlString parameters:paramter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSString *jsonStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *data = [[[[[jsonStr
                            stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\\r\\n"]
                           stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"]
                          stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"]
                         stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"]
                        dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONWritingPrettyPrinted | NSJSONReadingMutableContainers | NSJSONReadingAllowFragments error:nil];
        if (success) {
            success(jsonStr, [DeleteNull changeType:jsonDic]);
            //登录超时
            NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
            if ([codeStr isEqualToString:@"-5"]){
                [TCProgressHUD showMessage:jsonDic[@"msg"]];
                TCLoginViewController *loginVC = [[TCLoginViewController alloc] init];
                UINavigationController *navi = [[UIApplication sharedApplication] visibleNavigationController];
                [navi presentViewController:loginVC animated:YES completion:nil];
                
                AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
                delegate.isLoginChaoShi = YES;
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
    

@end
