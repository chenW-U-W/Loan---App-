//
//  UserObj.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/21.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "UserObj.h"
#import "CaiLaiServerAPI.h"
@implementation UserObj
- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if(!self)
    {
        
        return nil;
    }
    self.userName = [attributes objectForKey:@"username"];
    self.sessionid = [attributes objectForKey:@"session_id"];
    self.userID = [attributes objectForKey:@"id"];
    return self;
}
+ (void)signOut {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in cookieStorage.cookies) {
        [cookieStorage deleteCookie:each];
    }
}

//登陆
+(void)UserLoginWithBlock:(void(^)(id respon , NSError *error))block UserName:(NSString *)UserName withPassWord:(NSString *)passWord
{
    [self signOut];
    NSDictionary *dic = @{@"userName":UserName,@"userPwd":passWord,@"sname":@"user.login",@"flag":@"inside_salesman"};
    
    [CaiLaiServerAPI PostRequestWithParams:dic success:^(id JSON) {
        if (JSON) {
           id respond =  [JSON objectForKey:@"data"];
            UserObj *userobj = [[UserObj alloc] initWithAttributes:respond];
            if (block) {
                block(userobj,nil);
            }
                    }

    } failure:^(NSError *error) {
        if (block) {
            block(nil,error);
        }
       
    }];
}

//修改密码
+(void)ChangePassWordWithBlock:(void(^)(id respon, NSError *error))block  withNewPassWord:(NSString *)NewpassWord
{
    NSDictionary *dic = @{@"passwd":NewpassWord,@"sname":@"password.modify",@"flag":@"inside_salesman"};
    
    [CaiLaiServerAPI PostRequestWithParams:dic success:^(id JSON) {
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
