//
//  DownLoadImageObj.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/11/9.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CaiLaiServerAPI.h"
@interface DownLoadImageObj : NSObject
@property(nonatomic,strong)NSString *urlString;
+(void)getImageDataFromserverWithBlock:(void(^)(id respon, NSError *error))block withFilesType:(NSString *)fileType withPid:(NSString *)pid;

+ (void)getImageDataWithUrlString:(NSString *)urlstring WithBlock:(void(^)(id respon, NSError *error))block;
@end
