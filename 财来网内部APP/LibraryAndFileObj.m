//
//  LibraryAndFileObj.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/11/3.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "LibraryAndFileObj.h"

@implementation LibraryAndFileObj

+ (LibraryAndFileObj *)sharedManager
{
    static LibraryAndFileObj *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}




//创建文件夹
- (NSString *)doWithLibraryPath:(NSString *)libraryPath userId:(NSString *)userID
{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
    NSString *ourDocumentPath =[documentPaths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [ourDocumentPath stringByAppendingString:[NSString stringWithFormat:@"/%@_%@",libraryPath,userID]];
    BOOL isDicr; NSError *error;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDicr]) {
       BOOL isSucessed = [fileManager createDirectoryAtPath:[ourDocumentPath stringByAppendingString:[NSString stringWithFormat:@"/%@_%@",libraryPath,userID]] withIntermediateDirectories:YES attributes:nil error:&error];
        if (isSucessed) {
            return path;
        }
        else
        {
            NSLog(@"创建文件夹时出错error -----:%@",error);
        }
    }
    
        return path;
    

}
//删除本地图片数据
- (void)removeLocalImage:(NSString *)localString
{
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:localString error:&error];
    NSLog(@"error----%@",error);
}




@end
