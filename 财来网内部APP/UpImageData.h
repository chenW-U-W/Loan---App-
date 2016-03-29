//
//  UpImageData.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/11/4.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpImageData : NSObject
@property(nonatomic,strong)NSString *ImageNameString;
+(void)postImageDataToserverWithBlock:(void(^)(id respon, NSError *error))block withFilesType:(NSString *)fileType withPid:(NSString *)pid withUpdataDictionary:(NSDictionary *)imageDictionary fileClassldStr:(NSString *)fileClassIdStr;

+(void)deleateImageDataFromServerWithBlock:(void(^)(id respon, NSError *error))block withFilesType:(NSString *)fileType withPid:(NSString *)pid withNmaeStringArray:(NSArray *)nameStringArray ;

@end
