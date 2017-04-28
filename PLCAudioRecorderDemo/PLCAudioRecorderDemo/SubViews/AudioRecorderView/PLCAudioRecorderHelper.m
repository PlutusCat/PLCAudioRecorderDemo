//
//  PLCAudioRecorderHelper.m
//  PLCAudioRecorderDemo
//
//  Created by PlutusCat on 2017/4/27.
//  Copyright © 2017年 PlutusCat. All rights reserved.
//

#import "PLCAudioRecorderHelper.h"

@interface PLCAudioRecorderHelper ()<AVAudioRecorderDelegate>
/** 录音文件地址 */
@property (nonatomic, strong) NSURL *recordFileUrl;
//音频录音机
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) AVAudioSession *session;
@end

@implementation PLCAudioRecorderHelper

static PLCAudioRecorderHelper *_instance;

static id instance;

+ (instancetype)sharedPLCAudioRecorderHelper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [super allocWithZone:zone];
        }
    });
    return instance;
}

#pragma mark - 懒加载
- (AVAudioRecorder *)audioRecorder {
    if (!_audioRecorder) {
        
        self.recordFileUrl = [PLCAudioPath getRecordFilePath];
        
        NSDictionary *setting = [self getAudioSetting];

        NSError *error = nil;
        self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:_recordFileUrl
                                                         settings:setting
                                                            error:&error];
        self.audioRecorder.delegate = self;
        self.audioRecorder.meteringEnabled = YES;
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
        [self.audioRecorder prepareToRecord];
    }
    return _audioRecorder;
}

/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */
- (NSDictionary *)getAudioSetting {
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];

    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    [dicM setObject:@(11025.0) forKey:AVSampleRateKey];
    [dicM setObject:@(2) forKey:AVNumberOfChannelsKey];
    [dicM setObject:@(16) forKey:AVLinearPCMBitDepthKey];
    [dicM setObject:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];

    return dicM;
}


#pragma mark - - 开始录音
- (BOOL)startAudioRecorder {
    
    [PLCAudioPath deleteRecordFile];

    /**
     *  开始录音
     *  设置音频会话
     */
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if(session == nil) {
        NSLog(@"Error creating session: %@", [sessionError description]);
        
    }else {
        [session setActive:YES error:nil];
    }
    
    self.session = session;
    
    [self.audioRecorder record];
    
    if (![PLCAudioRecorderHelper didSystemOpendMicrophone]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"需要开启麦克风权限，请前往设置打开" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        
        return NO;
    }else {
       
        return YES;
    }
    
}

#pragma mark - - 暂停录音
- (void)pauseAudioRecorder {
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder pause];
    }
}

#pragma mark - - 恢复录音
- (void)resumeAudioRecorder {
    [self startAudioRecorder];
}

#pragma mark - - 停止录音
- (void)endAudioRecorder {
    [self.audioRecorder stop];
}

#pragma mark - - AVAudioRecorderDelegate -
/**
 *  录音完成，录音完成后播放录音
 *
 *  @param recorder 录音机对象
 *  @param flag     是否成功
 */
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (flag) {
        NSLog(@"录音完成!");
        [self.session setActive:NO error:nil];
        
        [recorder deleteRecording];
        
    }  
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error {
    
    NSLog(@"录音出错 = %@", error);
    
}


#pragma mark - 后台是否允许app使用麦克风  YES——允许  NO——不允许
+ (BOOL)didSystemOpendMicrophone {
    
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        
        __block BOOL isEnable = YES;
        
        [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                // Microphone enabled code
                NSLog(@"Microphone is enabled..");
                isEnable = YES;
            }
            else {
                // Microphone disabled code
                NSLog(@"Microphone is disabled..");
                isEnable = NO;
            }
        }];
        
        return isEnable;
        
    }
    return NO;
}


@end
