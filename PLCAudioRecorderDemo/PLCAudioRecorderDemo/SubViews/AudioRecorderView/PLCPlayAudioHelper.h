//
//  PLCPlayAudioHelper.h
//  PLCAudioRecorderDemo
//
//  Created by PlutusCat on 2017/4/27.
//  Copyright © 2017年 PlutusCat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLCPlayAudioHelper : NSObject
#pragma mark - - 播放相关
/** 播放录音 */
- (void)playRecorder;
/** 停止播放录音 */
- (void)stop;

- (void)playStreamRecorder;
- (void)playStreamRecorderWithUrl:(NSURL *)url;
- (void)endStreamRecorder;

@property (nonatomic, copy) void (^playCompletBlock) (BOOL completion);
@property (nonatomic, copy) void (^playErrorBlock) (NSString *error);

@property (nonatomic, copy) dispatch_block_t playerDidFinish;

+ (void)CAFChangeToMP3;

@end
