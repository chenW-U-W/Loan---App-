//
//  UserDetailObj.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/11/9.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDetailObj : NSObject
@property(nonatomic,strong) NSString *userId;
@property(nonatomic,strong) NSString *cstname;
@property(nonatomic,strong) NSString *tel;
@property(nonatomic,strong) NSString *borrowamt;
@property(nonatomic,strong) NSString *idno;
@property(nonatomic,strong) NSString *duration;
@property(nonatomic,strong) NSString *rate;
@property(nonatomic,strong) NSString *wed;
@property(nonatomic,strong) NSString *address;

@property(nonatomic,strong) NSString *order_status;
 
- (instancetype)initWithAttributes:(NSDictionary *)attributes;

+(void)getUserDetailWithBlock:(void(^)(id respon, NSError *error))block withOrderStatus:(NSString *)status withUserID:(NSString *)userID;
@end
