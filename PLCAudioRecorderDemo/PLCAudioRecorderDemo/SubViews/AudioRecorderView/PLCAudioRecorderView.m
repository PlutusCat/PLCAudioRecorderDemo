//
//  PLCAudioRecorderView.m
//  PLCAudioRecorderDemo
//
//  Created by PlutusCat on 2017/4/26.
//  Copyright © 2017年 PlutusCat. All rights reserved.
//

#import "PLCAudioRecorderView.h"
#import "PLCAudioRecorderHelper.h"
#import "PLCPlayAudioHelper.h"

#define stateSelect K_AUTOSIZE_WIDTH(168)
#define stateCancel K_AUTOSIZE_WIDTH(88)

#define topLableFont kFont(K_AUTOSIZE_WIDTH(32))
#define bottomLableFont kFont(K_AUTOSIZE_WIDTH(24))
#define buttonTitleFont kFont(K_AUTOSIZE_WIDTH(36))

static NSString *const clickSelectStr = @"单击说话";
static NSString *const clickCancelStr = @"单击模式";

static NSString *const pressSelectStr = @"长按说话";
static NSString *const pressCancelStr = @"长按模式";

@interface PLCAudioRecorderView ()

@property (nonatomic, strong) UILabel  *topLable;
@property (nonatomic, strong) UILabel  *bottomLable;
@property (nonatomic, strong) UIButton *clickButton;
@property (nonatomic, strong) UIButton *pressButton;

@property (nonatomic, strong) UIButton *auditionButton;
@property (nonatomic, strong) UIButton *againButton;

@property (nonatomic, assign) PLCAudioRecorderType recorderType;
@property (nonatomic, assign) PLCRecorderRunType   recorderRunType;

@property (nonatomic, strong) PLCAudioRecorderHelper *recorderHelper;
@property (nonatomic, strong) PLCPlayAudioHelper *playAudioHelper;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) TimerHelper *timerHelper;
@property (nonatomic, assign) CGFloat timeFloat;

@property (nonatomic, assign) BOOL isMP3;
@property (nonatomic, assign) BOOL isWillSend;
@property (nonatomic, assign) BOOL isSend;
@end

