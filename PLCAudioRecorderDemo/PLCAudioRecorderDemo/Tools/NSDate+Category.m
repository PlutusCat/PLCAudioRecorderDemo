//
//  NSDate+Category.m
//  PLCAudioRecorderDemo
//
//  Created by PlutusCat on 2017/5/2.
//  Copyright © 2017年 PlutusCat. All rights reserved.
//

#import "NSDate+Category.h"

@implementation NSDate (Category)
+ (NSString *)getTimeStampFromOriginalTime:(NSDate *)originalDate {
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh-Hant"];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS Z";
    NSString *date = [fmt stringFromDate:originalDate];
    NSString *timeStamp = [NSString stringWithFormat:@"%f",[[fmt dateFromString:date] timeIntervalSince1970]* 1000];
    NSRange range = [timeStamp rangeOfString:@"."];
    return [timeStamp substringToIndex:range.location];
    
}
@end
