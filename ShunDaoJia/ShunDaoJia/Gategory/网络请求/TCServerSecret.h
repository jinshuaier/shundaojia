//
//  TCServerSecret.h
//  某某
//
//  Created by apple on 16/3/16.
//  Copyright © 2016年 moumou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCServerSecret : NSObject
@property (nonatomic, strong) NSString *appapinterface;
@property (nonatomic, strong) NSString *approomno;
- (NSString *)md5:(NSString *)str;
- (NSString *)md52:(NSString *)str;

//sha1加密
- (NSString *)sha1:(NSString *)str;
+ (NSString *)singstr;

//线下测试
+ (NSString *)loginAndRegisterSecretceshiline:(NSString *)num;

+ (NSString *)loginAndRegisterSecretOnline:(NSString *)num;
//线上
+ (NSString *)loginAndRegisterSecretOffline:(NSString *)num;
+ (NSString *)loginAndRegisterSecret2:(NSString *)num;

//拼接字符串
+(NSString *)signStr:(NSDictionary*)dict;

//+ (NSString *)loginAndRegisterSecret3:(NSString *)num;
@end