@implementation PLCAudioRecorderView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cafChangeToMP3Complete) name:CAFChangeToMP3Complete object:nil];
        
        self.backgroundColor = [UIColor whiteColor];
        self.timeFloat = 0.0;
       
        UIButton *clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [clickButton setBackgroundImage:[UIImage imageNamed:@"living_btn_big_recard1"] forState:UIControlStateNormal];
        [clickButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:clickButton];
        self.clickButton = clickButton;
        
        UIButton *pressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [pressButton setBackgroundImage:[UIImage imageNamed:@"living_btn_big_recard2"] forState:UIControlStateNormal];
        [pressButton addTarget:self action:@selector(pressAction:) forControlEvents:UIControlEventTouchDown];
        [pressButton addTarget:self action:@selector(pressCancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:pressButton];
        self.pressButton = pressButton;
        
        UILabel *topLable = [[UILabel alloc] init];
        topLable.numberOfLines = 1;
        topLable.text = clickSelectStr;
        topLable.textColor = [UIColor blueColor];
        topLable.textAlignment = NSTextAlignmentCenter;
        topLable.font = topLableFont;
        [self addSubview:topLable];
        self.topLable = topLable;
        
        UILabel *bottomLable = [[UILabel alloc] init];
        bottomLable.numberOfLines = 1;
        bottomLable.text = pressCancelStr;
        bottomLable.textColor = [UIColor lightGrayColor];
        bottomLable.textAlignment = NSTextAlignmentCenter;
        bottomLable.font = bottomLableFont;
        [self addSubview:bottomLable];
        self.bottomLable = bottomLable;
        
        UIButton *auditionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        auditionButton.alpha = 0.0;
        [auditionButton setTitle:@"试听" forState:UIControlStateNormal];
        [auditionButton setTitle:@"取消" forState:UIControlStateSelected];
        [auditionButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        auditionButton.titleLabel.font = buttonTitleFont;
        [auditionButton addTarget:self action:@selector(auditionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:auditionButton];
        self.auditionButton = auditionButton;
        
        UIButton *againButton = [UIButton buttonWithType:UIButtonTypeCustom];
        againButton.alpha = 0.0;
        [againButton setTitle:@"重录" forState:UIControlStateNormal];
        [againButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        againButton.titleLabel.font = buttonTitleFont;
        [againButton addTarget:self action:@selector(againBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:againButton];
        self.againButton = againButton;
        
    }
    return self;
}

- (void)clickAction:(UIButton *)clickBtn {
    
    if (_recorderType == PLCAudioRecorderClickType) {
        
        self.recorderRunType = self.recorderRunType==PLCRecorderDidRunType ? PLCRecorderRunningType:self.recorderRunType+1;
        
        switch (_recorderRunType) {
            case PLCRecorderWillRunType:
            case PLCRecorderRunningType:{
                NSLog(@"PLCRecorderRunningType");
                [self changeclickWithImgName:@"living_btn_recarding"];

                [self startRecorder];
                
            }
                break;
                
            case PLCRecorderDidRunType:{
                NSLog(@"PLCRecorderDidRunType");
                
                [self.clickButton setBackgroundImage:[UIImage imageNamed:@"living_btn_send"] forState:UIControlStateNormal];
                [self.clickButton removeTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.clickButton addTarget:self action:@selector(sendAudioRecorder) forControlEvents:UIControlEventTouchUpInside];
                
                [UIView animateWithDuration:0.25 animations:^{
                    self.auditionButton.alpha = 1.0;
                    self.againButton.alpha = self.auditionButton.alpha;
                }];

                [self endRecorder];
                
            }
                break;
                
            default:
                break;
        }
        
    }else {
        [self changeAudioRecorderType:PLCAudioRecorderClickType];
    }
    
}

- (void)pressAction:(UIButton *)pressBtn {
   
    if (_recorderType == PLCAudioRecorderPressType) {
        // 开始 长按 录音
        NSLog(@"触摸开始 pressAction 录音开始");

        [self startRecorder];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.clickButton.alpha = 0.0;
            self.bottomLable.alpha = self.clickButton.alpha;
        }];
        
    }
}

- (void)pressCancelAction:(UIButton *)pressBtn {
   
    if (_recorderType == PLCAudioRecorderPressType) {
        
        NSLog(@"触摸取消 pressCancelAction 录音结束");

        [self endRecorder];

        [UIView animateWithDuration:0.25 animations:^{
            self.clickButton.alpha = 1.0;
            self.bottomLable.alpha = self.clickButton.alpha;
        }];
        
    }else {
        [self changeAudioRecorderType:PLCAudioRecorderPressType];
    }
 
}


- (void)auditionBtnAction:(UIButton *)auditionBtn {
    
    self.auditionButton.selected = !auditionBtn.isSelected;

    if (!_playAudioHelper) {
        PLCPlayAudioHelper *playAudioHelper = [[PLCPlayAudioHelper alloc] init];
        
        __weak typeof(self) weakSelf = self;
        playAudioHelper.playerDidFinish = ^{
            weakSelf.auditionButton.selected = !weakSelf.auditionButton.selected;
        };
        
        self.playAudioHelper = playAudioHelper;
    }
    
    if (self.auditionButton.isSelected) {
        NSLog(@"试听");
        NSURL *recorderPath = _isMP3==YES?[PLCAudioPath getMp3RecordFilePath]:[PLCAudioPath getRecordFilePath];
        
        [self.playAudioHelper playRecorderWithPath:recorderPath];

    }else {
        NSLog(@"取消");
        
        [self.playAudioHelper stop];
        
    }
    
}

- (void)againBtnAction:(UIButton *)againBtn {
    
    if (_recorderType==PLCAudioRecorderClickType) {
        [self changeclickWithImgName:@"living_btn_big_recard1"];
    }
    
    //重置 timer
    [TimerHelper endTimerHelper:_timer];
    //重置 top
    self.topLable.text = clickSelectStr;
    //停止 播放录音
    [self.playAudioHelper stop];
    
}


- (void)changeAudioRecorderType:(PLCAudioRecorderType)recorderType {
    self.recorderType = recorderType;
    
    CGRect frame = self.clickButton.frame;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.clickButton.frame = self.pressButton.frame;
        self.pressButton.frame = frame;
    }];
    
    switch (recorderType) {
        case PLCAudioRecorderClickType:{
            self.topLable.text = clickSelectStr;
            self.bottomLable.text = pressCancelStr;
        }
            break;
            
        case PLCAudioRecorderPressType:{
            self.topLable.text = pressSelectStr;
            self.bottomLable.text = clickCancelStr;
        }
            break;
            
        default:
            break;
    }
    
}

- (void)changePressState:(UIButton *)pressBtn {
    [self.pressButton setSelected:!pressBtn.isSelected];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.clickButton.alpha = !self.pressButton.isSelected;
        self.bottomLable.alpha = self.clickButton.alpha;
        
        self.auditionButton.alpha = self.pressButton.isSelected;
        self.againButton.alpha = self.auditionButton.alpha;
    }];
}

