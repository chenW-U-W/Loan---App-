//
//  MainTotalArray.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/12/2.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainTotalObj : NSObject


@property(nonatomic,strong)NSDictionary *hexinxinxiKVDic;
@property(nonatomic,strong)NSDictionary *jiekuanrenKVDic;
@property(nonatomic,strong)NSDictionary *jiekuanzhanghuKVDic;
@property(nonatomic,strong)NSDictionary *guoqiaoxinxiKVDic;
@property(nonatomic,strong)NSDictionary *diyawuxinxiKVDic;
@property(nonatomic,strong)NSDictionary *diyarenxinxiKVDic;
@property(nonatomic,strong)NSDictionary *yewuxinxiKVDic;

@property(nonatomic,strong)NSMutableArray *totalKDicArray;
- (instancetype)initWithAttributes:(NSDictionary *)attributes;
+(void)getMainListWithBlock:(void(^)(id respon, NSError *error))block withID:(NSString *)IDString;
@end
