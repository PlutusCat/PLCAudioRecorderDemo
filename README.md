# PLCAudioRecorderDemo
~~最终目的是一个小而美得应用 🤥~~
最终目的是实现 录音实时转码MP3 ，本地音频播放和在线音频队列播放。


# Requirements
* iOS8.0+ / Objective-C
* ARC / arm64

# Usage
```Objc
#import "PLCAudioRecorderHelper.h" //AVAudioRecorder
#import "PLCPlayAudioHelper.h"     //AVAudioPlayer + FSAudioStream
```

AVAudioRecorder setting 

```Objc
/* keys for all formats */
/*
 * value is an integer (format ID) from CoreAudioTypes.h 
 * kAudioFormatLinearPCM make .caf
 */
[dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey]; 
/* value is floating point in Hertz */
[dicM setObject:@(11025.0) forKey:AVSampleRateKey];
/* value is an integer */
[dicM setObject:@(2) forKey:AVNumberOfChannelsKey];
/* value is an integer, one of: 8, 16, 24, 32 */
[dicM setObject:@(16) forKey:AVLinearPCMBitDepthKey];
/* value is an integer from enum AVAudioQuality */
[dicM setObject:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
```

# libraries
*  [FreeStreamer](https://github.com/muhku/FreeStreamer)
*  [Masonry](https://github.com/SnapKit/Masonry)
*  [BlocksKit](https://github.com/zwaldowski/BlocksKit)
*  [lame_Build](https://github.com/wuqiong/mp3lame-for-iOS)
*  [SVProgressHUD](https://github.com/SVProgressHUD/SVProgressHUD)
*  [JHChainableAnimations](https://github.com/jhurray/JHChainableAnimations)




