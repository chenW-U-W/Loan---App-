//
//  ContractViewController.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/23.
//  Copyright © 2015年 陈思远. All rights reserved.
//  视频和音频

#import <UIKit/UIKit.h>

@interface RecorderViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *recordBtn;

@property (weak, nonatomic) IBOutlet UIImageView *recordImageView;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UIButton *resumeBtn;
@property (weak, nonatomic) IBOutlet UIButton *suspendBtn;
@property (weak, nonatomic) IBOutlet UIProgressView *audioPower;//音频波动
@property (weak, nonatomic) IBOutlet UIButton *backToPrevious;

@property (nonatomic,strong) NSString *userID;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingToImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startBtnWithSuspendBtnLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *suspendBtnWithResumeBtnLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *resumeBtnWithFinishBtnLayout;
- (IBAction)playAudioClick:(id)sender;
- (IBAction)backToPreviousClick:(id)sender;
- (IBAction)recordClick:(UIButton *)sender;
- (IBAction)pauseClick:(UIButton *)sender;
- (IBAction)resumeClick:(UIButton *)sender;
- (IBAction)stopClick:(UIButton *)sender;
@end
