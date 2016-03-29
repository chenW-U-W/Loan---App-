//
//  DetailMovieObj.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/11/5.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailMovieObj : NSObject
@property(nonatomic,strong) NSString *urlString;
@property(nonatomic,strong) NSString *nameString;
@property(nonatomic,strong) NSString *filetype;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
+(void)postMovieDataToserverWithBlock:(void(^)(id respon, NSError *error))block withFilesType:(NSString *)fileType withPid:(NSString *)pid withFileClassID:(NSString*)fileClassID  withUpdataDictionary:(NSDictionary *)imageDictionary;
+(void)getMovieDataToserverWithBlock:(void(^)(id respon, NSError *error))block withFilesType:(NSString *)fileType withPid:(NSString *)pid   withUpdataDictionary:(NSDictionary *)imageDictionary fileClassIdStr:(NSString *)fileClassIdStr;


+ (void)getMovieDataWithUrlString:(NSString *)urlstring WithBlock:(void(^)(id respon, NSError *error))block;
@end
