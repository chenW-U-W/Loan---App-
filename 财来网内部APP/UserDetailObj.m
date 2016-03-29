//
//  UserDetailObj.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/11/9.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "UserDetailObj.h"
#import "CaiLaiServerAPI.h"

typedef NS_ENUM(NSInteger,Number_order_status){
    Number_order_status_Unmarried=1,
    Number_order_status_married,
    Number_order_status_divorced,
};
@implementation UserDetailObj


- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if (self) {
        self.userId = [attributes objectForKey:@"id"];
        self.cstname = [attributes objectForKey:@"cstname"];
        self.tel = [attributes objectForKey:@"tel"];
        self.borrowamt = [[attributes objectForKey:@"borrowamt"] stringByAppendingString:@"元"];
        self.idno = [attributes objectForKey:@"idno"];
        self.duration = [[attributes objectForKey:@"duration"] stringByAppendingString:@"月"];
        self.rate = [[attributes objectForKey:@"rate"] stringByAppendingString:@"%"];
        self.order_status = [attributes objectForKey:@"order_status"];
        NSString *number_order_status = [attributes objectForKey:@"wed"];
        switch ([number_order_status integerValue]) {
            case Number_order_status_Unmarried:
                self.wed = @"未婚";
                break;
            case Number_order_status_married:
                self.wed = @"已婚";
                break;
            case Number_order_status_divorced:
                self.wed = @"离异";
                break;

            default:
                self.wed = @"--";
                break;
        }
        self.address = [attributes objectForKey:@"address"];
       
        return self;
    }
    return nil;
    
}


//获取贷款人详细信息列表
+(void)getUserDetailWithBlock:(void(^)(id respon, NSError *error))block withOrderStatus:(NSString *)status withUserID:(NSString *)userID
{
    NSDictionary *dic = @{@"sname":@"loan.info.detail",@"id":userID,@"flag":@"inside_salesman"};
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [CaiLaiServerAPI PostRequestWithParams:dic success:^(id JSON) {
        if (JSON) {
            id respond =  [JSON objectForKey:@"data"];
            for (NSDictionary *dic in respond) {
                UserDetailObj *userDetailObj= [[UserDetailObj alloc] initWithAttributes:dic];
                [mutableArray addObject:userDetailObj];
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
