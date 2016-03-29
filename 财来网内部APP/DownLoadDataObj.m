//
//  DownLoadDataObj.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/11/17.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "DownLoadDataObj.h"
#import "CaiLaiServerAPI.h"
@implementation DownLoadDataObj

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if (self = [super init]) {
        self.urlString = [attributes objectForKey:@"path"];
        self.extension = [attributes objectForKey:@"extension"];
        self.picType = [[attributes objectForKey:@"pictype"] integerValue];
        self.nameString = [attributes objectForKey:@"fileName"];
        return self;
    };
    return nil;
}

+(void)getDownLoadDataFromserverWithBlock:(void(^)(id respon, NSError *error))block withFileClassIdStr:(NSString *)fileClassIdStr withPid:(NSString *)pid
{
    
    
    NSDictionary *dic = @{@"sname":@"download.file",@"pid":pid,@"fileClassIdStr":fileClassIdStr,@"flag":@"inside_salesman"};
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:0];
    [CaiLaiServerAPI PostRequestWithParams:dic success:^(id JSON) {
        if (JSON) {
            id respond =  [JSON objectForKey:@"data"];
            if (![respond isKindOfClass:[NSArray class]]) {
                
            }
            else{
                for (NSDictionary *dictionary in respond) {
                    DownLoadDataObj *downLoadObj = [[DownLoadDataObj alloc] initWithAttributes:dictionary];
                    [mutableArray addObject:downLoadObj];
                }
            }
            
            if (block) {
                block(mutableArray,nil);
            }
        }
        
    } failure:^(NSError *error) {
        if (block) {
            block(nil,error);
        }
        
    }];
}

@end
