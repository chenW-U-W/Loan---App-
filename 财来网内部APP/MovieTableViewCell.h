//
//  MovieTableViewCell.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/29.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieObj.h"
@interface MovieTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameString;
@property (weak,nonatomic) MovieObj *movieObj;
@end
