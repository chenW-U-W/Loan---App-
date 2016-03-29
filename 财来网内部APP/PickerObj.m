//
//  PickerObj.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/12/2.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "PickerObj.h"
#import "CaiLaiServerAPI.h"
#import "ChosedItemObj.h"//将每个下拉选项作为对象
@implementation PickerObj
- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if (self = [super init]) {
//（0 借款类型，1 借款用途，2 婚姻装款，9 是否有过桥人， 10 过桥贷款人 3---）
        
        /*
         pledgeList =     (
         {
         id = 4;
         name = "\U7ecf\U8425\U6027\U5468\U8f6c";
         },
         {
         id = 5;
         name = "\U4e2a\U4eba\U6d88\U8d39";
         },
         {
         id = 6;
         name = "\U5176\U4ed6";
         }
         );
         salesmanList =     (
         {
         id = 2;
         name = "\U5f20\U987a\U6743";
         },
         {
         id = 3;
         name = "\U738b\U5fe0";
         },
         {
         id = 4;
         name = zzx;
         },
         {
         id = 5;
         name = "\U59dc\U78ca";
         }
         );
         secondAuditList =     (
         {
         id = 4;
         name = zzx;
         },
         {
         id = 5;
         name = "\U59dc\U78ca";
         }
         );
         
         
         wedList =     (
         "\U7ed3\U5a5a",
         "\U672a\U5a5a",
         "\U79bb\U5f02"
         );

         */
        
        NSMutableDictionary *mutAttributes = [attributes mutableCopy];
        //[mutAttributes removeObjectForKey:@"wedList"];//婚姻状况的数据格式异常
        
            NSArray *keyArray = mutAttributes.allKeys;
            
           for (NSString *string in keyArray) {
               NSMutableArray *totalarray = [[NSMutableArray alloc] init];
               NSArray *dicArray = [mutAttributes objectForKey:string];
               for (NSDictionary *detailDic in dicArray) {
                   ChosedItemObj *choseItemObj = [[ChosedItemObj alloc] initWithAttributes:detailDic];
                   [totalarray addObject:choseItemObj];
               }
               [self.mutableDic setObject:totalarray forKey:string];
               if ([string isEqualToString:@"organizationList"]) {
                   self.yewulaiyuanArray = totalarray;
               }
               if ([string isEqualToString:@"borrowUseList"]) {
                   self.jiekuanyongtuArray = totalarray;
               }
               if ([string isEqualToString:@"pledgeList"]) {
                   self.diyazhuangkuangArray = totalarray;
               }
               if ([string isEqualToString:@"houseTypeList"]) {
                   self.fangwuleixinArray = totalarray;
               }
               if ([string isEqualToString:@"salesmanList"]) {
                   self.yewuyuanArray = totalarray;
               }
               if ([string isEqualToString:@"firstAuditList"]) {
                   self.fengkongchushenArray = totalarray;
               }
               if ([string isEqualToString:@"secondAuditList"]) {
                   self.fengkongfushenArray = totalarray;
               }
               if ([string isEqualToString:@"organizationList"])
               {
                   self.zhijinglaiyuanArray = totalarray;
               }
//               if ([string isEqualToString:@"pledgeList"]) {
//                   self.diyazhuangkuangArray = totalarray;
//               }
               if ([string isEqualToString:@"wedList"]) {
                   self.hunyinzhuangkuangArray = totalarray;
               }
               if ([string isEqualToString:@"salesmanList"]) {
                   self.guoqiaorenArray = totalarray;
               }
               if ([string isEqualToString:@"categoryList"]) {
                   self.jiekuanleixinArray = totalarray;
               }
               
        }
        
//        self.hunyinzhuangkuangArray = [@[@"结婚",@"未婚",@"离异"] mutableCopy];
        return self;
    }
    return nil;
}
+(void)getDebiteItemListWithBlock:(void(^)(id respon, NSError *error))block
{
    NSDictionary *dic = @{@"sname":@"loan.info.select.content",@"flag":@"inside_salesman"};
   
    
    [CaiLaiServerAPI PostRequestWithParams:dic success:^(id JSON) {
        if (JSON) {
            id respond =  [JSON objectForKey:@"data"];
           
            PickerObj *pickerObj= [[PickerObj alloc] initWithAttributes:respond];            
            
            if (block) {
                block(pickerObj,nil);
            }
        }
        
    } failure:^(NSError *error) {
        if (block) {
            block(nil,error);
        }
        
    }];

}

@end
