//
//  TCCreatePlist.m
//  某某
//
//  Created by apple on 16/3/18.
//  Copyright © 2016年 moumou. All rights reserved.
//

#import "TCCreatePlist.h"

@implementation TCCreatePlist

+(NSString *)createPlistFile:(NSString *)name{
    NSString *filepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:[name stringByAppendingFormat:@"%@", @".plist"]];
    return filepath;
}

@end
