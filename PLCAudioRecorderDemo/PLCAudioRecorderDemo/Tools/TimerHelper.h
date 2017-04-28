//
//  TimerHelper.h
//  PLCAudioRecorderDemo
//
//  Created by PlutusCat on 2017/4/26.
//  Copyright © 2017年 PlutusCat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimerHelper : NSObject

+ (void)pauseTimerHelper:(NSTimer *)ti;
+ (void)keepTimerHelper:(NSTimer *)ti;
+ (void)endTimerHelper:(NSTimer *)ti;


- (NSString *)getTimerlength;
- (NSString *)getTimerlength2;
- (NSString *)getTimerlength3;
@end
