//
//  MainTotalArray.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/12/2.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "MainTotalObj.h"
#import "CaiLaiServerAPI.h"
@implementation MainTotalObj
- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if (self = [super init]) {
//        self.hexinxinxi = [[HexinxinxiObj alloc] initWithAttributes:[attributes objectForKey:@"1"]];
//        self.jiekuanrenxinxi = [[JiekuanrenxinxiObj alloc] initWithAttributes:[attributes objectForKey:@"2"]];
//        self.jiekuanrenzhanghu = [[JiekuanrenzhanghuObj alloc] initWithAttributes:[attributes objectForKey:@"3"]];
//        self.guoqiaodaikuanren = [[guoqiaodaikuanrenObj alloc] initWithAttributes:[attributes objectForKey:@"4"]];
//        self.diyawu = [[DiyawuObj alloc] initWithAttributes:[attributes objectForKey:@"6"]];
//        self.diyaren = [[Diyaren alloc] initWithAttributes:[attributes objectForKey:@"7"]];
//        self.yewu = [[YeWuObj alloc] initWithAttributes:[attributes objectForKey:@"8"]];
        self.hexinxinxiKVDic =[attributes objectForKey:@"1"];
        self.jiekuanrenKVDic =[attributes objectForKey:@"2"];
        self.jiekuanzhanghuKVDic =[attributes objectForKey:@"3"];
        self.guoqiaoxinxiKVDic =[attributes objectForKey:@"4"];
        self.diyawuxinxiKVDic =[attributes objectForKey:@"6"];
        self.diyarenxinxiKVDic =[attributes objectForKey:@"7"];
        self.yewuxinxiKVDic =[attributes objectForKey:@"8"];
        
        self.totalKDicArray = [[NSMutableArray alloc] initWithObjects:_hexinxinxiKVDic,_jiekuanrenKVDic,_jiekuanzhanghuKVDic,_guoqiaoxinxiKVDic,_diyawuxinxiKVDic,_diyarenxinxiKVDic,_yewuxinxiKVDic, nil];
        return self;
    }
    return nil;
}

+(void)getMainListWithBlock:(void(^)(id respon, NSError *error))block withID:(NSString *)IDString{
    NSDictionary *dic = @{@"sname":@"loan.info.byId.get",@"id":IDString,@"flag":@"inside_salesman"};
   
    
    [CaiLaiServerAPI PostRequestWithParams:dic success:^(id JSON) {
        if (JSON) {
            NSDictionary* respondDic =  [JSON objectForKey:@"data"];
         MainTotalObj *mainTotalObj =   [[MainTotalObj alloc] initWithAttributes:respondDic];
            if (block) {
                block(mainTotalObj,nil);
            }
        }
        
    } failure:^(NSError *error) {
        if (block) {
            block(nil,error);
        }
        
    }];

}

@end
