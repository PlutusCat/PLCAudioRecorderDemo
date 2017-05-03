//
//  TimerHelper.m
//  PLCAudioRecorderDemo
//
//  Created by PlutusCat on 2017/4/26.
//  Copyright © 2017年 PlutusCat. All rights reserved.
//

#import "TimerHelper.h"

@interface TimerHelper ()

@property (nonatomic, strong) NSTimer *timerHelper;

@property (nonatomic, assign) NSInteger persent;
@property (nonatomic, assign) NSInteger seconds;
@property (nonatomic, assign) NSInteger minutes;

@end

@implementation TimerHelper


// 暂停计时

+ (void)pauseTimerHelper:(NSTimer *)ti {
    if (ti!=nil) {
        //定时器暂
        [ti setFireDate:[NSDate distantFuture]];
    }
}

// 继续计时

+ (void)keepTimerHelper:(NSTimer *)ti {
    if(ti){
        //定时器继续
        [ti  setFireDate:[NSDate distantPast]];
    }
}

// 结束计时 注销 timer

+ (void)endTimerHelper:(NSTimer *)ti {
    if (ti) {
        [ti invalidate];
        ti = nil;
    }
}

- (NSString *)getTimerlength {
//    获取系统  minutes 分 seconds 秒
    self.seconds++;
    
    if (self.seconds == 60) {
        self.minutes++;
        self.seconds = 0;
    }

    return [NSString stringWithFormat:@"%02ld'%02ld\"",_minutes,_seconds];
}

@end
