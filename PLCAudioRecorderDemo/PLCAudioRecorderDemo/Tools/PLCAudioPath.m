//
//  PLCAudioPath.m
//  PLCAudioRecorderDemo
//
//  Created by PlutusCat on 2017/4/27.
//  Copyright © 2017年 PlutusCat. All rights reserved.
//

#import "PLCAudioPath.h"

#define kRecordAudioFile @"PLCRecord.caf"

@implementation PLCAudioPath
/**
 *  取得录音文件保存路径
 *
 *  @return 录音文件路径
 */
+ (NSURL *)getSavePath {
    NSString *urlStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr = [urlStr stringByAppendingPathComponent:kRecordAudioFile];
    NSLog(@"file path:%@",urlStr);
    NSURL *url = [NSURL fileURLWithPath:urlStr];
    return url;
}
@end