- (void)changeclickWithImgName:(NSString *)imgName{
    
    [self.clickButton setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [self.clickButton removeTarget:self action:@selector(sendAudioRecorder) forControlEvents:UIControlEventTouchUpInside];
    [self.clickButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.clickButton setSelected:!self.clickButton.isSelected];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.pressButton.alpha = !self.clickButton.isSelected;
        self.bottomLable.alpha = self.pressButton.alpha;
        
        self.auditionButton.alpha = 0.0;
        self.againButton.alpha = self.auditionButton.alpha;
    }];
    
}

#pragma mark - - 开始录音
- (void)startRecorder {

    _isWillSend = NO;
    
    //开始计时
    
    if (!_recorderHelper) {
        PLCAudioRecorderHelper *recorderHelper = [PLCAudioRecorderHelper sharedPLCAudioRecorderHelper];
        
        self.recorderHelper = recorderHelper;
    }
    
    if (![self.recorderHelper startAudioRecorder]) {
        return;
    }
    
    if (_recorderType==PLCAudioRecorderClickType) {
        
        TimerHelper *timerHelper = [[TimerHelper alloc] init];
        self.timerHelper = timerHelper;
        
        self.timer = [NSTimer bk_scheduledTimerWithTimeInterval:1.0 block:^(NSTimer *timer) {
            
            // 点击录音模式 需要显示录音时长
            [self changeTopLable:timer];
            
        } repeats:YES];
    }else {
        
        self.timer = [NSTimer bk_scheduledTimerWithTimeInterval:1.0 block:^(NSTimer *timer) {
            
            //长按录制 需要显示 HUD
            
        } repeats:YES];
        
        self.topLable.text = @"松开发送";
    }
    
}

#pragma mark - - 结束录音
- (void)endRecorder {
    
    [self.recorderHelper endAudioRecorder];
    
    //结束计时
    [TimerHelper endTimerHelper:_timer];
    
    if (_recorderType==PLCAudioRecorderClickType) {
        self.topLable.text = @"";
        
       [PLCPlayAudioHelper CAFChangeToMP3];
        
    }else {
        self.topLable.text = pressSelectStr;
    }
    
}


#pragma mark - - 发送录音
- (void)sendAudioRecorder {
    _isWillSend = YES;
    
    if (_recorderType==PLCAudioRecorderClickType) {
        
        [self.playAudioHelper stop];
        self.topLable.text = clickCancelStr;
        self.auditionButton.selected = NO;
        [self changeclickWithImgName:@"living_btn_big_recard1"];
        
        //如果转换完成了 直接发送
        if (_isMP3) {
            _isSend = YES;
            
            if (_sendRecordBlock) {
                _sendRecordBlock([PLCAudioPath getMp3RecordFilePath]);
            }
        }
        
    }
    
}

#pragma mark - - 显示录音时长
- (void)changeTopLable:(NSTimer *)timer {
    
    self.topLable.text = [self.timerHelper getTimerlength];
    
}

#pragma mark - - 默认模式布局

- (void)layoutSubviews {
    [super layoutSubviews];
    [self PLClayoutSubviews];
}

- (void)PLClayoutSubviews {
    [self.topLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(K_AUTOSIZE_HEIGHT(48));
        make.left.right.equalTo(self);
    }];
    
    [self.clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLable.mas_bottom).offset(K_AUTOSIZE_HEIGHT(32));
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_offset(CGSizeMake(stateSelect, stateSelect));
    }];
    
    [self.pressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.clickButton.mas_centerY);
        make.left.equalTo(self.clickButton.mas_right).offset(K_AUTOSIZE_WIDTH(92));
        make.size.mas_offset(CGSizeMake(stateCancel, stateCancel));
    }];
    
    [self.bottomLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pressButton.mas_bottom).offset(K_AUTOSIZE_HEIGHT(24));
        make.centerX.equalTo(self.pressButton.mas_centerX);
    }];
    
    [self.auditionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.clickButton.mas_centerY);
        make.right.equalTo(self.clickButton.mas_left).offset(-K_AUTOSIZE_WIDTH(64));
    }];
    
    [self.againButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.clickButton.mas_centerY);
        make.left.equalTo(self.clickButton.mas_right).offset(K_AUTOSIZE_WIDTH(64));
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomLable.mas_bottom).offset(K_AUTOSIZE_HEIGHT(40));
    }];
}

- (void)cafChangeToMP3Complete {
    NSLog(@"%s", __func__);
    self.isMP3 = YES;
    
    if (_isWillSend&&!_isSend) {
        // 转换完成再发送
        NSLog(@"发送 MP3");
        if (_sendRecordBlock) {
            _sendRecordBlock([PLCAudioPath getMp3RecordFilePath]);
        }
    }
}


#pragma mark - - 注销 
- (void)dealloc {
    NSLog(@"LCAudioRecorderView 注销了 ");
}
@end
