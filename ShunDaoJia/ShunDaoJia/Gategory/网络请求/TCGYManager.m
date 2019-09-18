//
//  TCGYManager.m
//  顺道嘉(新)
//
//  Created by GeYang on 2016/12/12.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "TCGYManager.h"
static AFHTTPSessionManager *manager;
@implementation TCGYManager
+(AFHTTPSessionManager *)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
    });
    return manager;
}
@end
