//
//  PickerObj.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/12/2.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PickerObj : NSObject


@property(nonatomic,strong)NSMutableArray *yewulaiyuanArray;
@property(nonatomic,strong)NSMutableArray *jiekuanyongtuArray;
@property(nonatomic,strong)NSMutableArray *jiekuanleixinArray;
@property(nonatomic,strong)NSMutableArray *diyazhuangkuangArray;
@property(nonatomic,strong)NSMutableArray *fangwuleixinArray;//房屋/抵押物类型
@property(nonatomic,strong)NSMutableArray *yewuyuanArray;
@property(nonatomic,strong)NSMutableArray *fengkongchushenArray;
@property(nonatomic,strong)NSMutableArray *fengkongfushenArray;
@property(nonatomic,strong)NSMutableArray *zhijinglaiyuanArray;
@property(nonatomic,strong)NSMutableArray *totalChosedItemArray;
@property(nonatomic,strong)NSMutableArray *hunyinzhuangkuangArray;
@property(nonatomic,strong)NSMutableArray *guoqiaorenArray;

@property(nonatomic,strong)NSMutableDictionary *mutableDic;


- (instancetype)initWithAttributes:(NSDictionary *)attributes;


+(void)getDebiteItemListWithBlock:(void(^)(id respon, NSError *error))block;
@end
