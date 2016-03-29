//
//  ChosedItemObj.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/12/3.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "ChosedItemObj.h"

@implementation ChosedItemObj
- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if (self =[super init]) {
        self.idString = [attributes objectForKey:@"id"];
        self.nameString = [attributes objectForKey:@"name"];
        return self;
    }
    return nil;
}
@end
