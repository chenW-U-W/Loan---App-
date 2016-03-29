//
//  OrderInformationObj.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/26.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderInformationObj : NSObject
@property (nonatomic,strong)NSString *processed;
@property (nonatomic,strong)NSString *processing;
@property (nonatomic,strong)NSString *unprocessed;
- (instancetype)initWithAttributes:(NSDictionary *)attributes;

+(void)getOrderMessageWithBlock:(void(^)(id respon, NSError *error))block;

@end
