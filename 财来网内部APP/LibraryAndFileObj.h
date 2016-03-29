//
//  LibraryAndFileObj.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/11/3.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LibraryAndFileObj : NSObject

+(LibraryAndFileObj *)sharedManager;
- (NSString *)doWithLibraryPath:(NSString *)libraryPath userId:(NSString *)userID;
- (void)removeLocalImage:(NSString *)localString;
@end
