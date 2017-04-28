//
//  PLCAudioRecorderHelper.h
//  PLCAudioRecorderDemo
//
//  Created by PlutusCat on 2017/4/27.
//  Copyright © 2017年 PlutusCat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLCAudioRecorderHelper : NSObject
+ (instancetype)sharedPLCAudioRecorderHelper;

#pragma mark - - 录音相关
/** 开始录音 */
- (BOOL)startAudioRecorder;
/** 暂停录音 */
- (void)pauseAudioRecorder;
/** 恢复录音 */
- (void)resumeAudioRecorder;
/** 停止录音 */
- (void)endAudioRecorder;


+ (BOOL)didSystemOpendMicrophone;

@end
