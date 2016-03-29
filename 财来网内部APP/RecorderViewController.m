//
//  ContractViewController.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/23.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "RecorderViewController.h"
#import <AVFoundation/AVFoundation.h>

#define constantSize  (self.view.bounds.size.width-4*52)/5.0
#define buttonHeight 45
@interface RecorderViewController ()<AVAudioRecorderDelegate>
@property (nonatomic,strong) AVAudioRecorder *audioRecorder;//音频录音机
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;//音频播放器，用于播放录音文件
@property (nonatomic,strong) NSTimer *timer;//录音声波监控（注意这里暂时不对播放进行监控）
@property (nonatomic,strong) NSURL *currentURL;
@end

@implementation RecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _userID = @"76";
    
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-buttonHeight);
    
    _leadingToImageView = [NSLayoutConstraint constraintWithItem:_recordBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_recordImageView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:constantSize];
    
    _startBtnWithSuspendBtnLayout = [NSLayoutConstraint constraintWithItem:_suspendBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_recordBtn attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:constantSize];
    
    _suspendBtnWithResumeBtnLayout = [NSLayoutConstraint constraintWithItem:_resumeBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_suspendBtn attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:constantSize];
    
    _resumeBtnWithFinishBtnLayout = [NSLayoutConstraint constraintWithItem:_finishBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_resumeBtn attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:constantSize];

    NSArray *constraintArray = [NSArray arrayWithObjects:_leadingToImageView,_startBtnWithSuspendBtnLayout,_suspendBtnWithResumeBtnLayout,_resumeBtnWithFinishBtnLayout, nil];
    [self.view addConstraints:constraintArray];
    
    [self setAudioSession];
    
    
}





#pragma mark - 私有方法
/**
 *  设置音频会话
 */
-(void)setAudioSession{
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}

/**
 *  取得录音文件保存路径
 *
 *  @return 录音文件路径
 */
-(NSURL *)getSavePath{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
    NSString *ourDocumentPath =[documentPaths objectAtIndex:0];
    NSString *dictionaryPathString = [ourDocumentPath stringByAppendingString:[NSString stringWithFormat:@"/LocalMusic_%@",_userID]];
    //根据userID创建documents下得文件夹LocalMusic_,的文件
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"yyyyMMddHHmmss";
    NSString *currentTimeStr = [formater stringFromDate:[NSDate date]] ;
    
    NSString *FilePathString = [dictionaryPathString stringByAppendingString:[NSString stringWithFormat:@"/%@.caf",currentTimeStr]];
    
    NSLog(@"file path:%@",FilePathString);
    NSURL *url=[NSURL fileURLWithPath:FilePathString];
    
    return url;
}




/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */
-(NSDictionary *)getAudioSetting{
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    //设置录音格式
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道,这里采用单声道
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //....其他设置等
    return dicM;
}

/**
 *  获得录音机对象
 *
 *  @return 录音机对象
 */
-(AVAudioRecorder *)audioRecorder{
    if (!_audioRecorder) {
        //创建录音文件保存路径,先创建文件夹
        
        NSURL *url=[self getSavePath];
        _currentURL = url;
        //创建录音格式设置
        NSDictionary *setting=[self getAudioSetting];
        //创建录音机
        NSError *error=nil;
        _audioRecorder=[[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate=self;
        _audioRecorder.meteringEnabled=YES;//如果要监控声波则必须设置为YES
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioRecorder;
}

/**
 *  创建播放器
 *
 *  @return 播放器
 */
-(AVAudioPlayer *)audioPlayer{
    if (!_audioPlayer) {
       
        NSError *error=nil;
        _audioPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:_currentURL error:&error];
        _audioPlayer.numberOfLoops=0;
        [_audioPlayer prepareToPlay];
        if (error) {
            NSLog(@"创建播放器过程中发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioPlayer;
}

/**
 *  录音声波监控定制器
 *
 *  @return 定时器
 */
-(NSTimer *)timer{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
    }
    return _timer;
}

/**
 *  录音声波状态设置
 */
-(void)audioPowerChange{
    [self.audioRecorder updateMeters];//更新测量值
    float power= [self.audioRecorder averagePowerForChannel:0];//取得第一个通道的音频，注意音频强度范围时-160到0
    CGFloat progress=(1.0/160.0)*(power+160.0);
    [self.audioPower setProgress:progress];
}
#pragma mark - UI事件
/**
 *  点击录音按钮
 *
 *  @param sender 录音按钮
 */
- (IBAction)playAudioClick:(id)sender {
    
    [self startPlayAudio];
}

- (IBAction)backToPreviousClick:(id)sender {
    
    [self.audioPlayer stop];
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"--------");
    }];
}

- (IBAction)recordClick:(UIButton *)sender {
    if (![self.audioRecorder isRecording]) {
        [self.audioRecorder record];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
        self.timer.fireDate=[NSDate distantPast];
    }
}

/**
 *  点击暂定按钮
 *
 *  @param sender 暂停按钮
 */
- (IBAction)pauseClick:(UIButton *)sender {
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder pause];
        self.timer.fireDate=[NSDate distantFuture];
    }
}

/**
 *  点击恢复按钮
 *  恢复录音只需要再次调用record，AVAudioSession会帮助你记录上次录音位置并追加录音
 *
 *  @param sender 恢复按钮
 */
- (IBAction)resumeClick:(UIButton *)sender {
    [self recordClick:sender];
}

/**
 *  点击停止按钮
 *
 *  @param sender 停止按钮
 */
- (IBAction)stopClick:(UIButton *)sender {
    [self.audioRecorder stop];
    self.timer.fireDate=[NSDate distantFuture];
    self.audioPower.progress=0.0;
}

#pragma mark - 录音机代理方法
/**
 *  录音完成，录音完成后播放录音
 *
 *  @param recorder 录音机对象
 *  @param flag     是否成功
 */
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    //[self startPlayAudio];
    NSLog(@"录音完成!");
}

- (void)startPlayAudio
{
    if (![self.audioPlayer isPlaying]) {
        [self.audioPlayer play];
    }
}





@end
