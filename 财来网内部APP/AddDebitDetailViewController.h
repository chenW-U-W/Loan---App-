//
//  AddDebitDetailViewController.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/12/1.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerObj.h"
@interface AddDebitDetailViewController : UIViewController
@property(nonatomic,assign)NSInteger categoryType;//类型
@property(nonatomic,strong)NSMutableArray *categotryArray;
@property(nonatomic,strong)NSArray *keyNameArray;
@property(nonatomic,strong)NSArray *localKeyNameArray;//分类的名称
@property(nonatomic,strong)NSString *pid;


@property(nonatomic,strong)NSMutableArray *jiekuanLeixinArray;//选择项
@property(nonatomic,strong)NSMutableArray *jiekuanYongTuArray;
@property(nonatomic,strong)NSMutableArray *hunyinzhuangkuanArray;
@property(nonatomic,strong)NSMutableArray *diyawuleixinArray;
@property(nonatomic,strong)NSMutableArray *haveguoqiaoPeopleArray;
@property(nonatomic,strong)NSMutableArray *guoqiaorenArray;
@property(nonatomic,strong)NSMutableArray *diyawuzhuangkuangArray;
@property(nonatomic,strong)NSMutableArray *yewulaiyuandanweiArray;
@property(nonatomic,strong)NSMutableArray *yewuyuanArray;
@property(nonatomic,strong)NSMutableArray *zhijinlaiyuanArray;
@property(nonatomic,strong)NSMutableArray *fengkongchushenArray;
@property(nonatomic,strong)NSMutableArray *fengkongfushenArray;

@property(nonatomic,strong)NSMutableArray *yewuxinxiArray;//上面5个数组组成的数组

@end
