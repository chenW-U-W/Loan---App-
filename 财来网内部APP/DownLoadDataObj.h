//
//  DownLoadDataObj.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/11/17.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownLoadDataObj : NSObject
@property(nonatomic,strong)NSString *urlString;
@property(nonatomic,strong)NSString *extension;
@property(nonatomic,assign)NSInteger picType;
@property(nonatomic,assign)NSInteger LocalPicType;

@property(nonatomic,assign)BOOL isMarked;
@property(nonatomic,assign)BOOL isSigned;
@property(nonatomic,strong)NSString *nameString;

+(void)getDownLoadDataFromserverWithBlock:(void(^)(id respon, NSError *error))block withFileClassIdStr:(NSString *)fileClassIdStr withPid:(NSString *)pid;
@end
