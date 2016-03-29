//
//  CommitObj.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/12/3.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommitObj : NSObject
+(void)postTotalDataListWithBlock:(void(^)(id respon, NSError *error))block withDic:(NSDictionary *)dic withStyle:(NSString *)style;
+(void)postTotalDataListWithBlock:(void(^)(id respon, NSError *error))block withDic:(NSDictionary *)dic withPid:(NSString *)pid withStyle:(NSString *)style;

@end
