//
//  DetailMovieObj.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/11/5.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "DetailMovieObj.h"
#import "CaiLaiServerAPI.h"

@implementation DetailMovieObj
- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if (self = [super init]) {
        self.urlString = [attributes objectForKey:@"path"];
        self.nameString = [attributes objectForKey:@"fileName"];
        
        return self;
    };
    return nil;
}

+(void)postMovieDataToserverWithBlock:(void(^)(id respon, NSError *error))block withFilesType:(NSString *)fileType withPid:(NSString *)pid withFileClassID:(NSString*)fileClassID withUpdataDictionary:(NSDictionary *)imageDictionary
{
    //NSMutableDictionary *imageDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    //目前上传图片只能上传一张
    NSArray *array = imageDictionary.allKeys;
    
    NSString *movieString = [imageDictionary objectForKey:[array objectAtIndex:0]];
    NSString *nameString = [array objectAtIndex:0];
    NSDictionary *dic = @{@"sname":@"upload.file",@"ext":fileType,@"pid":pid,@"fileData":movieString,@"fileName":nameString,@"fileClassId":fileClassID,@"flag":@"inside_salesman"};
    
    [CaiLaiServerAPI PostRequestWithParams:dic success:^(id JSON) {
        if (JSON) {
            id respond =  [JSON objectForKey:@"data"];
            
            if (block) {
                block(respond,nil);
            }
        }
        
    } failure:^(NSError *error) {
        if (block) {
            block(nil,error);
        }
        
    }];
}


+(void)getMovieDataToserverWithBlock:(void(^)(id respon, NSError *error))block withFilesType:(NSString *)fileType withPid:(NSString *)pid withUpdataDictionary:(NSDictionary *)imageDictionary fileClassIdStr:(NSString *)fileClassIdStr
{
    
    
    NSDictionary *dic = @{@"sname":@"download.file",@"ext":fileType,@"pid":pid,@"fileClassIdStr":fileClassIdStr,@"flag":@"inside_salesman"};
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:0];
    [CaiLaiServerAPI PostRequestWithParams:dic success:^(id JSON) {
        if (JSON) {
            id respond =  [JSON objectForKey:@"data"];
            if (![respond isKindOfClass:[NSArray class]] ) {
                if (block) {
                    block(respond,nil);
                }
            }
            else{
            for (NSDictionary *dictionary in respond) {
                 DetailMovieObj *detailMOBJ = [[DetailMovieObj alloc] initWithAttributes:dictionary];
                [mutableArray addObject:detailMOBJ];
            }
           
            if (block) {
                block(mutableArray,nil);
            }
        }
        }
        
        
    } failure:^(NSError *error) {
        if (block) {
            block(nil,error);
        }
        
    }];
}

+ (void)getMovieDataWithUrlString:(NSString *)urlstring WithBlock:(void(^)(id respon, NSError *error))block
{
    [CaiLaiServerAPI GetRequestWithUrlString:urlstring success:^(id JSON) {
        //json 传过来的是影片的保存地址 url
        
        
        if (block) {
            block(JSON,nil);
        }
        
    } failure:^(NSError *error) {
        if (block) {
             block(nil,error);
        }
       
    } ];
}

@end
