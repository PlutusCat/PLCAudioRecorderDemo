//
//  PLCAudioPath.m
//  PLCAudioRecorderDemo
//
//  Created by PlutusCat on 2017/4/27.
//  Copyright © 2017年 PlutusCat. All rights reserved.
//

#import "PLCAudioPath.h"

@implementation PLCAudioPath
/**
 *  取得录音文件保存路径
 *
 *  @return 录音文件路径
 */
+ (NSURL *)getRecordFilePath {
    NSString *urlStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr = [urlStr stringByAppendingPathComponent:kRecordAudioFile];
    NSLog(@"file path:%@",urlStr);
    NSURL *url = [NSURL fileURLWithPath:urlStr];
    return url;
}

+ (NSURL *)getMp3RecordFilePath {
    NSString *urlStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr = [urlStr stringByAppendingPathComponent:kChangedAudioFile];
    NSLog(@"file path:%@",urlStr);
    NSURL *url = [NSURL fileURLWithPath:urlStr];
    return url;
}

+ (void)deleteRecordFile {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *recordFileUrl = [PLCAudioPath getRecordFilePath];
    if (recordFileUrl) {
        [fileManager removeItemAtURL:recordFileUrl error:NULL];
    }
}

+ (void)getRecordAttributes {
    NSString *urlStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    urlStr = [urlStr stringByAppendingPathComponent:kRecordAudioFile];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:urlStr error:nil];
    NSArray *keys;
    id key, value;
    keys = [fileAttributes allKeys];
    NSInteger count = [keys count];
    for (int i = 0; i < count; i++) {
        key = [keys objectAtIndex: i];  //获取文件名
        value = [fileAttributes objectForKey: key];  //获取文件属性
        
        NSLog(@"key = %@  value = %@",key, value);
    }
}
@end
