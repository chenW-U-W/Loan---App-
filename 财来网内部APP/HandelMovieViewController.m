//
//  HandelMovieViewController.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/11/5.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "HandelMovieViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "DetailMovieObj.h"
#import "MBProgressHUD.h"

@interface HandelMovieViewController ()
@property (strong ,nonatomic) AVPlayer *player;//播放器，用于录制完视频后播放视频
@property (strong ,nonatomic) UIView *contentView;
@end


@implementation HandelMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *navView = [[UIView alloc] init];
    navView.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    [self.view addSubview:navView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 35);
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    btn.titleLabel.textColor = [UIColor blueColor];
    [btn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:btn];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, 260, 400)];
    _contentView.center = CGPointMake([UIScreen  mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.height/2.0);
    [self.view addSubview:_contentView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)goBack:(NSNotification *)notification
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)handelBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 60:
            [self uploadData:_urlString];
            break;
        case 61:
            [self playClickWithURLString:_urlString];
            break;
        case 62:
        {
            NSError *error;
            [[NSFileManager defaultManager] removeItemAtPath:_urlString error:&error];
            NSDictionary *dic  = [[NSDictionary alloc] initWithObjectsAndKeys:_MovieID,@"movieID", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"removeMovie" object:nil userInfo:dic];
            NSLog(@"%@",error);
            
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
       
            
        default:
            break;
    }
}



- (void)uploadData:(NSString *)urlString
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    NSData *data = [NSData dataWithContentsOfFile:urlString];
    NSString *dataBase64 =  [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [dictionary setObject:dataBase64 forKey:_nameString];
    //[dictionary setObject:data forKey:@"111"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [DetailMovieObj postMovieDataToserverWithBlock:^(id respon, NSError *error) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        if (error) {
//            NSLog(@"%@",error);
//        }
//        else
//        {
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSLog(@"-----------成功-------");
//                
//            });
//        }
//        
//    } withFilesType:@"mp4" withPid:_userID withUpdataDictionary:dictionary];


}


- (void)playClickWithURLString:(NSString *)aurlString
{
            //录制完之后自动播放
           NSURL *url=[NSURL fileURLWithPath:aurlString];
    
            _player=[AVPlayer playerWithURL:url];
            AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:_player];
            playerLayer.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
            [self.contentView.layer addSublayer:playerLayer];
            //添加约
//    NSLayoutConstraint *constant1 = [NSLayoutConstraint constraintWithItem:playerLayer attribute:NSLayoutAttributeLeading   relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
//    NSLayoutConstraint *constant2 = [NSLayoutConstraint constraintWithItem:playerLayer attribute:NSLayoutAttributeTop   relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeTop multiplier:1 constant:0];
//    NSLayoutConstraint *constant3 = [NSLayoutConstraint constraintWithItem:playerLayer attribute:NSLayoutAttributeBottom   relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
//    NSLayoutConstraint *constant4 = [NSLayoutConstraint constraintWithItem:playerLayer attribute:NSLayoutAttributeTrailing   relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
//    NSArray *array = [NSArray arrayWithObjects:constant1,constant2,constant3,constant4, nil];
//    [self.contentView addConstraints:array];
    
    
            [_player play];

}

@end
