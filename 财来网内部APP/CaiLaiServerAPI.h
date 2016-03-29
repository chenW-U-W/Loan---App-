//
//  CaiLaiServerAPI.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/21.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "AFHTTPSessionManager.h"
typedef void (^HttpSuccessBlock)(id JSON);
typedef void (^HttpFailureBlock)(NSError *error);
@interface CaiLaiServerAPI : AFHTTPSessionManager


+(void)PostRequestWithParams:(NSDictionary *)params success:(HttpSuccessBlock)success  failure:(HttpFailureBlock)failure;

+(void)GetRequestWithUrlString:(NSString *)urlString success:(HttpSuccessBlock)success  failure:(HttpFailureBlock)failure;
@end
