//
//  CommitObj.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/12/3.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "CommitObj.h"
#import "CaiLaiServerAPI.h"
@implementation CommitObj

+(void)postTotalDataListWithBlock:(void(^)(id respon, NSError *error))block withDic:(NSDictionary *)dic withStyle:(NSString *)style
{
        
    NSMutableDictionary *mutableDic = [dic mutableCopy];
    //[ mutableDic setObject:pid forKey:@"id"];
    [mutableDic setObject:style forKey:@"status"];
    [CaiLaiServerAPI PostRequestWithParams:mutableDic success:^(id JSON) {
        if (JSON) {
            id respond =  [JSON objectForKey:@"data"];
            if (block) {
                block(respond,nil);
            }
        }
        
    } failure:^(NSError *error) {
        if (block) {
            block(nil,error);
        }
        
    }];
    
}



+(void)postTotalDataListWithBlock:(void(^)(id respon, NSError *error))block withDic:(NSDictionary *)dic withPid:(NSString *)pid withStyle:(NSString *)style
{
    NSMutableDictionary *mutableDic = [dic mutableCopy];
    [ mutableDic setObject:pid forKey:@"id"];
    [mutableDic setObject:style forKey:@"status"];
    
    [CaiLaiServerAPI PostRequestWithParams:mutableDic success:^(id JSON) {
        if (JSON) {
            id respond =  [JSON objectForKey:@"data"];
            if (block) {
                block(respond,nil);
            }
        }
        
    } failure:^(NSError *error) {
        if (block) {
            block(nil,error);
        }
        
    }];
    
}


@end
