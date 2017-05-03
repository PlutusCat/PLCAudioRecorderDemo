//
//  PLCAudioRecorderView.h
//  PLCAudioRecorderDemo
//
//  Created by PlutusCat on 2017/4/26.
//  Copyright © 2017年 PlutusCat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PLCAudioRecorderType) {
    PLCAudioRecorderClickType,
    PLCAudioRecorderPressType
};

typedef NS_ENUM(NSInteger, PLCRecorderRunType) {
    PLCRecorderWillRunType = 0,
    PLCRecorderRunningType,
    PLCRecorderDidRunType
};

@interface PLCAudioRecorderView : UIView
/** 
 * 切换当前录音模式
 * recorderType 分 点击 和 长按 模式
 */
- (void)changeAudioRecorderType:(PLCAudioRecorderType)recorderType;

/** 
 录音时长
 */
@property (nonatomic, assign) CGFloat recorderTimer;

@property (nonatomic, copy) void (^sendRecordBlock) (NSURL *filePath);

@end
