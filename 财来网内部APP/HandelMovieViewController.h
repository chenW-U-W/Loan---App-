//
//  HandelMovieViewController.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/11/5.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HandelMovieViewController : UIViewController
- (IBAction)handelBtnClick:(id)sender;

@property (nonatomic,strong)NSString *urlString;
@property (nonatomic,strong)NSString *userID;
@property (nonatomic,strong)NSString *MovieID;
@property (nonatomic,strong)NSString *nameString;
@end
