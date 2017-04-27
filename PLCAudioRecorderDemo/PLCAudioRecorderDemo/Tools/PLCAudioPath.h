//
//  PLCAudioPath.h
//  PLCAudioRecorderDemo
//
//  Created by PlutusCat on 2017/4/27.
//  Copyright © 2017年 PlutusCat. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kRecordAudioFile = @"PLCRecord.caf";
static NSString * const kChangedAudioFile = @"PLCChangedRecord.mp3";

@interface PLCAudioPath : NSObject
/**
 *  取得录音文件保存路径
 *
 *  @return 录音文件路径
 */
+ (NSURL *)getRecordFilePath;
+ (NSURL *)getMp3RecordFilePath;

+ (void)deleteRecordFile;
@end
