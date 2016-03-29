//
//  FinishedHandleViewController.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/11/10.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "FinishedHandleViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface FinishedHandleViewController ()
@property(nonatomic,strong)UIView *contentView;
@property(nonatomic,strong)AVPlayer *player;
@end

@implementation FinishedHandleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 260, 400)];
    _contentView.center = CGPointMake([UIScreen  mainScreen].bounds.size.width/2.0, ([UIScreen mainScreen].bounds.size.height-100)/2.0);
    [self.view addSubview:_contentView];

    
    UIButton *playbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playbtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2.0-20, [UIScreen mainScreen].bounds.size.height-100, 40, 35);
    playbtn.backgroundColor = mainColor;
    [playbtn setTitle:@"播放" forState:UIControlStateNormal];
    playbtn.titleLabel.textColor = [UIColor blueColor];
    [playbtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playbtn];
}
- (void)playClick:(id)sender
{
    [self playClickWithURL:_urlPath];
}

- (void)playClickWithURL:(NSURL *)aurlString
{
    //录制完之后自动播放
    NSURL *url=aurlString;
    
    _player=[AVPlayer playerWithURL:url];
    AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:_player];
    playerLayer.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
    [self.contentView.layer addSublayer:playerLayer];
    
    
    [_player play];
    
}


- (void)goBack:(NSNotification *)notification
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
