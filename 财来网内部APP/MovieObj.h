//
//  MovieObj.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/29.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayerDefines.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MovieObj : NSObject
@property (nonatomic,strong) AVPlayer *player;//播放器对象
@property (nonatomic,strong) MPMoviePlayerController *MPMoviePlayerC;//播放对象
@property (nonatomic,strong) NSString *nameString;
@property (nonatomic,strong) NSString *urlString;
@end
