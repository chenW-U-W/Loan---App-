//
//  ChosedItemObj.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/12/3.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChosedItemObj : NSObject
@property(nonatomic,strong)NSString *idString;
@property(nonatomic,strong)NSString *nameString;
- (instancetype)initWithAttributes:(NSDictionary *)attributes;
@end
