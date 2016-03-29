//
//  OrderListObj.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/30.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "OrderListObj.h"
#import "CaiLaiServerAPI.h"
@implementation OrderListObj


- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if (self) {
        self.customerID = [[attributes objectForKey:@"id"] integerValue];
        self.customerName = [attributes objectForKey:@"cstname"];
        self.customerPhone = [attributes objectForKey:@"tel"];
        self.customerTime = [attributes objectForKey:@"fptime"];
        self.flagString = [attributes objectForKey:@"flag"];
        return self;
    }
    return nil;
    
}


//获取订单列表
+(void)getOrderListWithBlock:(void(^)(id respon, NSError *error))block withOrderStatus:(NSString *)status
{
    NSDictionary *dic = @{@"sname":@"loan.info.list",@"orderStatus":status,@"flag":@"inside_salesman"};
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [CaiLaiServerAPI PostRequestWithParams:dic success:^(id JSON) {
        if (JSON) {
            id respond =  [JSON objectForKey:@"data"];
            for (NSDictionary *dic in respond) {
                OrderListObj *orderListObj= [[OrderListObj alloc] initWithAttributes:dic];
                [mutableArray addObject:orderListObj];
            }
            
            if (block) {
                block(mutableArray,nil);
            }
        }
        
    } failure:^(NSError *error) {
        if (block) {
            block(nil,error);
        }
        
    }];
}

@end
