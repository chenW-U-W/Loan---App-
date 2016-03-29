//
//  OrderInformationObj.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/26.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "OrderInformationObj.h"
#import "CaiLaiServerAPI.h"
@implementation OrderInformationObj
- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if (self) {
        self.processed = [attributes objectForKey:@"processed"];
        self.processing = [attributes objectForKey:@"processing"];
        self.unprocessed = [attributes objectForKey:@"unprocessed"];
        return self;
    }
    return nil;
    
}


//获取订单列表
+(void)getOrderMessageWithBlock:(void(^)(id respon, NSError *error))block
{
    NSDictionary *dic = @{@"sname":@"loan.order.get",@"flag":@"inside_salesman"};
    
    [CaiLaiServerAPI PostRequestWithParams:dic success:^(id JSON) {
        if (JSON) {
            id respond =  [JSON objectForKey:@"data"];
           OrderInformationObj *orderInfor= [[OrderInformationObj alloc] initWithAttributes:respond];
            if (block) {
                block(orderInfor,nil);
            }
        }
        
    } failure:^(NSError *error) {
        if (block) {
            block(nil,error);
        }
        
    }];
}

@end
