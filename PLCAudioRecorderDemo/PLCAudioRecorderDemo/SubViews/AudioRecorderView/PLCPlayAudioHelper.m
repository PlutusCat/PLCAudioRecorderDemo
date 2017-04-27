//
//  PLCPlayAudioHelper.m
//  PLCAudioRecorderDemo
//
//  Created by PlutusCat on 2017/4/27.
//  Copyright © 2017年 PlutusCat. All rights reserved.
//

#import "PLCPlayAudioHelper.h"
#import "FSAudioStream.h"

@interface PLCPlayAudioHelper ()<AVAudioPlayerDelegate>
// 播放本地音频文件
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
// 播放在线音频路径
@property (nonatomic, strong) FSAudioStream *audioStream;
@end

@implementation PLCPlayAudioHelper
/**
 *  创建播放器
 *
 *  @return 播放器
 */
- (AVAudioPlayer *)audioPlayer{
    if (!_audioPlayer) {
        NSURL *url = [PLCAudioPath getSavePath];
        NSError *error=nil;
        _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        _audioPlayer.numberOfLoops=0;
        [_audioPlayer prepareToPlay];
        if (error) {
            NSLog(@"创建播放器过程中发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioPlayer;
}


#pragma mark - - 初始化并播放录音
- (void)playStreamRecorder {
    if (!_audioStream) {
        NSURL *url = [PLCAudioPath getSavePath];
        //创建FSAudioStream对象
        _audioStream = [[FSAudioStream alloc] initWithUrl:url];
        [_audioStream play];
        
        __weak __typeof(self)weakSelf = self;
        _audioStream.onFailure = ^(FSAudioStreamError error,NSString *description){
            NSLog(@"播放过程中发生错误，错误信息：%@",description);
            if (weakSelf.playErrorBlock) {
                weakSelf.playErrorBlock(description);
            }
        };
        
        _audioStream.onCompletion=^(){
            NSLog(@"播放完成!");
            if (weakSelf.playCompletBlock) {
                weakSelf.playCompletBlock(YES);
            }
        };
        
    }
}

- (void)playStreamRecorderWithUrl:(NSURL *)url {
    if (_audioStream.isPlaying) {
        [_audioStream stop];
    }
    [_audioStream playFromURL:url];
}


- (void)endStreamRecorder {
    [self.audioStream stop];
}

- (void)playRecorder {
    
    if (![self.audioPlayer isPlaying]) {
        [self.audioPlayer play];
    }
}

- (void)endRecorder {
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer stop];
    }
}


@end
