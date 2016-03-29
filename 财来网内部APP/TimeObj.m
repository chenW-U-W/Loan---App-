//
//  TimeObj.m
//  Cai
//
//  Created by 启竹科技 on 15/5/20.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "TimeObj.h"

@implementation TimeObj



//2015-04-12  date字符串转nsdate
+ (NSDate *)dateChangeFromString:(NSString *)str withFormat:(NSString *)format
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[NSLocale currentLocale]];    
    [inputFormatter setDateFormat:format];
    NSDate *date = [inputFormatter dateFromString:str];
    return date;
}

//14525774 时间戳
+ (NSDate *)dateChangeFromTimeIntervalString:(NSString *)str withFormat:(NSString *)format
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setTimeZone:[NSTimeZone localTimeZone]];
    inputFormatter.dateFormat = format;
    [inputFormatter setLocale:[NSLocale currentLocale]];
    [inputFormatter setDateFormat:format];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[str doubleValue]];//yyyy-MM-dd HH:mm:ss(HH要大些偶)
   return  date;
}


+(NSString *)stringFromReceivedDate:(NSDate *)adate withDateFormat:(NSString *)dateFormate
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    inputFormatter.dateFormat = dateFormate;
    //[dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [inputFormatter setLocale:[NSLocale currentLocale]];// 时间转换需要获得当地时区的偶
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [inputFormatter setTimeZone:localTimeZone];
    NSString *dateString = [inputFormatter stringFromDate:adate];
    return dateString;
}


@end
