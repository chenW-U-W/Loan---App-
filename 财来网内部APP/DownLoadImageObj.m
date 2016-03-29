//
//  DownLoadImageObj.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/11/9.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "DownLoadImageObj.h"

@implementation DownLoadImageObj

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if (self = [super init]) {
        self.urlString = [attributes objectForKey:@"path"];
        return self;
    };
    return nil;
}

+(void)getImageDataFromserverWithBlock:(void(^)(id respon, NSError *error))block withFilesType:(NSString *)fileType withPid:(NSString *)pid
{
    
    
    NSDictionary *dic = @{@"sname":@"download.file",@"ext":fileType,@"pid":pid,@"flag":@"inside_salesman"};
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:0];
    [CaiLaiServerAPI PostRequestWithParams:dic success:^(id JSON) {
        if (JSON) {
            id respond =  [JSON objectForKey:@"data"];
            if (![respond isKindOfClass:[NSArray class]]) {
                
            }
            else{
            for (NSDictionary *dictionary in respond) {
                DownLoadImageObj *downLoadImage = [[DownLoadImageObj alloc] initWithAttributes:dictionary];
                [mutableArray addObject:downLoadImage];
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
