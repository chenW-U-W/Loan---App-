//
//  TimeObj.h
//  Cai
//
//  Created by 启竹科技 on 15/5/20.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeObj : NSObject
+ (NSDate *)dateChangeFromString:(NSString *)str withFormat:(NSString *)format;
+ (NSDate *)dateChangeFromTimeIntervalString:(NSString *)str withFormat:(NSString *)format;
+(NSString *)stringFromReceivedDate:(NSDate *)adate withDateFormat:(NSString *)dateFormate;


@end
