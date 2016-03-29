//
//  RecordObj.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/29.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface RecordObj : NSObject
@property(nonatomic,assign) BOOL isMarked;
@property(nonatomic,strong) AVAudioPlayer *audioPlayer;
@property(nonatomic,assign) BOOL isOpening;
@end
