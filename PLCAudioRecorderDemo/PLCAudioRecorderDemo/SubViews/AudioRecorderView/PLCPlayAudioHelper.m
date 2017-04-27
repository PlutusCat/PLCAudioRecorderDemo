//
//  PLCPlayAudioHelper.m
//  PLCAudioRecorderDemo
//
//  Created by PlutusCat on 2017/4/27.
//  Copyright © 2017年 PlutusCat. All rights reserved.
//

#import "PLCPlayAudioHelper.h"
#import "FSAudioStream.h"

@interface PLCPlayAudioHelper ()<AVAudioPlayerDelegate, FSPCMAudioStreamDelegate>
// 播放本地音频文件
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
// 播放在线音频路径
@property (nonatomic, strong) FSAudioStream *audioStream;
@end

@implementation PLCPlayAudioHelper

#pragma mark - - 初始化并播放录音
- (void)playStreamRecorder {
    if (!_audioStream) {
        NSURL *url = [PLCAudioPath getRecordFilePath];
        //创建FSAudioStream对象
        _audioStream = [[FSAudioStream alloc] initWithUrl:url];
        _audioStream.delegate = self;
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

// 播放本地音频文件

- (void)playRecorder {
    
    if (!_audioPlayer) {
        NSURL *url = [PLCAudioPath getRecordFilePath];
        NSError *error = nil;
        self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        self.audioPlayer.delegate = self;
        self.audioPlayer.numberOfLoops = 0;
        [self.audioPlayer prepareToPlay];
        if (error) {
            NSLog(@"创建播放器过程中发生错误，错误信息：%@",error.localizedDescription);
            return ;
        }
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];

    }

    if (![self.audioPlayer isPlaying]) {
        [self.audioPlayer play];
    }
}

- (void)stop {
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer stop];
    }
}

#pragma mark - - FSPCMAudioStreamDelegate -
- (void)audioStream:(FSAudioStream *)audioStream samplesAvailable:(AudioBufferList *)samples frames:(UInt32)frames description:(AudioStreamPacketDescription)description {
    NSLog(@"%s", __func__);
}

#pragma mark - - AVAudioPlayerDelegate -
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        NSLog(@"播放录音完成");
        if (_playerDidFinish) {
            _playerDidFinish();
        }
    }
    
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSLog(@"播放录音错误 - %@", error);
}

@end


