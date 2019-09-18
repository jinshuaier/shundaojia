//
//  TCLocation.h
//  顺道嘉(新)
//
//  Created by 某某 on 16/9/24.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^addBlock)(NSString *address);
typedef void(^errorBlock)(void);

@interface TCLocation : NSObject

@property (nonatomic, copy) addBlock addblock;
@property (nonatomic, copy) errorBlock errorblock;

@property (nonatomic, assign) BOOL ishomePage;


- (void)getadds:(addBlock)blocks andMayBeError:(errorBlock)errorblock;

//- (void)zidong;
@end
