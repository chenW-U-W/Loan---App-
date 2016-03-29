//
//  UserObj.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/21.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserObj : NSObject
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *password;
@property(nonatomic,strong)NSString *sessionid;
@property(nonatomic,strong)NSString *userID;
- (instancetype)initWithAttributes:(NSDictionary *)attributes;

//登陆
+(void)UserLoginWithBlock:(void(^)(id respon, NSError *error))block UserName:(NSString *)UserName withPassWord:(NSString *)passWord;

//修改密码
+(void)ChangePassWordWithBlock:(void(^)(id respon, NSError *error))block  withNewPassWord:(NSString *)NewpassWord;

@end
