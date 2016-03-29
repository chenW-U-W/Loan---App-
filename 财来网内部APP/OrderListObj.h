//
//  OrderListObj.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/30.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderListObj : NSObject

@property (nonatomic,assign) NSInteger customerID;
@property (nonatomic,strong) NSString *customerName;
@property (nonatomic,strong) NSString *customerPhone;
@property (nonatomic,strong) NSString *customerTime;
@property (nonatomic,strong) NSString *flagString;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

+(void)getOrderListWithBlock:(void(^)(id respon, NSError *error))block withOrderStatus:(NSString *)status;

@end
