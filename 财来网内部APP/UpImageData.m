//
//  UpImageData.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/11/4.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "UpImageData.h"
#import "CaiLaiServerAPI.h"

@implementation UpImageData
+(void)postImageDataToserverWithBlock:(void(^)(id respon, NSError *error))block withFilesType:(NSString *)fileType withPid:(NSString *)pid withUpdataDictionary:(NSDictionary *)imageDictionary fileClassldStr:(NSString *)fileClassIdStr
{

    //1 从字典中取数据
    
    NSArray *imageKeyArray = imageDictionary.allKeys;
   
    NSString *leftString = @"\"";
    NSString *KVString= @"";
    //NSString *spaceStrig = @"\n";
    NSString* valueString = @"";
    NSString* nameString = @"";
    for (int i= 0; i<imageKeyArray.count; i++) {
        valueString = [imageDictionary  objectForKey:[imageKeyArray objectAtIndex:i]];// base64 加密的图片data
        nameString = [imageKeyArray objectAtIndex:i];
        NSString* keyString = [imageKeyArray objectAtIndex:i];
        KVString =[KVString stringByAppendingString:[NSString stringWithFormat:@"%@%@%@:%@%@%@",leftString,keyString,leftString,leftString,valueString,leftString]];
    }
    
    NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys:valueString,@"1", nil];
   
    
    NSString *dicString =[[@"{" stringByAppendingString:KVString] stringByAppendingString:@"}"];
    NSString *valueJSonString = [[@"{" stringByAppendingString:valueString] stringByAppendingString:@"}"];
    NSString *base64String = [[@"1" dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSDictionary *dic = @{@"sname":@"upload.file",@"ext":fileType,@"pid":pid,@"fileData":valueString,@"fileName":nameString,@"fileClassId":fileClassIdStr,@"flag":@"inside_salesman"};
       
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

+(void)deleateImageDataFromServerWithBlock:(void(^)(id respon, NSError *error))block withFilesType:(NSString *)fileType withPid:(NSString *)pid withNmaeStringArray:(NSArray *)nameStringArray
{
    
    
    //NSString *spaceStrig = @"\n";
    NSString* nameString = @"";
    for (int i= 0; i<nameStringArray.count; i++) {
        nameString = [nameStringArray objectAtIndex:i];
        
    }
    
    
    NSDictionary *dic = @{@"sname":@"file.del",@"ext":fileType,@"pid":pid,@"fileName":nameString,@"flag":@"inside_salesman"};
    
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

@end
