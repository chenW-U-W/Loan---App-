//
//  FinishedMovieTableViewCell.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/11/10.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailMovieObj.h"
@interface FinishedMovieTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameString;
@property (weak, nonatomic) IBOutlet UIImageView *movieImage;
@property (weak, nonatomic) IBOutlet UILabel *movieLength;
@property (weak,nonatomic) DetailMovieObj *detailMovieObj;
@end
