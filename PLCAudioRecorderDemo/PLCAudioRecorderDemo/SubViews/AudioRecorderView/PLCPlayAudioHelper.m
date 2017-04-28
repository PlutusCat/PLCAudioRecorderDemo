//
//  PLCPlayAudioHelper.m
//  PLCAudioRecorderDemo
//
//  Created by PlutusCat on 2017/4/27.
//  Copyright © 2017年 PlutusCat. All rights reserved.
//

#import "PLCPlayAudioHelper.h"
#import "FSAudioStream.h"
#import <lame/lame.h>

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
        NSURL *url = [PLCAudioPath getMp3RecordFilePath];
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


#pragma mark - - caf 转换 mp3
+ (void)CAFChangeToMP3 {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePath = [path stringByAppendingPathComponent:kRecordAudioFile];
        NSString *mp3FilePath = [path stringByAppendingPathComponent:kChangedAudioFile];
        
        @try {
            int read, write;
            
            FILE *pcm = fopen([filePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
            fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
            FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
            
            const int PCM_SIZE = 8192;
            const int MP3_SIZE = 8192;
            short int pcm_buffer[PCM_SIZE*2];
            unsigned char mp3_buffer[MP3_SIZE];
            
            lame_t lame = lame_init();
            lame_set_num_channels(lame,1);//设置1为单通道，默认为2双通道
            lame_set_in_samplerate(lame, 11025.0);
            lame_set_VBR(lame, vbr_default);
            lame_init_params(lame);
            
            do {
                
                read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
                if (read == 0)
                    write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
                else
                    write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
                
                fwrite(mp3_buffer, write, 1, mp3);
                
            } while (read != 0);
            
            lame_close(lame);
            fclose(mp3);
            fclose(pcm);
        }
        @catch (NSException *exception) {
            NSLog(@"%@",[exception description]);
        }
        @finally {
            NSLog(@"MP3生成成功: %@", mp3FilePath);
            [[NSNotificationCenter defaultCenter] postNotificationName:CAFChangeToMP3Complete object:nil];
        }

    });

}

@end


